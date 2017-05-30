import Foundation
import RxSwift
import PlaygroundSupport
@testable import HackerKit

PlaygroundPage.current.needsIndefiniteExecution = true

let session = URLSession(configuration: .default)
_ = Network.request(HN.frontPageStories, using: session)
    .subscribe(
        onSuccess: { print($0) },
        onError: { print($0) }
    )
