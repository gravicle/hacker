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

    func testCreatingStoryInStore() {
        let story = try? Story(map: .init(file: ), context: context)
        expect(story).toNot(beNil())
    }

}
