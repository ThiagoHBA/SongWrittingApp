import SwiftUI
import UIKit

struct IdentifiableItem: Identifiable {
    var id = UUID()
    var image: URL?
}

final class ItemListModel: ObservableObject {
    @Published var items: [IdentifiableItem] = []
}

final class ReferencesSectionView: UIView {
    private let itemModel = ItemListModel()

    var references: [AlbumReferenceViewEntity] = [] {
        didSet { updateItems(newItems: references) }
    }

    var addReferenceTapped: (() -> Void)?

    private let title: UILabel = {
        let label = UILabel()
        label.text = "Referências"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addButton: AddButtonComponent = {
        let button = AddButtonComponent()
        button.didTapped = { [weak self] in self?.addReferenceTapped?() }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var referenceList: UIView = {
        let hosting = UIHostingController(rootView: ReferenceListView(itemModel: itemModel))
        guard let uiKitView = hosting.view else { return UIView() }
        uiKitView.translatesAutoresizingMaskIntoConstraints = false
        return uiKitView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }

    private func updateItems(newItems: [AlbumReferenceViewEntity]) {
        itemModel.items = newItems.map { IdentifiableItem(image: $0.coverImage) }
    }
}

extension ReferencesSectionView: ViewCoding {
    func additionalConfiguration() {
        backgroundColor = .systemBackground
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            title.heightAnchor.constraint(equalToConstant: 30),

            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 28),
            addButton.widthAnchor.constraint(equalToConstant: 32),

            referenceList.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 24),
            referenceList.leadingAnchor.constraint(equalTo: leadingAnchor),
            referenceList.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func addViewInHierarchy() {
        addSubview(title)
        addSubview(addButton)
        addSubview(referenceList)
    }
}
