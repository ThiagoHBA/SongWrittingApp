import UIKit

public struct SWActionCardContent {
    public let title: String
    public let symbolName: String
    public let accessibilityLabel: String

    public init(title: String, symbolName: String, accessibilityLabel: String) {
        self.title = title
        self.symbolName = symbolName
        self.accessibilityLabel = accessibilityLabel
    }
}

public final class SWActionCardView: UIButton {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = SWColor.Content.primary
        configuration.background.backgroundColor = SWColor.Background.surface
        configuration.background.cornerRadius = SWRadius.large
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: SWSpacing.medium,
            leading: SWSpacing.small,
            bottom: SWSpacing.medium,
            trailing: SWSpacing.small
        )
        configuration.imagePlacement = .top
        configuration.imagePadding = SWSpacing.small
        configuration.titleAlignment = .center
        self.configuration = configuration
    }

    public required init?(coder: NSCoder) { nil }

    public func configure(with content: SWActionCardContent) {
        guard var configuration else { return }

        configuration.image = UIImage(
            systemName: content.symbolName,
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: SWSize.iconRegular + 6,
                weight: .semibold
            )
        )
        configuration.attributedTitle = AttributedString(
            content.title,
            attributes: AttributeContainer([.font: SWTypography.label])
        )

        self.configuration = configuration
        accessibilityLabel = content.accessibilityLabel
    }
}
