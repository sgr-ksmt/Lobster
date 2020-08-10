//
//  ConfigKeys.swift
//  SwiftUI-Demo
//
//  Created by Suguru Kishimoto on 2020/08/10.
//  Copyright © 2020 su-Tech. All rights reserved.
//

import Foundation
import Lobster

extension ConfigKeys {
    static let titleText = ConfigKey<String>("demo_title_text")
    static let titleColor = ConfigKey<UIColor>("demo_title_color")
    static let person = ConfigKey<Person>("demo_person")
}
