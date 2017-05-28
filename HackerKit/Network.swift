import Foundation
import RxSwift
import Mapper

struct Network {

    private init() {}

    static func request<R: Request>(_ request: R, using session: URLSession) -> Single<R.Resource> {
        guard let url = request.url else {
            return Observable.error(Error(desc: "Malformed Request: \(request)")).asSingle()
        }

        return Observable.create { (observer) -> Disposable in
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    observer.onError(Error(desc: error.localizedDescription))
                }

                guard let response = response, let data = data else {
                    observer.onError(Error(desc: "No response received"))
                    return
                }

                do { try validate(response) } catch { observer.onError(error) }
                do {
                    let mapper = try map(from: data)
                    let resource = try request.map(mapper)
                    observer.onNext(resource)
                } catch { observer.onError(error) }
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
        .asSingle()
    }

}

extension Network {

    struct Error: Swift.Error {
        let desc: String
    }

}

private extension Network {

    static func validate(_ res: URLResponse) throws {
        guard let response = res as? HTTPURLResponse else {
            assertionFailure("Response type mismatch")
            throw Error(desc: "Received response of unexpected type: \(res)")
        }

        guard case (200...299) = response.statusCode else { throw Error(desc: String(response.statusCode)) }
    }

    static func map(from data: Data) throws -> Mapper {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = json as? NSDictionary else {
            throw Error(desc: "Unexpected root object in json: \(json)")
        }

        return Mapper(JSON: dict)
    }

}
