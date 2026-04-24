import UIKit

public struct SWReferenceSelectionChipContent {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}

public final class SWReferenceSelectionListView: UIView {
    public var onChipTap: ((Int) -> Void)?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = SWSpacing.xxSmall
        stackView.alignment = .fill
        return stackView
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    public required init?(coder: NSCoder) { nil }

    public func configure(items: [SWReferenceSelectionChipContent]) {
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        items.enumerated().forEach { index, item in
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index

            var configuration = UIButton.Configuration.plain()
            configuration.baseForegroundColor = SWColor.Accent.primary
            configuration.background.backgroundColor = SWColor.Accent.emphasisBackground
            configuration.cornerStyle = .capsule
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: SWSpacing.xxxSmall + 2,
                leading: SWSpacing.xxSmall,
                bottom: SWSpacing.xxxSmall + 2,
                trailing: SWSpacing.xxSmall
            )
            configuration.image = UIImage(systemName: "xmark.circle.fill")
            configuration.imagePlacement = .trailing
            configuration.imagePadding = SWSpacing.xxxSmall
            configuration.attributedTitle = AttributedString(
                item.title,
                attributes: AttributeContainer([.font: SWTypography.label])
            )
            button.configuration = configuration
            button.addTarget(self, action: #selector(handleChipTap(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    @objc private func handleChipTap(_ sender: UIButton) {
        onChipTap?(sender.tag)
    }
}
