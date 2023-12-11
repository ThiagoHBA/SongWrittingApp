//
//  DiscoProfileViewController.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation

public class DiscoProfileViewController: UIViewController {
    let interactor: DiscoProfileBusinessRule
    let disco: DiscoListViewEntity
    
    let banner: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let projectName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var referenceSection: ReferencesSectionView = {
        let section = ReferencesSectionView()
        section.addReferenceTapped = addReferenceTapped
        section.translatesAutoresizingMaskIntoConstraints = false
        return section
    }()
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Seções"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addButton: AddButtonComponent = {
        let button = AddButtonComponent()
        button.didTapped = addSectionTapped
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var referenceViewController: AddReferencesViewController = {
        let sheet = AddReferencesViewController()
        sheet.searchReference = interactor.searchNewReferences
        sheet.saveReferences = { [weak self] referencesToAdd in
            guard let self = self else { return }
            interactor.addNewReferences(
                for: disco,
                references: referencesToAdd
            )
        }
        sheet.sheetPresentationController?.detents = [ .large() ]
        return sheet
    }()
    
    public init(disco: DiscoListViewEntity, interactor: DiscoProfileBusinessRule) {
        self.disco = disco
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }

    public override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.loadProfile(for: disco)
    }
    
    func addReferenceTapped() {
        present(referenceViewController, animated: true)
    }
    
    func configure(with profile: DiscoProfileViewEntity) {
        referenceSection.references = profile.references
    }
    
    func addSectionTapped() {
        
    }
}

extension DiscoProfileViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        banner.image = UIImage(data: disco.coverImage)!
        projectName.text = disco.name
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.topAnchor),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            banner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            projectName.topAnchor.constraint(equalTo: banner.bottomAnchor, constant: 8),
            projectName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            referenceSection.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 20),
            referenceSection.leadingAnchor.constraint(equalTo: projectName.leadingAnchor),
            referenceSection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            referenceSection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            sectionLabel.topAnchor.constraint(equalTo: referenceSection.bottomAnchor, constant: 42),
            sectionLabel.leadingAnchor.constraint(equalTo: projectName.leadingAnchor),
            
            addButton.centerYAnchor.constraint(equalTo: sectionLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            addButton.heightAnchor.constraint(equalToConstant: 28),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            
            tableView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 6),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addViewInHierarchy() {
        view.addSubview(tableView)
        view.addSubview(banner)
        view.addSubview(projectName)
        view.addSubview(referenceSection)
        view.addSubview(sectionLabel)
        view.addSubview(addButton)
    }
}

extension DiscoProfileViewController: AlertPresentable {}

//MARK: TableView Datasource/Delegate Conformance
extension DiscoProfileViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Title"
        return cell
    }
}

extension DiscoProfileViewController: DiscoProfileDisplayLogic {
    public func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            referenceSection.references = references
        }
    }
    
    public func startLoading() {
            
    }
    
    public func hideLoading() {
        
    }

    public func showProfile(_ profile: DiscoProfileViewEntity) {
        configure(with: profile)
    }
    
    public func addingReferencesError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }
    
    public func loadingProfileError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }
    
    public func showReferences(_ references: [AlbumReferenceViewEntity]) {
        self.referenceViewController.updateReferenceItems(references)
    }
}
