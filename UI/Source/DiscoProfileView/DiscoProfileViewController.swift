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
    
    public init(disco: DiscoListViewEntity) {
        self.disco = disco
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
}
