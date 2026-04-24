import DesignSystem
import SDWebImage
import UIKit

final class OnboardingPageContentViewController: UIViewController {
    private let page: OnboardingPageViewEntity

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = SWSpacing.large
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = SWSpacing.small
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let imageView: SDAnimatedImageView = {
        let imageView = SDAnimatedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "onboarding.page.image"
        imageView.layer.cornerRadius = SWRadius.medium
        imageView.clipsToBounds = true
        return imageView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = SWColor.Accent.primary
        return indicator
    }()

    private let titleLabel: SWTextLabel = {
        let label = SWTextLabel(style: .heroTitle, numberOfLines: 0)
        label.textAlignment = .center
        label.accessibilityIdentifier = "onboarding.page.title"
        return label
    }()

    private let messageLabel: SWTextLabel = {
        let label = SWTextLabel(style: .body, numberOfLines: 0)
        label.textAlignment = .center
        label.textColor = SWColor.Content.secondary
        label.accessibilityIdentifier = "onboarding.page.message"
        return label
    }()

    init(page: OnboardingPageViewEntity) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        configure()
    }
}

extension OnboardingPageContentViewController: ViewCoding {
    func addViewInHierarchy() {
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(messageLabel)
        imageView.addSubview(activityIndicator)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.large),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.large),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: page.imageScale ?? 0.4),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            textStackView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor)
        ])
    }

    func additionalConfiguration() {
        view.backgroundColor = .clear
    }
}

private extension OnboardingPageContentViewController {
    func configure() {
        titleLabel.text = page.title
        messageLabel.text = page.message

        switch page.imageSource {
        case .asset(let name):
            imageView.image = UIImage(named: name)
        case .system(let name):
            imageView.image = UIImage(systemName: name)
            imageView.tintColor = SWColor.Accent.primary
        case .gif(let name):
            activityIndicator.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let data = NSDataAsset(name: name)?.data,
                      let animatedImage = SDAnimatedImage(data: data) else {
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                    }
                    return
                }

                DispatchQueue.main.async {
                    self?.imageView.image = animatedImage
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
