import Mapper
import Library

public protocol Request {
    var api: API { get }
    var endpoint: String? { get }
    var params: Parameters { get }
}

extension Request {

    var url: URL? {
        var path = api.host

        if let endpoint = endpoint, endpoint.isNotEmpty {
             path = path.fromAppendingPathComponent(endpoint)
        }

        let queryString = params
            .flatMap { (key, value) in
                return value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap { key + "=" + $0 }
            }
            .joined(separator: "&")
        if queryString.isNotEmpty {
            path += "?" + queryString
        }

        return URL(string: path)
    }

}
