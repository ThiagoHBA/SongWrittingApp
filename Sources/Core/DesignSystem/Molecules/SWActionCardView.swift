import UIKit

struct SWActionCardContent {
    let title: String
    let symbolName: String
    let accessibilityLabel: String
}

final class SWActionCardView: UIButton {
    override init(frame: CGRect) {
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

    required init?(coder: NSCoder) { nil }

    func configure(with content: SWActionCardContent) {
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
