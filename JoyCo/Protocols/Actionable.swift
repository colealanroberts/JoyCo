//
//  Actionable.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/31/23.
//

import Foundation

/// `Actionable` defines a contract for conforming types, typically ViewModel instances,
/// to handle actions via a defined list. Conformers must specify an associated `Action` type,
/// often represented by an enum, which lists all publicly accessible actions that the model can perform.
protocol Actionable {
    /// The type representing all actions that can be performed by the conforming type.
    associatedtype Action
    
    /// - Parameter action: The action to be processed.
    func send(_ action: Action)
}
