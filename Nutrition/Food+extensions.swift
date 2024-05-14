//
//  Food+extensions.swift
//  Nutrition
//
//  Created by Robert Nash on 13/05/2024.
//

import Foundation
import Networking

extension Food {
    
    init?(item: FoodItem) {
        
        guard let photo = Photo(photo: item.photo) else {
            return nil
        }
            
        self.init(
            name: item.food_name,
            photo: photo,
            nutrients: .init(
                full: item.full_nutrients
            )
        )
    }
}

extension Food.Photo {
    
    init?(photo: Networking.Photo) {
        guard let thumbnail = photo.thumb else {
            return nil
        }
        let highres = photo.highres
        self.init(thumbnail: thumbnail, highres: highres)
    }
}

extension Food.Nutrients {
    
    init(full: [Networking.Nutrient]) {
        
        var f: Double?
        var c: Double?
        
        for nutrient in full {
            switch nutrient.attr_id {
            case 204: // ID for fats
                f = nutrient.value
            case 208: // ID for calories
                c = nutrient.value
            default:
                break
            }
        }
        
        let fats = f ?? 0
        let calories = c ?? 0
        
        self.init(fats: fats, calories: calories)
    }
}
