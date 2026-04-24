import UIKit

public struct SWDiscoCreationFormContent {
    public let title: String
    public let coverButtonTitle: String
    public let nameLabel: String
    public let namePlaceholder: String
    public let descriptionLabel: String
    public let descriptionPlaceholder: String
    public let submitButtonTitle: String

    public init(
        title: String,
        coverButtonTitle: String,
        nameLabel: String,
        namePlaceholder: String,
        descriptionLabel: String,
        descriptionPlaceholder: String,
        submitButtonTitle: String
    ) {
        self.title = title
        self.coverButtonTitle = coverButtonTitle
        self.nameLabel = nameLabel
        self.namePlaceholder = namePlaceholder
        self.descriptionLabel = descriptionLabel
        self.descriptionPlaceholder = descriptionPlaceholder
        self.submitButtonTitle = submitButtonTitle
    }

    public static let `default` = SWDiscoCreationFormContent(
        title: "Novo Disco",
        coverButtonTitle: "Escolher Capa",
        nameLabel: "Nome",
        namePlaceholder: "Ex: Meu novo disco incrível",
        descriptionLabel: "Descrição (opcional)",
        descriptionPlaceholder: "Ex: Um álbum de rock progressivo...",
        submitButtonTitle: "Criar Disco"
    )
}

public final class SWDiscoCreationFormView: UIView, UITextFieldDelegate {
    public var onPickCoverTap: (() -> Void)?
    public var onSubmitTap: (() -> Void)?

    private let titleLabel = SWTextLabel(style: .sectionTitle)
    private let coverButton: SWCoverButton
    private let nameFieldView: SWLabeledTextFieldView
    private let descriptionFieldView: SWLabeledTextFieldView
    private let submitButton = SWPrimaryButton(title: "")

    private static let descriptionMaxLength = 250

    public init(content: SWDiscoCreationFormContent = .default) {
        coverButton = SWCoverButton(title: content.coverButtonTitle)
        nameFieldView = SWLabeledTextFieldView(title: content.nameLabel, placeholder: content.namePlaceholder)
        descriptionFieldView = SWLabeledTextFieldView(
            title: content.descriptionLabel,
            placeholder: content.descriptionPlaceholder
        )
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = content.title
        titleLabel.textAlignment = .center
        submitButton.updateTitle(content.submitButtonTitle)

        coverButton.addTarget(self, action: #selector(handlePickCoverTap), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(handleSubmitTap), for: .touchUpInside)
        descriptionFieldView.textField.delegate = self

        addSubview(titleLabel)
        addSubview(coverButton)
        addSubview(nameFieldView)
        addSubview(descriptionFieldView)
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

            descriptionFieldView.topAnchor.constraint(equalTo: nameFieldView.bottomAnchor, constant: SWSpacing.small),
            descriptionFieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),

            submitButton.topAnchor.constraint(
                greaterThanOrEqualTo: descriptionFieldView.bottomAnchor,
                constant: SWSpacing.xLarge
            ),
            submitButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            submitButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SWSpacing.large),
            submitButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight)
        ])
    }

    public required init?(coder: NSCoder) { nil }

    public var discoName: String {
        nameFieldView.text
    }

    public var discoDescription: String {
        descriptionFieldView.text
    }

    public var selectedCoverImage: UIImage? {
        coverButton.selectedCoverImage
    }

    public func updateSelectedImage(_ image: UIImage?) {
        coverButton.updateImage(image)
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard textField === descriptionFieldView.textField else { return true }
        let current = textField.text ?? ""
        let updated = (current as NSString).replacingCharacters(in: range, with: string)
        return updated.count <= SWDiscoCreationFormView.descriptionMaxLength
    }

    @objc private func handlePickCoverTap() {
        onPickCoverTap?()
    }

    @objc private func handleSubmitTap() {
        onSubmitTap?()
    }
}
