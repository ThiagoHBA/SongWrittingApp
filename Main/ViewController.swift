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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .red
        let networkClient = NetworkClientImpl()
        let secureClient = SecureClientImpl()
        
        let authorizationHandler = AuthorizationHandler(
            networkClient: networkClient,
            secureClient: secureClient
        )
        
        authorizationHandler.loadToken { result in
            switch result {
                case .success(let token):
                    print(token.accessToken)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
//        let useCase = LoadReferencesUseCase(service: , input: )
    }


}

