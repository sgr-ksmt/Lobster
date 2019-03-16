//
//  ConfigSerializable+Builtin.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

extension String: ConfigSerializable {
    public static var _config: ConfigBridge<String> { return ConfigStringBridge() }

    public static var _configArray: ConfigBridge<[String]> {
        fatalError()
    }
}
