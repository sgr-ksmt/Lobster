//
//  ConfigBridge.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

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
