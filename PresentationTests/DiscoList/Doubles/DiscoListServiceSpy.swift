//
//  DiscoListServiceStub.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

final class DiscoListServiceSpy {
    enum Message: Equatable, CustomStringConvertible {
        case createDisco(String, Data)
        case loadDiscos
        
        var description: String {
            switch self {
            case .createDisco(let name, let image):
                return "createDisco Called with data: \(name), \(image)"
            case .loadDiscos:
                return "loadDiscos Called"
            }
        }
    }
    
    private(set) var receivedMessages: [Message] = [Message]()
    
    // MARK: - Completions
    var createDiscoCompletion: ((Result<Disco, Error>) -> Void)?
    var loadDiscosCompletion: ((Result<[Disco], Error>) -> Void)?
}

extension DiscoListServiceSpy: DiscoService {
    func createDisco(name: String, image: Data, completion: @escaping (Result<Disco, Error>) -> Void) {
        receivedMessages.append(.createDisco(name, image))
        createDiscoCompletion = completion
    }
    
    func loadDiscos(completion: @escaping (Result<[Disco], Error>) -> Void) {
        receivedMessages.append(.loadDiscos)
        loadDiscosCompletion = completion
    }
}
