//
//  AddReferencesViewController.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation
import SwiftUI

struct IdentifiableReference: Identifiable {
    let id: UUID = UUID()
    let refernce: AlbumReferenceViewEntity
}

class SelectedReferenceListModel: ObservableObject {
    @Published var items: [IdentifiableReference] = []
}

class AddReferencesViewController: UIViewController {
    private var loadedReferences: [AlbumReferenceViewEntity] = []
    private var selectedReferences: [AlbumReferenceViewEntity] = [] {
        didSet { updateSelectedReferenceItems(newItems: selectedReferences) }
    }
    private var itemModel = SelectedReferenceListModel()
    var searchReference: ((String) -> Void)?
    var saveReferences: (([AlbumReferenceViewEntity]) -> Void)?
    
    lazy var navBar: UINavigationBar = {
        let nav = UINavigationBar()
        let navigationItem = UINavigationItem(title: "Referências")
        let saveButton = UIBarButtonItem(
             title: "Save",
             style: .plain,
             target: self,
             action: #selector(saveReferencesTapped)
        )
        navigationItem.rightBarButtonItem = saveButton
        nav.items = [navigationItem]
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()
    
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
    
    lazy var selectedReferencesList: UIView = {
        var suiView = SelectedReferenceListView(itemModel: itemModel)
        suiView.selectedReferenceTapped = removeAddedReference
        let hosting = UIHostingController(rootView: suiView)
        guard let uiKitView = hosting.view else { return UIView() }
        uiKitView.translatesAutoresizingMaskIntoConstraints = false
        return uiKitView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    @objc func saveReferencesTapped() {
        saveReferences?(selectedReferences)
    }
    
    func removeAddedReference(_ reference: AlbumReferenceViewEntity) {
        guard let findedIndex = selectedReferences.firstIndex(where: { $0 == reference }) else {
            return
        }
        selectedReferences.remove(at: findedIndex)
    }
    
    public func updateReferenceItems(_ newItems: [AlbumReferenceViewEntity]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            loadedReferences = newItems
            referencesList.reloadData()
        }
    }
    
    func updateSelectedReferenceItems(newItems: [AlbumReferenceViewEntity]) {
        itemModel.items = newItems.map { IdentifiableReference(refernce: $0) }
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
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 46),
            
            
            searchBar.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 24),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            selectedReferencesList.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            selectedReferencesList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            selectedReferencesList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedReferencesList.heightAnchor.constraint(equalToConstant: 36),
            
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            resultLabel.topAnchor.constraint(equalTo: selectedReferencesList.bottomAnchor, constant: 24),
            
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
        view.addSubview(selectedReferencesList)
        view.addSubview(navBar)
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
                referencesList.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = loadedReferences[indexPath.row]
        selectedReferences.append(selectedItem)
    }
}
