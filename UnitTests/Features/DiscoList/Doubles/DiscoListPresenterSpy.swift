//
//  DiscoListPresenterSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class DiscoListPresenterSpy: DiscoListPresentationLogic {
    enum ReceivedMessage: Equatable {
        case presentLoading
        case presentLoadedDiscos([(disco: DiscoSummary, references: [AlbumReference])])
        case presentLoadDiscoError(String)
        case presentCreatedDisco(DiscoSummary)
        case presentCreateDiscoFailure(String)
        case presentCreateDiscoError(String)
        case presentDeletedDisco(DiscoSummary)
        case presentDeleteDiscoError(String)

        static func == (lhs: ReceivedMessage, rhs: ReceivedMessage) -> Bool {
            switch (lhs, rhs) {
            case (.presentLoading, .presentLoading):
                return true
            case let (.presentLoadedDiscos(lhsDiscos), .presentLoadedDiscos(rhsDiscos)):
                return lhsDiscos.elementsEqual(rhsDiscos) { lhs, rhs in
                    lhs.disco == rhs.disco && lhs.references == rhs.references
                }
            case let (.presentLoadDiscoError(lhs), .presentLoadDiscoError(rhs)):
                return lhs == rhs
            case let (.presentCreatedDisco(lhs), .presentCreatedDisco(rhs)):
                return lhs == rhs
            case let (.presentCreateDiscoFailure(lhs), .presentCreateDiscoFailure(rhs)):
                return lhs == rhs
            case let (.presentCreateDiscoError(lhs), .presentCreateDiscoError(rhs)):
                return lhs == rhs
            case let (.presentDeletedDisco(lhs), .presentDeletedDisco(rhs)):
                return lhs == rhs
            case let (.presentDeleteDiscoError(lhs), .presentDeleteDiscoError(rhs)):
                return lhs == rhs
            default:
                return false
            }
        }
    }

    private(set) var receivedMessages: [ReceivedMessage] = []

    func presentLoading() {
        receivedMessages.append(.presentLoading)
    }

    func presentLoadedDiscos(_ discos: [(disco: DiscoSummary, references: [AlbumReference])]) {
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

    func presentDeletedDisco(_ disco: DiscoSummary) {
        receivedMessages.append(.presentDeletedDisco(disco))
    }

    func presentDeleteDiscoError(_ error: Error) {
        receivedMessages.append(.presentDeleteDiscoError(error.localizedDescription))
    }
}
