//
//  SWCoverButton.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

final class SWCoverButton: UIButton {
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let placeholderContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = SWSpacing.xxSmall
        stackView.alignment = .center
        return stackView
    }()

    private let placeholderIconView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(
                systemName: "opticaldisc",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 34,
                    weight: .medium
                )
            )
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = SWColor.Accent.primary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let placeholderLabel = SWTextLabel(style: .body, numberOfLines: 2)

    private(set) var selectedCoverImage: UIImage? {
        didSet {
            previewImageView.image = selectedCoverImage
            placeholderContainer.isHidden = selectedCoverImage != nil
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = SWColor.Background.mutedSurface
        layer.cornerRadius = SWRadius.large
        layer.borderWidth = 1
        layer.borderColor = SWColor.Border.subtle.cgColor
        clipsToBounds = true

        placeholderLabel.text = title
        placeholderLabel.textAlignment = .center

        placeholderContainer.addArrangedSubview(placeholderIconView)
        placeholderContainer.addArrangedSubview(placeholderLabel)

        addSubview(previewImageView)
        addSubview(placeholderContainer)

        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: topAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            placeholderContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderContainer.leadingAnchor.constraint(
                greaterThanOrEqualTo: leadingAnchor,
                constant: SWSpacing.small
            ),
            placeholderContainer.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -SWSpacing.small
            )
        ])
    }

    required init?(coder: NSCoder) { nil }

    func updateImage(_ image: UIImage?) {
        selectedCoverImage = image
    }
}
