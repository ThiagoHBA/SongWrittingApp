//
//  ReferenceServiceSpy.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation
import Domain

final class ReferenceServiceSpy: ReferencesService {
    var loadReferencesCompletion: ((Result<[AlbumReference], Error>) -> Void)?
    
    func loadReferences(
        _ keywords: String,
        completion: @escaping (Result<[AlbumReference], Error>) -> Void
    ) {
        loadReferencesCompletion = completion
    }
}
