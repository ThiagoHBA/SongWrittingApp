//
//  SecureClientSpy.swift
//  DataTests
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
@testable import Data

class SecureClientSpy: SecurePersistenceClient {
    func saveData(_ data: Data) throws {
        
    }
    
    func getData() throws -> Data {
        return Data()
    }
    
    func deleteData() throws {
        
    }
}
