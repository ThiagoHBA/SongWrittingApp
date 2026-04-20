//
//  SWDiscoCreationFormView.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

struct SWDiscoCreationFormContent {
    let title: String
    let coverButtonTitle: String
    let nameLabel: String
    let namePlaceholder: String
    let submitButtonTitle: String

    static let `default` = SWDiscoCreationFormContent(
        title: "Novo Disco",
        coverButtonTitle: "Escolher Capa",
        nameLabel: "Nome",
        namePlaceholder: "Ex: Meu novo disco incrível",
        submitButtonTitle: "Criar Disco"
    )
}

final class SWDiscoCreationFormView: UIView {
    var onPickCoverTap: (() -> Void)?
    var onSubmitTap: (() -> Void)?

    private let titleLabel = SWTextLabel(style: .sectionTitle)
    private let coverButton: SWCoverButton
    private let nameFieldView: SWLabeledTextFieldView
    private let submitButton = SWPrimaryButton(title: "")

    init(content: SWDiscoCreationFormContent = .default) {
        coverButton = SWCoverButton(title: content.coverButtonTitle)
        nameFieldView = SWLabeledTextFieldView(title: content.nameLabel, placeholder: content.namePlaceholder)
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = content.title
        titleLabel.textAlignment = .center
        submitButton.updateTitle(content.submitButtonTitle)

        coverButton.addTarget(self, action: #selector(handlePickCoverTap), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(handleSubmitTap), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(coverButton)
        addSubview(nameFieldView)
        addSubview(submitButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            coverButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SWSpacing.xLarge),
            coverButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverButton.heightAnchor.constraint(equalToConstant: SWSize.creationCoverHeight),

            nameFieldView.topAnchor.constraint(equalTo: coverButton.bottomAnchor, constant: SWSpacing.large),
            nameFieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),

            submitButton.topAnchor.constraint(
                greaterThanOrEqualTo: nameFieldView.bottomAnchor,
                constant: SWSpacing.xLarge
            ),
            submitButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            submitButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SWSpacing.large),
            submitButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight)
        ])
    }

    required init?(coder: NSCoder) { nil }

    var discoName: String {
        nameFieldView.text
    }

    var selectedCoverImage: UIImage? {
        coverButton.selectedCoverImage
    }

    func updateSelectedImage(_ image: UIImage?) {
        coverButton.updateImage(image)
    }

    @objc private func handlePickCoverTap() {
        onPickCoverTap?()
    }

    @objc private func handleSubmitTap() {
        onSubmitTap?()
    }
}
