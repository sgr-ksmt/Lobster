//
//  ConfigBridge+Builtin.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig


//public final class ConfigObjectBridge<T>: ConfigBridge<T> {
//    public override func save(key: String, value: T?, defaults: [String: NSObject]) {
//        defaults[key] = value
//    }
//
//    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
//        return remoteConfig[key] as? T
//    }
//}

//public final class ConfigArrayBridge<T: Collection>: ConfigBridge<T> {
//    public override func save(key: String, value: T?, remoteConfig: RemoteConfig) {
//        userDefaults.set(value, forKey: key)
//    }
//
//    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
//        return userDefaults.array(forKey: key) as? T
//    }
//}
public final class ConfigStringBridge: ConfigBridge<String> {
    public typealias T = String
    public override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore.set(forKey: key, value: value)
    }

    public override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].stringValue
    }

    public override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return defaultsStore.get(forKey: key) as? String
    }
}
