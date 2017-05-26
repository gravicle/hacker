import CoreData
import Mapper

public class Item: NSManagedObject, JSONDecodable {

    public required init(map: Mapper, context: NSManagedObjectContext) throws {
        let className = type(of: self).className
        guard let entity = NSEntityDescription.entity(forEntityName: className, in: context) else {
            fatalError("Could not find model entity named: \(className)")
        }

        super.init(entity: entity, insertInto: context)

        id = String(try map.from("id") as Int)
        date = try map.from("created_at_i", transformation: Transform.extractDateFromTimeInterval) as NSDate
        points = try map.from("points")
        author = try map.from("author")
    }

}

// https://stackoverflow.com/a/39993120/2671390
private extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}
