//
//  ReferencesTableView.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation
import SwiftUI

struct IdentifiableItem: Identifiable {
    var id: UUID = UUID()
    var image: URL?
}

class ItemListModel: ObservableObject {
    @Published var items: [IdentifiableItem] = []
}

class ReferencesSectionView: UIView {
    private var itemModel = ItemListModel()

    var references: [AlbumReferenceViewEntity] = [] {
        didSet { updateItems(newItems: references) }
    }

    var addReferenceTapped: (() -> Void)?

    let title: UILabel = {
        let label = UILabel()
        label.text = "Referências"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var addButton: AddButtonComponent = {
        let button = AddButtonComponent()
        button.didTapped = { [weak self] in self?.addReferenceTapped?() }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var referenceList: UIView = {
        let itemArray = itemModel.$items
        let suiView = UIHostingController(
            rootView: ReferenceListView(itemModel: itemModel)
        )
        guard let uiKitView = suiView.view else { return UIView() }
        uiKitView.translatesAutoresizingMaskIntoConstraints = false
        return uiKitView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }

    func updateItems(newItems: [AlbumReferenceViewEntity]) {
        itemModel.items = newItems.map {
            IdentifiableItem(image: $0.coverImage)
        }
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
