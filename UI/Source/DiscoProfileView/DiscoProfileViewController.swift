//
//  DiscoProfileViewController.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation

public class DiscoProfileViewController: UIViewController {
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
    
    let referenceSection: ReferencesSectionView = {
        let section = ReferencesSectionView()
        section.translatesAutoresizingMaskIntoConstraints = false
        return section
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    public init(disco: DiscoListViewEntity) {
        self.disco = disco
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }

    public override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
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
            referenceSection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
    
    func addViewInHierarchy() {
        view.addSubview(tableView)
        view.addSubview(banner)
        view.addSubview(projectName)
        view.addSubview(referenceSection)
    }
}

//MARK: TableView Datasource/Delegate Conformance
extension DiscoProfileViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        return UITableViewCell()
    }
}
