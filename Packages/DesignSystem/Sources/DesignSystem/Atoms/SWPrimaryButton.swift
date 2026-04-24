import UIKit

public final class SWPrimaryButton: UIButton {
    public init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = SWColor.Accent.primary
        setTitleColor(SWColor.Content.inverse, for: .normal)
        titleLabel?.font = SWTypography.button
        titleLabel?.adjustsFontForContentSizeCategory = true
        layer.cornerRadius = SWRadius.medium
        setTitle(title, for: .normal)
        accessibilityTraits = .button
    }

    public required init?(coder: NSCoder) { nil }

    public func updateTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}
