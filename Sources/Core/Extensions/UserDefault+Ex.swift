//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import Foundation

/// Extension for UserDefaults.
extension UserDefaults: StaleValueStore {
    public var isStaled: Bool {
        get { bool(forKey: Self.key) }
        set { set(newValue, forKey: Self.key) }
    }
}
