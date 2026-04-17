import UIKit

final class FindedReferenceTableViewCell: UITableViewCell {
    static let identifier = "FindedReferenceTableViewCell"
    static let heigth = 200.0

    private let banner: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let discoTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let discoReleaseDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }

    func configure(with data: AlbumReferenceViewEntity) {
        if let bannerURL = data.coverImage {
            banner.load(url: bannerURL)
        }
        discoTitle.text = data.name
        artistName.text = data.artist
        discoReleaseDate.text = data.releaseDate
    }
}

extension FindedReferenceTableViewCell: ViewCoding {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            banner.heightAnchor.constraint(equalToConstant: FindedReferenceTableViewCell.heigth - 60.0),
            banner.widthAnchor.constraint(equalToConstant: 140),
            banner.centerYAnchor.constraint(equalTo: centerYAnchor),

            infoStack.leadingAnchor.constraint(equalTo: banner.trailingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            infoStack.centerYAnchor.constraint(equalTo: banner.centerYAnchor)
        ])
    }

    func addViewInHierarchy() {
        addSubview(banner)
        addSubview(infoStack)
        infoStack.addArrangedSubview(discoTitle)
        infoStack.addArrangedSubview(artistName)
        infoStack.addArrangedSubview(discoReleaseDate)
    }
}
