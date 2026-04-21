//
//  DiscoListRouterSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DiscoListRouterSpy: DiscoListRouting {
    func showProfile(of disco: DiscoSummary) {}
}
