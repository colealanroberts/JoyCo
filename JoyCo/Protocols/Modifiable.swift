//
//  Modifiable.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/30/23.
//

import Foundation

/// `Modifiable` enables conformers to perform inline property modification. This alleviates
/// the need to explicitly create a copy of a value type, effectively transforming —
///
/// ```
/// let egoism = Egoism()
/// var moreEgoism = egoism
/// moreEgoism.value = 2
/// ```
/// to
/// ```
/// let egoism = Egoism()
/// let moreEgoism = egoism.modifying { $0.value = 2 }
/// ```
protocol Modifiable {
    /// Modifies the instance using the provided closure and returns the modified instance.
    /// - Parameter modification: A closure that modifies the instance in place.
    /// - Returns: The modified instance.
    mutating func modifying(_ modification: (inout Self) -> Void) -> Self
}

extension Modifiable {
    mutating func modifying(_ modification: (inout Self) -> Void) -> Self {
        var copy = self
        modification(&copy)
        return copy
    }
}
