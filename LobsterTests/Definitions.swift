//
//  Definitions.swift
//  LobsterTests
//
//  Created by Suguru Kishimoto on 2020/08/10.
//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import XCTest
@testable import Lobster

enum Direction: Int, ConfigSerializable {
    case unknown = 0, forward, back, left, right
}

enum NetWork: String, ConfigSerializable {
    case unknown, LTE, wifi
    init(rawValue: String) {
        switch rawValue.uppercased() {
        case "LTE":
            self = .LTE
        case "WIFI":
            self = .wifi
        default:
            self = .unknown
        }
    }
}

struct Settings: Decodable, ConfigSerializable, Equatable {
    let flag: Bool
    let minimumVersion: String
}

struct Person: Codable, ConfigSerializable, Equatable {
    let name: String
    let age: Int
}

class MockStaleValueStore: StaleValueStore {
    var isStaled: Bool = false
}

extension ConfigKeys {
    static let text = ConfigKey<String>("text")
    static let textOptional = ConfigKey<String?>("text_optional")

    static let price = ConfigKey<Int>("price")
    static let priceOptional = ConfigKey<Int?>("price_optional")

    static let meter = ConfigKey<Double>("meter")
    static let meterOptional = ConfigKey<Double?>("meter_optional")

    static let alpha = ConfigKey<Float>("alpha")
    static let alphaOptional = ConfigKey<Float?>("alpha_optional")

    static let flag = ConfigKey<Bool>("flag")
    static let flagOptional = ConfigKey<Bool?>("flag_optional")

    static let url = ConfigKey<URL>("url")
    static let urlOptional = ConfigKey<URL?>("url_optional")

    static let bgColor = ConfigKey<UIColor>("bg_color")
    static let bgColorOptional = ConfigKey<UIColor?>("bg_color_optional")

    static let direction = ConfigKey<Direction>("direction")
    static let directionOptional = ConfigKey<Direction?>("direction_optional")

    static let network = ConfigKey<NetWork>("network")
    static let networkOptional = ConfigKey<NetWork?>("network_optional")

    static let settings = DecodableConfigKey<Settings>("settings")
    static let settingsOptional = DecodableConfigKey<Settings?>("settings_optional")

    static let person = CodableConfigKey<Person>("person")
    static let personOptional = CodableConfigKey<Person?>("person_optional")

    static let names = ConfigKey<[String]>("names")
    static let namesOptional = ConfigKey<[String]?>("names_optional")

    static let scores = ConfigKey<[Int]>("scores")
    static let scoresOptional = ConfigKey<[Int]?>("score_optional")

    static let directions = ConfigKey<[Direction]>("directions")
    static let directionsOptional = ConfigKey<[Direction]?>("directions_optional")

    static let persons = CodableConfigKey<[Person]>("persons")
    static let personsOptional = CodableConfigKey<[Person]?>("persons_optional")
}

extension ConfigKeys {
    static let title = ConfigKey<String>("title")
    static let titleOptional = ConfigKey<String?>("title_optional")
    static let count = ConfigKey<Int>("count")
    static let friendNames = ConfigKey<[String]>("friend_names")
    static let mike = CodableConfigKey<Person>("mike")
}
