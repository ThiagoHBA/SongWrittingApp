//
//  DiscoListRouterSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class DiscoListRouterSpy: DiscoListRouting {
    enum Message: Equatable {
        case showProfile(DiscoSummary)
    }

    private(set) var receivedMessages: [Message] = []

    func showProfile(of disco: DiscoSummary) {
        receivedMessages.append(.showProfile(disco))
    }
}
