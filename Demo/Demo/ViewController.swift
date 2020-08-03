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
    static let titleText = ConfigKey<String>("demo_title_text")
    static let titleColor = ConfigKey<UIColor>("demo_title_color")
    static let person = ConfigKey<Person>("demo_person")
    static let status = ConfigKey<Status>("demo_status")
}

class ViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var personViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var personViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var personNameLabel: UILabel!
    @IBOutlet private weak var personAgeLabel: UILabel!
    @IBOutlet private weak var personCountryLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var fetchButton: UIButton! {
        didSet {
            fetchButton.layer.masksToBounds = true
            fetchButton.layer.cornerRadius = 4.0
            fetchButton.addTarget(self, action: #selector(fetch(_:)), for: .touchUpInside)
        }
    }

    let loadFromPlist = false

    override func viewDidLoad() {
        super.viewDidLoad()
        Lobster.shared.debugMode = true
        Lobster.shared.fetchExpirationDuration = 0.0

        if loadFromPlist {
            Lobster.shared.setDefaults(fromPlist: "defaults")
        } else {
            Lobster.shared[default: .titleText] = "Demo Project"
            Lobster.shared[default: .titleColor] = .gray
            Lobster.shared[default: .person] = Person(name: "Taro", age: 18, country: "Japan")
            Lobster.shared[default: .status] = .inactive
        }

        updateUI()

    }

    @objc private func fetch(_ button: UIButton) {
        Lobster.shared.fetch { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }

    private func updateUI() {
        titleLabel.text = Lobster.shared[.titleText]
        titleLabel.textColor = Lobster.shared[.titleColor]

        let person = Lobster.shared[.person]
        personNameLabel.text = "Name : \(person.name)"
        personAgeLabel.text = "Age: \(person.age)"
        personCountryLabel.text = "Country: \(person.country)"
    }
}

