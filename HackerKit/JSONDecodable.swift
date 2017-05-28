import CoreData
import Mapper

public protocol JSONDecodable {
    init(map: Mapper, context: NSManagedObjectContext) throws
}
