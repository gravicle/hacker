import XCTest
import Nimble
@testable import HackerKit

class HNTests: XCTestCase {

    func testFrontPageRequest() {
        let req = HN.frontPageStories
        expect(req.url?.absoluteString) == "http://hn.algolia.com/api/v1/search?tags=front_page&hitsPerPage=100"
    }

}
