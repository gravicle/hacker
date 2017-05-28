import Mapper
import CoreData

extension Mapper {

    func from<T: JSONDecodable>(_ field: String, in context: NSManagedObjectContext) throws -> [T] {
        let value = try self.JSONFromField(field)
        guard let JSON = value as? [NSDictionary] else {
            throw MapperError.typeMismatchError(field: field, value: value, type: [NSDictionary].self)
        }
        return JSON.flatMap {
            do {
                return try T(map: Mapper(JSON: $0), context: context)
            } catch {
                print(error)
                return nil
            }
        }
    }

}
