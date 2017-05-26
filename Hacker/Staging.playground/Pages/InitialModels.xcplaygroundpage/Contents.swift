import Foundation

struct ItemID {
    let value: String
}

struct UserName {
    let value: String
}

class User {
    let userName: UserName
    let about: String?

    init(userName: UserName, about: String?) {
        self.userName = userName
        self.about = about
    }
}

final class Item {
    enum `Type`: Int32 {
        case story, comment
    }

    let id: ItemID
    let type: Type
    let author: User
    let date: Date
    let points: Int
    let title: String?
    let link: URL?
    let text: String?
    let children: [Item]
}