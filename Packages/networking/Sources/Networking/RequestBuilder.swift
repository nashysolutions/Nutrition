import Foundation

/// `RequestBuilder` constructs a URL request to fetch search results from the Nutritionix API.
public struct RequestBuilder {
    
    /// The search term used in the API request.
    let searchTerm: String
    
    /// The application ID for accessing the Nutritionix API.
    let appId: String
    
    /// The application key for accessing the Nutritionix API.
    let appKey: String
    
    /// Initialises a new `RequestBuilder` with the provided search term, application ID, and application key.
    /// Throws an error if the validation of the search term fails.
    /// - Parameters:
    ///   - searchTerm: The term to be searched in the Nutritionix API.
    ///   - appId: Your application's ID for the API.
    ///   - appKey: Your application's key for the API.
    public init(searchTerm: String, appId: String, appKey: String) throws {
        let validation = Validation(searchTerm: searchTerm)
        try validation.validate()
        self.searchTerm = searchTerm
        self.appId = appId
        self.appKey = appKey
    }
    
    /// Assembles and returns a `URLRequest` configured with the necessary headers and parameters for the API call.
    /// Throws an error if the URL cannot be constructed.
    /// - Returns: A `URLRequest` object ready for execution.
    public func assembleRequest() throws -> URLRequest {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "trackapi.nutritionix.com"
        components.path = "/v2/search/instant/"
        components.queryItems = [
            URLQueryItem(name: "query", value: searchTerm),
            URLQueryItem(name: "detailed", value: "true")
        ]
        
        guard let url = components.url else {
            throw Error.invalidSearchTerm
        }
        
        var request = URLRequest(url: url)
        request.setValue(appId, forHTTPHeaderField: "x-app-id")
        request.setValue(appKey, forHTTPHeaderField: "x-app-key")
        request.setValue("0", forHTTPHeaderField: "x-remote-user-id")  // Set to "0" if in development mode
        return request
    }
}

public extension RequestBuilder {
    
    /// Defines the error types that `RequestBuilder` can throw.
    enum Error: LocalizedError {
        
        /// Indicates that the search term provided is invalid.
        case invalidSearchTerm
        
        public var errorDescription: String? {
            switch self {
            case .invalidSearchTerm:
                return "The search term you provided is invalid."
            }
        }
    }
}

extension RequestBuilder {
    
    /// Handles the validation of the search term.
    struct Validation {
        
        /// The search term to validate.
        let searchTerm: String
        
        /// Validates the search term to ensure it is not empty.
        /// Throws an error if the validation fails.
        func validate() throws {
            if searchTerm.isEmpty {
                throw Error.invalidSearchTerm
            }
        }
    }
}

