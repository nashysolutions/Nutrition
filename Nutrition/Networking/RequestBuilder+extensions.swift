//
//  RequestBuilder+extensions.swift
//  Nutrition
//
//  Created by Robert Nash on 13/05/2024.
//

import Foundation
import Networking

private let appId = ProcessInfo.processInfo.environment["APP_ID"] ?? "default_app_id"
private let appKey = ProcessInfo.processInfo.environment["APP_KEY"] ?? "default_app_id"

extension RequestBuilder {
    
    init(searchTerm: String) throws {
        try self.init(
            searchTerm: searchTerm,
            appId: appId,
            appKey: appKey
        )
    }
}

extension NutrientsService {
    
    init(searchTerm: String) throws {
        let builder = try RequestBuilder(searchTerm: searchTerm)
        self.init(requestBuilder: builder)
    }
}
