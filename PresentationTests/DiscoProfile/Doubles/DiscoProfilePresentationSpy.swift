//
//  DiscoProfilePresentationSpy.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation
import Presentation

final class DiscoProfilePresenterSpy {
    private(set) var receivedMessages: [Message] = [Message]()

    enum Message: Equatable, CustomStringConvertible {
        case presentLoading
        case presentCreateSectionError(DiscoProfileError.CreateSectionError)

        var description: String {
            switch self {
            case .presentLoading:
                return "presentLoading Called"
            case .presentCreateSectionError(let error):
                return "presentCreateSectionError Called with data: \(error)"
            }
        }
    }
}

extension DiscoProfilePresenterSpy: DiscoProfilePresentationLogic {
    func presentLoading() {
        receivedMessages.append(.presentLoading)
    }

    func presentCreateSectionError(_ error: DiscoProfileError.CreateSectionError) {
        receivedMessages.append(.presentCreateSectionError(error))
    }
}
