//
//  AddReferencesViewController.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation

class AddReferencesViewController: UIViewController {
    private var loadedReferences: [AlbumReferenceViewEntity] = []
    var searchReference: ((String) -> Void)?
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Buscar"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Resultados"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let referencesList: UITableView = {
        let tableView = UITableView()
        tableView.register(
            FindedReferenceTableViewCell.self,
            forCellReuseIdentifier: FindedReferenceTableViewCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        title = "Referências"
    }
    
    public func updateReferenceItems(_ newItems: [AlbumReferenceViewEntity]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            loadedReferences = newItems
            referencesList.reloadData()
        }
    }
}

extension AddReferencesViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        referencesList.delegate = self
        referencesList.dataSource = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            resultLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 36),
            
            referencesList.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 12),
            referencesList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            referencesList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            referencesList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addViewInHierarchy() {
        view.addSubview(resultLabel)
        view.addSubview(searchBar)
        view.addSubview(referencesList)
    }
}

extension AddReferencesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if searchText != String() {
                searchReference?(searchText)
            } else {
                loadedReferences = []
            }
        }
    }
}

extension AddReferencesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedReferences.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FindedReferenceTableViewCell.heigth
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FindedReferenceTableViewCell.identifier,
            for: indexPath
        ) as? FindedReferenceTableViewCell else {
            return UITableViewCell()
        }
        
        let currentItem = loadedReferences[indexPath.row]
        cell.configure(with: currentItem)

        return cell
    }
    
    
}
