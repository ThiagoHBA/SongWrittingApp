import SDWebImage
import UIKit

public struct SWReferenceAvatarContent {
    public let imageURL: URL?

    public init(imageURL: URL?) {
        self.imageURL = imageURL
    }
}

public struct SWReferenceSectionContent {
    public let title: String
    public let actionSymbolName: String
    public let actionAccessibilityLabel: String
    public let emptyStateMessage: String
    public let items: [SWReferenceAvatarContent]

    public init(
        title: String,
        actionSymbolName: String,
        actionAccessibilityLabel: String,
        emptyStateMessage: String,
        items: [SWReferenceAvatarContent]
    ) {
        self.title = title
        self.actionSymbolName = actionSymbolName
        self.actionAccessibilityLabel = actionAccessibilityLabel
        self.emptyStateMessage = emptyStateMessage
        self.items = items
    }
}

public final class SWReferenceSectionView: UIView {
    public var onActionTap: (() -> Void)? {
        didSet {
            headerView.onActionTap = onActionTap
        }
    }

    private var currentContent = SWReferenceSectionContent(
        title: "",
        actionSymbolName: "plus",
        actionAccessibilityLabel: "",
        emptyStateMessage: "",
        items: []
    )

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    private let headerView = SWHeaderActionView()
    private let emptyStateView = SWMessageView()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let avatarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = SWSpacing.xxSmall
        return stackView
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(emptyStateView)
        stackView.addArrangedSubview(scrollView)
        scrollView.addSubview(avatarStackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scrollView.heightAnchor.constraint(equalToConstant: SWSize.referenceAvatar),

            avatarStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            avatarStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            avatarStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            avatarStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            avatarStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    public required init?(coder: NSCoder) { nil }

    override public var intrinsicContentSize: CGSize {
        let contentHeight: CGFloat
        if currentContent.items.isEmpty {
            contentHeight = max(
                emptyStateView.intrinsicContentSize.height,
                SWTypography.body.lineHeight
            )
        } else {
            contentHeight = SWSize.referenceAvatar
        }

        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: headerView.intrinsicContentSize.height + contentHeight
        )
    }

    public func configure(with content: SWReferenceSectionContent) {
        currentContent = content
        headerView.configure(
            with: SWHeaderActionContent(
                title: content.title,
                actionSymbolName: content.actionSymbolName,
                actionAccessibilityLabel: content.actionAccessibilityLabel
            )
        )
        emptyStateView.configure(message: content.emptyStateMessage)

        avatarStackView.arrangedSubviews.forEach { subview in
            avatarStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        content.items.forEach { item in
            avatarStackView.addArrangedSubview(makeAvatarView(with: item))
        }

        let hasItems = !content.items.isEmpty
        scrollView.isHidden = !hasItems
        emptyStateView.isHidden = hasItems
        invalidateIntrinsicContentSize()
    }

    private func makeAvatarView(with content: SWReferenceAvatarContent) -> UIView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = SWColor.Background.mutedSurface
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = SWSize.referenceAvatar / 2

        if let imageURL = content.imageURL {
            imageView.sd_setImage(with: imageURL)
        }

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: SWSize.referenceAvatar),
            imageView.heightAnchor.constraint(equalToConstant: SWSize.referenceAvatar)
        ])

        return imageView
    }
}
