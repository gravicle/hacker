import CoreData
import Mapper

extension Transform {

    public static func toOrderedSet(value: Any?) throws -> NSOrderedSet {
        guard let array = value as? [Any] else {
            throw MapperError.convertibleError(value: value, type: Any.self)
        }

        return NSOrderedSet(array: array)
    }

}
