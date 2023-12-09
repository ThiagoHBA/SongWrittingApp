//
//  DiscoService.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public protocol DiscoService {
    func createDisco(
        name: String,
        image: Data,
        completion: @escaping (Result<Disco, Error>) -> Void
    )
}
