//
//  DiscoListPresenterSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DiscoListPresenterSpy: DiscoListPresentationLogic {
    func presentLoading() {}
    func presentLoadedDiscos(_ discos: [DiscoSummary]) {}
    func presentLoadDiscoError(_ error: Error) {}
    func presentCreatedDisco(_ disco: DiscoSummary) {}
    func presentCreateDiscoFailure(_ error: Error) {}
    func presentCreateDiscoError(_ error: Error) {}
    func presentDeletedDisco(_ disco: DiscoSummary) {}
    func presentDeleteDiscoError(_ error: Error) {}
}
