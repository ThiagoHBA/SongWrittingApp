//
//  AddRecordsViewController.swift
//  UI
//
//  Created by Thiago Henrique on 11/12/23.
//

import UIKit

class AddRecordsViewController: UIViewController {
    var addSectionTapped: ((String) -> Void)?
    
    let sectionTitle: UILabel = {
        let label = UILabel()
        label.text = "Título"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var navBar: UINavigationBar = {
        let nav = UINavigationBar()
        let navigationItem = UINavigationItem(title: "Nova gravação")
        nav.items = [navigationItem]
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()
    
    private lazy var createSessionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Criar Seção", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    @objc func createTapped() {

    }
}

extension AddRecordsViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 46),
            
            sectionTitle.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 32),
            sectionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),

            createSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createSessionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])
    }
    
    func addViewInHierarchy() {
        view.addSubview(createSessionButton)
        view.addSubview(sectionTitle)
        view.addSubview(navBar)
    }
}
