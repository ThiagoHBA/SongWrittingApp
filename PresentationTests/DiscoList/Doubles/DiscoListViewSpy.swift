//
//  DiscoListViewSpy.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Presentation

final class DiscoListViewSpy {}

extension DiscoListViewSpy: DiscoListDisplayLogic {
    func startLoading() {
            
    }
    
    func hideLoading() {
        
    }
    
    func hideOverlays(completion: (() -> Void)?) {
        
    }
    
    func showDiscos(_ discos: [Presentation.DiscoListViewEntity]) {
        
    }
    
    func showNewDisco(_ disco: Presentation.DiscoListViewEntity) {
        
    }
    
    func createDiscoError(_ title: String, _ description: String) {
        
    }
    
    func loadDiscoError(_ title: String, _ description: String) {
        
    }
}
