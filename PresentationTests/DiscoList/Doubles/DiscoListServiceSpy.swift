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
        case loadProfile(Disco)
        case updateDiscoReferences(Disco, [AlbumReference])
        case addNewSection(Disco, Section)
        case addNewRecord(Disco, Section)
        
        var description: String {
            switch self {
                case .createDisco(let name, let image):
                    return "createDisco Called with data: \(name), \(image)"
                case .loadDiscos:
                    return "loadDiscos Called"
                case .loadProfile(let disco):
                    return "loadProfile Called with data: \(disco)"
                case .updateDiscoReferences(let disco, let references):
                    return "updateDiscoReferences Called with data: \(disco), \(references)"
                case .addNewSection(let disco, let section):
                    return "addNewSection Called with data: \(disco), \(section)"
                case .addNewRecord(let disco, let section):
                    return "addNewRecord Called with data: \(disco), \(section)"
            }
        }
    }
    
    private(set) var receivedMessages: [Message] = [Message]()
    
    // MARK: - Completions
    var createDiscoCompletion: ((Result<Disco, Error>) -> Void)?
    var loadDiscosCompletion: ((Result<[Disco], Error>) -> Void)?
}

extension DiscoListServiceSpy: DiscoService {
    func loadProfile(for disco: Disco, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
        receivedMessages.append(.loadProfile(disco))
    }
    
    func updateDiscoReferences(_ disco: Disco, references: [AlbumReference], completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
        receivedMessages.append(.updateDiscoReferences(disco, references))
    }
    
    func addNewSection(_ disco: Disco, _ section: Section, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
        receivedMessages.append(.addNewSection(disco, section))
    }
    
    func addNewRecord(_ disco: Disco, _ section: Section, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
        receivedMessages.append(.addNewRecord(disco, section))
        
    }
    
    func createDisco(name: String, image: Data, completion: @escaping (Result<Disco, Error>) -> Void) {
        receivedMessages.append(.createDisco(name, image))
        createDiscoCompletion = completion
    }
    
    func loadDiscos(completion: @escaping (Result<[Disco], Error>) -> Void) {
        receivedMessages.append(.loadDiscos)
        loadDiscosCompletion = completion
    }
}
