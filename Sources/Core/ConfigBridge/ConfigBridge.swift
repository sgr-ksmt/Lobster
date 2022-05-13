//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

/// A bridge class that connects Lobster and ConfigKey.
///
/// Getting a value and setting a value are executed in a class that inherit this class.
/// That is, There are bridge classes that inherit `ConfigBridge<T>` for each value type like `String`, `Int`, etc...
/// Lobster provides these bridge classes:
///
///  - String: `ConfigStringBridge`
///  - Int: `ConfigIntBridge`
///  - Double: `ConfigDoubleBridge`
///  - Float: `ConfigFloatBridge`
///  - Bool: `ConfigBoolBridge`
///  - Data: `ConfigDataBridge`
///  - URL: `ConfigURLBridge`
///  - UIColor: `ConfigColorBridge`
///  - RawRepresentable(Enum): `ConfigRawRepresentableBridge`
///  - Decodable: `ConfigDecodableBridge`
///  - Encodable: `ConfigCodableBridge`
///  - Array: `ConfigArrayBridge`
///  - Array for Enum: `ConfigRawRepresentableArrayBridge`
///
/// - note: It's an abstract class. If you want to adapt it to some value type, please override it.
open class ConfigBridge<T> {

    /// Initializer
    public init() {}

    /// Saves a value to DefaultsStore.
    ///
    /// - note: If you create a bridge class by inheriting `ConfigBridge<T>`, You need to override this function absolutely.
    open func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        fatalError("This function must be implemented onto subclass.")
    }

    /// Get a value from RemoteConfig
    ///
    /// If a value matched a key doesn't exist in RemoteConfig , this function will return `nil`
    /// - returns: A value of type of T?
    ///
    /// - note: If you create a bridge class by inheriting `ConfigBridge<T>`, You need to override this function absolutely.
    open func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any]) -> T? {
        fatalError("This function must be implemented onto subclass.")
    }

    /// Get a value from DefaultsStore
    ///
    /// If a value matched a key doesn't exist in DefaultsStore, this function will return `nil`
    /// - returns: A value of type of T?
    ///
    /// - note: If you create a bridge class by inheriting `ConfigBridge<T>`, You need to override this function absolutely.
    open func get(key: String, defaultsStore: DefaultsStore) -> T? {
        fatalError("This function must be implemented onto subclass.")
    }


    /// Saves a value to DefaultsStore.
    ///
    /// - note: If you create a bridge class by inheriting `ConfigBridge<T>`, You need to override this function absolutely.
    open func save(key: String, value: T?, defaultsStore: DefaultsStore, encoder: JSONEncoder) {
        fatalError("This function must be implemented onto subclass.")
    }

    /// Get a value from RemoteConfig
    ///
    /// If a value matched a key doesn't exist in RemoteConfig , this function will return `nil`
    /// - returns: A value of type of T?
    ///
    /// - note: If you create a bridge class by inheriting `ConfigBridge<T>`, You need to override this function absolutely.
    open func get(key: String, remoteConfig: RemoteConfig, experimentVariants: [String: Any], decoder: JSONDecoder) -> T? {
        fatalError("This function must be implemented onto subclass.")
    }

    /// Get a value from DefaultsStore
    ///
    /// If a value matched a key doesn't exist in DefaultsStore, this function will return `nil`
    /// - returns: A value of type of T?
    ///
    /// - note: If you create a bridge class by inheriting `ConfigBridge<T>`, You need to override this function absolutely.
    open func get(key: String, defaultsStore: DefaultsStore, decoder: JSONDecoder) -> T? {
        fatalError("This function must be implemented onto subclass.")
    }
}
