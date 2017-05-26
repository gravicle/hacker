import CoreData
import Mapper
import Foundation

@objc
public final class Story: Item {

    public required init(map: Mapper, context: NSManagedObjectContext) throws {
        try super.init(map: map, context: context)
        link = try? map.from("url")
        text = try? map.from("text")
        title = try? map.from("title")
        (try? map.from("children", in: context) as [Comment])?.forEach(addToChildren)
    }

}
