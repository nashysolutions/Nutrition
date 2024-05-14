//
//  Created by Robert Nash on 13/05/2024.
//

import Foundation

public struct Food: Identifiable, Hashable {
    
    public var id: String { name }
    public let name: String
    public let photo: Photo
    public let nutrients: Nutrients
    
    init(name: String, photo: Photo, nutrients: Nutrients) {
        self.name = name
        self.photo = photo
        self.nutrients = nutrients
    }
    
    public static func ==(lhs: Food, rhs: Food) -> Bool {
        lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

public extension Food {
    
    struct Photo {
        
        public let thumbnail: URL
        public let highres: URL?
        
        init(thumbnail: URL, highres: URL?) {
            self.thumbnail = thumbnail
            self.highres = highres
        }
    }
}

public extension Food {
    
    struct Nutrients {
        
        public let fats: Double
        public let calories: Double
        
        public init(fats: Double, calories: Double) {
            self.fats = fats.rounded(.towardZero)
            self.calories = calories.rounded(.towardZero)
        }
    }
}
