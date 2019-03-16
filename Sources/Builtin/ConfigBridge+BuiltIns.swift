//
//  ConfigBridge+Builtin.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

public final class ConfigStringBridge: ConfigBridge<String> {
    public typealias T = String

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].stringValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key) as? T
    }
}

public final class ConfigIntBridge: ConfigBridge<Int> {
    public typealias T = Int

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].numberValue?.intValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key) as? T
    }
}

public final class ConfigDoubleBridge: ConfigBridge<Double> {
    public typealias T = Double

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].numberValue?.doubleValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key) as? T
    }
}

public final class ConfigFloatBridge: ConfigBridge<Float> {
    public typealias T = Float

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].numberValue?.floatValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key) as? T
    }
}

public final class ConfigBoolBridge: ConfigBridge<Bool> {
    public typealias T = Bool

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].boolValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key) as? T
    }
}

public final class ConfigDataBridge: ConfigBridge<Data> {
    public typealias T = Data

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].dataValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key) as? T
    }
}

public final class ConfigURLBridge: ConfigBridge<URL> {
    public typealias T = URL

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].stringValue.flatMap(URL.init(string:))
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key) as? T
    }
}

public final class ConfigRawRepresentableBridge<T: RawRepresentable>: ConfigBridge<T> {
    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: value?.rawValue)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        if let stringValue = remoteConfig[key].stringValue {
            return deserialize(stringValue)
        } else if let numberValue = remoteConfig[key].numberValue {
            return deserialize(numberValue)
        }
        return nil
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key).flatMap(deserialize)
    }

    func deserialize(_ object: Any) -> T? {
        return (object as? T.RawValue).flatMap(T.init(rawValue:))
    }
}

public final class ConfigCodableBridge<T: Codable>: ConfigBridge<T> {
    public var decoder = JSONDecoder()
    public var encoder = JSONEncoder()

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: try? encoder.encode(value))
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return deserialize(remoteConfig[key].dataValue) ??
            remoteConfig[key].stringValue?.data(using: .utf8).flatMap(deserialize)
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key).flatMap(deserialize)
    }

    func deserialize(_ object: Any) -> T? {
        return (object as? Data).flatMap { try? decoder.decode(T.self, from: $0) }
    }
}
