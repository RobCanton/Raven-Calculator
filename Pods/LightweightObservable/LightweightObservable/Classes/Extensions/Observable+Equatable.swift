//
//  Observable+Equatable.swift
//  LightweightObservable
//
//  Created by Felix Mau on 01/05/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

/// Additional helper methods for an observable that that underlying type conforms to `Equatable`.
public extension Observable where T: Equatable {
    // MARK: - Types

    /// The type for the filter closure.
    typealias Filter = (Value, OldValue) -> Bool

    // MARK: - Public methods

    /// Informs the given observer on changes to our `value`, only if the given filter matches.
    ///
    /// - Parameters:
    ///   - filter: The filer-closure, that must return `true` in order for the observer to be notified.
    ///   - observer: The observer-closure that is notified on changes.
    func subscribe(filter: @escaping Filter, observer: @escaping Observer) -> Disposable {
        subscribe { newValue, oldValue in
            guard filter(newValue, oldValue) else { return }

            observer(newValue, oldValue)
        }
    }

    /// Informs the given observer on **distinct** changes to our `value`.
    ///
    /// - Parameter observer: The observer-closure that is notified on changes.
    func subscribeDistinct(_ observer: @escaping Observer) -> Disposable {
        subscribe(filter: { $0 != $1 },
                  observer: observer)
    }
}
