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
import SDWebImage

extension ConfigKeys {
    static let titleText = ConfigKey<String>("title_text")
    static let titleColor = ConfigKey<UIColor>("title_color")
    static let boxSize = CodableConfigKey<CGSize>("box_size")
    static let person = CodableConfigKey<Person>("person")
    static let backgroundImageURL = ConfigKey<URL>("background_image_url")
    static let myEnum1 = ConfigKey<MyEnum1>("my_enum")
    static let status = ConfigKey<Status>("status")
}

enum MyEnum1: Int {
    case invalid
    case A
    case B
    case C
}

enum Status {
    case invalid
    case foo(String)
    case bar(String)

    init(value: String?) {
        guard let value = value else {
            self = .invalid
            return
        }
        let separated = value.components(separatedBy: ":")
        guard let query: (String, String) = separated.first.flatMap({ f in separated.last.flatMap({ l in (f, l) })}) else {
            self = .invalid
            return
        }
        switch query {
        case ("foo", let x):
            self = .foo(x)
        case ("bar", let x):
            self = .bar(x)
        default:
            self = .invalid
        }
    }

    var value: String {
        switch self {
        case .foo(let x):
            return "foo:\(x)"
        case .bar(let x):
            return "bar:\(x)"
        default:
            return ""
        }
    }
}

extension Lobster {
    subscript(_ key: ConfigKey<Status>) -> Status? {
        get { return Status(value: configValue(forKey: key._key)) }
        set { setDefaultValue(newValue?.value, forKey: key._key) }
    }
}


struct Person: Codable {
    let name: String
    let age: Int
    let country: String
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
            Lobster.shared[.titleText] = "Demo Project"
            Lobster.shared[.titleColor] = .gray
            Lobster.shared[.boxSize] = .zero
            Lobster.shared[.person] = Person(name: "Taro", age: 18, country: "Japan")
            Lobster.shared[.myEnum1] = .A
            Lobster.shared[.status] = .foo("baz")
        }

        updateUI()

    }

    @objc private func fetch(_ button: UIButton) {
        Lobster.shared.fetch { [weak self] _ in
            self?.updateUI()
        }
    }

    private func updateUI() {
        titleLabel.text = Lobster.shared[.titleText]
        titleLabel.textColor = Lobster.shared[.titleColor]

        let boxSize = Lobster.shared[.boxSize] ?? .zero
        personViewWidthConstraint.constant = boxSize.width
        personViewHeightConstraint.constant = boxSize.width

        if let person = Lobster.shared[.person] {
            personNameLabel.text = "Name : \(person.name)"
            personAgeLabel.text = "Age: \(person.age)"
            personCountryLabel.text = "Country: \(person.country)"
        }

        backgroundImageView.sd_setImage(with: Lobster.shared[.backgroundImageURL], completed: nil)
    }
}

