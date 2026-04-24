import UIKit

public final class SWLabeledTextFieldView: UIView {
    private let minimumHeight: CGFloat = 48
    private let titleLabel = SWTextLabel(style: .label)
    public let textField: SWTextField

    public init(title: String, placeholder: String) {
        textField = SWTextField(placeholder: placeholder)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = title

        addSubview(titleLabel)
        addSubview(textField)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SWSpacing.xxSmall),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: SWSize.textFieldHeight)
        ])
    }

    public required init?(coder: NSCoder) { nil }

    override public var intrinsicContentSize: CGSize {
        let calculatedHeight = titleLabel.font.lineHeight + SWSpacing.xxSmall + SWSize.textFieldHeight

        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: max(minimumHeight, calculatedHeight)
        )
    }

    public var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    public func focus() {
        textField.becomeFirstResponder()
    }
}
