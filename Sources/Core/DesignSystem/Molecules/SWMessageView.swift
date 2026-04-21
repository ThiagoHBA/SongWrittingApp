//
//  SWMessageView.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

final class SWMessageView: UIView {
    private let messageLabel = SWTextLabel(style: .body, numberOfLines: 0)

    override init(frame: CGRect) {
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

    required init?(coder: NSCoder) { nil }

    override var intrinsicContentSize: CGSize {
        let availableWidth = max(bounds.width, UIScreen.main.bounds.width - (SWSpacing.large * 2))
        let fittingSize = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        let labelHeight = messageLabel.sizeThatFits(fittingSize).height

        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: ceil(labelHeight)
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        messageLabel.preferredMaxLayoutWidth = bounds.width
    }

    func configure(message: String) {
        messageLabel.text = message
        invalidateIntrinsicContentSize()
    }
}
