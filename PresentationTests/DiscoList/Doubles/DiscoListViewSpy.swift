//
//  DiscoListViewSpy.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Presentation

final class DiscoListViewSpy {
    private(set) var receivedMessages: [Message] = [Message]()

    enum Message: Equatable, CustomStringConvertible {
        case startLoading
        case hideLoading
        case hideOverlays
        case showDiscos([DiscoListViewEntity])
        case showNewDisco(DiscoListViewEntity)
        case createDiscoError(String, String)
        case loadDiscoError(String, String)

        var description: String {
            switch self {
            case .startLoading:
                return "startLoading Called"
            case .hideLoading:
                return "hideLoading Called"
            case .hideOverlays:
                return "hideOverlays Called"
            case .showDiscos(let discos):
                return "showDiscos Called with data: \(discos)"
            case .showNewDisco(let newDisco):
                return "showNewDisco Called with data: \(newDisco)"
            case .createDiscoError(let title, let message):
                return "createDiscoError Called with data: \(title), \(message)"
            case .loadDiscoError(let title, let message):
                return "loadDiscoError Called with data: \(title), \(message)"
            }
        }
    }

    var hideOverlaysCompletion: (() -> Void)?
}

extension DiscoListViewSpy: DiscoListDisplayLogic {
    func startLoading() {
        receivedMessages.append(.startLoading)
    }

    func hideLoading() {
        receivedMessages.append(.hideLoading)
    }

    func hideOverlays(completion: (() -> Void)?) {
        receivedMessages.append(.hideOverlays)
        hideOverlaysCompletion = completion
    }

    func showDiscos(_ discos: [DiscoListViewEntity]) {
        receivedMessages.append(.showDiscos(discos))
    }

    func showNewDisco(_ disco: DiscoListViewEntity) {
        receivedMessages.append(.showNewDisco(disco))
    }

    func createDiscoError(_ title: String, _ description: String) {
        receivedMessages.append(.createDiscoError(title, description))
    }

    func loadDiscoError(_ title: String, _ description: String) {
        receivedMessages.append(.loadDiscoError(title, description))
    }
}
