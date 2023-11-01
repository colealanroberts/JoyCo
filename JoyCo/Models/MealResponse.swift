//
//  MealResponse.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/31/23.
//

import Foundation

struct MealResponse<T: Decodable>: Decodable {
    let meals: T
}
