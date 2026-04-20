//
//  SWRecordListItemCell.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import AVFAudio
import UIKit

struct SWRecordListItemContent {
    let iconImage: UIImage?
    let audioURL: URL
}

final class SWRecordListItemCell: UITableViewCell {
    static let identifier = "SWRecordListItemCell"
    static let height = SWSize.recordRowHeight

    private let iconContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SWColor.Accent.emphasisBackground
        view.layer.cornerRadius = SWRadius.medium
        return view
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = SWColor.Accent.primary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let playerView = SWAudioPlayerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconView)
        contentView.addSubview(playerView)

        NSLayoutConstraint.activate([
            iconContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SWSpacing.small),
            iconContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: SWSize.iconButton),
            iconContainerView.heightAnchor.constraint(equalToConstant: SWSize.iconButton),

            iconView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: SWSize.iconRegular),
            iconView.heightAnchor.constraint(equalToConstant: SWSize.iconRegular),

            playerView.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: SWSpacing.small),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.small),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SWSpacing.small),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SWSpacing.small)
        ])
    }

    required init?(coder: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        playerView.player = nil
    }

    func configure(with content: SWRecordListItemContent) {
        iconView.image = content.iconImage
        playerView.player = makePlayer(for: content.audioURL)

        isAccessibilityElement = false
        iconContainerView.isAccessibilityElement = true
        iconContainerView.accessibilityLabel = "Ícone da gravação"
        iconContainerView.accessibilityTraits = .image
    }

    private func makePlayer(for audioURL: URL) -> AVAudioPlayer? {
        let isSecurityScoped = audioURL.startAccessingSecurityScopedResource()
        defer { if isSecurityScoped { audioURL.stopAccessingSecurityScopedResource() } }

        let player = try? AVAudioPlayer(contentsOf: audioURL)
        player?.numberOfLoops = 0
        player?.prepareToPlay()
        return player
    }
}
