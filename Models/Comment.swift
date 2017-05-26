import CoreData
import Mapper

@objc
public final class Comment: Item {

    public required init(map: Mapper, context: NSManagedObjectContext) throws {
        try super.init(map: map, context: context)
        text = try? map.from("text")
        (try? map.from("children", in: context))?.forEach(addToChildren)
    }

}
