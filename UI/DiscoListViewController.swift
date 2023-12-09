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
        label.text = "Discos"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init(presenter: DiscoListPresentationLogic) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
}

extension DiscoListViewController: DiscoListDisplayLogic {
    public func startLoading() {
        
    }
    
    public func hideLoading() {
        
    }
    
    public func showDiscos(_ discos: [DiscoListViewEntity]) {
        
    }
    
    public func showNewDisco(_ disco: DiscoListViewEntity) {
        
    }
    
    public func showError(_ title: String, _ description: String) {
        
    }
}

extension DiscoListViewController: ViewCoding {
    func additionalConfiguration() {
        self.view.backgroundColor = .systemBackground
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func addViewInHierarchy() {
        view.addSubview(titleLabel)
    }
}
