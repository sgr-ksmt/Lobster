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
    public typealias Defaults = [String: Any]

    init() {}
    var defaults: Defaults = [:]

    public subscript (key: String) -> Any? {
        get {
            return defaults[key]
        }
        set {
            defaults[key] = newValue
        }
    }

    public func asRemoteConfigDefaults() -> [String: NSObject] {
        return defaults.reduce(into: [:]) { $0[$1.key] = $1.value as? NSObject }
    }

    public func set(defaults: Defaults) {
        self.defaults = self.defaults.merging(defaults) { f, l in l }
    }

    public func clear() {
        defaults = [:]
    }
}
