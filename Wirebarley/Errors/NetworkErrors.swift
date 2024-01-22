//
//  NetworkErrors.swift
//  Wirebarley
//
//  Created by rbwo on 1/22/24.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case noData
    case decodingFailed
    case unknown
    case custom(String)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingFailed:
            return "Decoding Failed"
        case .unknown:
            return "Unknown Error"
        case .custom(let message):
            return message
        }
    }
}
