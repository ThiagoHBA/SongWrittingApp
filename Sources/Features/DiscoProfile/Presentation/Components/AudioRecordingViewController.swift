import AVFoundation
import UIKit

final class AudioRecordingViewController: UIViewController, AlertPresentable {
    var onSave: ((URL) -> Void)?

    private enum RecordingState {
        case recording
        case stopped(fileURL: URL)
    }

    private var state: RecordingState = .recording {
        didSet { applyState() }
    }

    private var audioRecorder: AVAudioRecorder?
    private var recordingTimer: Timer?
    private var elapsedSeconds: Int = 0

    private let statusLabel = SWTextLabel(style: .caption)
    private let timerLabel = SWTextLabel(style: .heroTitle)
    private let controlsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stopButton: SWIconButton = {
        let btn = SWIconButton(symbolName: "stop.fill", accessibilityLabel: "Parar gravação")
        btn.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        return btn
    }()

    private lazy var saveButton: SWPrimaryButton = {
        let btn = SWPrimaryButton(title: "Salvar")
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
    }()

    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancelar", for: .normal)
        btn.setTitleColor(SWColor.Accent.primary, for: .normal)
        btn.titleLabel?.font = SWTypography.button
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return btn
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        configureSheetPresentation()
        requestMicrophonePermissionAndStartRecording()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        audioRecorder?.stop()
        audioRecorder = nil
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    }

    @objc private func stopTapped() {
        stopTimer()
        guard let url = audioRecorder?.url else { return }
        audioRecorder?.stop()
        state = .stopped(fileURL: url)
    }

    @objc private func saveTapped() {
        guard case .stopped(let url) = state else { return }
        dismiss(animated: true) { [weak self] in
            self?.onSave?(url)
        }
    }

    @objc private func cancelTapped() {
        if case .stopped(let url) = state {
            try? FileManager.default.removeItem(at: url)
        }
        dismiss(animated: true)
    }

    private func requestMicrophonePermissionAndStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            configureAudioSessionForRecording()
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.configureAudioSessionForRecording()
                    } else {
                        self?.showPermissionDeniedAlert()
                    }
                }
            }
        case .denied:
            showPermissionDeniedAlert()
        @unknown default:
            showPermissionDeniedAlert()
        }
    }

    private func configureAudioSessionForRecording() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
            startRecording(at: makeRecordingURL())
        } catch {
            showAlert(title: "Erro de áudio", message: "Não foi possível configurar o áudio para gravação.") { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }
    }

    private func showPermissionDeniedAlert() {
        showAlert(
            title: "Permissão negada",
            message: "Permita o acesso ao microfone em Configurações para gravar áudio."
        ) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }

    private func makeRecordingURL() -> URL {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return caches.appendingPathComponent("recording_\(UUID().uuidString).m4a")
    }

    private func startRecording(at url: URL) {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            startTimer()
        } catch {
            showAlert(title: "Erro ao gravar", message: "Não foi possível iniciar a gravação.") { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }
    }

    private func startTimer() {
        elapsedSeconds = 0
        timerLabel.text = "00:00"
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsedSeconds += 1
            self.timerLabel.text = self.formattedTime(self.elapsedSeconds)
        }
    }

    private func stopTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }

    private func formattedTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }

    private func applyState() {
        switch state {
        case .recording:
            statusLabel.isHidden = false
            stopButton.isHidden = false
            saveButton.isHidden = true
            cancelButton.isHidden = true
        case .stopped:
            statusLabel.isHidden = true
            stopButton.isHidden = true
            saveButton.isHidden = false
            cancelButton.isHidden = false
        }
    }

    private func configureSheetPresentation() {
        guard let sheet = sheetPresentationController else { return }
        sheet.detents = [.custom { context in context.maximumDetentValue * 0.4 }]
        sheet.prefersGrabberVisible = true
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.preferredCornerRadius = SWRadius.large
    }
}

extension AudioRecordingViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = SWColor.Background.screen
        statusLabel.text = "A gravar..."
        statusLabel.textAlignment = .center
        timerLabel.text = "00:00"
        timerLabel.textAlignment = .center
        applyState()
    }

    func addViewInHierarchy() {
        view.addSubview(statusLabel)
        view.addSubview(timerLabel)
        view.addSubview(controlsContainer)
        controlsContainer.addSubview(stopButton)
        controlsContainer.addSubview(saveButton)
        controlsContainer.addSubview(cancelButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SWSpacing.xLarge),

            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: SWSpacing.xxSmall),

            controlsContainer.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: SWSpacing.xLarge),
            controlsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.large),
            controlsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.large),
            controlsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -SWSpacing.large),
            controlsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stopButton.centerXAnchor.constraint(equalTo: controlsContainer.centerXAnchor),
            stopButton.topAnchor.constraint(equalTo: controlsContainer.topAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: SWSize.iconButton),
            stopButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight),
            stopButton.bottomAnchor.constraint(equalTo: controlsContainer.bottomAnchor),

            saveButton.leadingAnchor.constraint(equalTo: controlsContainer.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: controlsContainer.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight),
            saveButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -SWSpacing.small),

            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: SWSpacing.medium),
            cancelButton.centerXAnchor.constraint(equalTo: controlsContainer.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: controlsContainer.bottomAnchor)
        ])
    }
}

extension AudioRecordingViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard !flag else { return }
        showAlert(title: "Erro na gravação", message: "A gravação foi interrompida.") { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        showAlert(title: "Erro de codificação", message: "Não foi possível salvar o áudio.") { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
}
