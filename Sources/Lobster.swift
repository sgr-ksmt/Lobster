//
//  Lobster.swift
//  Lobster
//
//  Created by sgr-ksmt on 2017/10/31.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import UIKit

/// Lobster
/// 
/// Lobster wraps Remote Config's interface
public class Lobster {
    /// The instance of Lobster.

    public static let shared = Lobster()

    /// The `FIRRemoteConfig` instance.
    ///
    /// - Note: Basically, You don't  have to use this directly.
    public let remoteConfig = RemoteConfig.remoteConfig()

    /// The default expiration duration. `12 hours`
    public static let defaultExpirationDuration: TimeInterval = 43_200.0

    /// A fetch expiration duration. You can change it you want.
    ///
    /// Default is `defaultExpirationDuration`
    public var fetchExpirationDuration: TimeInterval = Lobster.defaultExpirationDuration

    /// A flag indicating whether to check for stale status or not.
    ///
    /// Default is `true`.
    public var useStaleChecker: Bool = true

    /// A value store to store `isStaled`, which is the flag to judge remote config stale or not.
    ///
    /// You can inject another value store conforming to `StaleValueStore` protocol.
    /// Default is UserDefaults.
    public var staleValueStore: StaleValueStore = UserDefaults.standard

    /// set/get `isStaled` flag.
    /// If `useStaleChecker` is true and `isStaled` is true, Lobster fetch remote config values from Firebase immediately ignoring cache expiration when you call `Lobster.shared.fetch(completion:)`
    public var isStaled: Bool {
        get { staleValueStore.isStaled }
        set { staleValueStore.isStaled = newValue }
    }

    /// Debug mode
    /// NOTE: It must be false on production.
    public var debugMode: Bool = false {
        didSet {
            remoteConfig.configSettings.minimumFetchInterval = debugMode ?
                0 :
                Lobster.defaultExpirationDuration
        }
    }
    public private(set) var fetchStatus: RemoteConfigFetchStatus = .noFetchYet

    /// Default value store.
    public let defaultsStore = DefaultsStore()

    /// Initializer
    ///
    /// This method is private to prevent a developer create a new instance of `Lobster`
    private init() {}

    /// Fetches config data from Firebase. If its cache hasn't expired, RemoteConfig won't fetch but will return cache data.
    ///
    /// - Parameters:
    ///   - completion: A closure that takes an error as its argument. If Lobster fetched config from Firebase successfully, the argument of error will be nil. Default is `an empty closure`.
    public func fetch(completion: @escaping (Error?) -> Void = { _ in }) {
        let duration = getExpirationDuration()
        remoteConfig.fetch(withExpirationDuration: duration) { [unowned self] (status, fetchError) in
            self.remoteConfig.activate { (activated, activateError) in
                let error = fetchError ?? activateError
                self.fetchStatus = status
                self.isStaled = false
                completion(error)
                NotificationCenter.default.post(name: Lobster.didFetchConfig, object: error)
            }
        }
    }

    /// Set default config values. By setting default config values, You can use these value safely before fetching config data from Firebase.
    ///
    /// - Parameters:
    ///   - defaults: A dictionary that will set as default config values
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

    /// Clear default values and then RemoteConfig's default values will be updated to empty.
    public func clearDefaults() {
        defaultsStore.clear()
        updateDefaults()
    }
    
    /// Returns expiration duration for RemoteConfig.
    /// - Returns: If you use `useStaleChecker` and `isStaled` is true, this function will return `0.0`. If not so, it will return `fetchExpirationDuration`.
    private func getExpirationDuration() -> TimeInterval {
        if useStaleChecker, isStaled {
            return 0.0
        }
        return fetchExpirationDuration
    }
    
    /// Updates default values of RemoteConfig by using values stored in `defaultStore`
    func updateDefaults() {
        RemoteConfig.remoteConfig().setDefaults(defaultsStore.asRemoteConfigDefaults())
    }
}

/// Extensions of Lobster
extension Lobster {
    /// The key of Notification. Lobster notifies you of finishing fetching config data from Firebase.
    ///
    /// - Note: If an error occurred while fetching data, it'll be included as the object of `Notification`.
    public static var didFetchConfig: Notification.Name { return Notification.Name("LobsterDidFetchConfig") }
}
