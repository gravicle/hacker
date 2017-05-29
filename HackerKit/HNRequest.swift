import CoreData
import Mapper

public struct HNRequest: Request {
    public let api: API = "http://hn.algolia.com/api/v1"
    public var path: String? {
        return endpoint?.rawValue
    }
    public var params: Parameters {
        return tag.flatMap { ["tags": $0.rawValue] } ?? [:]
    }

    public let endpoint: Endpoint?
    public let tag: Tag?
}

// MARK: - Tags

public extension HNRequest {

    public enum Tag: String {
        case frontPage = "front_page"
    }

}

// MARK: - Endpoints

public extension HNRequest {

    public enum Endpoint: String {
        case search
    }

}

// MARK: - Requests

public extension HNRequest {

    public static let frontPageStories = HNRequest(endpoint: .search, tag: .frontPage)

}
