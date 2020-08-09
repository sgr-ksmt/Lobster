//
//  ConfigSerializable+Builtin.swift
//  Lobster
//
//  Created by sgr-ksmt on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

/// ConfigSerializable for `String`
extension String: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<String>`.
    public static var _config: ConfigBridge<Self> { ConfigStringBridge() }
    /// Returns a instance of `ConfigBridge<[String]>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Int`
extension Int: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<Int>`.
    public static var _config: ConfigBridge<Self> { ConfigIntBridge() }
    /// Returns a instance of `ConfigBridge<[Int]>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Double`
extension Double: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<Double>`.
    public static var _config: ConfigBridge<Self> { ConfigDoubleBridge() }
    /// Returns a instance of `ConfigBridge<[Double>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Float`
extension Float: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<Float>`.
    public static var _config: ConfigBridge<Self> { ConfigFloatBridge() }
    /// Returns a instance of `ConfigBridge<[Float]>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Bool`
extension Bool: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<Bool>`.
    public static var _config: ConfigBridge<Self> { ConfigBoolBridge() }
    /// Returns a instance of `ConfigBridge<[Bool]>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Data`
extension Data: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<Data>`.
    public static var _config: ConfigBridge<Self> { ConfigDataBridge() }
    /// Returns a instance of `ConfigBridge<[Data]>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `URL`
extension URL: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<URL>`.
    public static var _config: ConfigBridge<Self> { ConfigURLBridge() }
    /// Returns a instance of `ConfigBridge<[URL]>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `UIColor`
extension UIColor: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<UIColor>`.
    public static var _config: ConfigBridge<UIColor> { ConfigColorBridge() }
    /// Returns a instance of `ConfigBridge<[UIColor]>`.
    public static var _configArray: ConfigBridge<[UIColor]> { ConfigArrayBridge() }
}


/// ConfigSerializable for `RawRepresentable`
extension ConfigSerializable where Self: RawRepresentable {
    /// Returns a instance of `ConfigBridge<RawRepresentable>`.
    public static var _config: ConfigBridge<Self> { ConfigRawRepresentableBridge() }
    /// Returns a instance of `ConfigBridge<[RawRepresentable]>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigRawRepresentableArrayBridge() }
}

/// ConfigSerializable for `Decodable`
extension ConfigSerializable where Self: Decodable {
    /// Returns a instance of `ConfigBridge<Decodable>`.
    public static var _config: ConfigBridge<Self> { ConfigDecodableBridge() }
    /// Returns a instance of `ConfigBridge<[Decodable]>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigDecodableBridge() }
}

/// ConfigSerializable for `Codable`
extension ConfigSerializable where Self: Codable {
    /// Returns a instance of `ConfigBridge<Codable>`.
    public static var _config: ConfigBridge<Self> { ConfigCodableBridge() }
    /// Returns a instance of `ConfigBridge<[Codable]>`.
    public static var _configArray: ConfigBridge<[Self]> { ConfigCodableBridge() }
}

/// ConfigSerializable for `Array`
extension Array: ConfigSerializable where Element: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<[T]>`.
    public static var _config: ConfigBridge<Self> { Element._configArray as! ConfigBridge<Self> }

    /// Throw a fatal error because a type of ` [[T]]` is not supported.
    public static var _configArray: ConfigBridge<[Self]> { fatalError() }
}

/// ConfigSerializable for `Optional`
extension Optional: ConfigSerializable where Wrapped: ConfigSerializable {
    /// Returns a instance of `ConfigBridge<Optional<T>>`.
    public static var _config: ConfigBridge<Wrapped> { Wrapped._config as! ConfigBridge<Wrapped> }
    /// Returns a instance of `ConfigBridge<[Optional<T>]>`.
    public static var _configArray: ConfigBridge<[Wrapped]> { Wrapped._configArray as! ConfigBridge<[Wrapped]> }
}
