import UIKit

protocol DiscoListDisplayLogic: AnyObject {
    func startLoading()
    func hideLoading()
    func hideOverlays(completion: (() -> Void)?)
    func showDiscos(_ discos: [DiscoListViewEntity])
    func showNewDisco(_ disco: DiscoListViewEntity)
    func createDiscoError(_ title: String, _ description: String)
    func loadDiscoError(_ title: String, _ description: String)
}

final class DiscoListViewController: UIViewController, AlertPresentable {
    private let interactor: DiscoListBusinessLogic

    private var discos: [DiscoListViewEntity] = [] {
        didSet {
            emptyStateLabel.isHidden = !discos.isEmpty
        }
    }

    private var isLoading = false

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Seus Discos"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addDiscoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(addDiscoButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            DiscoTableViewCell.self,
            forCellReuseIdentifier: DiscoTableViewCell.identifier
        )
        tableView.showsVerticalScrollIndicator = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Você ainda não possui nenhum disco!
        Adicione um novo disco utilizando o ícone acima.
        """
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(interactor: DiscoListBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.loadDiscos()
    }

    @objc private func addDiscoButtonTapped() {
        let sheet = CreateDiscoViewController()
        sheet.sheetPresentationController?.detents = [.medium()]
        sheet.createDiscoTapped = interactor.createDisco
        present(sheet, animated: true)
    }

    private func loadPlaceholders() {
        let placeholder = DiscoListViewEntity(
            id: UUID(),
            name: "",
            coverImage: UIImage(named: "vinil_image_example")?.pngData() ?? Data()
        )
        discos = Array(repeating: placeholder, count: 4)
    }

    private func removePlaceholders() {
        discos.removeAll(where: { $0.name.isEmpty })
    }
}

extension DiscoListViewController: DiscoListDisplayLogic {
    func createDiscoError(_ title: String, _ description: String) {
        showAlert(title: title, message: description) { [weak self] _ in
            self?.addDiscoButtonTapped()
        }
    }

    func loadDiscoError(_ title: String, _ description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }

    func hideOverlays(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }

    func startLoading() {
        isLoading = true
        loadPlaceholders()
        tableView.reloadData()
    }

    func hideLoading() {
        isLoading = false
        removePlaceholders()
        tableView.reloadData()
    }

    func showDiscos(_ discos: [DiscoListViewEntity]) {
        self.discos = discos
        tableView.reloadData()
    }

    func showNewDisco(_ disco: DiscoListViewEntity) {
        discos.append(disco)
        showDiscos(discos)
    }
}

extension DiscoListViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),

            addDiscoButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addDiscoButton.widthAnchor.constraint(equalToConstant: 40),
            addDiscoButton.heightAnchor.constraint(equalToConstant: 40),
            addDiscoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addDiscoButton)
        view.addSubview(emptyStateLabel)
    }
}

extension DiscoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        discos.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiscoTableViewCell.identifier,
            for: indexPath
        ) as? DiscoTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        cell.configure(with: discos[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        DiscoTableViewCell.heigth
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.showProfile(of: discos[indexPath.row])
    }
}
