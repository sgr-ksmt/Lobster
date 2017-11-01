//
//  ViewController.swift
//  Demo
//
//  Created by suguru-kishimoto on 2017/11/02.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit
import Lobster
import FirebaseRemoteConfig

extension ConfigKeys {
    static let titleText = ConfigKey<String>("title_text")
    static let titleColor = ConfigKey<UIColor>("title_color")
    static let boxSize = CodableConfigKey<CGSize>("box_size")
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Lobster.shared.debugMode = true
        Lobster.shared.fetchExpirationDuration = 0.0

        Lobster.shared[.titleText] = "Demo Project"
        Lobster.shared[.boxSize] = CGSize(width: 100, height: 100)

        Lobster.shared.fetch {
            print(Lobster.shared.fetchStatus.rawValue as Any)
            print(Lobster.shared[.titleText])
            print(Lobster.shared[default: .titleText] as Any)
            print(Lobster.shared[.titleColor] as Any)
            print(Lobster.shared[default: .titleColor] as Any)

            print(Lobster.shared[.boxSize] as Any)
            print(Lobster.shared[default: .boxSize])
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

