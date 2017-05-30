import CoreData
import Mapper

public struct HN: Request {
    public let api: API = "http://hn.algolia.com/api/v1"
    public var path: String? {
        return endpoint?.rawValue
    }

    public var params: Parameters {
        var params: Parameters = [:]
        tag.then { params["tags"] = $0.rawValue }
        params["hitsPerPage"] = String(hitsPerPage)
        return params
    }

    let endpoint: Endpoint?
    let tag: Tag?
    let hitsPerPage: Int = 100
}

// MARK: - Tags

extension HN {

    public enum Tag: String {
        case frontPage = "front_page"
    }

}

// MARK: - Endpoints

extension HN {

    enum Endpoint: String {
        case search
    }

}

// MARK: - Requests

public extension HN {

    public static let frontPageStories = HN(endpoint: .search, tag: .frontPage)

}
