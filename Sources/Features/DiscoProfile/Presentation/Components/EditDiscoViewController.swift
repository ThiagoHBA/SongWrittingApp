//
//  EditDiscoViewController.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import UIKit

final class EditDiscoViewController: UIViewController {
    var saveNameTapped: ((String) -> Void)?
    var deleteDiscoTapped: (() -> Void)?

    var discoName: String = "" {
        didSet { nameField.text = discoName }
    }

    let nameField = SWLabeledTextFieldView(
        title: "Nome",
        placeholder: "Nome do disco"
    )

    private lazy var navBar: UINavigationBar = {
        let nav = UINavigationBar()
        let navigationItem = UINavigationItem(title: "Editar Disco")
        nav.items = [navigationItem]
        nav.backgroundColor = .clear
        nav.isTranslucent = false
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()

    private lazy var saveButton: SWPrimaryButton = {
        let button = SWPrimaryButton(title: "Salvar")
        button.accessibilityLabel = "Salvar"
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Deletar Disco", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = SWRadius.medium
        button.titleLabel?.font = SWTypography.button
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Deletar Disco"
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }

    @objc private func saveTapped() {
        saveNameTapped?(nameField.text)
    }

    @objc private func deleteTapped() {
        deleteDiscoTapped?()
    }
}

extension EditDiscoViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
        modalPresentationStyle = .overCurrentContext
        navigationController?.topViewController?.extendedLayoutIncludesOpaqueBars = false
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: SWSize.navigationBarHeight),

            nameField.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: SWSpacing.xLarge),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.xSmall),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.xSmall),

            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -SWSpacing.xxSmall),
            saveButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight),

            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.medium),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.medium),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -SWSpacing.large),
            deleteButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight)
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(navBar)
        view.addSubview(nameField)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
    }
}
