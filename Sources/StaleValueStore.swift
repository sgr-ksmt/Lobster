//
//  StaleValueStore.swift
//  Lobster
//
//  Created by sgr-ksmt on 2019/03/16.
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
