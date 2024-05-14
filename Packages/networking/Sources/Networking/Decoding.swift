//
//  Created by Robert Nash on 13/05/2024.
//

import Foundation

struct Root: Decodable {
    let common: [FoodItem]
}

public struct FoodItem: Decodable {
    public let food_name: String
    public let photo: Photo
    public let full_nutrients: [Nutrient]
}

public struct Photo: Decodable {
    
    public let thumb: URL?
    public let highres: URL?
    
    init(
        thumb: URL?,
        highres: URL?
    ) {
        self.thumb = thumb
        self.highres = highres
    }
    
    enum CodingKeys: CodingKey {
        case thumb
        case highres
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let thumb = try container.decode(String.self, forKey: .thumb)
        let highres = try container.decodeIfPresent(URL.self, forKey: .highres)
        self.init(
            thumb: URL(string: thumb),
            highres: highres
        )
    }
}

public struct Nutrient: Decodable {
    public let value: Double
    public let attr_id: Int
}
