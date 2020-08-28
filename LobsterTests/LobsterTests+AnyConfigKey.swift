//
//  LobsterTests+AnyConfigKey.swift
//  LobsterTests
//
//  Created by Suguru Kishimoto on 2020/08/28.
//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import XCTest
@testable import Lobster

class LobsterAnyConfigKeyTests: XCTestCase {

    func testConvert() {
        XCTContext.runActivity(named: "config key") { _ in
            let key = AnyConfigKey(ConfigKeys.text)
            XCTAssertEqual(key.type, .normal)
            XCTAssertEqual(ConfigKeys.text._key, key._key)
            XCTAssertEqual(
                String(describing: type(of: ConfigKeys.text)),
                String(describing: type(of: key.asConfigKey()!))
            )
        }

        XCTContext.runActivity(named: "decodable cofig key") { _ in
            let key = AnyConfigKey(ConfigKeys.settings)
            XCTAssertEqual(key.type, .decodable)
            XCTAssertEqual(ConfigKeys.settings._key, key._key)
            XCTAssertEqual(
                String(describing: type(of: ConfigKeys.settings)),
                String(describing: type(of: key.asDecodableConfigKey()!))
            )
        }

        XCTContext.runActivity(named: "codable cofig key") { _ in
            let key = AnyConfigKey(ConfigKeys.person)
            XCTAssertEqual(key.type, .codable)
            XCTAssertEqual(ConfigKeys.person._key, key._key)
            XCTAssertEqual(
                String(describing: type(of: ConfigKeys.person)),
                String(describing: type(of: key.asCodableConfigKey()!))
            )
        }
    }
}
