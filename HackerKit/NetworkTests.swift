import XCTest
import Nimble
import OHHTTPStubs
import RxSwift
import Library
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

    func testRequest() {
        let exp = expectation(description: "")
        let request = TestRequest()

        stub(condition: { _ in true }) { (req) -> OHHTTPStubsResponse in
            guard req.url?.absoluteString == "https://test.com/test" else {
                return .init(jsonObject: [:], statusCode: 500, headers: nil)
            }

            return .init(jsonObject: [:], statusCode: 200, headers: nil)
        }

        _ = Network.request(request, using: session)
            .debug()
            .subscribe(
                onSuccess: { _ in
                    exp.fulfill()
                },
                onError: {
                    fail($0.localizedDescription)
                    exp.fulfill()
                }
            )

        wait(for: [exp], timeout: 2.0)
    }

}
