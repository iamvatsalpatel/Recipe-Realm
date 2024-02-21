//
//  DessertAPI.swift
//  Recipe Realm
//
//  Created by Vatsal Patel  on 2/20/24.
//

import Foundation


enum APIErrors: Error {
    case urlError, responseError, parsingError
}


class DessertsAPI {
    func getDesserts() async throws -> DessertsAPIResponse {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
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
            return try decoder.decode(DessertsAPIResponse.self, from: data)
        } catch {
            throw APIErrors.parsingError
        }
    }
}
