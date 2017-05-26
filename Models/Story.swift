import CoreData
import Mapper
import Foundation

public final class Story: Item {

    public required init(map: Mapper, context: NSManagedObjectContext) throws {
        try super.init(map: map, context: context)
        link = try? map.from("url")
        text = try? map.from("text")
        title = try? map.from("title")
        let commentsArray: [Comment] = try map.from("children")
    }

}
