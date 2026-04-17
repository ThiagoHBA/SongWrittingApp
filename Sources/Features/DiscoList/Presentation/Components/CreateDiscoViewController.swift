import PhotosUI
import UIKit

final class CreateDiscoViewController: UIViewController {
    var createDiscoTapped: ((String, Data) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Novo Disco"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var discoImage: UIButton = {
        let button = UIButton()
        button.setTitle("Escolher Capa", for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.5)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(pickImageButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ex: Meu novo disco incrível"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Criar Disco", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
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
        let name = nameField.text ?? ""
        let imageData = discoImage.imageView?.image?.pngData()
            ?? UIImage(named: "vinil_image_example")?.pngData()
            ?? Data()
        createDiscoTapped?(name, imageData)
    }

    @objc private func pickImageButton() {
        configureImagePicker()
    }
}

extension CreateDiscoViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            discoImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            discoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            discoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            discoImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),

            nameLabel.topAnchor.constraint(equalTo: discoImage.bottomAnchor, constant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 42),

            createButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 32),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            createButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(discoImage)
        view.addSubview(nameLabel)
        view.addSubview(nameField)
        view.addSubview(createButton)
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
                self?.discoImage.setImage(selectedImage.fixOrientation(), for: .normal)
            }
        }
    }
}
