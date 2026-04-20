import UIKit

final class AddRecordSourceViewController: UIViewController {
    var onRecordTap: (() -> Void)?
    var onUploadTap: (() -> Void)?

    private let titleLabel = SWTextLabel(style: .sectionTitle, numberOfLines: 0)

    private lazy var recordOptionView: SWActionCardView = {
        let view = SWActionCardView()
        view.configure(
            with: SWActionCardContent(
                title: "Gravar",
                symbolName: "record.circle",
                accessibilityLabel: "Gravar"
            )
        )
        view.addTarget(self, action: #selector(handleRecordTap), for: .touchUpInside)
        return view
    }()

    private lazy var uploadOptionView: SWActionCardView = {
        let view = SWActionCardView()
        view.configure(
            with: SWActionCardContent(
                title: "Upload",
                symbolName: "square.and.arrow.up",
                accessibilityLabel: "Upload"
            )
        )
        view.addTarget(self, action: #selector(handleUploadTap), for: .touchUpInside)
        return view
    }()

    private let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = SWSpacing.small
        return stackView
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
    }

    @objc private func handleRecordTap() {
        onRecordTap?()
    }

    @objc private func handleUploadTap() {
        onUploadTap?()
    }

    private func configureSheetPresentation() {
        guard let sheetPresentationController else { return }

        sheetPresentationController.detents = [
            .custom { context in
                context.maximumDetentValue * 0.28
            }
        ]
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        sheetPresentationController.preferredCornerRadius = SWRadius.large
    }
}

extension AddRecordSourceViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = SWColor.Background.screen
        titleLabel.text = "Origem do audio"
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SWSpacing.small),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SWSpacing.large),
            optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.large),
            optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.large),
            optionsStackView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    func addViewInHierarchy() {
        optionsStackView.addArrangedSubview(recordOptionView)
        optionsStackView.addArrangedSubview(uploadOptionView)

        view.addSubview(titleLabel)
        view.addSubview(optionsStackView)
    }
}
