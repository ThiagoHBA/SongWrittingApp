//
//  AccessTokenResponse.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

struct AccessTokenResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
