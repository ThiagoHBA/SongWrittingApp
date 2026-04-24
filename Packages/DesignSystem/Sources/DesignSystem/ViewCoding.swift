import Foundation

public protocol ViewCoding {
    func setupConstraints()
    func addViewInHierarchy()
    func additionalConfiguration()
    func buildLayout()
}

extension ViewCoding {
    public func buildLayout() {
        addViewInHierarchy()
        setupConstraints()
        additionalConfiguration()
    }

    public func additionalConfiguration() {}
}
