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
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].stringValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore[key] as? T
    }
}

public final class ConfigIntBridge: ConfigBridge<Int> {
    public typealias T = Int

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].numberValue?.intValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore[key] as? T
    }
}

public final class ConfigDoubleBridge: ConfigBridge<Double> {
    public typealias T = Double

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].numberValue?.doubleValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore[key] as? T
    }
}

public final class ConfigFloatBridge: ConfigBridge<Float> {
    public typealias T = Float

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].numberValue?.floatValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore[key] as? T
    }
}

public final class ConfigBoolBridge: ConfigBridge<Bool> {
    public typealias T = Bool

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].boolValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore[key] as? T
    }
}

public final class ConfigDataBridge: ConfigBridge<Data> {
    public typealias T = Data

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].dataValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore[key] as? T
    }
}

public final class ConfigURLBridge: ConfigBridge<URL> {
    public typealias T = URL

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value?.absoluteString
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].stringValue.flatMap(URL.init(string:))
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return (defaultsStore[key] as? String).flatMap(URL.init(string:))
    }
}

public final class ConfigColorBridge: ConfigBridge<UIColor> {
    public typealias T = UIColor

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value?.hexString
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].stringValue.flatMap { $0.hexColor }
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return (defaultsStore[key] as? String).flatMap { $0.hexColor }
    }
}

public final class ConfigRawRepresentableBridge<T: RawRepresentable>: ConfigBridge<T> {
    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value?.rawValue
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].stringValue.flatMap(deserialize) ??
            remoteConfig[key].numberValue.flatMap(deserialize)
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore[key].flatMap(deserialize)
    }

    func deserialize(_ object: Any) -> T? {
        return (object as? T.RawValue).flatMap(T.init(rawValue:))
    }
}

public final class ConfigDecodableBridge<T: Decodable>: ConfigBridge<T> {
    public var decoder = JSONDecoder()

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return deserialize(remoteConfig[key].dataValue) ??
            remoteConfig[key].stringValue?.data(using: .utf8).flatMap(deserialize)
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return nil
    }

    func deserialize(_ object: Any) -> T? {
        return (object as? Data).flatMap { try? decoder.decode(T.self, from: $0) }
    }
}


public final class ConfigCodableBridge<T: Codable>: ConfigBridge<T> {
    public var decoder = JSONDecoder()
    public var encoder = JSONEncoder()

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = try? encoder.encode(value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return deserialize(remoteConfig[key].dataValue) ??
            remoteConfig[key].stringValue?.data(using: .utf8).flatMap(deserialize)
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore[key].flatMap(deserialize)
    }

    func deserialize(_ object: Any) -> T? {
        return (object as? Data).flatMap { try? decoder.decode(T.self, from: $0) }
    }
}

public final class ConfigArrayBridge<T: Collection>: ConfigBridge<T> {
    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value.flatMap { try? JSONSerialization.data(withJSONObject: $0, options: []) }
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return deserialize(remoteConfig[key].dataValue) ??
            remoteConfig[key].stringValue?.data(using: .utf8).flatMap(deserialize)
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return (defaultsStore[key] as? Data).flatMap(deserialize)
    }

    func deserialize(_ data: Data) -> T? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])).flatMap { $0 as? T }
    }
}

public final class ConfigRawRepresentableArrayBridge<T: Collection>: ConfigBridge<T> where T.Element: RawRepresentable {
    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value.flatMap { try? JSONSerialization.data(withJSONObject: $0.compactMap { $0.rawValue }, options: []) }
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        let deserialized = deserialize(remoteConfig[key].dataValue) ?? remoteConfig[key].stringValue?.data(using: .utf8).flatMap(deserialize)
        return deserialized?.compactMap(T.Element.init(rawValue:)) as? T
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return (defaultsStore[key] as? Data).flatMap(deserialize).flatMap { $0.compactMap(T.Element.init(rawValue:)) } as? T
    }

    func deserialize(_ data: Data) -> [T.Element.RawValue]? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])).flatMap { $0 as? [T.Element.RawValue] }
    }
}
