//
//  Lobster.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2017/10/31.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import UIKit

public class Lobster {
    /// Returns shared instance.
    public static let shared = Lobster()

    /// Returns FIRRemoteConfig instance.
    public let remoteConfig = RemoteConfig.remoteConfig()

    /// Default expiration duration. (12 hours)
    public static let defaultExpirationDuration: TimeInterval = 43_200.0

    /// Expiration duration for cache. Default duration is 12 hours
    public var fetchExpirationDuration: TimeInterval = Lobster.defaultExpirationDuration

    /// The flag whether to do stale check. Default is `true`.
    public var useStaleChecker: Bool = true

    /// `isStaled` flag's value store, Default is UserDefaults.
    public var staleValueStore: StaleValueStore = UserDefaults.standard

    /// set/get `isStaled` flag.
    /// If `useStaleChecker` is true and `isStaled` is true, fetch remote config values immediately.
    public var isStaled: Bool {
        get {
            return staleValueStore.isStaled
        }
        set {
            staleValueStore.isStaled = newValue
        }
    }

    /// Debug mode
    /// NOTE: It must be false on production.
    public var debugMode: Bool = false {
        didSet {
            remoteConfig.configSettings.minimumFetchInterval = debugMode ? 0 : Lobster.defaultExpirationDuration
        }
    }
    public private(set) var fetchStatus: RemoteConfigFetchStatus = .noFetchYet

    /// Default value store.
    public let defaultsStore = DefaultsStore()

    private init() {}

    /// Fetch config from remote.
    ///
    /// - Parameter completion: Fetch operation callback.
    public func fetch(completion: @escaping (Error?) -> Void = { _ in }) {
        let duration = getExpirationDuration()
        remoteConfig.fetch(withExpirationDuration: duration) { [unowned self] (status, error) in
            var fetchError: Error? = error
            RemoteConfig.remoteConfig().activate { (error) in
                fetchError = error ?? fetchError
                self.fetchStatus = status
                self.isStaled = false
                completion(fetchError)
                NotificationCenter.default.post(name: Lobster.didFetchConfig, object: error)
            }
        }
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

    /// Clear default values.
    public func clearDefaults() {
        defaultsStore.clear()
        updateDefaults()
    }

    private func getExpirationDuration() -> TimeInterval {
        if useStaleChecker, isStaled {
            return 0.0
        }
        return fetchExpirationDuration
    }

    func updateDefaults() {
        RemoteConfig.remoteConfig().setDefaults(defaultsStore.asRemoteConfigDefaults())
    }
}

extension Lobster {
    /// Notification's key of Lobster when config fetched.
    public static var didFetchConfig: Notification.Name { return Notification.Name("LobsterDidFetchConfig") }
}
