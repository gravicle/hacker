import Mapper
import Library

protocol Request {
    associatedtype Resource
    var api: API { get }
    var path: String? { get }
    var map: ((Mapper) throws -> Resource) { get }
}

extension Request {

    var url: URL? {
        let resolvedPath = api.host.fromAppendingPathComponent(path ?? "")
        return URL(string: resolvedPath)
    }

}
