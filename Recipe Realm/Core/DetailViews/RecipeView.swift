//
//  RecipeView.swift
//  Recipe Realm
//
//  Created by Vatsal Patel  on 2/20/24.
//

import SwiftUI

struct RecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var id: String
    let detailRecipeAPI = DetailRecipeAPI()
    @State private var fullDetailRecipe: DetailRecipeAPIResponse? = nil
    @State private var detailRecipeData: RecipeData?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        if let detailRecipeData = detailRecipeData {
            ScrollView {
                AsyncImage(url: URL(string: detailRecipeData.strMealThumb)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height:300, alignment: .center)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height:300, alignment: .center)
                            .clipped()
                        
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width:100, height: 100, alignment: .center)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 300)
                .background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.3), Color(.gray)]), startPoint: .top, endPoint: .bottom))
                

                VStack(alignment: .leading, spacing: 20) {
                    Text(detailRecipeData.strMeal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients/measurements")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            let ingredients = detailRecipeAPI.getIngredientsWithMeasurements(from: detailRecipeData)
                            ForEach(Array(ingredients.enumerated()), id: \.offset) { index, pair in
                                Text("\(index + 1). \(pair.ingredient) - \(pair.measurement)")
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Instructions")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        let instructions = detailRecipeData.strInstructions?.components(separatedBy: "\r\n") ?? []
                        let instructionsFiltered = instructions.filter({$0 != "" })
                        
                        ForEach(0..<instructionsFiltered.count, id: \.self) { index in
                            let step = instructionsFiltered[index]
                            if step != "" {
                                Text("\(index + 1). \(step)")
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 10)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.top, -30)
                .padding(.bottom, 30)
            }
            .ignoresSafeArea(.container, edges: .all)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Desserts")
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .foregroundStyle(Color.black)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)

                    })
                }
            }
        } else {
            ProgressView("Loading...")
                .frame(maxWidth: .infinity)
                .onAppear{
                    Task {
                        do {
                            fullDetailRecipe = try await detailRecipeAPI.getDetailRecipe(of: id)
                            detailRecipeData = fullDetailRecipe?.meals[0]
                        } catch {
                            alertMessage = "Something Went Wrong!"
                            showAlert = true
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
        }
    }
}

#Preview {
    RecipeView(id: "52900")
}
