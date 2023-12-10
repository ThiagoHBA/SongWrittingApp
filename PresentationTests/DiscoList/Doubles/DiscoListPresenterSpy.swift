//
//  PresenterSpy.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
@testable import Presentation

final class DiscoListPresenterSpy {
    private(set) var receivedMessages: [Message] = [Message]()
    
    enum Message: Equatable, CustomStringConvertible {
        case presentLoading
        case presentCreateDiscoError(DiscoListError.CreateDiscoError)
        
        var description: String {
            switch self {
                case .presentLoading:
                    return "presentLoading Called"
                case .presentCreateDiscoError(let error):
                    return "presentCreateDiscoError Called with data: \(error.localizedDescription)"
            }
        }
    }
}

extension DiscoListPresenterSpy: DiscoListPresentationLogic {
    func presentLoading() {
        receivedMessages.append(.presentLoading)
    }
    
    func presentCreateDiscoError(_ error: DiscoListError.CreateDiscoError) {
        receivedMessages.append(.presentCreateDiscoError(error))
    }
}
