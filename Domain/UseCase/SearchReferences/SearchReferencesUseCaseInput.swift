//
//  LoadReferencesUseCaseInput.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public struct SearchReferencesUseCaseInput {
    public let keywords: String
    
    public init(keywords: String) {
        self.keywords = keywords
    }
}
