//
//  StorageError.swift
//  Infra
//
//  Created by Thiago Henrique on 16/12/23.
//

import Foundation

enum StorageError: LocalizedError {
    case cantFindModel
    case cantLoadDisco
    case cantLoadProfile
}
