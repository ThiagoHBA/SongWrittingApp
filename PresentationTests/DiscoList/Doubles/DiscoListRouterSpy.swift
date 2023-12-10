//
//  DiscoListRouterSpy.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
@testable import Presentation

final class DiscoListRouterSpy {
    private(set) var receivedMessages: [Message] = [Message]()
    
    enum Message: Equatable, CustomStringConvertible {
        case showProfile(DiscoListViewEntity)
        
        var description: String {
            switch self {
                case .showProfile(let entity):
                    return "showProfile Called with data: \(entity)"
            }
        }
    }
}

extension DiscoListRouterSpy: DiscoListRouterLogic {
    func showProfile(of disco: DiscoListViewEntity) {
        receivedMessages.append(.showProfile(disco))
    }
}
