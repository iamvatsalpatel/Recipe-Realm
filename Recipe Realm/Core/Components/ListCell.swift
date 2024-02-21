//
//  ListCell.swift
//  Recipe Realm
//
//  Created by Vatsal Patel  on 2/20/24.
//

import SwiftUI

struct ListCell: View {
    let name: String
    let id: String
    let imageUrl: String
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 150, alignment: .center)
                        .cornerRadius(0)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 150, alignment: .center)
                        .cornerRadius(0)
                        
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 150, alignment: .center)
                        .cornerRadius(0)
                        .background(Color.gray)
                    
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(name.capitalizingFirstLetter())
                .tint(.black)
                .font(.headline)
                .padding(.vertical, 10)
                .padding(.bottom, 10)
                .fontWeight(.medium)
                .offset(x: 10)
        }
        .background(.white)
        .cornerRadius(10)
        .padding(.horizontal, 5)
        .padding(.vertical)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.15),radius: 6)
    }
}

#Preview {
    ListCell(name: "White chocolate creme brulee", id: "52917", imageUrl: "https://www.themealdb.com/images/media/meals/uryqru1511798039.jpg")
}

