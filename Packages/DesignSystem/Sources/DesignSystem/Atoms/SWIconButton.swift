import UIKit

public final class SWIconButton: UIButton {
    public enum Style {
        case regular
        case floatingAction
    }

    public init(
        symbolName: String,
        accessibilityLabel: String? = nil,
        style: Style = .regular
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setImage(
            UIImage(
                systemName: symbolName,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: SWSize.iconRegular,
                    weight: .bold
                )
            ),
            for: .normal
        )
        self.accessibilityLabel = accessibilityLabel
        accessibilityTraits = .button
        apply(style)
    }

    public required init?(coder: NSCoder) { nil }

    private func apply(_ style: Style) {
        switch style {
        case .regular:
            tintColor = SWColor.Accent.primary
            backgroundColor = SWColor.Accent.emphasisBackground
            layer.cornerRadius = SWRadius.pill
            layer.shadowOpacity = 0

        case .floatingAction:
            tintColor = SWColor.Content.inverse
            backgroundColor = SWColor.Accent.primary
            layer.cornerRadius = SWSize.floatingActionButton / 2
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.18
            layer.shadowRadius = 12
            layer.shadowOffset = CGSize(width: 0, height: 6)
            layer.masksToBounds = false
        }
    }
}
