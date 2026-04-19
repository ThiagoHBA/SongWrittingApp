//
//  DiscoListPresenterSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class DiscoListPresenterSpy: DiscoListPresentationLogic {
    enum Message: Equatable {
        case presentLoading
        case presentLoadedDiscos([DiscoSummary])
        case presentLoadDiscoError(String)
        case presentCreatedDisco(DiscoSummary)
        case presentCreateDiscoFailure(String)
        case presentCreateDiscoError(String)
    }

    private(set) var receivedMessages: [Message] = []

    func presentLoading() {
        receivedMessages.append(.presentLoading)
    }

    func presentLoadedDiscos(_ discos: [DiscoSummary]) {
        receivedMessages.append(.presentLoadedDiscos(discos))
    }

    func presentLoadDiscoError(_ error: Error) {
        receivedMessages.append(.presentLoadDiscoError(error.localizedDescription))
    }

    func presentCreatedDisco(_ disco: DiscoSummary) {
        receivedMessages.append(.presentCreatedDisco(disco))
    }

    func presentCreateDiscoFailure(_ error: Error) {
        receivedMessages.append(.presentCreateDiscoFailure(error.localizedDescription))
    }

    func presentCreateDiscoError(_ error: Error) {
        receivedMessages.append(.presentCreateDiscoError(error.localizedDescription))
    }
}
