//
//  FindedReferenceTableViewCell.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation
import AVFAudio

class RecordTableViewCell: UITableViewCell {
    static let identifier = "RecordTableViewCell"
    static let heigth = 80.0
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
        customPlayer.playButtonTapped = {}
        customPlayer.translatesAutoresizingMaskIntoConstraints = false
//        customPlayer.pauseButtonTapepd = presenter.pauseAudio
        return customPlayer
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func configure(with record: RecordViewEntity) {
        self.audioPlayer = try? AVAudioPlayer(data: record.audio)
        self.recordImage.image = defineImageForTag(record.tag)
    }
    
    func defineImageForTag(_ tag: InstrumentTagViewEntity) -> UIImage {
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
            recordImage.heightAnchor.constraint(equalToConstant: RecordTableViewCell.heigth - 20),
            recordImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15),
            
            recordComponent.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
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
