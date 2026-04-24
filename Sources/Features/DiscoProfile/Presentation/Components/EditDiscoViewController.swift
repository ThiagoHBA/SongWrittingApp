//
//  EditDiscoViewController.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import DesignSystem
import UIKit

final class EditDiscoViewController: UIViewController {
    var saveNameTapped: ((String) -> Void)?
    var deleteDiscoTapped: (() -> Void)?

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        button.backgroundColor = SWColor.Destructive.primary
        button.layer.cornerRadius = SWRadius.medium
        button.titleLabel?.font = SWTypography.button
        button.titleLabel?.adjustsFontForContentSizeCategory = true
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
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            navBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: SWSize.navigationBarHeight),

            nameField.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: SWSpacing.xLarge),
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SWSpacing.xSmall),
            nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.xSmall),

            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -SWSpacing.xxSmall),
            saveButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight),

            deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SWSpacing.medium),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.medium),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SWSpacing.large),
            deleteButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight)
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(navBar)
        contentView.addSubview(nameField)
        contentView.addSubview(saveButton)
        contentView.addSubview(deleteButton)
    }
}
