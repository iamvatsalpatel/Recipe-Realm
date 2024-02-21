//
//  DetailRecipeAPI.swift
//  Recipe Realm
//
//  Created by Vatsal Patel  on 2/20/24.
//

import Foundation

class DetailRecipeAPI {
    func getDetailRecipe(of recipeId: String ) async throws -> DetailRecipeAPIResponse {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(recipeId)") else {
            throw APIErrors.urlError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIErrors.responseError
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(DetailRecipeAPIResponse.self, from: data)
        } catch {
            throw APIErrors.parsingError
        }
    }
    
    func getIngredientsWithMeasurements(from data: RecipeData) -> [(ingredient: String, measurement: String)] {
        var results = [(ingredient: String, measurement: String)]()
        
        let ingredientProps = [
            data.strIngredient1, data.strIngredient2, data.strIngredient3, data.strIngredient4, data.strIngredient5,
            data.strIngredient6, data.strIngredient7, data.strIngredient8, data.strIngredient9, data.strIngredient10,
            data.strIngredient11, data.strIngredient12, data.strIngredient13, data.strIngredient14, data.strIngredient15,
            data.strIngredient16, data.strIngredient17, data.strIngredient18, data.strIngredient19, data.strIngredient20
        ]
        
        let measurementProps = [
            data.strMeasure1, data.strMeasure2, data.strMeasure3, data.strMeasure4, data.strMeasure5,
            data.strMeasure6, data.strMeasure7, data.strMeasure8, data.strMeasure9, data.strMeasure10,
            data.strMeasure11, data.strMeasure12, data.strMeasure13, data.strMeasure14, data.strMeasure15,
            data.strMeasure16, data.strMeasure17, data.strMeasure18, data.strMeasure19, data.strMeasure20
        ]
        
        for (ingredient, measurement) in zip(ingredientProps, measurementProps) {
            if let ing = ingredient, !ing.isEmpty, let meas = measurement, !meas.isEmpty {
                results.append((ingredient: ing, measurement: meas))
            }
        }
        
        return results
    }
}
