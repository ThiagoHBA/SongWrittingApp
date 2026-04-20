//
//  SWAudioPlayerView.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import AVFAudio
import UIKit

final class SWAudioPlayerView: UIView {
    var player: AVAudioPlayer? {
        willSet {
            player?.stop()
        }
        didSet {
            configureForCurrentPlayer()
        }
    }

    private var displayLink: CADisplayLink?

    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = SWColor.Accent.primary
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        return button
    }()

    private let progressBar: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = SWColor.Accent.primary
        slider.maximumTrackTintColor = SWColor.Border.subtle
        slider.setThumbImage(UIImage(), for: .normal)
        slider.isUserInteractionEnabled = false
        return slider
    }()

    private let durationLabel = SWTextLabel(style: .caption)

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        durationLabel.text = "00:00"

        addSubview(playButton)
        addSubview(progressBar)
        addSubview(durationLabel)

        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: SWSize.audioControl),
            playButton.heightAnchor.constraint(equalToConstant: SWSize.audioControl),

            progressBar.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: SWSpacing.xxSmall),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: topAnchor),

            durationLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: SWSpacing.xxxSmall),
            durationLabel.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { nil }

    deinit {
        stopUpdatingPlaybackStatus()
    }

    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: SWSize.audioControl + SWSpacing.xxxSmall + durationLabel.font.lineHeight
        )
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            stopUpdatingPlaybackStatus()
        }
    }

    @objc private func togglePlayback() {
        guard let player else { return }

        if player.isPlaying {
            player.pause()
            stopUpdatingPlaybackStatus()
        } else {
            player.play()
            startUpdatingPlaybackStatus()
        }

        updatePlaybackButton(isPlaying: player.isPlaying)
    }

    @objc private func updateProgress() {
        guard let player, player.duration > 0 else {
            progressBar.setValue(0, animated: false)
            durationLabel.text = "00:00"
            return
        }

        let remainingDuration = max(player.duration - player.currentTime, 0)
        let playbackProgress = Float(player.currentTime / player.duration)
        progressBar.setValue(playbackProgress, animated: true)
        durationLabel.text = formattedDuration(for: remainingDuration)
    }

    private func configureForCurrentPlayer() {
        stopUpdatingPlaybackStatus()
        progressBar.setValue(0, animated: false)
        invalidateIntrinsicContentSize()

        guard let player else {
            durationLabel.text = "00:00"
            updatePlaybackButton(isPlaying: false)
            return
        }

        player.delegate = self
        durationLabel.text = formattedDuration(for: player.duration)
        updatePlaybackButton(isPlaying: player.isPlaying)

        if player.isPlaying {
            startUpdatingPlaybackStatus()
        }
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

    private func updatePlaybackButton(isPlaying: Bool) {
        playButton.setImage(UIImage(systemName: isPlaying ? "pause.fill" : "play.fill"), for: .normal)
    }

    private func formattedDuration(for value: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: value) ?? "00:00"
    }
}

extension SWAudioPlayerView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.currentTime = 0
        stopUpdatingPlaybackStatus()
        updatePlaybackButton(isPlaying: false)
        progressBar.setValue(0, animated: false)
        durationLabel.text = formattedDuration(for: player.duration)
    }
}
