//
//  SWReferenceSearchResultCell.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import SDWebImage
import UIKit

struct SWReferenceSearchResultContent {
    let title: String
    let subtitle: String
    let detail: String
    let imageURL: URL?
}

final class SWReferenceSearchResultCell: UITableViewCell {
    static let identifier = "SWReferenceSearchResultCell"
    static let height = SWSize.referenceSearchCellHeight

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SWColor.Background.surface
        view.layer.cornerRadius = SWRadius.medium
        view.layer.borderWidth = 1
        view.layer.borderColor = SWColor.Border.subtle.cgColor
        return view
    }()

    private let artworkView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = SWColor.Background.mutedSurface
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = SWRadius.small
        return imageView
    }()

    private let titleLabel = SWTextLabel(style: .bodyStrong, numberOfLines: 0)
    private let subtitleLabel = SWTextLabel(style: .body)
    private let detailLabel = SWTextLabel(style: .caption)

    private let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = SWSpacing.small
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(artworkView)
        cardView.addSubview(infoStack)

        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(subtitleLabel)
        infoStack.addArrangedSubview(detailLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SWSpacing.xSmall),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SWSpacing.small),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.small),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SWSpacing.xSmall),

            artworkView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: SWSpacing.medium),
            artworkView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            artworkView.widthAnchor.constraint(equalToConstant: SWSize.referenceSearchArtworkWidth),
            artworkView.heightAnchor.constraint(
                equalToConstant: SWSize.referenceSearchCellHeight - (SWSpacing.medium * 3)
            ),

            infoStack.leadingAnchor.constraint(equalTo: artworkView.trailingAnchor, constant: SWSpacing.medium),
            infoStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -SWSpacing.medium),
            infoStack.centerYAnchor.constraint(equalTo: artworkView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        artworkView.sd_cancelCurrentImageLoad()
        artworkView.image = nil
    }

    func configure(with content: SWReferenceSearchResultContent) {
        titleLabel.text = content.title
        subtitleLabel.text = content.subtitle
        detailLabel.text = content.detail

        if let imageURL = content.imageURL {
            artworkView.sd_setImage(with: imageURL)
        } else {
            artworkView.image = nil
        }
    }
}
