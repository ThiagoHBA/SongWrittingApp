//
//  CreateDiscoView.swift
//  UI
//
//  Created by Thiago Henrique on 09/12/23.
//

import UIKit

class CreateDiscoViewController: UIViewController {
    var createDiscoTapped: ((String, Data) -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Novo Disco"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let discoImage: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .gray.withAlphaComponent(0.5)
        configuration.image = UIImage(
            systemName: "photo.on.rectangle.angled"
        )!.applyingSymbolConfiguration(.init(pointSize: 64))
        
        configuration.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ex: Meu novo disco incrível"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Criar Disco", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    @objc func buttonTapped() {
        if nameField.text == nil { nameField.text = "" }
        let name = nameField.text!
        let imageData = discoImage.imageView!.image!.pngData()!
        self.createDiscoTapped?(name, imageData)
    }
}

extension CreateDiscoViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            discoImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            discoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            discoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            discoImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            
            nameLabel.topAnchor.constraint(equalTo: discoImage.bottomAnchor, constant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 42),
            
            createButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 32),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            createButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    func addViewInHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(discoImage)
        view.addSubview(nameLabel)
        view.addSubview(nameField)
        view.addSubview(createButton)
    }
}
