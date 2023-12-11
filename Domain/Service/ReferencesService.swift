//
//  ReferencesService.swift
//  Domain
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public protocol ReferencesService {
    func loadReferences(
        _ keywords: String,
        completion: @escaping (Result<[AlbumReference], Error>) -> Void
    )
}
