//
//  Loadable.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/31/23.
//

import Foundation

/// `Loadable` models `Content` which may be loaded, typically from a network request.
enum Loadable<Content> {
    /// The content failed to load.
    case error(any Error)
    
    /// The content is loading.
    case loading
    
    /// The content has been loaded.
    case loaded(Content)
    
    /// Returns whether the current state is loading.
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    /// Returns whether loading has failed.
    var hasError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
    
    /// The associated content, if any, otherwise nil.
    var content: Content? {
        if case .loaded(let content) = self {
            return content
        }
        return nil
    }
    
    /// The associated error, if any, otherwise nil.
    var error: (any Error)? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
}

// MARK: - Loadable+Collection -

extension Loadable where Content: Collection {
    var isEmpty: Bool {
        switch self {
        case .error:
            return true
        case .loading:
            return false
        case .loaded(let content):
            return content.isEmpty
        }
    }
}

// MARK: - Loadable+Equatable

extension Loadable: Equatable where Content: Equatable {
    static func == (lhs: Loadable<Content>, rhs: Loadable<Content>) -> Bool {
        lhs.content == rhs.content
    }
}

