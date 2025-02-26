//
//  Dish.swift
//  Domashka
//
//  Created by Ulyana Eskova on 17.01.2025.
//

import Foundation

struct Dish {
    let id: String
    let name: String
    let description: String
    let chef: Chef
    let rating: Double
    let nutritionalInfo: NutritionalInfo
    let optionalIngredients: [Ingredient]
    let portionSize: String
    let price: Int
    let imageUrl: String
    let deliveryTimeMin: Int
    let deliveryTimeMax: Int
}
