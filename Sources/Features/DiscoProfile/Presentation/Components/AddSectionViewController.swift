import UIKit

final class AddSectionViewController: UIViewController {
    var addSectionTapped: ((String) -> Void)?

    let sectionField = SWLabeledTextFieldView(
        title: "Título",
        placeholder: "Ex: Minha nova seção"
    )

    private lazy var navBar: UINavigationBar = {
        let nav = UINavigationBar()
        let navigationItem = UINavigationItem(title: "Nova Seção")
        nav.items = [navigationItem]
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()

    private lazy var createSessionButton: SWPrimaryButton = {
        let button = SWPrimaryButton(title: "Criar Seção")
        button.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }

    @objc private func createTapped() {
        addSectionTapped?(sectionField.text)
    }
}

extension AddSectionViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: SWSize.navigationBarHeight),

            sectionField.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: SWSpacing.xLarge),
            sectionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.xSmall),
            sectionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.xSmall),

            createSessionButton.topAnchor.constraint(equalTo: sectionField.bottomAnchor, constant: SWSpacing.large),
            createSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createSessionButton.leadingAnchor.constraint(equalTo: sectionField.leadingAnchor),
            createSessionButton.trailingAnchor.constraint(equalTo: sectionField.trailingAnchor),
            createSessionButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight)
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(sectionField)
        view.addSubview(createSessionButton)
        view.addSubview(navBar)
    }
}
