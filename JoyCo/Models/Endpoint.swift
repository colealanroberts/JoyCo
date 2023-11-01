//
//  Endpoint.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/31/23.
//

import Foundation

struct Endpoint {
    /// The path associated with this endpoint
    /// - Note: For example, `/api/v1/...`
    let path: String
    
    /// Any query parameters associated with the request.
    let queryItems: [URLQueryItem]
    
    /// The cache policy associated with the endpoint, if any.
    /// - Note: If no policy is supplied, the default policy `.useProtocolCachePolicy`.
    /// is used when making the request.
    let cachePolicy: URLRequest.CachePolicy?
}

// MARK: - Endpoint+Util -

extension Endpoint {
    /// A utility function which includes the path `/api/json/v1/1` by default.
    static func api(
        path: String,
        queryItems: [URLQueryItem],
        cachePolicy: URLRequest.CachePolicy? = nil
    ) -> Self {
        self.init(
            path: "\(Endpoint.rootPath)\(path)",
            queryItems: queryItems,
            cachePolicy: cachePolicy
        )
    }
}
