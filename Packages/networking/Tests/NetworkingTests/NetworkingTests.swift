import XCTest
import Dependencies

@testable import Networking

final class NetworkingTests: XCTestCase {
    
    func testURLAssembly() throws {
        let builder = try RequestBuilder(searchTerm: "Spicy Korean Beef Noodles, Regular", appId: "", appKey: "")
        let request = try builder.assembleRequest()
        XCTAssertEqual(request.url?.absoluteString, "https://trackapi.nutritionix.com/v2/search/instant/?query=Spicy%20Korean%20Beef%20Noodles,%20Regular&detailed=true")
    }
    
    func testURLAssembly_emptySearchTerm() throws {
        let expression = RequestBuilder.init(searchTerm:appId:appKey:)
        var error: RequestBuilder.Error?
        XCTAssertThrowsError(try expression("", "", ""), "Expecting empty search term to fail validation.") {
            error = $0 as? RequestBuilder.Error
        }
        let description = try XCTUnwrap(error).errorDescription
        XCTAssertEqual(description, "The search term you provided is invalid.")
    }
    
    func testFetching() async throws {
        
        let service = try withDependencies {
            
            $0.sessionClient = .init(data: { _ in
                
                let jsonString = """
                {
                    "common": [{
                        "food_name": "Spicy Korean Beef Noodles, Regular",
                        "photo": {
                            "thumb": "https://d2eawub7utcl6.cloudfront.net/images/nix-apple-grey.png",
                            "highres": null,
                            "is_user_uploaded": false
                        },
                        "full_nutrients": [
                            {
                                "value": 30,
                                "attr_id": 203
                            },
                            {
                                "value": 34,
                                "attr_id": 204
                            },
                            {
                                "value": 112,
                                "attr_id": 205
                            },
                            {
                                "value": 880,
                                "attr_id": 208
                            },
                            {
                                "value": 43,
                                "attr_id": 269
                            }
                        ]
                    }]
                }
                """
                
                let data = jsonString.data(using: .utf8) ?? Data()
                return (data, URLResponse())
            })
        } operation: {
            let builder = try RequestBuilder(searchTerm: "Spicy Korean Beef Noodles, Regular", appId: "", appKey: "")
            return NutrientsService(requestBuilder: builder)
        }
        
        let items = try await service.foodItems()
        let item = try XCTUnwrap(items.first)
        XCTAssertEqual("Spicy Korean Beef Noodles, Regular", item.food_name)
        XCTAssertEqual("https://d2eawub7utcl6.cloudfront.net/images/nix-apple-grey.png", item.photo.thumb?.absoluteString)
        XCTAssertEqual(items.count, 1)
    }
}
