import UIKit

public final class SWTextField: UITextField {
    private let horizontalInset: CGFloat = SWSpacing.small

    public init(placeholder: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .none
        backgroundColor = SWColor.Background.surface
        textColor = SWColor.Content.primary
        font = SWTypography.body
        layer.cornerRadius = SWRadius.medium
        layer.borderWidth = 1
        layer.borderColor = SWColor.Border.subtle.cgColor
        autocorrectionType = .no
        autocapitalizationType = .sentences
        self.placeholder = placeholder
    }

    public required init?(coder: NSCoder) { nil }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: horizontalInset, dy: 0)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: horizontalInset, dy: 0)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: horizontalInset, dy: 0)
    }
}
