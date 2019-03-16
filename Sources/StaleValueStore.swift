//
//  StaleValueStore.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation

public protocol StaleValueStore {
    var isStaled: Bool { get set }
}

extension StaleValueStore {
    var key: String {
        return "StaleValueStore.isStaled"
    }
}

extension UserDefaults: StaleValueStore {
    public var isStaled: Bool {
        set { set(newValue, forKey: key) }
        get { return bool(forKey: key) }
    }
}
