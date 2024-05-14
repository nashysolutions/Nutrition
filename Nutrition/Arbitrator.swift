//
//  Created by Robert Nash on 13/05/2024.
//

import Foundation
import Combine
import Dependencies

/// `Arbitrator` is a class that acts as a mediator for value changes. It leverages a `PassthroughSubject` to monitor
/// value changes and invokes a ruling closure when a distinct change is detected.
/// The class uses a debounce mechanism to ensure that rapid fluctuations in the value do not trigger unnecessary actions.
public final class Arbitrator<Value: Equatable> {
    
    /// The subject that observes the changes in value.
    private var subject: PassthroughSubject<Value, Never>
    
    /// The subscription to the subject.
    private var subscription: AnyCancellable?
    
    /// A closure that defines the action to be taken when a distinct change in value is detected.
    /// This ruling is executed after the debounce interval, only when the new value differs from the previous value.
    public var ruling: (Value) -> Void = { _ in }
    
    /// Initializes the `Arbitrator` with a specific debounce interval.
    /// - Parameter debounceInterval: The time interval (in seconds) to wait before processing a new value.
    public init(debounceInterval: TimeInterval) {
        subject = PassthroughSubject()
        
        @Dependency(\.mainRunLoop) var mainRunLoop
        
        subscription = subject
            .debounce(for: .seconds(debounceInterval), scheduler: mainRunLoop)
            .sink { [weak self] newValue in
                guard let self = self else {
                    return
                }
                self.ruling(newValue)
            }
    }
    
    /// Sends a new value to the subject, potentially triggering the ruling closure after the debounce interval.
    /// - Parameter newValue: The new value to be processed.
    public func disclose(_ newValue: Value) {
        subject.send(newValue)
    }
}
