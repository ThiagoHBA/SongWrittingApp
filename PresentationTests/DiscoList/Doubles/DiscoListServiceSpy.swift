//
//  DiscoListServiceStub.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

final class DiscoListServiceSpy {
    private(set) var receivedMessages: [Message] = [Message]()
    
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
}

extension DiscoListServiceSpy: DiscoService {
    func createDisco(name: String, image: Data, completion: @escaping (Result<Disco, Error>) -> Void) {
        receivedMessages.append(.createDisco(name, image))
    }
    
    func loadDiscos(completion: @escaping (Result<[Disco], Error>) -> Void) {
        receivedMessages.append(.loadDiscos)
    }
}
