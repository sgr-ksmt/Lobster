//
//  CustomTypes.swift
//  Demo
//
//  Created by suguru-kishimoto on 2019/03/17.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import Lobster

final class ConfigStatusBridge: ConfigBridge<Status> {
    typealias T = Status
    override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value?.value
    }

    override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].stringValue.flatMap(Status.init(value:))
    }

    override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return (defaultsStore[key] as? String).flatMap(Status.init(value:))
    }
}

enum Status: ConfigSerializable {
    static var _config: ConfigBridge<Status> { return ConfigStatusBridge() }
    static var _configArray: ConfigBridge<[Status]> { fatalError("Not implemented") }

    case unknown
    case active
    case inactive

    init(value: String?) {
        guard let value = value else {
            self = .unknown
            return
        }
        switch value {
        case "active": self = .active
        case "inactive": self = .inactive
        default: self = .unknown
        }
    }

    var value: String {
        switch self {
        case .active: return "active"
        case .inactive: return "inactive"
        default: return ""
        }
    }
}

struct Person: Codable, ConfigSerializable {
    let name: String
    let age: Int
    let country: String
}

