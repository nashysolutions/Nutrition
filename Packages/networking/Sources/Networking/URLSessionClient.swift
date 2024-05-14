//
//  Created by Robert Nash on 13/05/2024.
//

import Foundation
import Dependencies

public struct URLSessionClient {
    
    public var data: @Sendable (URLRequest) async throws -> (Data, URLResponse)
    
    public init(data: @Sendable @escaping (URLRequest) async throws -> (Data, URLResponse)) {
        self.data = data
    }
}

public struct URLSessionClientDependencyKey: TestDependencyKey {
    
    public static var testValue = URLSessionClient { _ in
        return (Data(), URLResponse())
    }
}
