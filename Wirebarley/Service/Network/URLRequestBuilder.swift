//
//  URLRequestBuilder.swift
//  Wirebarley
//
//  Created by rbwo on 1/22/24.
//

import Foundation

struct URLRequestBuilder {
    private var url: URLComponents?
    private var method: HTTPMethod = .get
    private var headers: [String: String] = [:]
    private var body: Data?

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
   
    init(url: String) {
        self.url = URLComponents(string: url)
    }

    mutating func setMethod(_ method: HTTPMethod) {
        self.method = method
    }

    mutating func addHeader(field: String, value: String) {
        self.headers[field] = value
    }

    mutating func setBody(_ body: Data) {
        self.body = body
    }
    
    mutating func appendQuery(name: String, value: String) {
        let query = URLQueryItem(name: name, value: value)
        self.url?.queryItems?.append(query)
    }

    func build() -> URLRequest? {
        guard let url = url?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
