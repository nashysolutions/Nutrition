//
//  FoodCell.swift
//  Nutrition
//
//  Created by Robert Nash on 13/05/2024.
//

import SwiftUI
import Networking

struct FoodCell: View {
    
    let item: Food
    
    var body: some View {
        HStack {
            image
            VStack(alignment: .leading) {
                Text(item.name)
                HStack {
                    HStack(spacing: 5) {
                        Text("Fats:").bold()
                        Text("\(item.nutrients.fats.formatted(.number))")
                    }
                    HStack(spacing: 5) {
                        Text("Calories:").bold()
                        Text("\(item.nutrients.calories.formatted(.number))")
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private var image: some View {
        AsyncImage(url: item.photo.thumbnail) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 40, height: 40)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 40)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    
    let url = Bundle.main.url(forResource: "nix-apple-grey", withExtension: "png")!
    
    return FoodCell(
        item: Food(
            name: "Apple",
            photo: Food.Photo(
                thumbnail: url,
                highres: nil
            ), 
            nutrients: .init(fats: 23, calories: 431)
        )
    )
}
