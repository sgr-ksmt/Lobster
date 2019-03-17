//
//  ConfigSerializable+Builtin.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

extension String: ConfigSerializable {
    public static var _config: ConfigBridge<String> { return ConfigStringBridge() }
    public static var _configArray: ConfigBridge<[String]> { return ConfigArrayBridge() }
}

extension Int: ConfigSerializable {
    public static var _config: ConfigBridge<Int> { return ConfigIntBridge() }
    public static var _configArray: ConfigBridge<[Int]> { return ConfigArrayBridge() }
}

extension Double: ConfigSerializable {
    public static var _config: ConfigBridge<Double> { return ConfigDoubleBridge() }
    public static var _configArray: ConfigBridge<[Double]> { return ConfigArrayBridge() }
}

extension Float: ConfigSerializable {
    public static var _config: ConfigBridge<Float> { return ConfigFloatBridge() }
    public static var _configArray: ConfigBridge<[Float]> { return ConfigArrayBridge() }
}

extension Bool: ConfigSerializable {
    public static var _config: ConfigBridge<Bool> { return ConfigBoolBridge() }
    public static var _configArray: ConfigBridge<[Bool]> { return ConfigArrayBridge() }
}

extension Data: ConfigSerializable {
    public static var _config: ConfigBridge<Data> { return ConfigDataBridge() }
    public static var _configArray: ConfigBridge<[Data]> { return ConfigArrayBridge() }
}

extension URL: ConfigSerializable {
    public static var _config: ConfigBridge<URL> { return ConfigURLBridge() }
    public static var _configArray: ConfigBridge<[URL]> { return ConfigArrayBridge() }
}

extension UIColor: ConfigSerializable {
    public static var _config: ConfigBridge<UIColor> { return ConfigColorBridge() }
    public static var _configArray: ConfigBridge<[UIColor]> { return ConfigArrayBridge() }
}


extension ConfigSerializable where Self: RawRepresentable {
    public static var _config: ConfigBridge<Self> { return ConfigRawRepresentableBridge() }
    public static var _configArray: ConfigBridge<[Self]> { return ConfigRawRepresentableArrayBridge() }
}

extension ConfigSerializable where Self: Decodable {
    public static var _config: ConfigBridge<Self> { return ConfigDecodableBridge() }
    public static var _configArray: ConfigBridge<[Self]> { return ConfigDecodableBridge() }
}

extension ConfigSerializable where Self: Codable {
    public static var _config: ConfigBridge<Self> { return ConfigCodableBridge() }
    public static var _configArray: ConfigBridge<[Self]> { return ConfigCodableBridge() }
}

extension Array: ConfigSerializable where Element: ConfigSerializable {
    public typealias T = [Element]

    public static var _config: ConfigBridge<[Element]> { return Element._configArray as! ConfigBridge<[Element]> }
    public static var _configArray: ConfigBridge<[[Element]]> { fatalError() }
}

extension Optional: ConfigSerializable where Wrapped: ConfigSerializable {
    public typealias T = Wrapped

    public static var _config: ConfigBridge<Wrapped> { return Wrapped._config as! ConfigBridge<Wrapped> }
     public static var _configArray: ConfigBridge<[Wrapped]> { return Wrapped._configArray as! ConfigBridge<[Wrapped]> }
}
