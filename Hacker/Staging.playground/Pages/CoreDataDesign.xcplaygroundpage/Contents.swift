import CoreData
import Models
import Mapper

let container = NSPersistentContainer(name: "Hacker")
container.loadPersistentStores { (_, error) in
    if let error = error {
        print(error)
    }
}

enum MappingError: Error {
    case couldNotUnwrap
}

protocol JSONDecodable {
    static func from(_ map: Mapper, in context: NSManagedObjectContext) throws -> Self
}

extension Story: JSONDecodable {
    static func from(_ map: Mapper, in context: NSManagedObjectContext) throws -> Self {
        fatalError()
    }
}

do {
    let storyFile = #fileLiteral(resourceName: "story.json")
    let storyData = try Data(contentsOf: storyFile)
    let json = try JSONSerialization.jsonObject(with: storyData, options: [])
    let mapper = Mapper(JSON: json as! NSDictionary)
    let item = try Item(map: mapper, in: container.viewContext)

    try container.viewContext.save()
} catch { print(error) }
