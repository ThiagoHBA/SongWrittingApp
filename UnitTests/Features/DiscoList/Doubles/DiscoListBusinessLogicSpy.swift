//
//  DiscoListBusinessLogicSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DiscoListBusinessLogicSpy: DiscoListBusinessLogic {
    func loadDiscos() {}
    func createDisco(name: String, description: String?, image: Data) {}
    func showProfile(of disco: DiscoListViewEntity) {}
    func deleteDisco(_ disco: DiscoListViewEntity) {}
}

extension DiscoListBusinessLogicSpy {
    func reset() {
        receivedMessages.removeAll()
    }
}
