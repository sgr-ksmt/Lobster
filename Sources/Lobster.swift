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
    static let lobsterDidFetchConfig = Notification.Name("LobsterDidFetchConfig")
}

public class Lobster {
    public static let shared = Lobster()

    public var fetchExpirationDuration: TimeInterval = 43_200.0
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

    public func fetch(completion: @escaping () -> Void = {}) {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchExpirationDuration) { [unowned self] (status, error) in
            guard error == nil else {
                return
            }
            RemoteConfig.remoteConfig().activateFetched()
            self.fetchStatus = status
            completion()
            NotificationCenter.default.post(name: .lobsterDidFetchConfig, object: nil)
        }
    }

    public func setDefaults(_ defaults: [String: Any]) {
        _setDefaults(defaults.reduce(into: [:]) {
            if let value = $1.value as? NSObject { $0[$1.key] = value }
        })
    }

    public func setDefaults(fromPlist plistFileName: String, bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: plistFileName, withExtension: "plist") else { return }
        guard let defaults = NSDictionary(contentsOf: url) as? [String: NSObject] else { return }
        _setDefaults(defaults)
    }

    func _setDefaults(_ defaults: [String: NSObject]) {
        self.defaults = defaults.reduce(into: self.defaults) { $0[$1.key] = $1.value }
        updateDefaults()
    }

    public func removeValue<ValueType>(forKey key: ConfigKey<ValueType>) {
        defaults[key._key] = nil
        updateDefaults()
    }

    public func removeDefaults() {
        defaults = [:]
        updateDefaults()
    }

    func updateDefaults() {
        RemoteConfig.remoteConfig().setDefaults(defaults)
    }
}
