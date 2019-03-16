# Lobster
Type-safe Firebase-RemoteConfig helper library


[![GitHub release](https://img.shields.io/github/release/sgr-ksmt/Lobster.svg)](https://github.com/sgr-ksmt/Lobster/releases)
![Language](https://img.shields.io/badge/language-Swift%204.1-orange.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=flat)](https://cocoapods.org/pods/Lobster)
[![CocoaPodsDL](https://img.shields.io/cocoapods/dt/Lobster.svg)](https://cocoapods.org/pods/Lobster)

## Feature
- Make config value **type safe.** ✨
- Easy to set default value by key-value subscripting.
- Custom type available ✨
  - `String`/`Int` enum
  - `Decodable`(read-only) and `Codable`.

**There's only three steps to using Lobster:**

- Define `ConfigKey`

```swift
extension ConfigKeys {
    static let welcomeTitle = ConfigKey<String>("welcome_title")
    static let welcomeTitleColor = ConfigKey<UIColor>("welcome_title_color")
}
```

- Define value in Firebase project

![](docs/img1.png)

- Just use it!

```swift
// Set default value
Lobster.shared[default: .welcomeTitle] = "Welcome"
Lobster.shared[default: .welcomeTitleColor] = .black
self.titleLabel.text = Lobster.shared[.welcomeTitle]

// Fetch remote-config
Lobster.shared.fetch { [weak self] _ in
    self?.titleLabel.text = Lobster.shared[.welcomeTitle]
    self?.titleLabel.textColor = Lobster.shared[.welcomeTitleColor]
}
```

You can get Type-Safed value through subscripting syntax`([])` by defining `ConfigKey`.

## How to use
### Fetch latest value from remote.
```swift
Lobster.shared.fetch { [weak self] error in
    if let error = error {
        print(error)
    }
    self?.titleLabel.text = Lobster.shared[.titleText]
}
```

### Get value
Use subscripting syntax.

- Non-Optional

```swift
extension ConfigKeys {
    static let text = ConfigKey<String>("text")
}

// Get value.
// If value didn't fetch from remote yet. returns default value (if exists).
let text: String = Lobster.shared[.text]
let text: String = Lobster.shared[config: .text]
let text: String = Lobster.shared[default: .text]

let text: String? = Lobster.shared[safe: .text]
let text: String? = Lobster.shared[safeConfig: .text]
let text: String? = Lobster.shared[safeDefault: .text]
```

- Optional

```swift
extension ConfigKeys {
    static let textOptional = ConfigKey<String?>("text_optional")
}

let text: String? = Lobster.shared[.textOptional]
let text: String? = Lobster.shared[config: .textOptional]
let text: String? = Lobster.shared[default: .textOptional]
```

### Set Default value
You can set default values using `subscripting syntax` or plist.

```swift
// Set default value using `[default:]` syntax.
Lobster.shared[default: .titleText] = "Cart Items"
Lobster.shared[default: .titleColor] = .black

// or load from `defaults.plist`
Lobster.shared.setDefaults(fromPlist: "defaults")
```

### Set debug mode
```swift
// Enable debug mode (development only)
Lobster.shared.debugMode = true
Lobster.shared.fetchExpirationDuration = 0.0
```

### isStaled

```swift
Lobster.shared.fetchExpirationDuration = 60 * 12

Lobster.shared.isStaled = true

// Default expire duration is 12 hours.
// But if `isStaled` set to true,
// Lobster fetch values from remote ignoring expire duration.
Lobster.shared.fetch()
```

### Demo
Required: CocoaPods 1.5 or higher.

```bash
$ cd path/to/Lobster
$ bundle install
$ cd ./Demo
$ bundle exec pod install
$ open Demo.xcworkspace
```

## Supported types

Lobster supports more types as default followings:

- String
- Int
- Float
- Double
- Bool
- Data
- URL
- enum(String/Int)
- Decodable Object
- Codable Object
- Collection(Array)
  - String
  - Int
  - Float
  - Double
  - Bool
  - Data
  - URL
  - enum(String/Int)
  - Decodable Object
  - Codable Object
- Dictionary

#### URL
support text: e.g. `"https://example.com"`.

![](docs/img2.png)

#### UIColor
support only HEX sttring like `"#FF00FF"`.

![](docs/img3.png)

#### CGPoint
support text: e.g. `"[100, 100]"`
→ Use `DecodableConfigKey`(or `CodableConfigKey`)

```swift
extension ConfigKeys {
    static let labelOrigin = ConfigKey<CGPoint>("label_origin")
}
```

#### CGSize
support text: e.g. `"[100, 100]"`
→ Use `DecodableConfigKey`(or `CodableConfigKey`)

```swift
extension ConfigKeys {
    static let boxSize = ConfigKey<CGSize>("box_size")
}
```

#### CGRect
support text: e.g. `"[10, 10, 100, 100]"`
→ Use `DecodableConfigKey`(or `CodableConfigKey`)

```swift
extension ConfigKeys {
    static let boxRect = ConfigKey<CGRect>("box_rect")
}
```

<br />

![](docs/img4.png)

#### Enum
supports `Int` or `String` rawValue.
If you want to use other enum, see "Use custom value".

#### Decodable compliant type
read only

#### Codable compliant type
can set default value / read config value


## Use custom value
You can easily define custom key in order to get remote value.

### Ex 1: enum

```swift
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

// define subscript
extension Lobster {
    subscript(_ key: ConfigKey<Status>) -> Status? {
        get { return Status(value: configValue(forKey: key._key)) }
        set { setDefaultValue(newValue?.value, forKey: key._key) }
    }
}

// define ConfigKey
extension ConfigKeys {
    static let status = ConfigKey<Status>("status")
}

// Use
// set default value
Lobster.shared[.status] = .foo("bar")

// get config value
if let status = Lobster.shared[.status] {
    // ...
}
```

To define subscript makes it possible to access custom enum.

### Ex 2: Decodable compliant type
Just adapt class or struct to Decodable or Codable

```swift
struct Person: Codable {
    let name: String
    let age: Int
    let country: String
}

extension ConfigKeys {
    static let person = CodableConfigKey<Person>("person")
}
```

Define config value like below:

![](docs/img5.png)

## Requirements
- iOS 11.0+
- Xcode 10+
- Swift 4.2

## Installation
### CocoaPods
**Lobster** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Lobster', '~> 2.0'
```

and run `pod install`

### Manually Install
Download all `*.swift` files and put your project.

## Special Thanks
Lobster is inspired by [SwiftyUserDefaults](https://github.com/radex/SwiftyUserDefaults)

## Communication
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.:muscle:

## License
**Lobster** is under MIT license. See the [LICENSE](LICENSE) file for more info.
