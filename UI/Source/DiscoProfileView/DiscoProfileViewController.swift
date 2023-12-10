//
//  DiscoProfileViewController.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation

class DiscoProfileViewController: UIViewController {
    let disco: DiscoListViewEntity
    
    init(disco: DiscoListViewEntity) {
        self.disco = disco
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
