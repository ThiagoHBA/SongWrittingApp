//
//  DiscoListServiceStub.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

final class DiscoListServiceStub: DiscoService {
    func createDisco(name: String, image: Data, completion: @escaping (Result<Domain.Disco, Error>) -> Void) {
        
    }
    
    func loadDiscos(completion: @escaping (Result<[Domain.Disco], Error>) -> Void) {
        
    }
}
