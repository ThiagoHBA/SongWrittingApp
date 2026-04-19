//
//  SearchReferenceViewEntity.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation

struct SearchReferenceViewEntity: Equatable {
    let id: Int
    let title: String
    let imagePath: String
    
    init(id: Int, title: String, imagePath: String) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
    }
    
    init(from domainEntity: ReferenceProvider) {
        id = domainEntity.rawValue

        switch domainEntity {
        case .spotify:
            imagePath = "spotify_icon"
            title = "Spotify"
        case .lastFM:
            imagePath = "lastfm_icon"
            title = "Last.fm"
        }
    }
}
