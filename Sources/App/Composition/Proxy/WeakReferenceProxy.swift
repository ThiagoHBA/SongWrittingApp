import Foundation

final class WeakReferenceProxy<T: AnyObject> {
    weak var instance: T?

    init(_ instance: T) {
        self.instance = instance
    }
}
