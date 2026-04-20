//
//  DiscoListViewController.swift
//  Main
//
//  Created by Thiago Henrique on 20/04/26.
//

import UIKit

protocol DiscoListDisplayLogic: AnyObject {
    func startLoading()
    func hideLoading()
    func hideOverlays(completion: (() -> Void)?)
    func showDiscos(_ discos: [DiscoListViewEntity])
    func showNewDisco(_ disco: DiscoListViewEntity)
    func createDiscoError(_ title: String, _ description: String)
    func loadDiscoError(_ title: String, _ description: String)
    func removeDisco(_ disco: DiscoListViewEntity)
    func deleteDiscoError(_ title: String, _ description: String)
}

final class DiscoListViewController: UIViewController, AlertPresentable {
    private let interactor: DiscoListBusinessLogic

    private var discos: [DiscoListViewEntity] = [] {
        didSet {
            emptyStateView.isHidden = !discos.isEmpty
        }
    }

    private var isLoading = false

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            SWDiscoListItemCell.self,
            forCellReuseIdentifier: SWDiscoListItemCell.identifier
        )
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(
            top: SWSpacing.small,
            left: 0,
            bottom: SWSpacing.large,
            right: 0
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let emptyStateView: SWMessageView = {
        let view = SWMessageView()
        view.configure(
            message: """
            Você ainda não possui nenhum disco!
            Adicione um novo disco utilizando o ícone acima.
            """
        )
        view.isHidden = true
        return view
    }()

    init(interactor: DiscoListBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.loadDiscos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @objc private func addDiscoButtonTapped() {
        let sheet = CreateDiscoViewController()

        sheet.createDiscoTapped = { [weak self] name, description, cover in
            self?.interactor.createDisco(
                name: name,
                description: description,
                image: cover
            )
        }

        present(sheet, animated: true)
    }

    private func loadPlaceholders() {
        let placeholder = DiscoListViewEntity(
            id: UUID(),
            name: "",
            coverImage: UIImage(named: "vinil_image_example")?.pngData() ?? Data(),
            entityType: .placeholder
        )

        discos.append(contentsOf: Array(repeating: placeholder, count: 4))
    }

    private func removePlaceholders() {
        discos.removeAll(where: { $0.entityType == .placeholder })
    }

    private func showDeleteConfirmation(for disco: DiscoListViewEntity) {
        let alert = UIAlertController(
            title: "Deletar Disco",
            message: "Tem certeza que deseja deletar \"\(disco.name)\"? Esta ação não pode ser desfeita.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Deletar", style: .destructive) { [weak self] _ in
            self?.interactor.deleteDisco(disco)
        })
        present(alert, animated: true)
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

    func removeDisco(_ disco: DiscoListViewEntity) {
        discos.removeAll(where: { $0.id == disco.id })
        tableView.reloadData()
    }

    func deleteDiscoError(_ title: String, _ description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }
}

extension DiscoListViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = SWColor.Background.screen
        title = "Meus Discos"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addDiscoButtonTapped)
        )
        navigationItem.rightBarButtonItem?.accessibilityLabel = "Adicionar disco"
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.large),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.large),

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
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
            withIdentifier: SWDiscoListItemCell.identifier,
            for: indexPath
        ) as? SWDiscoListItemCell else {
            return UITableViewCell()
        }

        let disco = discos[indexPath.row]
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: SWColor.Background.screen)
        cell.configure(
            with: SWDiscoListItemContent(
                title: disco.name,
                coverImage: UIImage(data: disco.coverImage)
            )
        )
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SWDiscoListItemCell.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.showProfile(of: discos[indexPath.row])
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let disco = discos[indexPath.row]
        guard disco.entityType == .disco else { return nil }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let deleteAction = UIAction(
                title: "Deletar",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { [weak self] _ in
                self?.showDeleteConfirmation(for: disco)
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }
}
