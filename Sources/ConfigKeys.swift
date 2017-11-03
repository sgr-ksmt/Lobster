//
//  ConfigKeys.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2017/11/01.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation

public class ConfigKeys {
    init() {}
}

public protocol ConfigKeyType {
    var _key: String { get }
}

/// Config key
/// can access / set default config value as ValueType object.
public class ConfigKey<ValueType>: ConfigKeys, ConfigKeyType {
    public let _key: String

    public init(_ key: String) {
        self._key = key
        super.init()
    }
}

extension ConfigKey: Hashable {
    public static func == (lhs: ConfigKey, rhs: ConfigKey) -> Bool {
        return lhs._key == rhs._key
    }

    public var hashValue: Int {
        return _key.hashValue
    }
}

/// Decodable Config key
/// can access config value as codable object.
public class DecodableConfigKey<ValueType: Decodable>: ConfigKey<ValueType> {
    public enum DataType {
        case rawData
        case json(String.Encoding)
    }

    let dataType: DataType
    let decoder: JSONDecoder

    public init(_ key: String, dataType: DataType = .json(.utf8), decoder: JSONDecoder = .init()) {
        self.dataType = dataType
        self.decoder = decoder
        super.init(key)
    }
}

/// Codable Config key
/// can access / set default config value as codable object.
public class CodableConfigKey<ValueType: Codable>: DecodableConfigKey<ValueType> {
    let encoder: JSONEncoder
    public init(_ key: String, dataType: DataType = .json(.utf8), decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.encoder = encoder
        super.init(key, dataType: dataType, decoder: decoder)
    }
}


/// Type-Erased config key
public class AnyConfigKey: ConfigKeys, ConfigKeyType {
    let base: ConfigKeyType

    init(_ base: ConfigKeyType) {
        self.base = base
    }

    public var _key: String {
        return base._key
    }
}
