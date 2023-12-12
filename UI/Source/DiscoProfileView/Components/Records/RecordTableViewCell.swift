//
//  FindedReferenceTableViewCell.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation
import AVFAudio
import AVFoundation

class RecordTableViewCell: UITableViewCell {
    static let identifier = "RecordTableViewCell"
    static let heigth = 90.0
    private var audioPlayer: AVAudioPlayer?

    private let recordImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var recordComponent: CustomPlayer = {
        let customPlayer = CustomPlayer(
            frame: .zero,
            player: audioPlayer ?? AVAudioPlayer()
        )
        customPlayer.playButtonTapped = { [weak self] in
            self?.audioPlayer?.play()
        }
        customPlayer.translatesAutoresizingMaskIntoConstraints = false
        customPlayer.pauseButtonTapepd = { [weak self] in
            self?.audioPlayer?.pause()
        }
        return customPlayer
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }

    func configure(with record: RecordViewEntity) {
        configureAudioPlayer(record.audio)
        self.recordImage.image = defineImageForTag(record.tag)
    }

    private func configureAudioPlayer(_ recordURL: URL) {
        guard let audioData = try? Data(contentsOf: recordURL) else { return }
        audioPlayer = try? AVAudioPlayer(data: audioData)
        audioPlayer?.numberOfLoops = 0
        recordComponent.player = audioPlayer ?? AVAudioPlayer()
    }

    private func defineImageForTag(_ tag: InstrumentTagViewEntity) -> UIImage {
        switch tag {
        case .guitar:
            return UIImage(systemName: "guitars.fill")!
        case .vocal:
            return UIImage(systemName: "waveform.and.mic")!
        case .drums:
            return UIImage(systemName: "light.cylindrical.ceiling.fill")!
        case .bass:
            return UIImage(systemName: "waveform.badge.plus")!
        case .custom:
            return UIImage(systemName: "waveform.path")!
        }
    }
}

extension RecordTableViewCell: ViewCoding {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            recordImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recordImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            recordImage.heightAnchor.constraint(equalToConstant: RecordTableViewCell.heigth * 0.5),
            recordImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),

            recordComponent.trailingAnchor.constraint(equalTo: trailingAnchor),
            recordComponent.heightAnchor.constraint(equalToConstant: RecordTableViewCell.heigth - 26),
            recordComponent.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.76),
            recordComponent.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func addViewInHierarchy() {
        contentView.addSubview(recordImage)
        contentView.addSubview(recordComponent)
    }
}
