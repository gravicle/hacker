import Mapper
import Library

struct Request<Resource> {
    let api: API
    let path: String?
    let map: ((Mapper) throws -> Resource)
}

extension Request {

    var url: URL? {
        let resolvedPath = api.host.fromAppendingPathComponent(path ?? "")
        return URL(string: resolvedPath)
    }

}
