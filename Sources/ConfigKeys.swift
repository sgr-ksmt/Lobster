//
//  ConfigKeys.swift
//  Lobster
//
//  Created by sgr-ksmt on 2017/11/01.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

/// ConfigKeys
///
/// ConfigKeys is just a class that gathers `ConfigKey` instances you define.
/// You can define `ConfigKey` inside this class's extension.
///
/// Example for definition of ConfigKey:
///
///     extension ConfigKeys {
///         static let title = ConfigKey<String>("title")
///         static let buttonColor = ConfigKey<UIColor>("button_color")
///         static let experimentEnabled = ConfigKey<Bool>("experiment_enabled")
///     }
open class ConfigKeys {
    init() {}
}

/// ConfigKey
///
/// ConfigKey is a key class specialized with `ValueType` for Remote Config
/// It allows you to get value as a type of `ValueType` from Remote Config with subscription.
/// That is, you don't need to manually convert value to another type you want. You can handle the value  to type safe.
///
/// Example for getting value with ConfigKey:
///
///     extension ConfigKeys {
///         static let title = ConfigKey<String>("title")
///     }
///
///     let title = Lobster.shared[.title]
///     print(String(describing: type(of: title))) // String
public class ConfigKey<ValueType: ConfigSerializable>: ConfigKeys {

    /// A key.
    public let _key: String

    /// Initializer
    /// - parameters:
    ///   - key: A key
    public init(_ key: String) {
        self._key = key
    }
}
