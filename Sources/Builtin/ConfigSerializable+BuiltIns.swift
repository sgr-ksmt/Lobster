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
}

extension Int: ConfigSerializable {
    public static var _config: ConfigBridge<Int> { return ConfigIntBridge() }
}

extension Double: ConfigSerializable {
    public static var _config: ConfigBridge<Double> { return ConfigDoubleBridge() }
}

extension Float: ConfigSerializable {
    public static var _config: ConfigBridge<Float> { return ConfigFloatBridge() }
}

extension Bool: ConfigSerializable {
    public static var _config: ConfigBridge<Bool> { return ConfigBoolBridge() }
}

extension Data: ConfigSerializable {
    public static var _config: ConfigBridge<Data> { return ConfigDataBridge() }
}

extension URL: ConfigSerializable {
    public static var _config: ConfigBridge<URL> { return ConfigURLBridge() }
}

extension ConfigSerializable where Self: RawRepresentable {
    public static var _defaults: ConfigBridge<Self> { return ConfigRawRepresentableBridge() }
}

extension Optional: ConfigSerializable where Wrapped: ConfigSerializable {
    public typealias T = Wrapped

    public static var _config: ConfigBridge<Wrapped> { return Wrapped._config as! ConfigBridge<Wrapped> }
}
