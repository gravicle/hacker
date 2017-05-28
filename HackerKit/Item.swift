import CoreData
import Mapper

@objc
public class Item: NSManagedObject, JSONDecodable {

    public required init(map: Mapper, context: NSManagedObjectContext) throws {
        let className = type(of: self).className
        guard let entity = NSEntityDescription.entity(forEntityName: className, in: context) else {
            fatalError("Could not find model entity named: \(className)")
        }

        // If requirements are met, only then create object in the context 
        // by calling super.init. Oterwise objects which do not meet requirements
        // cause runtime crashes when trying to save the context.
        let id = String(try map.from("id") as Int)
        let date = try map.from("created_at_i", transformation: Transform.extractDateFromTimeInterval) as NSDate
        let points: Int32? = try? map.from("points") // points can be nil in the response, for some reason
        let author: String = try map.from("author")

        super.init(entity: entity, insertInto: context)
        self.id = id
        self.date = date
        self.points = points ?? 0
        self.author = author
    }

}

// https://stackoverflow.com/a/39993120/2671390
private extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}
