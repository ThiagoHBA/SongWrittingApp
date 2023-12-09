//
//  ViewController.swift
//  Main
//
//  Created by Thiago Henrique on 08/12/23.
//

import UIKit
import Data
import Infra
import Domain

class ViewController: UIViewController {
    let networkClient = NetworkClientImpl()
    let secureClient = SecureClientImpl()
    let referenceImpl: ReferencesServiceImpl
    
    init() {
        let tokenProvider = AuthorizationHandlerImpl(
            networkClient: networkClient,
            secureClient: secureClient
        )
        let decorator = AuthorizationDecorator(
            client: networkClient,
            tokenProvider: tokenProvider
        )
        self.referenceImpl = ReferencesServiceImpl(networkClient: decorator)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        referenceImpl.loadReferences(ReferenceRequest(keywords: "ACDC"))
//        try! secureClient.deleteData()
//        
//        authorizationHandler.loadTokenOnStorage { [weak self] error in
//            guard let self = self else { return }
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//    
//            let secureTokenData = try! secureClient.getData()
//            let token = try! AccessTokenResponse.loadFromData(secureTokenData)
//        }
    }
}

