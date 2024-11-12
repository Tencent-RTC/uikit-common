//
//  VoiceRoomState.swift
//  SeatGridView
//
//  Created by abyyxwang on 2024/11/7.
//

import Combine
import Foundation

public protocol PropetrySelector {
    /// The input for the `Selector`.
    associatedtype State
    /// The output of the `Selector`,
    associatedtype Value
    /**
     A pure function which takes a `State` and returns a `Value` from it.
     
     - Parameter state: The `State` to map
     - Returns: The `Value` mapped from the `State`
     */
    func map(_ state: State) -> Value
}

public class StateSelector<State, Value>: PropetrySelector {
    private let _projector: (State) -> Value
    private(set) var result: (stateHash: UUID, value: Value)?
    
    public convenience init(keyPath: KeyPath<State, Value>) {
        self.init(projector: { $0[keyPath: keyPath] })
    }
    
    public init(projector: @escaping (State) -> Value) {
        _projector = projector
    }
    
    public func map(_ state: State) -> Value {
        _projector(state)
    }
}

/// Memoization support, where the `Selector` remembers the last result to speed up mapping.
public extension StateSelector {
    /**
     Sets the value and the corresponding `stateHash`.
     
     - Parameter value: The value to save
     - Parameter stateHash: The hash of the state the value was selected from
     */
    func setResult(value: Value, forStateHash stateHash: UUID) {
        result = (stateHash: stateHash, value: value)
    }
    
    /**
     Selects the `Value` from the `State` based on the subclass's `map` function and saves the result.
     
     - If a value is already saved and the saved state hash matches the passed, the saved value is returned.
     - If a value is already saved but the saved state hash doesn't match the passed
     a new value is selected and saved along with the passed state hash
     
     - Parameter state: The `State` to select from
     - Parameter stateHash: The hash of the `State` to select from
     - Returns: The `Value` mapped with the `projector`
     */
    func map(_ state: State, stateHash: UUID) -> Value {
        if let result = result, result.stateHash == stateHash {
            return result.value
        }
        let value = map(state)
        setResult(value: value, forStateHash: stateHash)
        return value
    }
}

public class ObservableState<State>: ObservableObject {
    
    public typealias StateUpdateClosure = (inout State) -> Void
    
    @Published public private(set) var state: State
    
    internal private(set) var stateHash = UUID()
    
    public init(initialState: State) {
        state = initialState
    }
    
    public func update(isPublished: Bool = true, reduce: StateUpdateClosure) {
        if isPublished {
            let oldState = state
            var newState = oldState
            reduce(&newState)
            stateHash = UUID()
            state = newState
        } else {
            reduce(&state)
        }
        
    }
    
    public func subscribe<Value: Equatable>(_ selector: StateSelector<State, Value>) -> AnyPublisher<Value, Never> {
        $state.map { selector.map($0, stateHash: self.stateHash) }.removeDuplicates().eraseToAnyPublisher()
    }
    
    public func subscribe<Value>(_ selector: StateSelector<State, Value>) -> AnyPublisher<Value, Never> {
        $state.map { selector.map($0, stateHash: self.stateHash) }.eraseToAnyPublisher()
    }
    
    public func subscribe() -> AnyPublisher<State, Never> {
        $state.eraseToAnyPublisher()
    }
}

