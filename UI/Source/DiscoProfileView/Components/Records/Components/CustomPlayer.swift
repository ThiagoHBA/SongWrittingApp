//
//  CustomPlayer.swift
//  UI
//
//  Created by Thiago Henrique on 11/12/23.
//

import UIKit
import AVFAudio

class CustomPlayer: UIView {
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
    
    let audioDuration: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(), for: .normal)
        slider.thumbTintColor = .systemBlue
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(didBeginDraggingSlider), for: .touchDown)
        slider.addTarget(self, action: #selector(didEndDraggingSlider), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    @objc func updateProgress() {
        let currentDuration = player.duration - player.currentTime
        let playbackProgress = Float(player.currentTime / player.duration)
        updatePlayerDuration(currentDuration)
        progressBar.setValue(playbackProgress, animated: true)
    }
    
    @objc func didBeginDraggingSlider() {
        displayLink?.isPaused = true
    }

    @objc func didEndDraggingSlider() {
        let newPosition = player.duration * Double(progressBar.value)
        let newDuration = player.duration - player.currentTime
        updatePlayerDuration(newDuration)
        player.currentTime = newPosition
        displayLink?.isPaused = false
    }
    
    func startUpdatingPlaybackStatus() {
         displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
         displayLink!.add(to: .main, forMode: .common)
     }

     func stopUpdatingPlaybackStatus() {
         displayLink?.invalidate()
     }

    func updatePlayerDuration(_ value: TimeInterval) {
        let date = Date(timeIntervalSinceReferenceDate: value)
        let format = DateFormatter()
        format.dateFormat = "mm:ss"
        audioDuration.text = format.string(from: date)
    }
    
    func clearPlayer() {
        displayLink?.invalidate()
        displayLink = nil
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        player.stop()
    }
    
    @objc func toggleState() {
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
    
    init(frame: CGRect, player: AVAudioPlayer) {
        self.player = player
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePlayerDuration(player.duration)
        startUpdatingPlaybackStatus()
        playButton.setImage(UIImage(systemName: player.isPlaying ? "pause.fill" : "play.fill"), for: .normal)
        player.delegate = self
    }
}

extension CustomPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        clearPlayer()
    }
}

extension CustomPlayer: ViewCoding {
    func addViewInHierarchy() {
        self.addSubview(playButton)
        self.addSubview(progressBar)
        self.addSubview(audioDuration)
    }
    
    func setupConstraints() {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 28),
            playButton.heightAnchor.constraint(equalToConstant: 28)
        ]
        
        let progressBarConstraints = [
            progressBar.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            progressBar.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 6),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ]
        
        let audioDurationConstraints = [
            audioDuration.topAnchor.constraint(equalTo: progressBar.bottomAnchor),
            audioDuration.leadingAnchor.constraint(equalTo: playButton.trailingAnchor),
            audioDuration.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(progressBarConstraints)
        NSLayoutConstraint.activate(audioDurationConstraints)
    }
}
