import Foundation

final class MainQueueProxy<T: AnyObject> {
    let instance: T

    init(_ instance: T) {
        self.instance = instance
    }
}
