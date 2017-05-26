import Mapper
import Foundation

public extension Mapper {

    public init(file: URL) throws {
        let data = try Data(contentsOf: file, options: [])
        guard let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary else {
            throw MapperError.customError(field: nil, message: "Could not parse contents of file into valid JSON: \(file)")
        }
        self.init(JSON: json)
    }

}
