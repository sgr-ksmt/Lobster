# Lobster

Type-safe Firebase-RemoteConfig helper library.


[![GitHub release](https://img.shields.io/github/release/sgr-ksmt/Lobster.svg?style=for-the-badge)](https://github.com/sgr-ksmt/Lobster/releases)
![Language](https://img.shields.io/badge/language-Swift%205.0-orange.svg?style=for-the-badge)  

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=for-the-badge)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-compatible-4BC51D.svg?style=for-the-badge)](https://cocoapods.org/pods/Lobster)

## Feature

- Can get a value from RemoteConfig / set a value to RemoteConfig to type-safe.
- Easy to set default value to RemoteConfig by using key-value subscripting.
- Custom type available ✨
  - `String`/`Int` enum
  - `Decodable`(read-only) and `Codable`.
- Can manage expiration duration of config values.
- Combine framwork support.

---

## Getting Started

- [API Documentation](https://sgr-ksmt.github.io/Lobster/index.html)
- Example Apps
  - [Swift Demo](https://github.com/sgr-ksmt/Lobster/tree/master/Demo)
  - [SwiftUI + Combine Demo](https://github.com/sgr-ksmt/Lobster/tree/master/SwiftUI-Demo)

## Basic Usage

**You can integrate Lobster in a few steps implementation:**

### 1. Define `ConfigKey`

```swift
extension ConfigKeys {
    static let welcomeTitle = ConfigKey<String>("welcome_title")
    static let welcomeTitleColor = ConfigKey<UIColor>("welcome_title_color")
}
```

### 2. Register value to Firebase Project

[Go to Firebase Project](https://console.firebase.google.com/) and set values you want to get.

![](readme-docs/img1.png)


### 3. Let's use Lobster

```swift
import Lobster

// Set default value
Lobster.shared[default: .welcomeTitle] = "Welcome"
Lobster.shared[default: .welcomeTitleColor] = .black

self.titleLabel.text = Lobster.shared[.welcomeTitle]

// Fetch remote-config
Lobster.shared.fetch { _ in
    dispatchQueue.main.async { [weak self] in
        self?.titleLabel.text = Lobster.shared[.welcomeTitle]
        self?.titleLabel.textColor = Lobster.shared[.welcomeTitleColor]
    }
}
```

## Tips for you

### Combine

You can get values from Lobster with Combine's stream.  
Here is a sampl viewmodel class.

```swift
import Lobster
import Combine

extension ConfigKeys {
    static let title = ConfigKey<String>("title")
}

final class ViewModel: ObservableObject {
    @Published var title: String
    private var cancellables: Set<AnyCancellable> = []

    init() {
        title = Lobster.shared[.titleText]

        Lobster.shared.combine.fetched(.title)
            .receive(on: RunLoop.main)
            .assign(to: \.title, on: self)
            .store(in: &cancellables)
    }
}
```

NOTE: You need to install `Lobster/Combine` before using it.

### Get value with subscripting syntax.

Use subscripting syntax.

- Non-Optional

```swift
extension ConfigKeys {
    static let text = ConfigKey<String>("text")
}

// Get value from config.
// If value didn't fetch from remote yet. returns default value (if exists).
let text: String = Lobster.shared[.text]

// Get value from only config.
// it is possible to crash if value didn't fetch from remote yet.
let text: String = Lobster.shared[config: .text]

// Get value from only default.
// It is possible to crash if the default value is not set yet.
let text: String = Lobster.shared[default: .text]

// [safe:], [safeConfig:], [safeDefault:] subscripting syntax.
// It is safe because they return nil if they have no value.(return type is `Optional<T>`.)
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

If you set `isStaled` to true, Lobster will fetch remote value ignoring `fetchExpirationDuration`.  
That is, You can retrieve config values immediately when you call `fetch` after You set `isStales` to true.  
And `isStaled` will be set to `false` after fetched remote value.

```swift
Lobster.shared.fetchExpirationDuration = 60 * 12

Lobster.shared.isStaled = true

// Default expire duration is 12 hours.
// But if `isStaled` set to true,
// Lobster fetch values from remote ignoring expire duration.
Lobster.shared.fetch()
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
- UIColor
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

### TODO

- [ ] CGPoint
- [ ] CGSize
- [ ] CGRect
- [ ] Dictionary

#### URL

Supports text: 

![](readme-docs/img2.png)

#### UIColor

Supports only HEX string like `"#FF00FF"`.

![](readme-docs/img3.png)

#### Enum

supports `Int` or `String` rawValue.
It can be used only by adapting `ConfigSerializable`.
If you want to use other enum, see ***Use custom value***.

#### Decodable compliant type

read only

#### Codable compliant type

can set default value / read config value


## Advanced Usage

You can easily get/set a value of custom type.  
If you want to get/set `ValueType` (It's a custom type that Lobster doesn't support), you need to implement these steps:

- Conform `ConfigSerializable` to the `ValueType`
- Create `ConfigBridge<ValueType>
- Define `ConfigKey<ValueType>`

### Example case 1: Enum

```swift
// Adapt protocol `ConfigSerializable`
enum Status: ConfigSerializable {
    // Define `_config`, `_configArray`(If needed).
    // Custom ConfigBridge's definition see below.
    static var _config: ConfigBridge<Status> { return ConfigStatusBridge() }
    static var _configArray: ConfigBridge<[Status]> { fatalError("Not implemented") }

    case unknown
    case active
    case inactive

    init(value: String?) {
        guard let value = value else {
            self = .unknown
            return
        }
        switch value {
        case "active": self = .active
        case "inactive": self = .inactive
        default: self = .unknown
        }
    }

    var value: String {
        switch self {
        case .active: return "active"
        case .inactive: return "inactive"
        default: return ""
        }
    }
}

// Define Bridge class
final class ConfigStatusBridge: ConfigBridge<Status> {
    typealias T = Status

    // Save value to default store
    override func save(key: String, value: T?, defaultsStore: DefaultsStore) {
        defaultsStore[key] = value?.value
    }

    // Get value from RemoteConfig
    override func get(key: String, remoteConfig: RemoteConfig) -> T? {
        return remoteConfig[key].stringValue.flatMap(Status.init(value:))
    }

    // Get value from default store
    override func get(key: String, defaultsStore: DefaultsStore) -> T? {
        return (defaultsStore[key] as? String).flatMap(Status.init(value:))
    }
}

// Define ConfigKey
extension ConfigKeys {
    static let status = ConfigKey<Status>
}

// Set default
Lobster.shared[default: .status] = .inactive

// Use value
Lobster.shared.fetch { _ in
    let currentStatus = Lobster.shared[.status]
}
```

To define subscript makes it possible to access custom enum.

### Example Case 2: Decodable compliant type

Just adapt `Decodable` or `Codable` to class or struct and adapt `ConfigSerializable`

```swift
struct Person: Codable, ConfigSerializable {
    let name: String
    let age: Int
    let country: String
}

extension ConfigKeys {
    static let person = CodableConfigKey<Person>("person")
}
```

Define config value like below in console:

![](readme-docs/img5.png)


## Requirements
- iOS 11.0+
- Xcode 10+
- Swift 5.0

## Installation

### [CocoaPods](https://cocoapods.org/)

**Lobster** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Lobster', '~> 3.1.0'

# If you want to use extensions of Combine, please install below:
pod 'Lobster/Combine'
```

and run `pod install`

## Development

- 1: setup project

```bash
$ cd path/to/Lobster
$ make
```

- 2: prepare `GoogleService-Info.plist`

Due to security issues, I'm not providing `GoogleService-Info.plist` file.
So please prepare it yourself in your Firebase Project.  
And Please make Firebase App's bundle identifier `-.test.LobsterTests`.  
After that, put it into `LobsterTests/`.


<img src="readme-docs/img6.png" width="500" />

## Communication
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.:muscle:

## License
**Lobster** is under MIT license. See the [LICENSE](LICENSE) file for more info.
