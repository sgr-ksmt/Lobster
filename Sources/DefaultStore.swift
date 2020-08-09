//
//  DefaultStore.swift
//  Lobster
//
//  Created by sgr-ksmt on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

/// DefaultStore
///
/// DefaultStore is a value store class to sync default values with RemoteConfig.
///
/// You can set default value through Lobster's subscripting.
///
/// Example for setting default value to DefaultStore and syncing withRemoteConfig.
///
///     extension ConfigKeys {
///         static let title = ConfigKey<String>("title")
///     }
///
///     // use subscripting
///     Lobster.shared[default: .title] = "foo bar"
///
///     // use dictionary
///     Lobster.shared.setDefaults([ConfigKeys.title._key: "foo bar"])
///
/// - note: Basically, You don't have to use it directly.
public final class DefaultsStore {
    /// A typealias of default values.
    public typealias Defaults = [String: Any]

    internal init() {}
    /// A dictionary to store default values.
    var _defaults: Defaults = [:]

    public subscript (key: String) -> Any? {
        get {
            return _defaults[key]
        }
        set {
            _defaults[key] = newValue
        }
    }

    /// Returns default values
    ///
    /// default values are converted from `[String: Any]` to `[String: NSObject]`  before returning.
    public var defaults: [String: NSObject] {
        _defaults.reduce(into: [:]) { $0[$1.key] = $1.value as? NSObject }
    }

    /// Set default values
    ///
    /// Basically, DefaultStore try to merge new default values into existing default values.
    ///
    /// But If you want to overwrite default values, please pass `merge: true` parameter.
    ///
    /// - Parameters:
    ///   - defaults: default values
    ///   - merge: A flag for deciding whether merge default values into existing values or not.
    public func set(defaults: Defaults, merge: Bool = true) {
        if merge {
            _defaults = _defaults.merging(defaults) { f, l in l }
        } else {
            _defaults = defaults
        }
    }

    /// Clear existing default values.
    public func clear() {
        _defaults = [:]
    }
}
