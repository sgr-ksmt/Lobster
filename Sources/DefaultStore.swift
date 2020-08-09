//
//  DefaultStore.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

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
