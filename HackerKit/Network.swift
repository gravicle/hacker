import Foundation
import RxSwift
import Mapper

struct Network {

    private init() {}

    static func request<R: Request>(_ request: R, using session: URLSession) -> Single<Mapper> {
        guard let url = request.url else {
            return Single.error(Error(desc: "Malformed Request: \(request)"))
        }

        return Single<Mapper>.create { (single) in
            let task = session.dataTask(with: url) { (data, response, error) in
                do {
                    let mapper = try map(from: data, response: response, error: error)
                    single(.success(mapper))
                } catch { single(.error(error)) }
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
    }

}

// MARK: - Network Error

extension Network {

    struct Error: Swift.Error {
        let desc: String
    }

}

// MARK: - Response Validation

private extension Network {

    static func validate(_ res: URLResponse) throws {
        guard let response = res as? HTTPURLResponse else {
            assertionFailure("Response type mismatch")
            throw Error(desc: "Received response of unexpected type: \(res)")
        }

        guard case (200...299) = response.statusCode else { throw Error(desc: String(response.statusCode)) }
    }

}

// MARK: - Map

private extension Network {

    static func map(from data: Data?, response: URLResponse?, error: Swift.Error?) throws -> Mapper {
        if let error = error {
            throw Error(desc: error.localizedDescription)
        }

        guard let response = response, let data = data else {
            throw Error(desc: "No response received")
        }

        try validate(response)
        return try map(from: data)
    }

    static func map(from data: Data) throws -> Mapper {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = json as? NSDictionary else {
            throw Error(desc: "Unexpected root object in json: \(json)")
        }

        return Mapper(JSON: dict)
    }

}
