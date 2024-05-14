//
//  DependencyValues.swift
//  Nutrition
//
//  Created by Robert Nash on 13/05/2024.
//

import Foundation
import Networking
import Dependencies

/// For `@Dependency(\.sessionClient) var sessionClient`
extension URLSessionClientDependencyKey: DependencyKey {
    
    /// See `Dependencies` library docs regarding the use of `.urlSession` directly
    ///
    /// "While it is possible to use this dependency value from more complex dependencies, like API
    /// clients, we generally advise against _designing_ a dependency around a URL session. Mocking
    /// a URL session's responses is a complex process that requires a lot of work that can be
    /// avoided."
    ///
    @Dependency(\.urlSession) static var urlSession
        
    public static var liveValue = URLSessionClient {
        try await urlSession.data(for: $0)
    }
}
