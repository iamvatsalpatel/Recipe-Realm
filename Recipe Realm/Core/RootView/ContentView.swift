//
//  ContentView.swift
//  Recipe Realm
//
//  Created by Vatsal Patel  on 2/20/24.
//

import SwiftUI

struct ContentView: View {
    let dessertAPI = DessertsAPI()
    @State private var dessertsFound: DessertsAPIResponse? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:5) {
                    if let desserts = dessertsFound?.meals.sorted(by: { $0.strMeal < $1.strMeal }) {
                        ForEach(desserts, id: \.idMeal) { dessert in
                            NavigationLink {
                                RecipeView(id: dessert.idMeal)
                            } label: {
                                ListCell(name: dessert.strMeal, id: dessert.idMeal, imageUrl: dessert.strMealThumb)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Desserts")
        }
        .ignoresSafeArea(.all)
        .task {
            do {
                dessertsFound = try await dessertAPI.getDesserts()
            } catch {
                alertMessage = "Something Went Wrong!"
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}
