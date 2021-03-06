//
//  FirebaseSetupHandler.swift
//  LobsterTests
//
//  Created by sgr-ksmt on 2019/03/16.
//  Copyright © 2019 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseCore

class FirebaseSetupHandler {
    static let handler: FirebaseSetupHandler = FirebaseSetupHandler()
    private init() {
        let options = FirebaseOptions(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "GoogleService-Info", ofType: "plist")!)!
        FirebaseApp.configure(options: options)
    }
}
