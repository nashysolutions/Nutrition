//
//  Created by Robert Nash on 13/05/2024.
//

import Foundation
import Dependencies

public extension DependencyValues {
    
    var sessionClient: URLSessionClient {
        get { self[URLSessionClientDependencyKey.self] }
        set { self[URLSessionClientDependencyKey.self] = newValue }
    }
}
