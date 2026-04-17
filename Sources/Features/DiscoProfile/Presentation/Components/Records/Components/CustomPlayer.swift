import AVFAudio
import UIKit

final class CustomPlayer: UIView {
    var playButtonTapped: (() -> Void)?
    var pauseButtonTapepd: (() -> Void)?
    var player: AVAudioPlayer
    private var displayLink: CADisplayLink?

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(toggleState), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let audioDuration: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(), for: .normal)
        slider.thumbTintColor = .systemBlue
        slider.isContinuous = false
        slider.isUserInteractionEnabled = false
        slider.addTarget(self, action: #selector(didBeginDraggingSlider), for: .touchDown)
        slider.addTarget(self, action: #selector(didEndDraggingSlider), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    init(frame: CGRect = .zero, player: AVAudioPlayer) {
        self.player = player
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) { nil }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            stopUpdatingPlaybackStatus()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePlayerDuration(player.duration)

        if player.isPlaying {
            startUpdatingPlaybackStatus()
        }

        playButton.setImage(
            UIImage(systemName: player.isPlaying ? "pause.fill" : "play.fill"),
            for: .normal
        )
        player.delegate = self
    }

    @objc private func updateProgress() {
        let currentDuration = player.duration - player.currentTime
        let playbackProgress = Float(player.currentTime / player.duration)
        updatePlayerDuration(currentDuration)
        progressBar.setValue(playbackProgress, animated: true)
    }

    @objc private func didBeginDraggingSlider() {
        displayLink?.isPaused = true
    }

    @objc private func didEndDraggingSlider() {
        let newPosition = player.duration * Double(progressBar.value)
        let newDuration = player.duration - player.currentTime
        updatePlayerDuration(newDuration)
        player.currentTime = newPosition
        displayLink?.isPaused = false
    }

    private func startUpdatingPlaybackStatus() {
        guard displayLink == nil else { return }
        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .main, forMode: .common)
    }

    private func stopUpdatingPlaybackStatus() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func updatePlayerDuration(_ value: TimeInterval) {
        let date = Date(timeIntervalSinceReferenceDate: value)
        let format = DateFormatter()
        format.dateFormat = "mm:ss"
        audioDuration.text = format.string(from: date)
    }

    private func clearPlayer() {
        stopUpdatingPlaybackStatus()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        player.stop()
    }

    @objc private func toggleState() {
        if player.isPlaying {
            pauseButtonTapepd?()
            stopUpdatingPlaybackStatus()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            return
        }

        playButtonTapped?()
        startUpdatingPlaybackStatus()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
}

extension CustomPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        clearPlayer()
    }
}

extension CustomPlayer: ViewCoding {
    func addViewInHierarchy() {
        addSubview(playButton)
        addSubview(progressBar)
        addSubview(audioDuration)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 28),
            playButton.heightAnchor.constraint(equalToConstant: 28),

            progressBar.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            progressBar.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 6),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            audioDuration.topAnchor.constraint(equalTo: progressBar.bottomAnchor),
            audioDuration.leadingAnchor.constraint(equalTo: playButton.trailingAnchor),
            audioDuration.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
