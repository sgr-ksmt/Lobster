//
//  Lobster+Subscripting.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

public extension Lobster {

    subscript<T: ConfigSerializable>(key: ConfigKey<T?>) -> T.T? {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig) {
                return value
            } else if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore) {
                return defaultValue
            } else {
                return nil
            }
        }
        set {
            T._config.save(key: key._key, value: newValue, defaultsStore: defaultsStore)
        }
    }

    subscript<T: ConfigSerializable>(key: ConfigKey<T>) -> T.T where T.T == T {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig) {
                return value
            } else if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore) {
                return defaultValue
            } else {
                fatalError("")
            }
        }
        set {
            T._config.save(key: key._key, value: newValue, defaultsStore: defaultsStore)
        }
    }
}
