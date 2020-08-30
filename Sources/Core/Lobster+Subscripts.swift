//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import Foundation

/// Extensions for Lobster
///
/// Lobster provides convenient subscriptings.
/// You can get value from Lobster with a config key. You also can set value to Lobster with a config key.
public extension Lobster {
    /// Get value with given config key.
    ///
    /// You can use this subscripting if a type of config key is `ConfigKey<T?>`. This is, `ConfigKey.ValueType` must be Optional type such as `String?`.
    /// Also, `T` is needed to be conformed protocol `ConfigSerializable`
    ///
    /// Lobster will return the value for key if RemoteConfig has the value at first.
    /// If not so, Lobster will try to retrieve value from DefaultsStore automatically.
    /// If Neigher RemoteConfig nor DefaultsStore have the value, Lobster will return `nil`.
    subscript<T: ConfigSerializable>(key: ConfigKey<T?>) -> T.Value? {
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
    subscript<T: ConfigSerializable>(key: ConfigKey<T>) -> T.Value {
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
    subscript<T: ConfigSerializable>(safe key: ConfigKey<T>) -> T.Value? {
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
    subscript<T: ConfigSerializable>(config key: ConfigKey<T?>) -> T.Value? {
        get { T._config.get(key: key._key, remoteConfig: remoteConfig) }
    }

    /// Get value from config
    subscript<T: ConfigSerializable>(config key: ConfigKey<T>) -> T.Value {
        get {
            guard let value = T._config.get(key: key._key, remoteConfig: remoteConfig) else {
                fatalError("Failed to get value from default. Please set default value before or use `safeConfig` subscript.")
            }
            return value
        }
    }

    /// Get value safely from config
    subscript<T: ConfigSerializable>(safeConfig key: ConfigKey<T>) -> T.Value? {
        get { T._config.get(key: key._key, remoteConfig: remoteConfig) }
    }

    /// Get value from default / Set value to default
    subscript<T: ConfigSerializable>(default key: ConfigKey<T?>) -> T.Value? {
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
    ///
    /// If DefaultsStore doesn't have a value matched a config key, Lobster will throw a fatal error.
    /// If you can get the value safely, please use `safeDefault:` subscripting instead.
    subscript<T: ConfigSerializable>(default key: ConfigKey<T>) -> T.Value {
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
    ///
    /// If DefaultsStore doesn't have a value matched a config key, Lobster will return `nil`.
    subscript<T: ConfigSerializable>(safeDefault key: ConfigKey<T>) -> T.Value? {
        get { T._config.get(key: key._key, defaultsStore: defaultsStore) }
    }
}

public extension Lobster {
    subscript<T: ConfigSerializable>(key: DecodableConfigKey<T?>) -> T.Value? {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) {
                return value
            } else {
                return nil
            }
        }
    }

    /// Get value from remote-config -> default
    subscript<T: ConfigSerializable>(key: DecodableConfigKey<T>) -> T.Value {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) {
                return value
            } else {
                fatalError("Failed to get value. Please set default value or remote config value before.")
            }
        }
    }

    /// Get value safely from remote-config -> default
    subscript<T: ConfigSerializable>(safe key: DecodableConfigKey<T>) -> T.Value? {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) {
                return value
            } else {
                return nil
            }
        }
    }

    /// Get value from config
    subscript<T: ConfigSerializable>(config key: DecodableConfigKey<T?>) -> T.Value? {
        get { T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) }
    }

    /// Get value from config
    subscript<T: ConfigSerializable>(config key: DecodableConfigKey<T>) -> T.Value {
        get {
            guard let value = T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) else {
                fatalError("Failed to get value from default. Please set default value before or use `safeConfig` subscript.")
            }
            return value
        }
    }

    /// Get value safely from config
    subscript<T: ConfigSerializable>(safeConfig key: DecodableConfigKey<T>) -> T.Value? {
        get { T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) }
    }
}

public extension Lobster {
    subscript<T: ConfigSerializable>(key: CodableConfigKey<T?>) -> T.Value? {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) {
                return value
            } else if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore, decoder: key.decoder) {
                return defaultValue
            } else {
                return nil
            }
        }
    }

    /// Get value from remote-config -> default
    subscript<T: ConfigSerializable>(key: CodableConfigKey<T>) -> T.Value {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) {
                return value
            } else if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore, decoder: key.decoder) {
                return defaultValue
            } else {
                fatalError("Failed to get value. Please set default value or remote config value before.")
            }
        }
    }

    /// Get value safely from remote-config -> default
    subscript<T: ConfigSerializable>(safe key: CodableConfigKey<T>) -> T.Value? {
        get {
            if let value = T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) {
                return value
            } else if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore, decoder: key.decoder) {
                return defaultValue
            } else {
                return nil
            }
        }
    }

    /// Get value from config
    subscript<T: ConfigSerializable>(config key: CodableConfigKey<T?>) -> T.Value? {
        get { T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) }
    }

    /// Get value from config
    subscript<T: ConfigSerializable>(config key: CodableConfigKey<T>) -> T.Value {
        get {
            guard let value = T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) else {
                fatalError("Failed to get value from default. Please set default value before or use `safeConfig` subscript.")
            }
            return value
        }
    }

    /// Get value safely from config
    subscript<T: ConfigSerializable>(safeConfig key: CodableConfigKey<T>) -> T.Value? {
        get { T._config.get(key: key._key, remoteConfig: remoteConfig, decoder: key.decoder) }
    }

    /// Get value from default / Set value to default
    subscript<T: ConfigSerializable>(default key: CodableConfigKey<T?>) -> T.Value? {
        get {
            if let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore, decoder: key.decoder) {
                return defaultValue
            } else {
                return nil
            }
        }
        set {
            T._config.save(key: key._key, value: newValue, defaultsStore: defaultsStore,encoder: key.encoder)
            updateDefaults()
        }
    }


    /// Get value from default / Set value to default
    ///
    /// If DefaultsStore doesn't have a value matched a config key, Lobster will throw a fatal error.
    /// If you can get the value safely, please use `safeDefault:` subscripting instead.
    subscript<T: ConfigSerializable>(default key: CodableConfigKey<T>) -> T.Value {
        get {
            guard let defaultValue = T._config.get(key: key._key, defaultsStore: defaultsStore, decoder: key.decoder) else {
                fatalError("Failed to get value from default. Please set default value before or use `safeDefault` subscript.")
            }
            return defaultValue
        }
        set {
            T._config.save(key: key._key, value: newValue, defaultsStore: defaultsStore, encoder: key.encoder)
            updateDefaults()
        }
    }

    /// Get value safely from default
    ///
    /// If DefaultsStore doesn't have a value matched a config key, Lobster will return `nil`.
    subscript<T: ConfigSerializable>(safeDefault key: CodableConfigKey<T>) -> T.Value? {
        get { T._config.get(key: key._key, defaultsStore: defaultsStore, decoder: key.decoder) }
    }

}

public extension Lobster {
    subscript<T: ConfigSerializable>(key: AnyConfigKey<T?>) -> T.Value? {
        get { key.asConfigKey().flatMap { self[$0] } }
    }

    subscript<T: ConfigSerializable & Decodable>(key: AnyConfigKey<T?>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                return key.asConfigKey().flatMap { self[$0] }
            case .decodable:
                return key.asDecodableConfigKey().flatMap { self[$0] }
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable & Codable>(key: AnyConfigKey<T?>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                return key.asConfigKey().flatMap { self[$0] }
            case .codable:
                return key.asCodableConfigKey().flatMap { self[$0] }
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable>(key: AnyConfigKey<T>) -> T.Value {
        get {
            guard let value = key.asConfigKey().flatMap({ self[$0] }) else {
                fatalError("Failed to get value. Please set default value or remote config value before.")
            }
            return value
        }
    }

    subscript<T: ConfigSerializable & Decodable>(key: AnyConfigKey<T>) -> T.Value {
        get {
            switch key.type {
            case .normal:
                guard let value = key.asConfigKey().flatMap({ self[$0] }) else {
                    fatalError("Failed to get value. Please set default value or remote config value before.")
                }
                return value

            case .decodable:
                guard let value = key.asDecodableConfigKey().flatMap({ self[$0] }) else {
                    fatalError("Failed to get value. Please set default value or remote config value before.")
                }
                return value

            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable & Codable>(key: AnyConfigKey<T>) -> T.Value {
        get {
            switch key.type {
            case .normal:
                guard let value = key.asConfigKey().flatMap({ self[$0] }) else {
                    fatalError("Failed to get value. Please set default value or remote config value before.")
                }
                return value

            case .codable:
                guard let value = key.asCodableConfigKey().flatMap({ self[$0] }) else {
                    fatalError("Failed to get value. Please set default value or remote config value before.")
                }
                return value

            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable>(safe key: AnyConfigKey<T>) -> T.Value? {
        get { key.asConfigKey().flatMap { self[safe: $0] } }
    }

    subscript<T: ConfigSerializable & Decodable>(safe key: AnyConfigKey<T>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                return key.asConfigKey().flatMap { self[safe: $0] }
            case .decodable:
                return key.asDecodableConfigKey().flatMap { self[safe: $0] }
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable & Codable>(safe key: AnyConfigKey<T>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                return key.asConfigKey().flatMap { self[safe: $0] }
            case .codable:
                return key.asCodableConfigKey().flatMap { self[safe: $0] }
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable>(config key: AnyConfigKey<T?>) -> T.Value? {
        get { key.asConfigKey().flatMap { self[config: $0] } }
    }

    subscript<T: ConfigSerializable & Decodable>(config key: AnyConfigKey<T?>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                return key.asConfigKey().flatMap { self[config: $0] }
            case .decodable:
                return key.asDecodableConfigKey().flatMap { self[config: $0] }
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable & Codable>(config key: AnyConfigKey<T?>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                return key.asConfigKey().flatMap { self[config: $0] }
            case .codable:
                return key.asCodableConfigKey().flatMap { self[config: $0] }
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable>(config key: AnyConfigKey<T>) -> T.Value {
        get {
            guard let value = key.asConfigKey().flatMap({ self[config: $0]}) else {
                fatalError("Failed to get value from default. Please set default value before or use `safeConfig` subscript.")
            }
            return value
        }
    }

    subscript<T: ConfigSerializable & Decodable>(config key: AnyConfigKey<T>) -> T.Value {
        get {
            switch key.type {
            case .normal:
                guard let value = key.asConfigKey().flatMap({ self[config: $0]}) else {
                    fatalError("Failed to get value from default. Please set default value before or use `safeConfig` subscript.")
                }
                return value
            case .decodable:
                guard let value = key.asDecodableConfigKey().flatMap({ self[config: $0]}) else {
                    fatalError("Failed to get value from default. Please set default value before or use `safeConfig` subscript.")
                }
                return value
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable & Codable>(config key: AnyConfigKey<T>) -> T.Value {
        get {
            switch key.type {
            case .normal:
                guard let value = key.asConfigKey().flatMap({ self[config: $0]}) else {
                    fatalError("Failed to get value from default. Please set default value before or use `safeConfig` subscript.")
                }
                return value
            case .codable:
                guard let value = key.asCodableConfigKey().flatMap({ self[config: $0]}) else {
                    fatalError("Failed to get value from default. Please set default value before or use `safeConfig` subscript.")
                }
                return value
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable>(safeConfig key: AnyConfigKey<T>) -> T.Value? {
        get { key.asConfigKey().flatMap { self[safeConfig: $0] } }
    }

    subscript<T: ConfigSerializable & Decodable>(safeConfig key: AnyConfigKey<T>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                 return key.asConfigKey().flatMap { self[safeConfig: $0] }
            case .decodable:
                return key.asDecodableConfigKey().flatMap { self[safeConfig: $0] }
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable & Codable>(safeConfig key: AnyConfigKey<T>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                return key.asConfigKey().flatMap { self[safeConfig: $0] }
            case .codable:
                return key.asCodableConfigKey().flatMap { self[safeConfig: $0] }
            default:
                fatalError("invalid key type")
            }
        }
    }


    subscript<T: ConfigSerializable>(default key: AnyConfigKey<T?>) -> T.Value? {
        get { key.asConfigKey().flatMap { self[default: $0] } }
        set {
            if let configKey: ConfigKey<T?> = key.asConfigKey()  {
                self[default: configKey] = newValue
            }
        }
    }

    subscript<T: ConfigSerializable & Codable>(default key: AnyConfigKey<T?>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                return key.asConfigKey().flatMap { self[default: $0] }
            case .codable:
                return key.asCodableConfigKey().flatMap { self[default: $0] }
            default:
                fatalError("invalid key type")
            }
        }
        set {
            switch key.type {
            case .normal:
                if let configKey: ConfigKey<T?> = key.asConfigKey()  {
                    self[default: configKey] = newValue
                }
            case .codable:
                if let configKey: CodableConfigKey<T?> = key.asCodableConfigKey() {
                    self[default: configKey] = newValue
                }
            default:
                fatalError("invalid key type")
            }
        }
    }


    subscript<T: ConfigSerializable>(default key: AnyConfigKey<T>) -> T.Value {
        get {
            guard let value = key.asConfigKey().flatMap({ self[default: $0] }) else {
                fatalError("Failed to get value from default. Please set default value before or use `safeDefault` subscript.")
            }
            return value
        }
        set {
            if let configKey: ConfigKey<T> = key.asConfigKey()  {
                self[default: configKey] = newValue
            }
        }
    }

    subscript<T: ConfigSerializable & Codable>(default key: AnyConfigKey<T>) -> T.Value {
        get {
            switch key.type {
            case .normal:
                guard let value = key.asConfigKey().flatMap({ self[default: $0] }) else {
                    fatalError("Failed to get value from default. Please set default value before or use `safeDefault` subscript.")
                }
                return value
            case .codable:
                guard let value = key.asCodableConfigKey().flatMap({ self[default: $0] }) else {
                    fatalError("Failed to get value from default. Please set default value before or use `safeDefault` subscript.")
                }
                return value
            default:
                fatalError("invalid key type")
            }
        }
        set {
            switch key.type {
            case .normal:
                if let configKey: ConfigKey<T> = key.asConfigKey()  {
                    self[default: configKey] = newValue
                }
            case .codable:
                if let configKey: CodableConfigKey<T> = key.asCodableConfigKey()  {
                    self[default: configKey] = newValue
                }
            default:
                fatalError("invalid key type")
            }
        }
    }

    subscript<T: ConfigSerializable>(safeDefault key: AnyConfigKey<T>) -> T.Value? {
        get { key.asConfigKey().flatMap { self[safeDefault: $0] } }
    }

    subscript<T: ConfigSerializable & Codable>(safeDefault key: AnyConfigKey<T>) -> T.Value? {
        get {
            switch key.type {
            case .normal:
                return key.asConfigKey().flatMap { self[safeDefault: $0] }
            case .codable:
                return  key.asCodableConfigKey().flatMap { self[safeDefault: $0] }
            default:
                fatalError("invalid key type")
            }
        }
    }
}
