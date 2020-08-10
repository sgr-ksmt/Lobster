//
//  SceneDelegate.swift
//  SwiftUI-Demo
//
//  Created by Suguru Kishimoto on 2020/08/10.
//  Copyright © 2020 su-Tech. All rights reserved.
//

import UIKit
import SwiftUI
import Lobster
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        FirebaseApp.configure()
        Lobster.shared.debugMode = true
        Lobster.shared.fetchExpirationDuration = 0
        Lobster.shared[default: .titleText] = "Demo Project"
        Lobster.shared[default: .titleColor] = .gray
        Lobster.shared[default: .person] = Person(name: "Taro", age: 18, country: "Japan")


        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
