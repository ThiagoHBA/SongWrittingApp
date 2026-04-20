//
//  DiscoListBusinessLogicSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class DiscoListBusinessLogicSpy: DiscoListBusinessLogic {
    enum Message: Equatable {
        case loadDiscos
        case createDisco(name: String, description: String?, image: Data)
        case showProfile(DiscoListViewEntity)
        case deleteDisco(DiscoListViewEntity)
    }

    private(set) var receivedMessages: [Message] = []

    func loadDiscos() {
        receivedMessages.append(.loadDiscos)
    }

    func createDisco(name: String, description: String?, image: Data) {
        receivedMessages.append(.createDisco(name: name, description: description, image: image))
    }

    func showProfile(of disco: DiscoListViewEntity) {
        receivedMessages.append(.showProfile(disco))
    }

    func deleteDisco(_ disco: DiscoListViewEntity) {
        receivedMessages.append(.deleteDisco(disco))
    }

    func reset() {
        receivedMessages.removeAll()
    }
}
