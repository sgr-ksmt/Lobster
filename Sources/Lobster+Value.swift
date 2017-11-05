//
//  Lobster+Value.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2017/11/01.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit
import FirebaseRemoteConfig

extension Lobster {
    public func setDefaultValue<ValueType>(_ value: ValueType?, forKey key: CodableConfigKey<ValueType>) throws {
        guard let value = value else {
            defaults[key._key] = nil
            updateDefaults()
            return
        }

        let data = try key.encoder.encode(value)
        switch key.dataType {
        case .rawData:
            defaults[key._key] = data as NSData
        case .json(let encoding):
            guard let json = String(data: data, encoding: encoding) else { return }
            defaults[key._key] = json as NSString
        }
        updateDefaults()
    }

    public func setDefaultValue(_ value: String?, forKey key: ConfigKey<String>) {
        setDefaultValue(value, forKey: key._key)
    }

    public func setDefaultValue(_ value: String?, forKey key: String) {
        defaults[key] = value.map { $0 as NSString }
        updateDefaults()
    }

    public func setDefaultValue(_ value: Int?, forKey key: ConfigKey<Int>) {
        setDefaultValue(value, forKey: key._key)
    }

    public func setDefaultValue(_ value: Int?, forKey key: String) {
        defaults[key] = value.map { $0 as NSNumber }
        updateDefaults()
    }

    public func setDefaultValue(_ value: Double?, forKey key: ConfigKey<Double>) {
        setDefaultValue(value, forKey: key._key)
    }

    public func setDefaultValue(_ value: Double?, forKey key: String) {
        defaults[key] = value.map { $0 as NSNumber }
        updateDefaults()
    }

    public func setDefaultValue(_ value: Float?, forKey key: ConfigKey<Float>) {
        setDefaultValue(value, forKey: key._key)
    }

    public func setDefaultValue(_ value: Float?, forKey key: String) {
        defaults[key] = value.map { $0 as NSNumber }
        updateDefaults()
    }

    public func setDefaultValue(_ value: Bool?, forKey key: ConfigKey<Bool>) {
        setDefaultValue(value, forKey: key._key)
    }

    public func setDefaultValue(_ value: Bool?, forKey key: String) {
        defaults[key] = value.map { $0 as NSNumber }
        updateDefaults()
    }

    public func setDefaultValue(_ value: Data?, forKey key: ConfigKey<Data>) {
        defaults[key._key] = value.map { $0 as NSData }
        updateDefaults()
    }

    public func setDefaultValue(_ value: URL?, forKey key: ConfigKey<URL>) {
        defaults[key._key] = value.map { $0.absoluteString as NSString }
        updateDefaults()
    }

    public func setDefaultValue(_ value: UIColor?, forKey key: ConfigKey<UIColor>) {
        defaults[key._key] = value.map { $0.hexString as NSString }
        updateDefaults()
    }
}

extension Lobster {
    public func configValue<ValueType>(forKey key: DecodableConfigKey<ValueType>) throws -> ValueType? {
        let data: Data? = {
            switch key.dataType {
            case .rawData: return RemoteConfig.remoteConfig()[key._key].dataValue
            case .json(let encoding): return RemoteConfig.remoteConfig()[key._key].stringValue?.data(using: encoding)
            }
        }()
        return try data.map { try key.decoder.decode(ValueType.self, from: $0) }
    }

    public func configValue(forKey key: ConfigKey<String>) -> String? {
        return configValue(forKey: key._key)
    }

    public func configValue(forKey key: String) -> String? {
        return RemoteConfig.remoteConfig()[key].stringValue
    }

    public func configValue(forKey key: ConfigKey<Int>) -> Int? {
        return configValue(forKey: key._key)
    }

    public func configValue(forKey key: String) -> Int? {
        return RemoteConfig.remoteConfig()[key].numberValue?.intValue
    }

    public func configValue(forKey key: ConfigKey<Double>) -> Double? {
        return configValue(forKey: key._key)
    }

    public func configValue(forKey key: String) -> Double? {
        return RemoteConfig.remoteConfig()[key].numberValue?.doubleValue
    }

    public func configValue(forKey key: ConfigKey<Float>) -> Float? {
        return configValue(forKey: key._key)
    }

    public func configValue(forKey key: String) -> Float? {
        return RemoteConfig.remoteConfig()[key].numberValue?.floatValue
    }

    public func configValue(forKey key: ConfigKey<Bool>) -> Bool {
        return configValue(forKey: key._key)
    }

    public func configValue(forKey key: String) -> Bool {
        return RemoteConfig.remoteConfig()[key].boolValue
    }

    public func configValue(forKey key: ConfigKey<Data>) -> Data {
        return RemoteConfig.remoteConfig()[key._key].dataValue
    }

    public func configValue(forKey key: ConfigKey<URL>) -> URL? {
        return RemoteConfig.remoteConfig()[key._key].stringValue.flatMap(URL.init(string:))
    }

    public func configValue(forKey key: ConfigKey<UIColor>) -> UIColor? {
        return configValue(forKey: key._key)?.hexColor
    }

    public func configValue(forKey key: AnyConfigKey) -> RemoteConfigValue {
        return RemoteConfig.remoteConfig()[key._key]
    }
}

// convenience functions
extension Lobster {
    public func getDefaultValue(forKey key: ConfigKey<String>) -> String? {
        return getDefaultValue(forKey: key._key)
    }

    public func getDefaultValue(forKey key: String) -> String? {
        return (defaults[key] as? NSString) as String?
    }

    public func getDefaultValue(forKey key: ConfigKey<NSNumber>) -> NSNumber? {
        return getDefaultValue(forKey: key._key)
    }

    public func getDefaultValue(forKey key: String) -> NSNumber? {
        return defaults[key] as? NSNumber
    }

    public func getDefaultValue(forKey key: ConfigKey<Int>) -> Int? {
        return getDefaultValue(forKey: key._key)
    }

    public func getDefaultValue(forKey key: String) -> Int? {
        return getDefaultValue(forKey: key)?.intValue
    }

    public func getDefaultValue(forKey key: ConfigKey<Float>) -> Float? {
        return getDefaultValue(forKey: key._key)
    }

    public func getDefaultValue(forKey key: String) -> Float? {
        return getDefaultValue(forKey: key)?.floatValue
    }

    public func getDefaultValue(forKey key: ConfigKey<Double>) -> Double? {
        return getDefaultValue(forKey: key._key)
    }

    public func getDefaultValue(forKey key: String) -> Double? {
        return getDefaultValue(forKey: key)?.doubleValue
    }

    public func getDefaultValue(forKey key: ConfigKey<Bool>) -> Bool? {
        return getDefaultValue(forKey: key._key)
    }

    public func getDefaultValue(forKey key: String) -> Bool? {
        return getDefaultValue(forKey: key)?.boolValue
    }

    public func getDefaultValue(forKey key: ConfigKey<Data>) -> Data? {
        return getDefaultValue(forKey: key._key)
    }

    public func getDefaultValue(forKey key: String) -> Data? {
        return (defaults[key] as? NSData) as Data?
    }
}

extension Lobster {
    public subscript(_ key: ConfigKey<String>) -> String? {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Int>) -> Int? {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Float>) -> Float? {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Double>) -> Double? {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Bool>) -> Bool {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Data>) -> Data {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<URL>) -> URL? {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<UIColor>) -> UIColor? {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }

    public subscript<ValueType>(_ key: DecodableConfigKey<ValueType>) -> ValueType? {
        return (try? configValue(forKey: key))?.flatMap { $0 }
    }

    public subscript<ValueType: Codable>(_ key: CodableConfigKey<ValueType>) -> ValueType? {
        get {
            return (try? configValue(forKey: key))?.flatMap { $0 }
        }
        set {
            try? setDefaultValue(newValue, forKey: key)
        }
    }

    /// Get string value by using object subscripting syntax.
    ///
    /// - Parameter key: config key.
    public subscript(default key: ConfigKey<String>) -> String? {
        return getDefaultValue(forKey: key)
    }

    public subscript(default key: ConfigKey<Int>) -> Int? {
        return getDefaultValue(forKey: key)
    }

    /// Get float value by using object subscripting syntax.
    ///
    /// - Parameter key: config key.
    public subscript(default key: ConfigKey<Float>) -> Float? {
        return getDefaultValue(forKey: key)
    }

    /// Get double value by using object subscripting syntax.
    ///
    /// - Parameter key: config key.
    public subscript(default key: ConfigKey<Double>) -> Double? {
        return getDefaultValue(forKey: key)
    }

    /// Get bool value by using object subscripting syntax.
    ///
    /// - Parameter key: config key.
    public subscript(default key: ConfigKey<Bool>) -> Bool? {
        return getDefaultValue(forKey: key)
    }

    /// Get data by using object subscripting syntax.
    ///
    /// - Parameter key: config key.
    public subscript(default key: ConfigKey<Data>) -> Data? {
        return getDefaultValue(forKey: key)
    }

    /// Get url by using object subscripting syntax.
    ///
    /// - Parameter key: config key.
    public subscript(default key: ConfigKey<URL>) -> URL? {
        return getDefaultValue(forKey: key._key).flatMap(URL.init(string:))
    }

    /// Get color by using object subscripting syntax.
    ///
    /// - Parameter key: config key.
    public subscript(default key: ConfigKey<UIColor>) -> UIColor? {
        return getDefaultValue(forKey: key._key)?.hexColor
    }

    /// Get decodable value by using object subscripting syntax.
    ///
    /// - Parameter key: config key.
    public subscript<ValueType>(default key: DecodableConfigKey<ValueType>) -> ValueType? {
        let data: Data? = {
            switch key.dataType {
            case .rawData: return (defaults[key._key] as? NSData) as Data?
            case .json(let encoding): return getDefaultValue(forKey: key._key)?.data(using: encoding)
            }
        }()
        return data.flatMap { (try? key.decoder.decode(ValueType.self, from: $0)) }
    }

    /// Get value by using object subscripting syntax.
    ///
    /// - Parameter key: type-erased config key.
    public subscript(default key: AnyConfigKey) -> Any? {
        return defaults[key._key]
    }
}

/// Support for Enum
extension Lobster {
    public func setDefaultValue<T: RawRepresentable>(_ value: T?, forKey key: ConfigKey<T>) where T.RawValue == Int {
        defaults[key._key] = value.map { $0.rawValue as NSNumber }
        updateDefaults()
    }

    public func setDefaultValue<T: RawRepresentable>(_ value: T?, forKey key: ConfigKey<T>) where T.RawValue == String {
        defaults[key._key] = value.map { $0.rawValue as NSString }
        updateDefaults()
    }

    public func configValue<T: RawRepresentable>(forKey key: ConfigKey<T>) -> T? where T.RawValue == Int {
        return configValue(forKey: key._key).flatMap { T(rawValue: $0) }
    }

    public func configValue<T: RawRepresentable>(forKey key: ConfigKey<T>) -> T? where T.RawValue == String {
        return configValue(forKey: key._key).flatMap { T(rawValue: $0) }
    }

    public func getDefaultValue<T: RawRepresentable>(forKey key: ConfigKey<T>) -> T? where T.RawValue == Int {
        return getDefaultValue(forKey: key._key).flatMap { T(rawValue: $0) }
    }

    public func getDefaultValue<T: RawRepresentable>(forKey key: ConfigKey<T>) -> T? where T.RawValue == String {
        return getDefaultValue(forKey: key._key).flatMap { T(rawValue: $0) }
    }

    public subscript<T: RawRepresentable>(_ key: ConfigKey<T>) -> T? where T.RawValue == Int {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }

    public subscript<T: RawRepresentable>(_ key: ConfigKey<T>) -> T? where T.RawValue == String {
        get { return configValue(forKey: key) }
        set { setDefaultValue(newValue, forKey: key) }
    }
}
