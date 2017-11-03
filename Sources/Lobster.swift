//
//  Lobster.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2017/10/31.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

extension Notification.Name {
    public static let lobsterDidFetchConfig = Notification.Name("LobsterDidFetchConfig") // object is Error if exists.
}

public class Lobster {
    public static let shared = Lobster()

    /// Expiration duration for cache. Default is 12 hours
    public var fetchExpirationDuration: TimeInterval = 43_200.0

    /// Debug mode
    /// NOTE: It must be false on production.
    public var debugMode: Bool = false {
        didSet {
            guard let settings = RemoteConfigSettings(developerModeEnabled: debugMode) else { return }
            RemoteConfig.remoteConfig().configSettings = settings
        }
    }
    public private(set) var fetchStatus: RemoteConfigFetchStatus = .noFetchYet

    var defaults = [String: NSObject]()

    private init() {
    }

    /// Fetch config from remote.
    ///
    /// - Parameter completion: Fetch operation callback.
    public func fetch(completion: @escaping (Error?) -> Void = { _ in}) {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchExpirationDuration) { [unowned self] (status, error) in
            if error == nil {
                RemoteConfig.remoteConfig().activateFetched()
            }
            self.fetchStatus = status
            completion(error)
            NotificationCenter.default.post(name: .lobsterDidFetchConfig, object: error)
        }
    }


    /// Set default values using dictionary
    ///
    /// - Parameter defaults: default parametes.
    public func setDefaults(_ defaults: [String: Any]) {
        _setDefaults(defaults.reduce(into: [:]) {
            if let value = $1.value as? NSObject { $0[$1.key] = value }
        })
    }


    /// Set default values using loaded data from plist
    ///
    /// - Parameters:
    ///   - plistFileName: plist file name w/o extension
    ///   - bundle: bundle that embedded plist file. (Default is main bundle)
    public func setDefaults(fromPlist plistFileName: String, bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: plistFileName, withExtension: "plist") else { return }
        guard let defaults = NSDictionary(contentsOf: url) as? [String: NSObject] else { return }
        _setDefaults(defaults)
    }

    func _setDefaults(_ defaults: [String: NSObject]) {
        self.defaults = defaults.reduce(into: self.defaults) { $0[$1.key] = $1.value }
        updateDefaults()
    }

    /// Remove default value using key.
    ///
    /// - Parameter key: config key.
    public func removeDefaultValue<ValueType>(forKey key: ConfigKey<ValueType>) {
        defaults[key._key] = nil
        updateDefaults()
    }

    /// Remove default values.
    public func removeDefaults() {
        defaults = [:]
        updateDefaults()
    }

    func updateDefaults() {
        RemoteConfig.remoteConfig().setDefaults(defaults)
    }
}
