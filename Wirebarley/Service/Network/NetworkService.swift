//
//  NetworkManager.swift
//  Wirebarley
//
//  Created by rbwo on 1/22/24.
//

import Foundation

class NetworkService {
    
    func request<T: Codable>(request: URLRequest, type: T.Type, completion: @escaping (Result<T, NetworkErrors>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if (200..<300).contains(httpResponse.statusCode) {
                    let decoder = JSONDecoder()
                    let data = try? decoder.decode(T.self, from: data!)
                    completion(.success(data!))
                    return
                }
                else {
                    completion(.failure(.unknown))
                    return
                }
            }
        }.resume()
    }
}
