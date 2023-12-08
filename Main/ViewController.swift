//
//  ViewController.swift
//  Main
//
//  Created by Thiago Henrique on 08/12/23.
//

import UIKit
import Data
import Infra

class ViewController: UIViewController {
    let networkClient = NetworkClientImpl()
    let secureClient = SecureClientImpl()
    
    let authorizationHandler: AuthorizationHandler
    
    init() {
        self.authorizationHandler = .init(
            networkClient: networkClient,
            secureClient: secureClient
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red

        try! secureClient.deleteData()
        
        authorizationHandler.loadToken { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
    
            let secureTokenData = try! secureClient.getData()
            let token = try! AccessTokenResponse.loadFromData(secureTokenData)
        }
    }
}

