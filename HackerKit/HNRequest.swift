import CoreData
import Mapper

public struct HNRequest: Request {
    public let api: API = "http://hn.algolia.com/api/v1"
    public var endpoint: String?
    public let params: Parameters
}

extension HNRequest {

}
