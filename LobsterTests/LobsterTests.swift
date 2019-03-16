//
//  ConfigKeyTests.swift
//  LobsterTests
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import XCTest
@testable import Lobster
import Firebase

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

struct Person: Codable, ConfigSerializable, Equatable {
    let name: String
    let age: Int
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

    static let direction = ConfigKey<Direction>("direction")
    static let directionOptional = ConfigKey<Direction?>("direction_optional")

    static let network = ConfigKey<NetWork>("network")
    static let networkOptional = ConfigKey<NetWork?>("network_optional")

    static let person = ConfigKey<Person>("person")
    static let personOptional = ConfigKey<Person?>("person_optional")

    static let names = ConfigKey<[String]>("names")
    static let namesOptional = ConfigKey<[String]?>("names_optional")

    static let scores = ConfigKey<[Int]>("scores")
    static let scoresOptional = ConfigKey<[Int]?>("score_optional")

    static let directions = ConfigKey<[Direction]>("directions")
    static let directionsOptional = ConfigKey<[Direction]?>("directions_optional")

    static let persons = ConfigKey<[Person]>("persons")
    static let personsOptional = ConfigKey<[Person]?>("persons_optional")
}

class LobsterTests: XCTestCase {

    override func setUp() {
        _ = FirebaseSetupHandler.handler
        Lobster.shared.clearDefaults()
    }

    override func tearDown() {
        Lobster.shared.clearDefaults()
    }

    func testStringValueKey() {
        XCTAssertEqual(Lobster.shared[.text], "")
        XCTAssertEqual(Lobster.shared[safe: .text], "")
        XCTAssertEqual(Lobster.shared[config: .text], "")
        XCTAssertEqual(Lobster.shared[safeConfig: .text], "")
        XCTAssertEqual(Lobster.shared[safeDefault: .text], nil)
        Lobster.shared[default: .text] = "abc"
        XCTAssertEqual(Lobster.shared[.text], "abc")
        XCTAssertEqual(Lobster.shared[safe: .text], "abc")
        XCTAssertEqual(Lobster.shared[config: .text], "abc")
        XCTAssertEqual(Lobster.shared[default: .text], "abc")
        XCTAssertEqual(Lobster.shared[safeConfig: .text], "abc")
        XCTAssertEqual(Lobster.shared[safeDefault: .text], "abc")

        XCTAssertEqual(Lobster.shared[.textOptional], "")
        XCTAssertEqual(Lobster.shared[config: .textOptional], "")
        XCTAssertEqual(Lobster.shared[default: .textOptional], nil)
        Lobster.shared[default: .textOptional] = "abc"
        XCTAssertEqual(Lobster.shared[.textOptional], "abc")
        XCTAssertEqual(Lobster.shared[config: .textOptional], "abc")
        XCTAssertEqual(Lobster.shared[default: .textOptional], "abc")
    }

    func testIntValueKey() {
        XCTAssertEqual(Lobster.shared[.price], 0)
        XCTAssertEqual(Lobster.shared[safe: .price], 0)
        XCTAssertEqual(Lobster.shared[config: .price], 0)
        XCTAssertEqual(Lobster.shared[safeConfig: .price], 0)
        XCTAssertEqual(Lobster.shared[safeDefault: .price], nil)
        Lobster.shared[default: .price] = 123
        XCTAssertEqual(Lobster.shared[.price], 123)
        XCTAssertEqual(Lobster.shared[safe: .price], 123)
        XCTAssertEqual(Lobster.shared[config: .price], 123)
        XCTAssertEqual(Lobster.shared[default: .price], 123)
        XCTAssertEqual(Lobster.shared[safeConfig: .price], 123)
        XCTAssertEqual(Lobster.shared[safeDefault: .price], 123)

        XCTAssertEqual(Lobster.shared[.priceOptional], 0)
        XCTAssertEqual(Lobster.shared[config: .priceOptional], 0)
        XCTAssertEqual(Lobster.shared[default: .priceOptional], nil)
        Lobster.shared[default: .priceOptional] = 123
        XCTAssertEqual(Lobster.shared[.priceOptional], 123)
        XCTAssertEqual(Lobster.shared[config: .priceOptional], 123)
        XCTAssertEqual(Lobster.shared[default: .priceOptional], 123)
    }

    func testDoubleValueKey() {
        XCTAssertEqual(Lobster.shared[.meter], 0.0)
        XCTAssertEqual(Lobster.shared[safe: .meter], 0.0)
        XCTAssertEqual(Lobster.shared[config: .meter], 0.0)
        XCTAssertEqual(Lobster.shared[safeConfig: .meter], 0.0)
        XCTAssertEqual(Lobster.shared[safeDefault: .meter], nil)
        Lobster.shared[default: .meter] = 1.5
        XCTAssertEqual(Lobster.shared[.meter], 1.5)
        XCTAssertEqual(Lobster.shared[safe: .meter], 1.5)
        XCTAssertEqual(Lobster.shared[config: .meter], 1.5)
        XCTAssertEqual(Lobster.shared[default: .meter], 1.5)
        XCTAssertEqual(Lobster.shared[safeConfig: .meter], 1.5)
        XCTAssertEqual(Lobster.shared[safeDefault: .meter], 1.5)

        XCTAssertEqual(Lobster.shared[.meterOptional], 0.0)
        XCTAssertEqual(Lobster.shared[config: .meterOptional], 0.0)
        XCTAssertEqual(Lobster.shared[default: .meterOptional], nil)
        Lobster.shared[default: .meterOptional] = 1.5
        XCTAssertEqual(Lobster.shared[.meterOptional], 1.5)
        XCTAssertEqual(Lobster.shared[config: .meterOptional], 1.5)
        XCTAssertEqual(Lobster.shared[default: .meterOptional], 1.5)
    }

    func testFloatValueKey() {
        XCTAssertEqual(Lobster.shared[.alpha], 0.0)
        XCTAssertEqual(Lobster.shared[safe: .alpha], 0.0)
        XCTAssertEqual(Lobster.shared[config: .alpha], 0.0)
        XCTAssertEqual(Lobster.shared[safeConfig: .alpha], 0.0)
        XCTAssertEqual(Lobster.shared[safeDefault: .alpha], nil)
        Lobster.shared[default: .alpha] = 1.5
        XCTAssertEqual(Lobster.shared[.alpha], 1.5)
        XCTAssertEqual(Lobster.shared[safe: .alpha], 1.5)
        XCTAssertEqual(Lobster.shared[config: .alpha], 1.5)
        XCTAssertEqual(Lobster.shared[default: .alpha], 1.5)
        XCTAssertEqual(Lobster.shared[safeConfig: .alpha], 1.5)
        XCTAssertEqual(Lobster.shared[safeDefault: .alpha], 1.5)

        XCTAssertEqual(Lobster.shared[.alphaOptional], 0.0)
        XCTAssertEqual(Lobster.shared[config: .alphaOptional], 0.0)
        XCTAssertEqual(Lobster.shared[default: .alphaOptional], nil)
        Lobster.shared[default: .alphaOptional] = 1.5
        XCTAssertEqual(Lobster.shared[.alphaOptional], 1.5)
        XCTAssertEqual(Lobster.shared[config: .alphaOptional], 1.5)
        XCTAssertEqual(Lobster.shared[default: .alphaOptional], 1.5)
    }

    func testBoolValueKey() {
        XCTAssertEqual(Lobster.shared[.flag], false)
        XCTAssertEqual(Lobster.shared[safe: .flag], false)
        XCTAssertEqual(Lobster.shared[config: .flag], false)
        XCTAssertEqual(Lobster.shared[safeConfig: .flag], false)
        XCTAssertEqual(Lobster.shared[safeDefault: .flag], nil)
        Lobster.shared[default: .flag] = true
        XCTAssertEqual(Lobster.shared[.flag], true)
        XCTAssertEqual(Lobster.shared[safe: .flag], true)
        XCTAssertEqual(Lobster.shared[config: .flag], true)
        XCTAssertEqual(Lobster.shared[default: .flag], true)
        XCTAssertEqual(Lobster.shared[safeConfig: .flag], true)
        XCTAssertEqual(Lobster.shared[safeDefault: .flag], true)

        XCTAssertEqual(Lobster.shared[.flagOptional], false)
        XCTAssertEqual(Lobster.shared[config: .flagOptional], false)
        XCTAssertEqual(Lobster.shared[default: .flagOptional], nil)
        Lobster.shared[default: .flagOptional] = true
        XCTAssertEqual(Lobster.shared[.flagOptional], true)
        XCTAssertEqual(Lobster.shared[config: .flagOptional], true)
        XCTAssertEqual(Lobster.shared[default: .flagOptional], true)
    }

    func testURLValueKey() {
        XCTAssertEqual(Lobster.shared[safe: .url], nil)
        XCTAssertEqual(Lobster.shared[safeConfig: .url], nil)
        XCTAssertEqual(Lobster.shared[safeDefault: .url], nil)
        Lobster.shared[default: .url] = URL(string: "https://example.com")!
        XCTAssertEqual(Lobster.shared[.url].absoluteString, "https://example.com")
        XCTAssertEqual(Lobster.shared[safe: .url]?.absoluteString, "https://example.com")
        XCTAssertEqual(Lobster.shared[config: .url].absoluteString, "https://example.com")
        XCTAssertEqual(Lobster.shared[default: .url].absoluteString, "https://example.com")
        XCTAssertEqual(Lobster.shared[safe: .url]?.absoluteString, "https://example.com")
        XCTAssertEqual(Lobster.shared[safeConfig: .url]?.absoluteString, "https://example.com")
        XCTAssertEqual(Lobster.shared[safeDefault: .url]?.absoluteString, "https://example.com")

        XCTAssertEqual(Lobster.shared[.urlOptional], nil)
        XCTAssertEqual(Lobster.shared[config: .urlOptional], nil)
        XCTAssertEqual(Lobster.shared[default: .urlOptional], nil)
        Lobster.shared[default: .urlOptional] = URL(string: "https://example.com")
        XCTAssertEqual(Lobster.shared[.urlOptional]?.absoluteString, "https://example.com")
        XCTAssertEqual(Lobster.shared[config: .urlOptional]?.absoluteString, "https://example.com")
        XCTAssertEqual(Lobster.shared[default: .urlOptional]?.absoluteString, "https://example.com")
    }

    func testIntEnumValueKey() {
        XCTAssertEqual(Lobster.shared[.direction], .unknown)
        XCTAssertEqual(Lobster.shared[safe: .direction], .unknown)
        XCTAssertEqual(Lobster.shared[config: .direction], .unknown)
        XCTAssertEqual(Lobster.shared[safeConfig: .direction], .unknown)
        XCTAssertEqual(Lobster.shared[safeDefault: .direction], nil)
        Lobster.shared[default: .direction] = .back
        XCTAssertEqual(Lobster.shared[.direction], .back)
        XCTAssertEqual(Lobster.shared[safe: .direction], .back)
        XCTAssertEqual(Lobster.shared[config: .direction], .back)
        XCTAssertEqual(Lobster.shared[default: .direction], .back)
        XCTAssertEqual(Lobster.shared[safeConfig: .direction], .back)
        XCTAssertEqual(Lobster.shared[safeDefault: .direction], .back)

        XCTAssertEqual(Lobster.shared[.directionOptional], .unknown)
        XCTAssertEqual(Lobster.shared[config: .directionOptional], .unknown)
        XCTAssertEqual(Lobster.shared[default: .directionOptional], nil)
        Lobster.shared[default: .directionOptional] = .forward
        XCTAssertEqual(Lobster.shared[.directionOptional], .forward)
        XCTAssertEqual(Lobster.shared[config: .directionOptional], .forward)
        XCTAssertEqual(Lobster.shared[default: .directionOptional], .forward)
    }

    func testStringEnumValueKey() {
        XCTAssertEqual(Lobster.shared[.network], .unknown)
        XCTAssertEqual(Lobster.shared[safe: .network], .unknown)
        XCTAssertEqual(Lobster.shared[config: .network], .unknown)
        XCTAssertEqual(Lobster.shared[safeConfig: .network], .unknown)
        XCTAssertEqual(Lobster.shared[safeDefault: .network], nil)
        Lobster.shared[default: .network] = .wifi
        XCTAssertEqual(Lobster.shared[.network], .wifi)
        XCTAssertEqual(Lobster.shared[safe: .network], .wifi)
        XCTAssertEqual(Lobster.shared[config: .network], .wifi)
        XCTAssertEqual(Lobster.shared[default: .network], .wifi)
        XCTAssertEqual(Lobster.shared[safeConfig: .network], .wifi)
        XCTAssertEqual(Lobster.shared[safeDefault: .network], .wifi)

        XCTAssertEqual(Lobster.shared[.networkOptional], .unknown)
        XCTAssertEqual(Lobster.shared[config: .networkOptional], .unknown)
        XCTAssertEqual(Lobster.shared[default: .networkOptional], nil)
        Lobster.shared[default: .networkOptional] = .LTE
        XCTAssertEqual(Lobster.shared[.networkOptional], .LTE)
        XCTAssertEqual(Lobster.shared[config: .networkOptional], .LTE)
        XCTAssertEqual(Lobster.shared[default: .networkOptional], .LTE)
    }

    func testCodableValueKey() {
        XCTAssertEqual(Lobster.shared[safe: .person], nil)
        XCTAssertEqual(Lobster.shared[safeConfig: .person], nil)
        XCTAssertEqual(Lobster.shared[safeDefault: .person], nil)
        Lobster.shared[default: .person] = Person(name: "John", age: 10)
        XCTAssertEqual(Lobster.shared[.person].name, "John")
        XCTAssertEqual(Lobster.shared[.person].age, 10)
        XCTAssertEqual(Lobster.shared[safe: .person]?.name, "John")
        XCTAssertEqual(Lobster.shared[safe: .person]?.age, 10)
        XCTAssertEqual(Lobster.shared[config: .person].name, "John")
        XCTAssertEqual(Lobster.shared[config: .person].age, 10)
        XCTAssertEqual(Lobster.shared[default: .person].name, "John")
        XCTAssertEqual(Lobster.shared[default: .person].age, 10)
        XCTAssertEqual(Lobster.shared[safe: .person]?.name, "John")
        XCTAssertEqual(Lobster.shared[safe: .person]?.age, 10)
        XCTAssertEqual(Lobster.shared[safeConfig: .person]?.name, "John")
        XCTAssertEqual(Lobster.shared[safeConfig: .person]?.age, 10)
        XCTAssertEqual(Lobster.shared[safeDefault: .person]?.name, "John")
        XCTAssertEqual(Lobster.shared[safeDefault: .person]?.age, 10)

        XCTAssertEqual(Lobster.shared[.networkOptional], .unknown)
        XCTAssertEqual(Lobster.shared[default: .networkOptional], nil)
        Lobster.shared[default: .networkOptional] = .LTE
        XCTAssertEqual(Lobster.shared[.networkOptional], .LTE)
        XCTAssertEqual(Lobster.shared[default: .networkOptional], .LTE)
    }

    func testCodableArrayValueKey() {
        XCTAssertEqual(Lobster.shared[safe: .names], nil)
        XCTAssertEqual(Lobster.shared[safeConfig: .names], nil)
        XCTAssertEqual(Lobster.shared[safeDefault: .names], nil)
        Lobster.shared[default: .names] = ["John", "Mike"]
        XCTAssertEqual(Lobster.shared[.names], ["John", "Mike"])
        XCTAssertEqual(Lobster.shared[safe: .names], ["John", "Mike"])
        XCTAssertEqual(Lobster.shared[config: .names], ["John", "Mike"])
        XCTAssertEqual(Lobster.shared[default: .names], ["John", "Mike"])
        XCTAssertEqual(Lobster.shared[safeConfig: .names], ["John", "Mike"])
        XCTAssertEqual(Lobster.shared[safeDefault: .names], ["John", "Mike"])

        XCTAssertEqual(Lobster.shared[.namesOptional], nil)
        XCTAssertEqual(Lobster.shared[config: .namesOptional], nil)
        XCTAssertEqual(Lobster.shared[default: .namesOptional], nil)
        Lobster.shared[default: .namesOptional] = ["John", "Mike"]
        XCTAssertEqual(Lobster.shared[.namesOptional], ["John", "Mike"])
        XCTAssertEqual(Lobster.shared[config: .namesOptional], ["John", "Mike"])
        XCTAssertEqual(Lobster.shared[default: .namesOptional], ["John", "Mike"])

        XCTAssertEqual(Lobster.shared[safe: .scores], nil)
        XCTAssertEqual(Lobster.shared[safeConfig: .scores], nil)
        XCTAssertEqual(Lobster.shared[safeDefault: .scores], nil)
        Lobster.shared[default: .scores] = [20, 50, 80, 100]
        XCTAssertEqual(Lobster.shared[.scores], [20, 50, 80, 100])
        XCTAssertEqual(Lobster.shared[safe: .scores], [20, 50, 80, 100])
        XCTAssertEqual(Lobster.shared[config: .scores], [20, 50, 80, 100])
        XCTAssertEqual(Lobster.shared[default: .scores], [20, 50, 80, 100])
        XCTAssertEqual(Lobster.shared[safeConfig: .scores], [20, 50, 80, 100])
        XCTAssertEqual(Lobster.shared[safeDefault: .scores], [20, 50, 80, 100])

        XCTAssertEqual(Lobster.shared[.scoresOptional], nil)
        XCTAssertEqual(Lobster.shared[config: .scoresOptional], nil)
        XCTAssertEqual(Lobster.shared[default: .scoresOptional], nil)
        Lobster.shared[default: .scoresOptional] = [20, 50, 80, 100]
        XCTAssertEqual(Lobster.shared[.scoresOptional], [20, 50, 80, 100])
        XCTAssertEqual(Lobster.shared[config: .scoresOptional], [20, 50, 80, 100])
        XCTAssertEqual(Lobster.shared[default: .scoresOptional], [20, 50, 80, 100])

        XCTAssertEqual(Lobster.shared[safe: .directions], nil)
        XCTAssertEqual(Lobster.shared[safeConfig: .directions], nil)
        XCTAssertEqual(Lobster.shared[safeDefault: .directions], nil)
        Lobster.shared[default: .directions] = [.forward, .back, .left, .right]
        XCTAssertEqual(Lobster.shared[.directions], [.forward, .back, .left, .right])
        XCTAssertEqual(Lobster.shared[safe: .directions], [.forward, .back, .left, .right])
        XCTAssertEqual(Lobster.shared[config: .directions], [.forward, .back, .left, .right])
        XCTAssertEqual(Lobster.shared[default: .directions], [.forward, .back, .left, .right])
        XCTAssertEqual(Lobster.shared[safeConfig: .directions], [.forward, .back, .left, .right])
        XCTAssertEqual(Lobster.shared[safeDefault: .directions], [.forward, .back, .left, .right])

        XCTAssertEqual(Lobster.shared[.directionsOptional], nil)
        XCTAssertEqual(Lobster.shared[config: .directionsOptional], nil)
        XCTAssertEqual(Lobster.shared[default: .directionsOptional], nil)
        Lobster.shared[default: .directionsOptional] = [.forward, .back, .left, .right]
        XCTAssertEqual(Lobster.shared[.directionsOptional], [.forward, .back, .left, .right])
        XCTAssertEqual(Lobster.shared[config: .directionsOptional], [.forward, .back, .left, .right])
        XCTAssertEqual(Lobster.shared[default: .directionsOptional], [.forward, .back, .left, .right])

        XCTAssertEqual(Lobster.shared[safe: .persons], nil)
        XCTAssertEqual(Lobster.shared[safeConfig: .persons], nil)
        XCTAssertEqual(Lobster.shared[safeDefault: .persons], nil)
        Lobster.shared[default: .persons] = [Person(name: "John", age: 10), Person(name: "Mike", age: 12)]
        XCTAssertEqual(Lobster.shared[.persons], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
        XCTAssertEqual(Lobster.shared[safe: .persons], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
        XCTAssertEqual(Lobster.shared[config: .persons], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
        XCTAssertEqual(Lobster.shared[default: .persons], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
        XCTAssertEqual(Lobster.shared[safeConfig: .persons], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
        XCTAssertEqual(Lobster.shared[safeDefault: .persons], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])

        XCTAssertEqual(Lobster.shared[.personsOptional], nil)
        XCTAssertEqual(Lobster.shared[config: .personsOptional], nil)
        XCTAssertEqual(Lobster.shared[default: .personsOptional], nil)
        Lobster.shared[default: .personsOptional] = [Person(name: "John", age: 10), Person(name: "Mike", age: 12)]
        XCTAssertEqual(Lobster.shared[.personsOptional], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
        XCTAssertEqual(Lobster.shared[config: .personsOptional], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
        XCTAssertEqual(Lobster.shared[default: .personsOptional], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
    }
}
