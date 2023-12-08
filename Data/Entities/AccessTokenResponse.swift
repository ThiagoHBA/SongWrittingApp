//
//  AccessTokenResponse.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public struct AccessTokenResponse: DataEntity, Decodable {
    public let accessToken: String
    public let tokenType: String
    public let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
