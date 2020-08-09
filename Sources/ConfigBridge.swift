//
//  ConfigBridge.swift
//  Lobster
//
//  Created by sgr-ksmt on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

/// 
///
/// - note: It's an abstract class. If you want to adapt it to some value type, please override it.
open class ConfigBridge<T> {

    public init() {}

    open func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        fatalError("This function must be implemented onto subclass.")
    }

    open func get(key: String, remoteConfig: RemoteConfig) -> T? {
        fatalError("This function must be implemented onto subclass.")
    }

    open func get(key: String, defaultsStore: DefaultsStore) -> T? {
        fatalError("This function must be implemented onto subclass.")
    }
}
