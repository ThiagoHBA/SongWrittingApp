//
//  NetworkClientImpl.swift
//  Infra
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Data

public final class NetworkClientImpl: NetworkClient {
    let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = endpoint.makeURL() else {
             //completion(.failure(DataError.unableToCreateURL))
             return
         }
        
         var request = URLRequest(url: url)
         request.allHTTPHeaderFields = endpoint.headers
         request.httpBody = endpoint.body
         request.httpMethod = endpoint.httpMethod?.rawValue
         
         session.dataTask(with: request) { data, response, error in
              guard let data = data, error == nil else {
//                  completion(.failure(DataError.transportError))
                  return
              }
              guard let response = response as? HTTPURLResponse else { return }
              let status = response.statusCode
              guard (200...299).contains(status) else {
//                  completion(.failure(DataError.httpError(status)))
                  return
              }
             completion(.success(data))
          }.resume()
    }
}

