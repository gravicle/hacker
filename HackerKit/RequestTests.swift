import XCTest
import Nimble
@testable import HackerKit

let testApi = "https://test.com"

class RequestTests: XCTestCase {

    struct TestRequest: Request {
        let api: API = .init(host: testApi)
        let endpoint: String?
        let params: Parameters
    }

    func testBuildingURLWithoutAnEndpointOrParams() {
        let req = TestRequest(endpoint: nil, params: [:])
        expect(req.url) == URL(string: testApi)!
    }

    func testBuildingURLWithEndpoint() {
        let req = TestRequest(endpoint: "test", params: [:])
        expect(req.url) == URL(string: testApi + "/" + "test")!
    }

    func testBuildingURLWithEndpointAndParams() {
        let req = TestRequest(endpoint: "test", params: ["name": "erlich"])
        expect(req.url) == URL(string: testApi + "/test?name=erlich")!
    }

    func testBuildingURLWithMultipleParams() {
        let req = TestRequest(endpoint: "test", params: ["first_name": "erlich", "last_name": "bachman"])
        expect(req.url) == URL(string: testApi + "/test?first_name=erlich&last_name=bachman")!
    }

}
