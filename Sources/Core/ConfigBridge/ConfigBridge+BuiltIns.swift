//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

/// ConfigBridge for `String`
public final class ConfigStringBridge: ConfigBridge<String> {
    public override func save(key: String, value: String?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> String? {
        if let experimentValue = experimentVariants[key] as? String {
            return experimentValue
        } else {
            return remoteConfig[key].stringValue
        }
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> String? {
        return defaultsStore[key] as? String
    }
}

/// ConfigBridge for `Int`
public final class ConfigIntBridge: ConfigBridge<Int> {
    public override func save(key: String, value: Int?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> Int? {
        if let experimentValue = experimentVariants[key] as? Int {
            return experimentValue
        } else {
            return remoteConfig[key].numberValue.intValue
        }
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> Int? {
        return defaultsStore[key] as? Int
    }
}

/// ConfigBridge for `Double`
public final class ConfigDoubleBridge: ConfigBridge<Double> {
    public override func save(key: String, value: Double?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> Double? {
        if let experimentValue = experimentVariants[key] as? Double {
            return experimentValue
        } else {
            return remoteConfig[key].numberValue.doubleValue
        }
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> Double? {
        return defaultsStore[key] as? Double
    }
}

/// ConfigBridge for `Float`
public final class ConfigFloatBridge: ConfigBridge<Float> {
    public override func save(key: String, value: Float?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> Float? {
        if let experimentValue = experimentVariants[key] as? Double {
            return Float(experimentValue)
        } else {
            return remoteConfig[key].numberValue.floatValue
        }
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> Float? {
        return defaultsStore[key] as? Float
    }
}

/// ConfigBridge for `Bool`
public final class ConfigBoolBridge: ConfigBridge<Bool> {
    public override func save(key: String, value: Bool?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> Bool? {
        if let experimentValue = experimentVariants[key] as? Bool {
            return experimentValue
        } else {
            return remoteConfig[key].boolValue
        }
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> Bool? {
        return defaultsStore[key] as? Bool
    }
}

/// ConfigBridge for `Data`
public final class ConfigDataBridge: ConfigBridge<Data> {
    public override func save(key: String, value: Data?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> Data? {
        if let experimentValue = experimentVariants[key] as? Data {
            return experimentValue
        } else {
            return remoteConfig[key].dataValue
        }
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> Data? {
        return defaultsStore[key] as? Data
    }
}

/// ConfigBridge for `URL`
public final class ConfigURLBridge: ConfigBridge<URL> {
    public override func save(key: String, value: URL?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value?.absoluteString
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> URL? {
        if let experimentValue = experimentVariants[key] {
            return (experimentValue as? String).flatMap(URL.init(string:))
        } else {
            return remoteConfig[key].stringValue.flatMap(URL.init(string:))
        }
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> URL? {
        return (defaultsStore[key] as? String).flatMap(URL.init(string:))
    }
}

/// ConfigBridge for `UIColor`
public final class ConfigColorBridge: ConfigBridge<UIColor> {
    public override func save(key: String, value: UIColor?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value?.hexString
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> UIColor? {
        if let experimentValue = experimentVariants[key] {
            return (experimentValue as? String).flatMap { $0.hexColor }
        } else {
            return remoteConfig[key].stringValue.flatMap { $0.hexColor }
        }
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> UIColor? {
        return (defaultsStore[key] as? String).flatMap { $0.hexColor }
    }
}

/// ConfigBridge for `RawRepresentable`(Enum)
public final class ConfigRawRepresentableBridge<T: RawRepresentable>: ConfigBridge<T> {
    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value?.rawValue
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> T? {
        return experimentVariants[key].flatMap(deserialize) ??
            remoteConfig[key].stringValue.flatMap(deserialize) ??
            deserialize(remoteConfig[key].numberValue)
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore[key].flatMap(deserialize)
    }

    func deserialize(_ object: Any) -> T? {
        return (object as? T.RawValue).flatMap(T.init(rawValue:))
    }
}

/// ConfigBridge for `Decodable`
///
/// - note: You can't set default value if a value is `Decodasble` object, not `Encodable` object.
///  If you can set default value, Please make object conform to `Encodable` and use `ConfigCodableBridge`.
///
public final class ConfigDecodableBridge<T: Decodable>: ConfigBridge<T> {

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any], decoder: JSONDecoder) -> T? {
        return experimentDeserialize(for: key, from: experimentVariants, decoder) ??
            remoteConfigDeserialize(remoteConfig[key].dataValue, decoder) ??
            remoteConfig[key].stringValue?.data(using: .utf8).flatMap { remoteConfigDeserialize($0, decoder) }
    }

    public override func get(key: String, defaultsStore: DefaultsStore, decoder: JSONDecoder) -> T? {
        return nil
    }

    func remoteConfigDeserialize(_ object: Any, _ decoder: JSONDecoder) -> T? {
        return (object as? Data).flatMap { try? decoder.decode(T.self, from: $0) }
    }
    
    func experimentDeserialize(for key: String, from experimentVariants: [String: Any], _ decoder: JSONDecoder) -> T? {
        guard let experimentJSONValue = experimentVariants[key],
              let experimentDictionary = experimentJSONValue as? [String: Any],
              let dictionaryEncoded = try? JSONSerialization.data(withJSONObject: experimentDictionary) else {
            return nil
        }

        do {
            return try decoder.decode(T.self, from: dictionaryEncoded)
        } catch {
            return nil
        }
    }
}

/// ConfigBridge for `Codable`
public final class ConfigCodableBridge<T: Codable>: ConfigBridge<T> {

    public override func save(key: String, value: T?, defaultsStore: DefaultsStore, encoder: JSONEncoder) {
        defaultsStore[key] = try? encoder.encode(value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any], decoder: JSONDecoder) -> T? {
        return experimentDeserialize(for: key, from: experimentVariants, decoder) ??
            remoteConfigDeserialize(remoteConfig[key].dataValue, decoder) ??
            remoteConfig[key].stringValue?.data(using: .utf8).flatMap { remoteConfigDeserialize($0, decoder) }
    }

    public override func get(key: String, defaultsStore: DefaultsStore, decoder: JSONDecoder) -> T? {
        return defaultsStore[key].flatMap { remoteConfigDeserialize($0, decoder)}
    }

    func remoteConfigDeserialize(_ object: Any, _ decoder: JSONDecoder) -> T? {
        return (object as? Data).flatMap { try? decoder.decode(T.self, from: $0) }
    }
    
    func experimentDeserialize(for key: String, from experimentVariants: [String: Any], _ decoder: JSONDecoder) -> T? {
        guard let experimentJSONValue = experimentVariants[key],
              let experimentDictionary = experimentJSONValue as? [String: Any],
              let dictionaryEncoded = try? JSONSerialization.data(withJSONObject: experimentDictionary) else {
            return nil
        }

        do {
            return try decoder.decode(T.self, from: dictionaryEncoded)
        } catch {
            return nil
        }
    }
}

// MARK: - TODO
/// ConfigBridge for `Array`
public final class ConfigArrayBridge<T: Collection>: ConfigBridge<T> {
    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value.flatMap { try? JSONSerialization.data(withJSONObject: $0, options: []) }
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> T? {
        // TODO: Make a working function for Array of Codable
//        let experimentDeserialized = (experimentKeys[key] as? [T.Element])?
//            .compactMap({ T.Element(rawValue: $0) }) as? T
//
//        let remoteConfigDeserialized = remoteConfigDeserialize(remoteConfig[key].dataValue) ??
//            remoteConfig[key].stringValue?.data(using: .utf8).flatMap(remoteConfigDeserialize)
//
//        return experimentDeserialized ?? remoteConfigDeserialized
        
        return experimentDeserialize(for: key, from: experimentVariants) ??
            remoteConfigDeserialize(remoteConfig[key].dataValue) ??
            remoteConfig[key].stringValue?.data(using: .utf8).flatMap(remoteConfigDeserialize)
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return (defaultsStore[key] as? Data).flatMap(remoteConfigDeserialize)
    }

    func remoteConfigDeserialize(_ data: Data) -> T? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])).flatMap { $0 as? T }
    }
    
    // TODO: Make a working function for Array of Codable
    func experimentDeserialize(for key: String, from experimentVariants: [String: Any]) -> T? {
        if let array = experimentVariants[key] as? [Any],
           let nonCodableArray = array.compactMap({ $0 as? T.Element }) as? T {
            return nonCodableArray
        } else {
            guard let experimentJSONValue = experimentVariants[key],
                  let jsonDictionary = experimentJSONValue as? [[String: Any]],
                  let dictionaryData = try? JSONSerialization.data(withJSONObject: jsonDictionary) else {
                return nil
            }

            do {
                return try JSONSerialization.jsonObject(with: dictionaryData, options: []) as? T
            } catch {
                return nil
            }
        }
    }
}

/// ConfigBridge for `Array` if `Collection.Element` is `RawRepresentable` (for Enum element).
public final class ConfigRawRepresentableArrayBridge<T: Collection>: ConfigBridge<T> where T.Element: RawRepresentable {
    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value
            .flatMap { try? JSONSerialization.data(withJSONObject: $0.compactMap { $0.rawValue }, options: []) }
    }

    public override func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> T? {
        let experimentDeserialized = (experimentVariants[key] as? [T.Element.RawValue])?
            .compactMap({ T.Element(rawValue: $0) }) as? T
        
        let remoteConfigDeserialized = (deserialize(remoteConfig[key].dataValue) ??
                                        remoteConfig[key].stringValue?.data(using: .utf8).flatMap(deserialize))?
            .compactMap(T.Element.init(rawValue:)) as? T
        
        return experimentDeserialized ?? remoteConfigDeserialized
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return (defaultsStore[key] as? Data).flatMap(deserialize).flatMap { $0.compactMap(T.Element.init(rawValue:)) } as? T
    }

    func deserialize(_ data: Data) -> [T.Element.RawValue]? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])).flatMap { $0 as? [T.Element.RawValue] }
    }
}
