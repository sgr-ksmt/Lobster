//
//  ViewController.swift
//  Demo
//
//  Created by suguru-kishimoto on 2017/11/02.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit
import Lobster

extension ConfigKeys {
    static let titleText = ConfigKey<String>("title_text")
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Lobster.shared.debugMode = true

        Lobster.shared[.titleText] = "Demo Project"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

