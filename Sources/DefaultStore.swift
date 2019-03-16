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

    subscript (key: String) -> Any? {
        get {
            return defaults[key]
        }
        set {
            defaults[key] = newValue
        }
    }

    func asRemoteConfigDefaults() -> [String: NSObject] {
        return defaults.reduce(into: [:]) { $0[$1.key] = $1.value as? NSObject }
    }

    func set(defaults: Defaults) {
        self.defaults = self.defaults.merging(defaults) { f, l in l }
    }

    func clear() {
        defaults = [:]
    }
}
