//
//  Created by Robert Nash on 13/05/2024.
//

import Foundation
import Dependencies

/// `NutrientsService` provides the functionality to retrieve food item information from an API.
public struct NutrientsService {
    
    /// A dependency-injected session client used for making network requests.
    @Dependency(\.sessionClient) private var sessionClient
    
    /// The `RequestBuilder` responsible for creating the URL requests.
    let requestBuilder: RequestBuilder
    
    /// The JSON decoder used to decode the response data into model objects.
    let decoder = JSONDecoder()
    
    /// Initialises a new instance of `NutrientsService` with the specified `RequestBuilder`.
    /// - Parameter requestBuilder: The `RequestBuilder` instance to use for creating URL requests.
    public init(requestBuilder: RequestBuilder) {
        self.requestBuilder = requestBuilder
    }
    
    /// Fetches a list of food items from a remote data source and ensures that the returned list
    /// contains unique food items based on their names, maintaining the order of their appearance.
    ///
    /// - Returns: An array of unique `Food` objects in the order they were received.
    /// - Throws: An error if the request fails or the data cannot be decoded.
    public func foodItems() async throws -> [FoodItem] {
        let request = try requestBuilder.assembleRequest()
        let (data, _) = try await sessionClient.data(request)
        let root = try decoder.decode(Root.self, from: data)
        var uniqueFoods = [FoodItem]()
        var addedNames = Set<String>()

        for item in root.common {
            if !addedNames.contains(item.food_name) {
                uniqueFoods.append(item)
                addedNames.insert(item.food_name)
            }
        }
        
        return uniqueFoods
    }
    
    /*
     Just noticed this in the docs, but I've spent too much time on this now...
     
     How do I filter out duplicate common foods from the /search/instant endpoint?
     To provide the best experience to the end user, it is recommended to filter common food results on "tag_id". Common foods with the same tag_id have identical nutrition (for example, "Blackberry" and "Blackberries"). For best results, filter the results to show only one food per tag_id. Generally, the first one will be the most relevant based on the user search query.
     */
}
