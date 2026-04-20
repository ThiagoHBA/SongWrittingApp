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
        case presentDeletedDisco(DiscoSummary)
        case presentDeleteDiscoError(String)
    }

    private(set) var receivedMessages: [Message] = []
    var onReceivedMessages: (() -> Void)?

    func presentLoading() {
        receivedMessages.append(.presentLoading)
        onReceivedMessages?()
    }

    func presentLoadedDiscos(_ discos: [DiscoSummary]) {
        receivedMessages.append(.presentLoadedDiscos(discos))
        onReceivedMessages?()
    }

    func presentLoadDiscoError(_ error: Error) {
        receivedMessages.append(.presentLoadDiscoError(error.localizedDescription))
        onReceivedMessages?()
    }

    func presentCreatedDisco(_ disco: DiscoSummary) {
        receivedMessages.append(.presentCreatedDisco(disco))
        onReceivedMessages?()
    }

    func presentCreateDiscoFailure(_ error: Error) {
        receivedMessages.append(.presentCreateDiscoFailure(error.localizedDescription))
        onReceivedMessages?()
    }

    func presentCreateDiscoError(_ error: Error) {
        receivedMessages.append(.presentCreateDiscoError(error.localizedDescription))
        onReceivedMessages?()
    }

    func presentDeletedDisco(_ disco: DiscoSummary) {
        receivedMessages.append(.presentDeletedDisco(disco))
        onReceivedMessages?()
    }

    func presentDeleteDiscoError(_ error: Error) {
        receivedMessages.append(.presentDeleteDiscoError(error.localizedDescription))
        onReceivedMessages?()
    }
}
