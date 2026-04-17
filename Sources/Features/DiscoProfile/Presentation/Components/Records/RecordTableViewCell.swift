import AVFAudio
import AVFoundation
import UIKit

final class RecordTableViewCell: UITableViewCell {
    static let identifier = "RecordTableViewCell"
    static let heigth = 90.0

    private var audioPlayer: AVAudioPlayer?

    private let recordImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var recordComponent: CustomPlayer = {
        let customPlayer = CustomPlayer(player: audioPlayer ?? AVAudioPlayer())
        customPlayer.playButtonTapped = { [weak self] in
            self?.audioPlayer?.play()
        }
        customPlayer.pauseButtonTapepd = { [weak self] in
            self?.audioPlayer?.pause()
        }
        customPlayer.translatesAutoresizingMaskIntoConstraints = false
        return customPlayer
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }

    func configure(with record: RecordViewEntity) {
        configureAudioPlayer(record.audio)
        recordImage.image = defineImageForTag(record.tag)
    }

    private func configureAudioPlayer(_ recordURL: URL) {
        guard let audioData = try? Data(contentsOf: recordURL) else { return }
        audioPlayer = try? AVAudioPlayer(data: audioData)
        audioPlayer?.numberOfLoops = 0
        recordComponent.player = audioPlayer ?? AVAudioPlayer()
    }

    private func defineImageForTag(_ tag: InstrumentTagViewEntity) -> UIImage? {
        switch tag {
        case .guitar:
            return UIImage(systemName: "guitars.fill")
        case .vocal:
            return UIImage(systemName: "waveform.and.mic")
        case .drums:
            return UIImage(systemName: "light.cylindrical.ceiling.fill")
        case .bass:
            return UIImage(systemName: "waveform.badge.plus")
        case .custom:
            return UIImage(systemName: "waveform.path")
        }
    }
}

extension RecordTableViewCell: ViewCoding {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            recordImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recordImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            recordImage.heightAnchor.constraint(equalToConstant: RecordTableViewCell.heigth * 0.45),
            recordImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),

            recordComponent.trailingAnchor.constraint(equalTo: trailingAnchor),
            recordComponent.heightAnchor.constraint(equalToConstant: RecordTableViewCell.heigth - 30),
            recordComponent.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.76),
            recordComponent.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func addViewInHierarchy() {
        contentView.addSubview(recordImage)
        contentView.addSubview(recordComponent)
    }
}
