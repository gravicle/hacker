//import CoreData
//import Models
//import Mapper
//
//let container = NSPersistentContainer(name: "Hacker")
//let description = NSPersistentStoreDescription()
//description.type = NSInMemoryStoreType
//container.persistentStoreDescriptions = [description]
//container.loadPersistentStores { (_, error) in
//    if error != nil { fatalError() }
//}
//
//let context = container.viewContext
//do { let story = try Story(map: .init(file: #fileLiteral(resourceName: "story.json")), context: context) }
//catch { print(error) }
//
