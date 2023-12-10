//
//  CreateDiscoView.swift
//  UI
//
//  Created by Thiago Henrique on 09/12/23.
//

import UIKit
import PhotosUI

class CreateDiscoViewController: UIViewController {
    var createDiscoTapped: ((String, Data) -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Novo Disco"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var discoImage: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName:"photo.on.rectangle.angled"
            )!.applyingSymbolConfiguration(.init(pointSize: 64)),
            for: .normal
        )
        button.backgroundColor = .gray.withAlphaComponent(0.5)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(pickImageButton), for: .touchUpInside)
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
    
    func configureImagePicker(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    @objc func buttonTapped() {
        if nameField.text == nil { nameField.text = "" }
        let name = nameField.text!
        let imageData = discoImage.imageView!.image!.pngData()!
        self.createDiscoTapped?(name, imageData)
    }
    
    @objc func pickImageButton() {
        configureImagePicker()
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

extension CreateDiscoViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        if let itemprovider = results.first?.itemProvider {
            if itemprovider.canLoadObject(ofClass: UIImage.self) {
                itemprovider.loadObject(ofClass: UIImage.self) { image , error  in
                    if error != nil { return }
                    if let selectedImage = image as? UIImage{
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.discoImage.setImage(selectedImage, for: .normal)
                        }
                    }
                }
            }
        }
    }
}
