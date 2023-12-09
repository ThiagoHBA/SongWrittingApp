//
//  DiscoListViewController.swift
//  UI
//
//  Created by Thiago Henrique on 09/12/23.
//

import UIKit
import Presentation

public class DiscoListViewController: UIViewController {
    let presenter: DiscoListPresentationLogic
    private var discos: [DiscoListViewEntity] = [DiscoListViewEntity]()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Seus Discos"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    public init(presenter: DiscoListPresentationLogic) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        presenter.createDisco(name: "White Album", image: UIImage(systemName: "photo.fill")!.pngData()!)
        presenter.createDisco(name: "Let it be", image: UIImage(systemName: "photo.fill")!.pngData()!)
        presenter.createDisco(name: "Revolver", image: UIImage(systemName: "photo.fill")!.pngData()!)
//        presenter.loadDiscos()
    }
}

extension DiscoListViewController: DiscoListDisplayLogic {
    public func startLoading() {
        print("Starting Load")
    }
    
    public func hideLoading() {
        print("Hiding Load")
    }
    
    public func showDiscos(_ discos: [DiscoListViewEntity]) {
        self.discos = discos
        tableView.reloadData()
    }
    
    public func showNewDisco(_ disco: DiscoListViewEntity) {
        print("New Disco created")
        self.discos.append(disco)
        self.showDiscos(discos)
    }
    
    public func showError(_ title: String, _ description: String) {
        print("Erro: \(title): \(description)")
    }
}

extension DiscoListViewController: ViewCoding {
    func additionalConfiguration() {
        self.view.backgroundColor = .systemBackground
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
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addViewInHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
}

//MARK: TableView Datasource/Delegate Conformance
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
        
        cell.configure(with: discos[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DiscoTableViewCell.heigth
    }
    
}
