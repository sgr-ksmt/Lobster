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
    public static var _config: ConfigBridge<String> { ConfigStringBridge() }
    public static var _configArray: ConfigBridge<[String]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Int`
extension Int: ConfigSerializable {
    public static var _config: ConfigBridge<Int> { ConfigIntBridge() }
    public static var _configArray: ConfigBridge<[Int]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Double`
extension Double: ConfigSerializable {
    public static var _config: ConfigBridge<Double> { ConfigDoubleBridge() }
    public static var _configArray: ConfigBridge<[Double]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Float`
extension Float: ConfigSerializable {
    public static var _config: ConfigBridge<Float> { ConfigFloatBridge() }
    public static var _configArray: ConfigBridge<[Float]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Bool`
extension Bool: ConfigSerializable {
    public static var _config: ConfigBridge<Bool> { ConfigBoolBridge() }
    public static var _configArray: ConfigBridge<[Bool]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `Data`
extension Data: ConfigSerializable {
    public static var _config: ConfigBridge<Data> { ConfigDataBridge() }
    public static var _configArray: ConfigBridge<[Data]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `URL`
extension URL: ConfigSerializable {
    public static var _config: ConfigBridge<URL> { ConfigURLBridge() }
    public static var _configArray: ConfigBridge<[URL]> { ConfigArrayBridge() }
}

/// ConfigSerializable for `UIColor`
extension UIColor: ConfigSerializable {
    public static var _config: ConfigBridge<UIColor> { ConfigColorBridge() }
    public static var _configArray: ConfigBridge<[UIColor]> { ConfigArrayBridge() }
}


/// ConfigSerializable for `RawRepresentable`
extension ConfigSerializable where Self: RawRepresentable {
    public static var _config: ConfigBridge<Self> { ConfigRawRepresentableBridge() }
    public static var _configArray: ConfigBridge<[Self]> { ConfigRawRepresentableArrayBridge() }
}

/// ConfigSerializable for `Decodable`
extension ConfigSerializable where Self: Decodable {
    public static var _config: ConfigBridge<Self> { ConfigDecodableBridge() }
    public static var _configArray: ConfigBridge<[Self]> { ConfigDecodableBridge() }
}

/// ConfigSerializable for `Codable`
extension ConfigSerializable where Self: Codable {
    public static var _config: ConfigBridge<Self> { ConfigCodableBridge() }
    public static var _configArray: ConfigBridge<[Self]> { ConfigCodableBridge() }
}

/// ConfigSerializable for `Array`
extension Array: ConfigSerializable where Element: ConfigSerializable {
    public typealias T = [Element]

    public static var _config: ConfigBridge<[Element]> { Element._configArray as! ConfigBridge<[Element]> }
    public static var _configArray: ConfigBridge<[[Element]]> { fatalError() }
}

/// ConfigSerializable for `Optional`
extension Optional: ConfigSerializable where Wrapped: ConfigSerializable {
    public typealias T = Wrapped

    public static var _config: ConfigBridge<Wrapped> { Wrapped._config as! ConfigBridge<Wrapped> }
     public static var _configArray: ConfigBridge<[Wrapped]> { Wrapped._configArray as! ConfigBridge<[Wrapped]> }
}
