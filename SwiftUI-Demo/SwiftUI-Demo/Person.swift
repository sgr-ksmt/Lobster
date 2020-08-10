//
//  Person.swift
//  SwiftUI-Demo
//
//  Created by Suguru Kishimoto on 2020/08/10.
//  Copyright © 2020 su-Tech. All rights reserved.
//

import Foundation
import Lobster

struct Person: Codable, ConfigSerializable {
    let name: String
    let age: Int
    let country: String
}
