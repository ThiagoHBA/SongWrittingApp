//
//  SWHeaderActionView.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

struct SWHeaderActionContent {
    let title: String
    let actionSymbolName: String
    let actionAccessibilityLabel: String
}

final class SWHeaderActionView: UIView {
    var onActionTap: (() -> Void)?

    private let titleLabel = SWTextLabel(style: .heroTitle, numberOfLines: 0)
    private let actionButton = SWIconButton(symbolName: "plus")

    override init(frame: CGRect) {
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

    required init?(coder: NSCoder) { nil }

    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: max(titleLabel.font.lineHeight, SWSize.iconButton)
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = bounds.width - SWSize.iconButton - SWSpacing.medium
    }

    func configure(with content: SWHeaderActionContent) {
        titleLabel.text = content.title
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
