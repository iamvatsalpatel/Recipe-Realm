//
//  DessertAPIResponse.swift
//  Recipe Realm
//
//  Created by Vatsal Patel  on 2/20/24.
//

import Foundation

struct DessertsAPIResponse: Codable {
    let meals: [DessertsData]
}

struct DessertsData: Codable, Identifiable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String { idMeal }
}
