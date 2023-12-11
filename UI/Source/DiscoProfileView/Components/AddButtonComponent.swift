//
//  AddButton.swift
//  UI
//
//  Created by Thiago Henrique on 11/12/23.
//

import UIKit

class AddButtonComponent: UIView {
    var didTapped: (() -> Void)?
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    @objc func buttonTapped() { didTapped?() }
}

extension AddButtonComponent: ViewCoding {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.topAnchor.constraint(equalTo: topAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addButton.heightAnchor.constraint(equalTo: heightAnchor),
            addButton.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    func addViewInHierarchy() {
        addSubview(addButton)
    }
}
