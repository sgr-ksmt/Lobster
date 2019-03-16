//
//  ConfigSerializable.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

public protocol ConfigSerializable {
    associatedtype T

    static var _config: ConfigBridge<T> { get }
    static var _configArray: ConfigBridge<[T]> { get }
}
