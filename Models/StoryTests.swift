import CoreData
import XCTest
import Nimble
@testable import Models

class StoryTests: XCTestCase {

    var container: NSPersistentContainer!
    var context: NSManagedObjectContext {
        return container.viewContext
    }

    override func setUp() {
        super.setUp()

        let modelsBundle = Bundle(identifier: "me.amitjain.Models")
        let modelURL = modelsBundle!.url(forResource: "Hacker", withExtension: "momd")!
        container = NSPersistentContainer(name: "Hacker", managedObjectModel: NSManagedObjectModel(contentsOf: modelURL)!)

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (_, error) in
            if error != nil { fatalError() }
        }
    }

    func testParsingStory() throws {
        let story = try Story(map: .init(file: R.file.storyJson()!), context: context)
        expect(story.id) == "3742902"
        expect(story.author) == "olalonde"
        expect(story.title) == "Show HN: This up votes itself"
        expect(story.url) == URL(string: "htpp://test.com")!
        expect(story.points) == 3381
        expect(story.text) == "This is story text"
        expect(story.comments.count) == 5
        expect(try self.context.save()).toNot(throwError())
    }

    func testParsingStoryWithNegativePoints() throws {
        let story = try Story(map: .init(file: R.file.storyWithNegativePointsJson()!), context: context)
        expect(story.points) == -1
        expect(try self.context.save()).toNot(throwError())
    }

    func testParsingAStoryWithoutPoints() throws {
        let story = try Story(map: .init(file: R.file.storyWithoutPointsJson()!), context: context)
        expect(story.points) == 0
        expect(try self.context.save()).toNot(throwError())
    }

    func testThatAnInvalidStoryIsNotParsed() {
        expect(try Story(map: .init(file: R.file.storyWithoutIDJson()!), context: self.context)).to(throwError())
    }

    func testThatCommentsAreParsedByIgnoringInvalidComments() throws {
        let story = try Story(map: .init(file: R.file.storyWithInvalidCommentJson()!), context: context)
        expect(story.comments.count) == 2
        expect(story.comments[0].id) == "3743110"
        expect(story.comments[1].id) == "3742988"
        expect(try self.context.save()).toNot(throwError())
    }

    func testSavingAFullStoryInStore() throws {
        let story = try Story(map: .init(file: R.file.fullStoryJson()!), context: self.context)
        expect(story.comments.count) == 83
        expect(try self.context.save()).toNot(throwError())
    }

    func testParsingPerformance() {
        self.measure {
            try! self.testSavingAFullStoryInStore()
        }
    }

}
