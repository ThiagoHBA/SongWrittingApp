//
//  ReferencesTableView.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation
import SwiftUI

class ReferencesSectionView: UIView {
    var references: [AlbumReferenceViewEntity] = [] {
        didSet {
            referenceList = buildReferenceList()
        }
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Referências"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var referenceList: UIView = {
        return buildReferenceList()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func buildReferenceList() -> UIView {
        let suiView = UIHostingController(rootView: ReferenceListView(
            items: references.map {
                IdentifiableItem(image: UIImage(data: $0.coverImage))
            }
        ))
        guard let uiKitView = suiView.view else { return UIView() }
        uiKitView.translatesAutoresizingMaskIntoConstraints = false
        return uiKitView
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
