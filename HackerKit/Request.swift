import Mapper
import Library

public protocol Request {
    var api: API { get }
    var path: String? { get }
    var params: Parameters { get }
}

extension Request {

    var url: URL? {
        var fullPath = api.host

        if let path = path, path.isNotEmpty {
             fullPath = fullPath.fromAppendingPathComponent(path)
        }

        let queryString = params
            .flatMap { (arg) -> String? in
                let (key, value) = arg
                return value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap { key + "=" + $0 }
            }
            .joined(separator: "&")
        if queryString.isNotEmpty {
            fullPath += "?" + queryString
        }

        return URL(string: fullPath)
    }

}
