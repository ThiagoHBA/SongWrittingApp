//
//  SWDiscoListItemCell.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

struct SWDiscoListItemContent {
    let title: String
    let coverImage: UIImage?
}

final class SWDiscoListItemCell: UITableViewCell {
    static let identifier = "SWDiscoListItemCell"
    static let height: CGFloat = 260

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SWColor.Background.surface
        view.layer.cornerRadius = SWRadius.large
        view.layer.borderWidth = 1
        view.layer.borderColor = SWColor.Border.subtle.cgColor
        view.clipsToBounds = true
        return view
    }()

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = SWColor.Background.mutedSurface
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel = SWTextLabel(style: .bodyStrong, numberOfLines: 2)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(coverImageView)
        cardView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SWSpacing.xSmall),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SWSpacing.large),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.large),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SWSpacing.xSmall),

            coverImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: SWSize.discoCoverHeight),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: SWSpacing.small),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: SWSpacing.small),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -SWSpacing.small),
            titleLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: cardView.bottomAnchor,
                constant: -SWSpacing.small
            )
        ])
    }

    required init?(coder: NSCoder) { nil }

    func configure(with content: SWDiscoListItemContent) {
        coverImageView.image = content.coverImage
        titleLabel.text = content.title

        isAccessibilityElement = true
        accessibilityLabel = "Disco: \(content.title)"
        accessibilityHint = "Toque  para ver detalhes"
        accessibilityTraits = .button
    }
}

extension SWDiscoListItemCell: ShimmeringViewProtocol {
    var shimmeringAnimatedItems: [UIView] {
        [coverImageView, titleLabel]
    }
}
