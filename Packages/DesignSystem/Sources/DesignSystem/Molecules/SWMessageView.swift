import UIKit

public final class SWMessageView: UIView {
    private let messageLabel = SWTextLabel(style: .body, numberOfLines: 0)

    override public init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        messageLabel.textAlignment = .center

        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    public required init?(coder: NSCoder) { nil }

    override public var intrinsicContentSize: CGSize {
        let availableWidth = max(bounds.width, UIScreen.main.bounds.width - (SWSpacing.large * 2))
        let fittingSize = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        let labelHeight = messageLabel.sizeThatFits(fittingSize).height

        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: ceil(labelHeight)
        )
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        messageLabel.preferredMaxLayoutWidth = bounds.width
    }

    public func configure(message: String) {
        messageLabel.text = message
        invalidateIntrinsicContentSize()
    }
}
