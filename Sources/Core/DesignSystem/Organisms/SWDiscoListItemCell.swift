//
//  SWDiscoListItemCell.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import SDWebImage
import UIKit

struct SWDiscoListItemContent {
    let title: String
    let coverImage: UIImage?
    let referenceCoverURLs: [URL]

    init(title: String, coverImage: UIImage?, referenceCoverURLs: [URL] = []) {
        self.title = title
        self.coverImage = coverImage
        self.referenceCoverURLs = referenceCoverURLs
    }
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

    private let referencesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let referencesStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = SWSpacing.xxSmall
        return stackView
    }()

    private var referencesHeightConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(coverImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(referencesScrollView)
        referencesScrollView.addSubview(referencesStack)

        referencesHeightConstraint = referencesScrollView.heightAnchor.constraint(equalToConstant: 0)

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

            referencesScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SWSpacing.small),
            referencesScrollView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: SWSpacing.small),
            referencesScrollView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -SWSpacing.small),
            referencesScrollView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -SWSpacing.small),
            referencesHeightConstraint,

            referencesStack.topAnchor.constraint(equalTo: referencesScrollView.contentLayoutGuide.topAnchor),
            referencesStack.leadingAnchor.constraint(equalTo: referencesScrollView.contentLayoutGuide.leadingAnchor),
            referencesStack.trailingAnchor.constraint(equalTo: referencesScrollView.contentLayoutGuide.trailingAnchor),
            referencesStack.bottomAnchor.constraint(equalTo: referencesScrollView.contentLayoutGuide.bottomAnchor),
            referencesStack.heightAnchor.constraint(equalTo: referencesScrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        referencesStack.arrangedSubviews.forEach { view in
            (view as? UIImageView)?.sd_cancelCurrentImageLoad()
            referencesStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    func configure(with content: SWDiscoListItemContent) {
        coverImageView.image = content.coverImage
        titleLabel.text = content.title

        if content.referenceCoverURLs.isEmpty {
            referencesHeightConstraint.constant = 0
            referencesScrollView.isHidden = true
        } else {
            content.referenceCoverURLs.forEach { url in
                referencesStack.addArrangedSubview(makeAvatarView(with: url))
            }
            referencesHeightConstraint.constant = SWSize.referenceAvatarCompact
            referencesScrollView.isHidden = false
        }

        isAccessibilityElement = true
        accessibilityLabel = "Disco: \(content.title)"
        accessibilityHint = "Toque  para ver detalhes"
        accessibilityTraits = .button
    }

    private func makeAvatarView(with url: URL) -> UIView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = SWColor.Background.mutedSurface
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = SWSize.referenceAvatarCompact / 2
        imageView.sd_setImage(with: url)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: SWSize.referenceAvatarCompact),
            imageView.heightAnchor.constraint(equalToConstant: SWSize.referenceAvatarCompact)
        ])
        return imageView
    }
}

extension SWDiscoListItemCell: ShimmeringViewProtocol {
    var shimmeringAnimatedItems: [UIView] {
        [coverImageView, titleLabel]
    }
}
