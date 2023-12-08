//
//  SecureClient.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public protocol SecurePersistenceClient {
    var server: String { get }
    
    func saveData(account: String, dataToSave: Data) throws
    func getData() throws -> Data
    func deleteData() throws 
}

public extension SecurePersistenceClient {
    var server: String {
        return Constants.accountUrl
    }
}
