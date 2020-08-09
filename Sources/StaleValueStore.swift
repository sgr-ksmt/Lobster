//
//  StaleValueStore.swift
//  Lobster
//
//  Created by sgr-ksmt on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

/// Represents a value store that can store `isStaled`.
public protocol StaleValueStore {
    /// Returns/Set  a bool value whether RemoteConfig's values are staled or not.
    var isStaled: Bool { get set }
}

/// Extension for `StaleValueStore`
public extension StaleValueStore {
    /// A key to store `isStaled` value.
    static var key: String { "StaleValueStore.isStaled" }
}
