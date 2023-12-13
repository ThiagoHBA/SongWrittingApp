//
//  DiscoListViewController.swift
//  UI
//
//  Created by Thiago Henrique on 09/12/23.
//

import UIKit
import Presentation

public class DiscoListViewController: UIViewController, AlertPresentable {
    let interactor: DiscoListBusinessLogic
    private var discos: [DiscoListViewEntity] = [DiscoListViewEntity]() {
        didSet {
            emptyStateLabel.isHidden = !discos.isEmpty
        }
    }
    private(set) var isLoading: Bool = false

    let titleLabel: UILabel = {
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

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            DiscoTableViewCell.self,
            forCellReuseIdentifier: DiscoTableViewCell.identifier
        )
        tableView.showsVerticalScrollIndicator = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let emptyStateLabel: UILabel = {
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

    public init(interactor: DiscoListBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    public override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.loadDiscos()
    }

    @objc func addDiscoButtonTapped() {
        let sheet = CreateDiscoViewController()
        sheet.sheetPresentationController?.detents = [ .medium() ]
        sheet.createDiscoTapped = interactor.createDisco
        present(sheet, animated: true)
    }

    private func loadPlaceholders() {
        let placeholder: DiscoListViewEntity = .init(
            id: UUID(),
            name: "",
            coverImage: UIImage(named: "vinil_image_example")!.pngData()!
        )
        discos.append(placeholder)
        discos.append(placeholder)
        discos.append(placeholder)
        discos.append(placeholder)
    }

    private func removePlaceholders() {
        discos.removeAll(where: { $0.name == "" })
    }
}

extension DiscoListViewController: DiscoListDisplayLogic {
    public func createDiscoError(_ title: String, _ description: String) {
        showAlert(title: title, message: description) { [weak self] _ in
            self?.addDiscoButtonTapped()
        }
    }

    public func loadDiscoError(_ title: String, _ description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }

    public func hideOverlays(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }

    public func startLoading() {
        isLoading = true
        loadPlaceholders()
        tableView.reloadData()
    }

    public func hideLoading() {
        isLoading = false
        removePlaceholders()
        tableView.reloadData()
    }

    public func showDiscos(_ discos: [DiscoListViewEntity]) {
        self.discos = discos
        tableView.reloadData()
    }

    public func showNewDisco(_ disco: DiscoListViewEntity) {
        self.discos.append(disco)
        self.showDiscos(discos)
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

// MARK: TableView Datasource/Delegate Conformance
extension DiscoListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discos.count
    }

    public func tableView(
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

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DiscoTableViewCell.heigth
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDisco = discos[indexPath.row]
        interactor.showProfile(of: selectedDisco)
    }
}
