//
//  DefaultStore.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

public final class DefaultsStore {
    init() {}
    var defaults: Lobster.Defaults = [:]

    public func set(forKey key: String, value: Any?) {
        defaults[key] = value
    }

    public func get(forKey key: String) -> Any? {
        return defaults[key]
    }

    func asRemoteConfigDefaults() -> [String: NSObject] {
        return defaults.reduce(into: [:]) { $0[$1.key] = $1.value as? NSObject }
    }

    func set(defaults: Lobster.Defaults) {
        self.defaults = self.defaults.merging(defaults) { f, l in l }
    }

    func clear() {
        defaults = [:]
    }
}
