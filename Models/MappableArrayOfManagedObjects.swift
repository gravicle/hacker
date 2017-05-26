import Mapper
import CoreData

extension Mapper {

    func from<T: JSONDecodable>(_ field: String, in context: NSManagedObjectContext) throws -> [T] {
        let value = try self.JSONFromField(field)
        guard let JSON = value as? [NSDictionary] else {
            throw MapperError.typeMismatchError(field: field, value: value, type: [NSDictionary].self)
        }
        guard JSON.count > 0 else { throw MapperError.customError(field: field, message: "No elements in array.") }
        return try JSON.map { try T(map: Mapper(JSON: $0), context: context) }
    }

}
