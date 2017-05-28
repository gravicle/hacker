import CoreData
import Mapper
import Foundation

@objc
public final class Story: Item {

    public var url: URL? {
        return link.flatMap(URL.init)
    }

    public var comments: [Comment] {
        return commentsSet?.array
            .flatMap { $0 as? Comment }
            ?? []
    }

    public required init(map: Mapper, context: NSManagedObjectContext) throws {
        try super.init(map: map, context: context)
        link = try? map.from("url")
        text = try? map.from("text")
        title = try? map.from("title")
        let comments: [Comment]? = try? map.from("children", in: context)
        comments?.forEach { $0.addTo(self) }
    }

}
