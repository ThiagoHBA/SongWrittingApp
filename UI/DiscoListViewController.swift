//
//  DiscoListViewController.swift
//  UI
//
//  Created by Thiago Henrique on 09/12/23.
//

import UIKit
import Domain
import Presentation

public class DiscoListViewController: UIViewController {
    let presenter: DiscoListPresentationLogic
    private var discos: [Disco] = [Disco]()
    
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

extension DiscoListViewController: ViewCoding {
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
