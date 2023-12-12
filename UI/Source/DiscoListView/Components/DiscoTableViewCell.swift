//
//  DiscoTableViewCell.swift
//  UI
//
//  Created by Thiago Henrique on 09/12/23.
//

import UIKit
import Presentation

class DiscoTableViewCell: UITableViewCell {
    static let identifier = "DiscoTableViewCell"
    static let heigth = 240.0

    private let banner: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let discoTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Disco Title"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }

    func configure(with disco: DiscoListViewEntity) {
        banner.image = UIImage(data: disco.coverImage)
        discoTitle.text = disco.name
    }
}

extension DiscoTableViewCell: ViewCoding {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            banner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            banner.heightAnchor.constraint(equalToConstant: DiscoTableViewCell.heigth - 80.0),
            banner.widthAnchor.constraint(equalToConstant: 180),

            discoTitle.topAnchor.constraint(equalTo: banner.bottomAnchor, constant: 6),
            discoTitle.centerXAnchor.constraint(equalTo: banner.centerXAnchor)
        ])
    }

    func addViewInHierarchy() {
        self.addSubview(banner)
        self.addSubview(discoTitle)
    }
}
