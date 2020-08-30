//
//  LobsterTests+AnyConfigKey.swift
//  LobsterTests
//
//  Created by Suguru Kishimoto on 2020/08/28.
//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import XCTest
@testable import Lobster
import Firebase

class LobsterAnyConfigKeyTests: XCTestCase {

    override func setUp() {
        _ = FirebaseSetupHandler.handler
        Lobster.shared.clearDefaults()
    }

    override func tearDown() {
        Lobster.shared.clearDefaults()
    }
    
    func testConvert() {
        XCTContext.runActivity(named: "config key") { _ in
            let key = AnyConfigKey(ConfigKeys.text)
            XCTAssertEqual(key.type, .normal)
            XCTAssertEqual(ConfigKeys.text._key, key._key)
            XCTAssertEqual(
                String(describing: type(of: ConfigKeys.text)),
                String(describing: type(of: key.asConfigKey()!))
            )
            XCTAssertNil(key.decoder())
            XCTAssertNil(key.encoder())
        }

        XCTContext.runActivity(named: "decodable cofig key") { _ in
            let key = AnyConfigKey(ConfigKeys.settings)
            XCTAssertEqual(key.type, .decodable)
            XCTAssertEqual(ConfigKeys.settings._key, key._key)
            XCTAssertEqual(
                String(describing: type(of: ConfigKeys.settings)),
                String(describing: type(of: key.asDecodableConfigKey()!))
            )
            XCTAssertNotNil(key.decoder())
            XCTAssertNil(key.encoder())
        }

        XCTContext.runActivity(named: "codable cofig key") { _ in
            let key = AnyConfigKey(ConfigKeys.person)
            XCTAssertEqual(key.type, .codable)
            XCTAssertEqual(ConfigKeys.person._key, key._key)
            XCTAssertEqual(
                String(describing: type(of: ConfigKeys.person)),
                String(describing: type(of: key.asCodableConfigKey()!))
            )
            XCTAssertNotNil(key.decoder())
            XCTAssertNotNil(key.encoder())
        }
    }

    func testStringValueKey() {
        XCTContext.runActivity(named: "String key") { _ in
            let key = AnyConfigKey(ConfigKeys.text)
            XCTAssertEqual(Lobster.shared[key], "")
            XCTAssertEqual(Lobster.shared[safe: key], "")
            XCTAssertEqual(Lobster.shared[config: key], "")
            XCTAssertEqual(Lobster.shared[safeConfig: key], "")
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = "abc"
            XCTAssertEqual(Lobster.shared[key], "abc")
            XCTAssertEqual(Lobster.shared[safe: key], "abc")
            XCTAssertEqual(Lobster.shared[config: key], "abc")
            XCTAssertEqual(Lobster.shared[default: key], "abc")
            XCTAssertEqual(Lobster.shared[safeConfig: key], "abc")
            XCTAssertEqual(Lobster.shared[safeDefault: key], "abc")
        }

        XCTContext.runActivity(named: "Optional<String> key") { _ in
            let key = AnyConfigKey(ConfigKeys.textOptional)
            XCTAssertEqual(Lobster.shared[key], "")
            XCTAssertEqual(Lobster.shared[config: key], "")
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = "abc"
            XCTAssertEqual(Lobster.shared[key], "abc")
            XCTAssertEqual(Lobster.shared[config: key], "abc")
            XCTAssertEqual(Lobster.shared[default: key], "abc")
        }
    }

    func testIntValueKey() {
        XCTContext.runActivity(named: "Int key") { _ in
            let key = AnyConfigKey(ConfigKeys.price)
            XCTAssertEqual(Lobster.shared[key], 0)
            XCTAssertEqual(Lobster.shared[safe: key], 0)
            XCTAssertEqual(Lobster.shared[config: key], 0)
            XCTAssertEqual(Lobster.shared[safeConfig: key], 0)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = 123
            XCTAssertEqual(Lobster.shared[key], 123)
            XCTAssertEqual(Lobster.shared[safe: key], 123)
            XCTAssertEqual(Lobster.shared[config: key], 123)
            XCTAssertEqual(Lobster.shared[default: key], 123)
            XCTAssertEqual(Lobster.shared[safeConfig: key], 123)
            XCTAssertEqual(Lobster.shared[safeDefault: key], 123)

        }

        XCTContext.runActivity(named: "Optional<Int> key") { _ in
            let key = AnyConfigKey(ConfigKeys.priceOptional)
            XCTAssertEqual(Lobster.shared[key], 0)
            XCTAssertEqual(Lobster.shared[config: key], 0)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = 123
            XCTAssertEqual(Lobster.shared[key], 123)
            XCTAssertEqual(Lobster.shared[config: key], 123)
            XCTAssertEqual(Lobster.shared[default: key], 123)
        }
    }

    func testDoubleValueKey() {
        XCTContext.runActivity(named: "Double key") { _ in
            let key = AnyConfigKey(ConfigKeys.meter)
            XCTAssertEqual(Lobster.shared[key], 0.0)
            XCTAssertEqual(Lobster.shared[safe: key], 0.0)
            XCTAssertEqual(Lobster.shared[config: key], 0.0)
            XCTAssertEqual(Lobster.shared[safeConfig: key], 0.0)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = 1.5
            XCTAssertEqual(Lobster.shared[key], 1.5)
            XCTAssertEqual(Lobster.shared[safe: key], 1.5)
            XCTAssertEqual(Lobster.shared[config: key], 1.5)
            XCTAssertEqual(Lobster.shared[default: key], 1.5)
            XCTAssertEqual(Lobster.shared[safeConfig: key], 1.5)
            XCTAssertEqual(Lobster.shared[safeDefault: key], 1.5)
        }

        XCTContext.runActivity(named: "Optional<Double> key") { _ in
            let key = AnyConfigKey(ConfigKeys.meterOptional)
            XCTAssertEqual(Lobster.shared[key], 0.0)
            XCTAssertEqual(Lobster.shared[config: key], 0.0)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = 1.5
            XCTAssertEqual(Lobster.shared[key], 1.5)
            XCTAssertEqual(Lobster.shared[config: key], 1.5)
            XCTAssertEqual(Lobster.shared[default: key], 1.5)
        }
    }

    func testFloatValueKey() {
        XCTContext.runActivity(named: "Float key") { _ in
            let key = AnyConfigKey(ConfigKeys.alpha)
            XCTAssertEqual(Lobster.shared[key], 0.0)
            XCTAssertEqual(Lobster.shared[safe: key], 0.0)
            XCTAssertEqual(Lobster.shared[config: key], 0.0)
            XCTAssertEqual(Lobster.shared[safeConfig: key], 0.0)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = 1.5
            XCTAssertEqual(Lobster.shared[key], 1.5)
            XCTAssertEqual(Lobster.shared[safe: key], 1.5)
            XCTAssertEqual(Lobster.shared[config: key], 1.5)
            XCTAssertEqual(Lobster.shared[default: key], 1.5)
            XCTAssertEqual(Lobster.shared[safeConfig: key], 1.5)
            XCTAssertEqual(Lobster.shared[safeDefault: key], 1.5)
        }
    }

    func testBoolValueKey() {
        XCTContext.runActivity(named: "Bool key") { _ in
            let key = AnyConfigKey(ConfigKeys.flag)
            XCTAssertEqual(Lobster.shared[key], false)
            XCTAssertEqual(Lobster.shared[safe: key], false)
            XCTAssertEqual(Lobster.shared[config: key], false)
            XCTAssertEqual(Lobster.shared[safeConfig: key], false)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = true
            XCTAssertEqual(Lobster.shared[key], true)
            XCTAssertEqual(Lobster.shared[safe: key], true)
            XCTAssertEqual(Lobster.shared[config: key], true)
            XCTAssertEqual(Lobster.shared[default: key], true)
            XCTAssertEqual(Lobster.shared[safeConfig: key], true)
            XCTAssertEqual(Lobster.shared[safeDefault: key], true)
        }

        XCTContext.runActivity(named: "Optional<Bool> key") { _ in
            let key = AnyConfigKey(ConfigKeys.flagOptional)
            XCTAssertEqual(Lobster.shared[key], false)
            XCTAssertEqual(Lobster.shared[config: key], false)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = true
            XCTAssertEqual(Lobster.shared[key], true)
            XCTAssertEqual(Lobster.shared[config: key], true)
            XCTAssertEqual(Lobster.shared[default: key], true)
        }
    }

    func testURLValueKey() {
        XCTContext.runActivity(named: "URL key") { _ in
            let key = AnyConfigKey(ConfigKeys.url)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default:key] = URL(string: "https://example.com")!
            XCTAssertEqual(Lobster.shared[key].absoluteString, "https://example.com")
            XCTAssertEqual(Lobster.shared[safe: key]?.absoluteString, "https://example.com")
            XCTAssertEqual(Lobster.shared[config: key].absoluteString, "https://example.com")
            XCTAssertEqual(Lobster.shared[default: key].absoluteString, "https://example.com")
            XCTAssertEqual(Lobster.shared[safe: key]?.absoluteString, "https://example.com")
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.absoluteString, "https://example.com")
            XCTAssertEqual(Lobster.shared[safeDefault: key]?.absoluteString, "https://example.com")
        }

        XCTContext.runActivity(named: "Optional<URL> key") { _ in
            let key = AnyConfigKey(ConfigKeys.urlOptional)
            XCTAssertEqual(Lobster.shared[key], nil)
            XCTAssertEqual(Lobster.shared[config: key], nil)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = URL(string: "https://example.com")
            XCTAssertEqual(Lobster.shared[key]?.absoluteString, "https://example.com")
            XCTAssertEqual(Lobster.shared[config: key]?.absoluteString, "https://example.com")
            XCTAssertEqual(Lobster.shared[default: key]?.absoluteString, "https://example.com")
        }
    }

    func testColorValueKey() {
        XCTContext.runActivity(named: "UIColor key") { _ in
            let key = AnyConfigKey(ConfigKeys.bgColor)
            XCTAssertEqual(Lobster.shared[safe: key], .clear)
            XCTAssertEqual(Lobster.shared[safeConfig: key], .clear)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = .red
            XCTAssertEqual(Lobster.shared[key], .red)
            XCTAssertEqual(Lobster.shared[safe: key], .red)
            XCTAssertEqual(Lobster.shared[config: key], .red)
            XCTAssertEqual(Lobster.shared[default: key], .red)
            XCTAssertEqual(Lobster.shared[safe: key], .red)
            XCTAssertEqual(Lobster.shared[safeConfig: key], .red)
            XCTAssertEqual(Lobster.shared[safeDefault: key], .red)
        }

        XCTContext.runActivity(named: "Optional<UIColor> key") { _ in
            let key = AnyConfigKey(ConfigKeys.bgColorOptional)
            XCTAssertEqual(Lobster.shared[key], .clear)
            XCTAssertEqual(Lobster.shared[config: key], .clear)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = .green
            XCTAssertEqual(Lobster.shared[key], .green)
            XCTAssertEqual(Lobster.shared[config: key], .green)
            XCTAssertEqual(Lobster.shared[default: key], .green)
        }
    }

    func testIntEnumValueKey() {
        XCTContext.runActivity(named: "Enum Int key") { _ in
            let key = AnyConfigKey(ConfigKeys.direction)
            XCTAssertEqual(Lobster.shared[key], .unknown)
            XCTAssertEqual(Lobster.shared[safe: key], .unknown)
            XCTAssertEqual(Lobster.shared[config: key], .unknown)
            XCTAssertEqual(Lobster.shared[safeConfig: key], .unknown)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = .back
            XCTAssertEqual(Lobster.shared[key], .back)
            XCTAssertEqual(Lobster.shared[safe: key], .back)
            XCTAssertEqual(Lobster.shared[config: key], .back)
            XCTAssertEqual(Lobster.shared[default: key], .back)
            XCTAssertEqual(Lobster.shared[safeConfig: key], .back)
            XCTAssertEqual(Lobster.shared[safeDefault: key], .back)
        }

        XCTContext.runActivity(named: "Optional<Enum Int> key") { _ in
            let key = AnyConfigKey(ConfigKeys.directionOptional)
            XCTAssertEqual(Lobster.shared[key], .unknown)
            XCTAssertEqual(Lobster.shared[config: key], .unknown)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = .forward
            XCTAssertEqual(Lobster.shared[key], .forward)
            XCTAssertEqual(Lobster.shared[config: key], .forward)
            XCTAssertEqual(Lobster.shared[default: key], .forward)
        }
    }

    func testStringEnumValueKey() {
        XCTContext.runActivity(named: "Enum String key") { _ in
            let key = AnyConfigKey(ConfigKeys.network)
            XCTAssertEqual(Lobster.shared[key], .unknown)
            XCTAssertEqual(Lobster.shared[safe: key], .unknown)
            XCTAssertEqual(Lobster.shared[config: key], .unknown)
            XCTAssertEqual(Lobster.shared[safeConfig: key], .unknown)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = .wifi
            XCTAssertEqual(Lobster.shared[key], .wifi)
            XCTAssertEqual(Lobster.shared[safe: key], .wifi)
            XCTAssertEqual(Lobster.shared[config: key], .wifi)
            XCTAssertEqual(Lobster.shared[default: key], .wifi)
            XCTAssertEqual(Lobster.shared[safeConfig: key], .wifi)
            XCTAssertEqual(Lobster.shared[safeDefault: key], .wifi)
        }

        XCTContext.runActivity(named: "Optional<Enum String> key") { _ in
            let key = AnyConfigKey(ConfigKeys.networkOptional)
            XCTAssertEqual(Lobster.shared[key], .unknown)
            XCTAssertEqual(Lobster.shared[config: key], .unknown)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = .LTE
            XCTAssertEqual(Lobster.shared[key], .LTE)
            XCTAssertEqual(Lobster.shared[config: key], .LTE)
            XCTAssertEqual(Lobster.shared[default: key], .LTE)
        }
    }

    func testDecodableValueKey() {
        let settingsJson = """
{"flag": true, "minimumVersion": "1.0.1"}
"""

        XCTContext.runActivity(named: "Decodable key") { _ in
            let key = AnyConfigKey(ConfigKeys.settings)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            Lobster.shared.remoteConfig.setDefaults([ConfigKeys.settings._key: NSString(string: settingsJson)])
            XCTAssertEqual(Lobster.shared[safe: key]?.flag, true)
            XCTAssertEqual(Lobster.shared[safe: key]?.minimumVersion, "1.0.1")
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.flag, true)
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.minimumVersion, "1.0.1")
        }

        XCTContext.runActivity(named: "Optional<Decodable> key") { _ in
            let key = AnyConfigKey(ConfigKeys.settingsOptional)
            XCTAssertEqual(Lobster.shared[key], nil)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[config: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            Lobster.shared.remoteConfig.setDefaults([ConfigKeys.settingsOptional._key: NSString(string: settingsJson)])
            XCTAssertEqual(Lobster.shared[key]?.flag, true)
            XCTAssertEqual(Lobster.shared[key]?.minimumVersion, "1.0.1")
            XCTAssertEqual(Lobster.shared[safe: key]?.flag, true)
            XCTAssertEqual(Lobster.shared[safe: key]?.minimumVersion, "1.0.1")
            XCTAssertEqual(Lobster.shared[config: key]?.flag, true)
            XCTAssertEqual(Lobster.shared[config: key]?.minimumVersion, "1.0.1")
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.flag, true)
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.minimumVersion, "1.0.1")
        }
    }

    func testCodableValueKey() {
        XCTContext.runActivity(named: "Codable key") { _ in
            let key = AnyConfigKey(ConfigKeys.person)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = Person(name: "John", age: 10)
            XCTAssertEqual(Lobster.shared[key].name, "John")
            XCTAssertEqual(Lobster.shared[key].age, 10)
            XCTAssertEqual(Lobster.shared[safe: key]?.name, "John")
            XCTAssertEqual(Lobster.shared[safe: key]?.age, 10)
            XCTAssertEqual(Lobster.shared[config: key].name, "John")
            XCTAssertEqual(Lobster.shared[config: key].age, 10)
            XCTAssertEqual(Lobster.shared[default: key].name, "John")
            XCTAssertEqual(Lobster.shared[default: key].age, 10)
            XCTAssertEqual(Lobster.shared[safe: key]?.name, "John")
            XCTAssertEqual(Lobster.shared[safe: key]?.age, 10)
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.name, "John")
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.age, 10)
            XCTAssertEqual(Lobster.shared[safeDefault: key]?.name, "John")
            XCTAssertEqual(Lobster.shared[safeDefault: key]?.age, 10)
        }

        XCTContext.runActivity(named: "Optional<Codable> key") { _ in
            let key = AnyConfigKey(ConfigKeys.personOptional)
            XCTAssertEqual(Lobster.shared[key], nil)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = Person(name: "John", age: 10)
            XCTAssertEqual(Lobster.shared[key].name, "John")
            XCTAssertEqual(Lobster.shared[key].age, 10)
            XCTAssertEqual(Lobster.shared[safe: key]?.name, "John")
            XCTAssertEqual(Lobster.shared[safe: key]?.age, 10)
            XCTAssertEqual(Lobster.shared[config: key].name, "John")
            XCTAssertEqual(Lobster.shared[config: key].age, 10)
            XCTAssertEqual(Lobster.shared[default: key].name, "John")
            XCTAssertEqual(Lobster.shared[default: key].age, 10)
            XCTAssertEqual(Lobster.shared[safe: key]?.name, "John")
            XCTAssertEqual(Lobster.shared[safe: key]?.age, 10)
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.name, "John")
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.age, 10)
            XCTAssertEqual(Lobster.shared[safeDefault: key]?.name, "John")
            XCTAssertEqual(Lobster.shared[safeDefault: key]?.age, 10)
        }
    }

    func testCodableWithCodingModifier() {
        let timestampJson = """
    {"date": "2014-10-10T13:50:40+09:00"}
    """
        let expectedDate = { () -> Date in
            let f = ISO8601DateFormatter()
            return f.date(from: "2014-10-10T13:50:40+09:00")!
        }()

        XCTContext.runActivity(named: "Decodable key with coding modifier") { _ in
            let key = AnyConfigKey(ConfigKeys.timestamp)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            Lobster.shared.remoteConfig.setDefaults([ConfigKeys.timestamp._key: NSString(string: timestampJson)])
            XCTAssertEqual(Lobster.shared[safe: key]?.date, expectedDate)
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.date, expectedDate)
        }

        XCTContext.runActivity(named: "Optional<Decodable> key with coding modifier") { _ in
            let key = AnyConfigKey(ConfigKeys.timestampOptional)
            XCTAssertEqual(Lobster.shared[key], nil)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[config: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            Lobster.shared.remoteConfig.setDefaults([ConfigKeys.timestampOptional._key: NSString(string: timestampJson)])
            XCTAssertEqual(Lobster.shared[key]?.date, expectedDate)
            XCTAssertEqual(Lobster.shared[safe: key]?.date, expectedDate)
            XCTAssertEqual(Lobster.shared[config: key]?.date, expectedDate)
            XCTAssertEqual(Lobster.shared[safeConfig: key]?.date, expectedDate)
        }
    }

    func testCodableArrayValueKey() {
        XCTContext.runActivity(named: "Array<String> key") { _ in
            let key = AnyConfigKey(ConfigKeys.names)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = ["John", "Mike"]
            XCTAssertEqual(Lobster.shared[key], ["John", "Mike"])
            XCTAssertEqual(Lobster.shared[safe: key], ["John", "Mike"])
            XCTAssertEqual(Lobster.shared[config: key], ["John", "Mike"])
            XCTAssertEqual(Lobster.shared[default: key], ["John", "Mike"])
            XCTAssertEqual(Lobster.shared[safeConfig: key], ["John", "Mike"])
            XCTAssertEqual(Lobster.shared[safeDefault: key], ["John", "Mike"])
        }

        XCTContext.runActivity(named: "Array<Optional<String>> key") { _ in
            let key = AnyConfigKey(ConfigKeys.namesOptional)
            XCTAssertEqual(Lobster.shared[key], nil)
            XCTAssertEqual(Lobster.shared[config: key], nil)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = ["John", "Mike"]
            XCTAssertEqual(Lobster.shared[key], ["John", "Mike"])
            XCTAssertEqual(Lobster.shared[config: key], ["John", "Mike"])
            XCTAssertEqual(Lobster.shared[default: key], ["John", "Mike"])
        }

        XCTContext.runActivity(named: "Array<Int> key") { _ in
            let key = AnyConfigKey(ConfigKeys.scores)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = [20, 50, 80, 100]
            XCTAssertEqual(Lobster.shared[key], [20, 50, 80, 100])
            XCTAssertEqual(Lobster.shared[safe: key], [20, 50, 80, 100])
            XCTAssertEqual(Lobster.shared[config: key], [20, 50, 80, 100])
            XCTAssertEqual(Lobster.shared[default: key], [20, 50, 80, 100])
            XCTAssertEqual(Lobster.shared[safeConfig: key], [20, 50, 80, 100])
            XCTAssertEqual(Lobster.shared[safeDefault: key], [20, 50, 80, 100])
        }

        XCTContext.runActivity(named: "Array<Optional<Int>> key") { _ in
            let key = AnyConfigKey(ConfigKeys.scoresOptional)
            XCTAssertEqual(Lobster.shared[key], nil)
            XCTAssertEqual(Lobster.shared[config: key], nil)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = [20, 50, 80, 100]
            XCTAssertEqual(Lobster.shared[key], [20, 50, 80, 100])
            XCTAssertEqual(Lobster.shared[config: key], [20, 50, 80, 100])
            XCTAssertEqual(Lobster.shared[default: key], [20, 50, 80, 100])
        }

        XCTContext.runActivity(named: "Array<Enum Int> key") { _ in
            let key = AnyConfigKey(ConfigKeys.directions)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = [.forward, .back, .left, .right]
            XCTAssertEqual(Lobster.shared[key], [.forward, .back, .left, .right])
            XCTAssertEqual(Lobster.shared[safe: key], [.forward, .back, .left, .right])
            XCTAssertEqual(Lobster.shared[config: key], [.forward, .back, .left, .right])
            XCTAssertEqual(Lobster.shared[default: key], [.forward, .back, .left, .right])
            XCTAssertEqual(Lobster.shared[safeConfig: key], [.forward, .back, .left, .right])
            XCTAssertEqual(Lobster.shared[safeDefault: key], [.forward, .back, .left, .right])
        }

        XCTContext.runActivity(named: "Array<Optional<Enum Int>> key") { _ in
            let key = AnyConfigKey(ConfigKeys.directionsOptional)
            XCTAssertEqual(Lobster.shared[key], nil)
            XCTAssertEqual(Lobster.shared[config: key], nil)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = [.forward, .back, .left, .right]
            XCTAssertEqual(Lobster.shared[key], [.forward, .back, .left, .right])
            XCTAssertEqual(Lobster.shared[config: key], [.forward, .back, .left, .right])
            XCTAssertEqual(Lobster.shared[default: key], [.forward, .back, .left, .right])
        }

        XCTContext.runActivity(named: "Array<Codable> key") { _ in
            let key = AnyConfigKey(ConfigKeys.persons)
            XCTAssertEqual(Lobster.shared[safe: key], nil)
            XCTAssertEqual(Lobster.shared[safeConfig: key], nil)
            XCTAssertEqual(Lobster.shared[safeDefault: key], nil)
            Lobster.shared[default: key] = [Person(name: "John", age: 10), Person(name: "Mike", age: 12)]
            XCTAssertEqual(Lobster.shared[key], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
            XCTAssertEqual(Lobster.shared[safe: key], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
            XCTAssertEqual(Lobster.shared[config: key], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
            XCTAssertEqual(Lobster.shared[default: key], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
            XCTAssertEqual(Lobster.shared[safeConfig: key], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
            XCTAssertEqual(Lobster.shared[safeDefault: key], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
        }

        XCTContext.runActivity(named: "Array<Optional<Codable>> key") { _ in
            let key = AnyConfigKey(ConfigKeys.personsOptional)
            XCTAssertEqual(Lobster.shared[key], nil)
            XCTAssertEqual(Lobster.shared[config: key], nil)
            XCTAssertEqual(Lobster.shared[default: key], nil)
            Lobster.shared[default: key] = [Person(name: "John", age: 10), Person(name: "Mike", age: 12)]
            XCTAssertEqual(Lobster.shared[key], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
            XCTAssertEqual(Lobster.shared[config: key], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
            XCTAssertEqual(Lobster.shared[default: key], [Person(name: "John", age: 10), Person(name: "Mike", age: 12)])
        }
    }
}
