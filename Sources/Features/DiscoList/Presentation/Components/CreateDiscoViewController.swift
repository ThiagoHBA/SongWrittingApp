import DesignSystem
import PhotosUI
import UIKit

final class CreateDiscoViewController: UIViewController {
    var createDiscoTapped: ((String, String?, Data) -> Void)?

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var formView: SWDiscoCreationFormView = {
        let view = SWDiscoCreationFormView()
        view.onPickCoverTap = { [weak self] in
            self?.pickImageButton()
        }
        view.onSubmitTap = { [weak self] in
            self?.buttonTapped()
        }
        return view
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

    private func configureImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }

    @objc private func buttonTapped() {
        let name = formView.discoName
        let descriptionText = formView.discoDescription
        let description: String? = descriptionText.isEmpty ? nil : descriptionText
        let imageData = formView.selectedCoverImage?.pngData()
            ?? UIImage(named: "vinil_image_example")?.pngData()
            ?? Data()
        createDiscoTapped?(name, description, imageData)
    }

    @objc private func pickImageButton() {
        configureImagePicker()
    }

    private func configureSheetPresentation() {
        guard let sheetPresentationController else { return }

        sheetPresentationController.detents = [
            .custom { context in
                context.maximumDetentValue * 0.85
            }
        ]
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        sheetPresentationController.preferredCornerRadius = SWRadius.large
    }
}

extension CreateDiscoViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = SWColor.Background.screen
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SWSpacing.xSmall),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            formView.topAnchor.constraint(equalTo: contentView.topAnchor),
            formView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SWSpacing.large),
            formView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.large),
            formView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(formView)
    }
}

extension CreateDiscoViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }

        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard error == nil, let selectedImage = image as? UIImage else { return }

            DispatchQueue.main.async {
                self?.formView.updateSelectedImage(selectedImage.fixOrientation())
            }
        }
    }
}
