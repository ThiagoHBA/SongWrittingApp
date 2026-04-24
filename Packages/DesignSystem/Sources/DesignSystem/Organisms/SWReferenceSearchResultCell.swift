import SDWebImage
import UIKit

public struct SWReferenceSearchResultContent {
    public let title: String
    public let subtitle: String
    public let detail: String
    public let imageURL: URL?

    public init(title: String, subtitle: String, detail: String, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.imageURL = imageURL
    }
}

public final class SWReferenceSearchResultCell: UITableViewCell {
    public static let identifier = "SWReferenceSearchResultCell"
    public static let height = SWSize.referenceSearchCellHeight

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

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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

    public required init?(coder: NSCoder) { nil }

    override public func prepareForReuse() {
        super.prepareForReuse()
        artworkView.sd_cancelCurrentImageLoad()
        artworkView.image = nil
    }

    public func configure(with content: SWReferenceSearchResultContent) {
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
