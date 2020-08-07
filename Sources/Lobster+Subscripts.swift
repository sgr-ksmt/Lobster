//
//  Lobster+Subscripting.swift
//  Lobster
//
//  Created by sgr-ksmt on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

extension Lobster {
    /// Get value with given config key.
    ///
    /// You can use this subscripting if a type of config key is `ConfigKey<T?>`. This is, `ConfigKey.ValueType` must be Optional type such as `String?`.
    ///
    /// Lobster will return the value for key if RemoteConfig has the value at first.
    /// If not so, Lobster will try to retrieve value from DefaultStore automatically.
    /// If Neigher RemoteConfig nor DefaultStore have the value, Lobster will return `nil`.
    public subscript<T: ConfigSerializable>(key: ConfigKey<T?>) -> T.T? {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig) {
                return value
            } else if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore) {
                return defaultValue
            } else {
                return nil
            }
        }
    }

    /// Get value from remote-config -> default
    public subscript<T: ConfigSerializable>(key: ConfigKey<T>) -> T.T where T.T == T {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig) {
                return value
            } else if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore) {
                return defaultValue
            } else {
                fatalError("Failed to get value. Please set default value or remote config value before.")
            }
        }
    }

    /// Get value safely from remote-config -> default
    public subscript<T: ConfigSerializable>(safe key: ConfigKey<T>) -> T.T? {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig) {
                return value
            } else if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore) {
                return defaultValue
            } else {
                return nil
            }
        }
    }

    /// Get value from config
    public subscript<T: ConfigSerializable>(config key: ConfigKey<T?>) -> T.T? {
        get {
            return T._config.get(key: key._key, remoteConfig: remoteConfig)
        }
    }

    /// Get value from config
    public subscript<T: ConfigSerializable>(config key: ConfigKey<T>) -> T.T where T.T == T {
        get {
            guard let value = T._config.get(key: key._key, remoteConfig: remoteConfig) else {
                fatalError("Failed to get value from default. Please set default value before or use `safeConfig` subscript.")
            }
            return value
        }
    }

    /// Get value safely from config
    public subscript<T: ConfigSerializable>(safeConfig key: ConfigKey<T>) -> T.T? {
        get {
            return T._config.get(key: key._key, remoteConfig: remoteConfig)
        }
    }

    /// Get value from default / Set value to default
    public subscript<T: ConfigSerializable>(default key: ConfigKey<T?>) -> T.T? {
        get {
            if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore) {
                return defaultValue
            } else {
                return nil
            }
        }
        set {
            T._config.save(key: key._key, value: newValue, defaultsStore: defaultsStore)
            updateDefaults()
        }
    }


    /// Get value from default / Set value to default
    public subscript<T: ConfigSerializable>(default key: ConfigKey<T>) -> T.T where T.T == T {
        get {
            guard let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore) else {
                fatalError("Failed to get value from default. Please set default value before or use `safeDefault` subscript.")
            }
            return defaultValue
        }
        set {
            T._config.save(key: key._key, value: newValue, defaultsStore: defaultsStore)
            updateDefaults()
        }
    }

    /// Get value safely from default
    public subscript<T: ConfigSerializable>(safeDefault key: ConfigKey<T>) -> T.T? {
        get {
            return T._config.get(key: key._key, defaultsStore: defaultsStore)
        }
    }
}
