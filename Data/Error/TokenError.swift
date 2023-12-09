//
//  TokenError.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public enum TokenError: Error {
    case unableToCreateToken
    case needToRefresh
    case requestError(Error)
}
