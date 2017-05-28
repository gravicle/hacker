import CoreData
import Mapper

@objc
public final class Comment: Item {

    public var children: [Comment] {
        return childrenSet?.array
            .flatMap { $0 as? Comment } ?? []
    }

    public required init(map: Mapper, context: NSManagedObjectContext) throws {
        try super.init(map: map, context: context)
        text = try? map.from("text")

        let children: [Comment]? = try? map.from("children", in: context)
        children?.forEach(addToChildrenSet)
    }

    /// Adds comment to a story.
    /// Called on top level comments which call
    /// the method on their children. Ultimately, the entire 
    /// graph inherits `story` as its parent node.
    ///
    /// - Parameter story: The parent Story
    @nonobjc
    func addTo(_ story: Story) {
        self.story = story
        children.forEach { $0.addTo(story) }
    }

}
