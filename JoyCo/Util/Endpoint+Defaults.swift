//
//  Endpoint+Defaults.swift
//  JoyCo
//
//  Created by Cole Roberts on 11/1/23.
//

import Foundation

/// I've stored these here solely for this project, in a production environment
/// these URLs could be configurable through a debug menu, XCode Build Configuration files, etc.
extension Endpoint {
    static let scheme = "https"
    static let host = "themealdb.com"
    static let version = "v1"
    static let rootPath = "/api/json/\(version)/1"
}
