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
    public typealias Defaults = [String: Any]
    public static let shared = Lobster()
    public let remoteConfig = RemoteConfig.remoteConfig()
    /// Expiration duration for cache. Default is 12 hours
    public var fetchExpirationDuration: TimeInterval = 43_200.0

    public var useStaleChecker: Bool = true
    public var staleValueStore: StaleValueStore = UserDefaults.standard
    public var isStaled: Bool {
        set {
            staleValueStore.isStaled = newValue
        }
        get {
            return staleValueStore.isStaled
        }
    }

    /// Debug mode
    /// NOTE: It must be false on production.
    public var debugMode: Bool = false {
        didSet {
            remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: debugMode)
        }
    }
    public private(set) var fetchStatus: RemoteConfigFetchStatus = .noFetchYet

    public let defaultsStore = DefaultsStore()

    private init() {}

    /// Fetch config from remote.
    ///
    /// - Parameter completion: Fetch operation callback.
    public func fetch(completion: @escaping (Error?) -> Void = { _ in}) {
        let duration = getExpirationDuration()
        remoteConfig.fetch(withExpirationDuration: duration) { [unowned self] (status, error) in
            if error == nil {
                RemoteConfig.remoteConfig().activateFetched()
            }
            self.fetchStatus = status
            completion(error)
            NotificationCenter.default.post(name: .lobsterDidFetchConfig, object: error)
        }
    }

    private func getExpirationDuration() -> TimeInterval {
        if useStaleChecker, isStaled {
            return 0.0
        }
        return fetchExpirationDuration
    }


    /// Set default values using dictionary
    ///
    /// - Parameter defaults: default parametes.
    public func setDefaults(_ defaults: [String: AnyObject]) {
        defaultsStore.set(defaults: defaults)
        updateDefaults()
    }

    /// Set default values using loaded data from plist
    ///
    /// - Parameters:
    ///   - plistFileName: plist file name w/o extension
    ///   - bundle: bundle that embedded plist file. (Default is main bundle)
    public func setDefaults(fromPlist plistFileName: String, bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: plistFileName, withExtension: "plist") else { return }
        guard let defaults = NSDictionary(contentsOf: url) as? [String: NSObject] else { return }
        setDefaults(defaults)
    }

    /// Remove default value using key.
    ///
    /// - Parameter key: config key.
    public func removeDefaultValue<ValueType>(forKey key: ConfigKey<ValueType>) {
        defaultsStore.set(forKey: key._key, value: nil)
        updateDefaults()
    }

    /// Clear default values.
    public func clearDefaults() {
        defaultsStore.clear()
        updateDefaults()
    }

    func updateDefaults() {
        RemoteConfig.remoteConfig().setDefaults(defaultsStore.asRemoteConfigDefaults())
    }
}
