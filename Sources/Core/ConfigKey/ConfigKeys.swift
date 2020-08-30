//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
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
public class ConfigKeys {
    init() {}
}

public class ConfigKeyBase<ValueType: ConfigSerializable>: ConfigKeys {

    /// A key.
    public let _key: String

    /// Initializer
    /// - parameters:
    ///   - key: A key
    public init(_ key: String) {
        self._key = key
    }
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
public final class ConfigKey<ValueType: ConfigSerializable>: ConfigKeyBase<ValueType> {
}

public final class DecodableConfigKey<ValueType: ConfigSerializable & Decodable>: ConfigKeyBase<ValueType> {

    public let decoder: JSONDecoder

    public init(_ key: String, decoder: JSONDecoder = .init()) {
        self.decoder = decoder
        super.init(key)
    }
}

public final class CodableConfigKey<ValueType: ConfigSerializable & Codable>: ConfigKeyBase<ValueType> {

    public let decoder: JSONDecoder
    public let encoder: JSONEncoder

    public init(_ key: String, modifier: (JSONDecoder, JSONEncoder) -> Void = { _, _ in}) {
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        super.init(key)
        modifier(decoder, encoder)
    }
}
