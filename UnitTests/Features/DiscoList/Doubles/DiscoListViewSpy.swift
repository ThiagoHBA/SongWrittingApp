//
//  DiscoListViewSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DiscoListViewSpy: DiscoListDisplayLogic {
    var hideOverlaysCompletion: (() -> Void)?

    func startLoading() {}
    func hideLoading() {}
    @SWSpyMethodTracker
    func hideOverlays(completion: (() -> Void)?) {
        receivedMessages.append(.hideOverlays)
        hideOverlaysCompletion = completion
    }
    func showDiscos(_ discos: [DiscoListViewEntity]) {}
    func showNewDisco(_ disco: DiscoListViewEntity) {}
    func createDiscoError(_ title: String, _ description: String) {}
    func loadDiscoError(_ title: String, _ description: String) {}
    func removeDisco(_ disco: DiscoListViewEntity) {}
    func deleteDiscoError(_ title: String, _ description: String) {}
}
