//
//  DiscoListViewSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class DiscoListViewSpy: DiscoListDisplayLogic {
    enum Message: Equatable {
        case startLoading
        case hideLoading
        case hideOverlays
        case showDiscos([DiscoListViewEntity])
        case showNewDisco(DiscoListViewEntity)
        case createDiscoError(String, String)
        case loadDiscoError(String, String)
    }

    private(set) var receivedMessages: [Message] = []
    var hideOverlaysCompletion: (() -> Void)?

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
