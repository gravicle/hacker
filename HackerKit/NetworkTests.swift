import XCTest
import Nimble
import OHHTTPStubs
import RxSwift
import Library
import Mapper
@testable import HackerKit

class NetworkTests: XCTestCase {

    struct TestRequest: Request {
        let api: API = "https://test.com"
        var path: String? = "test"
        var params: Parameters = [:]
    }

    var session: URLSession!

    override func setUp() {
        super.setUp()
        session = URLSession(configuration: .default)
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func testRequestURL() {
        let exp = expectation(description: "")
        let request = TestRequest()

        stub(condition: { _ in true }) { (req) -> OHHTTPStubsResponse in
            defer { exp.fulfill() }
            expect(req.url?.absoluteString) == "https://test.com/test"
            return .init(jsonObject: [:], statusCode: 200, headers: nil)
        }

        _ = Network.request(request, using: session)
            .subscribe()

        wait(for: [exp], timeout: 2.0)
    }

    func testHTTPErrorHandling() {
        let exp = expectation(description: "")

        stub(condition: { _ in true }) { (req) -> OHHTTPStubsResponse in
            guard let path = req.url?.lastPathComponent, let code = Int(path) else {
                fatalError("Malformed request")
            }

            switch code {
            case (200...299): return .init(jsonObject: [:], statusCode: 200, headers: nil)
            default: return .init(jsonObject: [:], statusCode: 500, headers: nil)
            }
        }

        enum Expectation {
            case met, unmet
        }

        let susccessfulRequest = TestRequest(path: "200", params: [:])
        let successfulResponse: Observable<Expectation> = Network
            .request(susccessfulRequest, using: session)
            .asObservable()
            .map { _ in .met }
            .catchErrorJustReturn(.unmet)

        let unsusccessfulRequest = TestRequest(path: "500", params: [:])
        let unsuccessfulResponse: Observable<Expectation> = Network
            .request(unsusccessfulRequest, using: session)
            .asObservable()
            .map { _ in .unmet }
            .catchErrorJustReturn(.met)

        _ = Observable.zip(successfulResponse, unsuccessfulResponse) { $0 }
            .subscribe(
                onNext: { (successExpectation, failureExpectation) in
                    expect(successExpectation) == Expectation.met
                    expect(failureExpectation) == Expectation.met
                    exp.fulfill()
                },
                onError: {
                    fail($0.localizedDescription)
                    exp.fulfill()
                }
            )

        wait(for: [exp], timeout: 2.0)
    }

    func testResponseDataParsing() {
        let exp = expectation(description: "")

        let json: Any = [
            "testKey": "testValue",
            "testObject": ["key": "value"],
            "testArray": [1, 2, 3]
        ]

        stub(condition: { _ in true }) { (_) -> OHHTTPStubsResponse in
            return .init(jsonObject: json, statusCode: 200, headers: nil)
        }

        _ = Network
            .request(TestRequest(), using: session)
            .subscribe(onSuccess: {
                defer { exp.fulfill() }
                expect(try? $0.from("testKey") as String) == "testValue"
                expect(try? $0.from("testObject") as [String:String]) == ["key": "value"]
                expect(try? $0.from("testArray") as [Int]) == [1, 2, 3]
            })

        wait(for: [exp], timeout: 1.0)
    }

}
