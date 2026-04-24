import UIKit

public struct SWHeaderActionContent {
    public let title: String
    public let titleStyle: SWTextLabel.Style
    public let actionSymbolName: String
    public let actionAccessibilityLabel: String

    public init(
        title: String,
        titleStyle: SWTextLabel.Style = .sectionTitle,
        actionSymbolName: String,
        actionAccessibilityLabel: String
    ) {
        self.title = title
        self.titleStyle = titleStyle
        self.actionSymbolName = actionSymbolName
        self.actionAccessibilityLabel = actionAccessibilityLabel
    }
}

public final class SWHeaderActionView: UIView {
    public var onActionTap: (() -> Void)?

    private let titleLabel = SWTextLabel(style: .heroTitle, numberOfLines: 0)
    private let actionButton = SWIconButton(symbolName: "plus")

    override public init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        actionButton.addTarget(self, action: #selector(handleActionTap), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            actionButton.leadingAnchor.constraint(
                greaterThanOrEqualTo: titleLabel.trailingAnchor,
                constant: SWSpacing.medium
            ),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: SWSize.iconButton),
            actionButton.widthAnchor.constraint(equalToConstant: SWSize.iconButton)
        ])
    }

    public required init?(coder: NSCoder) { nil }

    override public var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: max(titleLabel.font.lineHeight, SWSize.iconButton)
        )
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = bounds.width - SWSize.iconButton - SWSpacing.medium
    }

    public func configure(with content: SWHeaderActionContent) {
        titleLabel.text = content.title
        titleLabel.apply(style: content.titleStyle)
        actionButton.accessibilityLabel = content.actionAccessibilityLabel
        invalidateIntrinsicContentSize()
        actionButton.setImage(
            UIImage(
                systemName: content.actionSymbolName,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: SWSize.iconRegular,
                    weight: .bold
                )
            ),
            for: .normal
        )
    }

    @objc private func handleActionTap() {
        onActionTap?()
    }
}
