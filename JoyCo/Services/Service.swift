//
//  Service.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/31/23.
//

import Foundation

// MARK: - Service -

protocol Service {
    /// Returns a genericized `Model` conforming to `Decodable`.
    /// - Parameter endpoint: The concrete `Endpoint` of which to perform the request.
    /// - Returns: `Model`
    func request<Model: Decodable>(_ endpoint: Endpoint) async throws -> Model
}

// MARK: - NetworkService -

final class NetworkService: Service {

    // MARK: Private Properties
    
    private let decoder: JSONDecoder
    private let urlSession: URLSession
    
    // MARK: Init
    
    init(
        decoder: JSONDecoder,
        urlSession: URLSession
    ) {
        self.decoder = decoder
        self.urlSession = urlSession
    }
    
    func request<Model: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> Model {
        let (data, response) = try await urlSession.data(for: endpoint.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw Error.statusCode(httpResponse.statusCode)
        }
        
        return try decoder.decode(Model.self, from: data)
    }
}

// MARK: - BaseService+Error -

extension NetworkService {
    enum Error: Swift.Error {
        // Error indicating that the response received was not of type `HTTPURLResponse`.
        case invalidResponse
        
        /// Error indicating a specific HTTP status code with its corresponding 3-digit value.
        case statusCode(Int)
    }
}

// MARK: - Endpoint+Build -

fileprivate extension Endpoint {
    var urlRequest: URLRequest {
        var components = URLComponents()
        components.scheme = Endpoint.scheme
        components.host = Endpoint.host
        components.path = path
        components.queryItems = queryItems
        
        // The decision to utilize a `preconditionFailure(_:)` here is itentional, these URLs are never
        // constructed from user input. However, one might opt for an assertionFailure instead.
        guard let url = components.url else {
            preconditionFailure("Failed to construct a valid URL, got: \(String(describing: components.url))")
        }
        
        var request = URLRequest(url: url)
        if let cachePolicy {
            request.cachePolicy = cachePolicy
        }
        return request
    }
}
