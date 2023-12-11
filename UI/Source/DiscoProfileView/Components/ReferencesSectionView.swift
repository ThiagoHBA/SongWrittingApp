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
    var image: UIImage?
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
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var referenceList: UIView = {
        let itemArray = itemModel.$items
        let suiView = UIHostingController(
            rootView: ReferenceListView(
                itemModel: itemModel
            )
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
            IdentifiableItem(image: UIImage(data: $0.coverImage))
        }
    }
    
    @objc func buttonTapped() {
        addReferenceTapped?()
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

            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 28),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            
            referenceList.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 18),
            referenceList.leadingAnchor.constraint(equalTo: leadingAnchor),
            referenceList.trailingAnchor.constraint(equalTo: trailingAnchor),
            referenceList.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func addViewInHierarchy() {
        addSubview(title)
        addSubview(addButton)
        addSubview(referenceList)
    }
}
