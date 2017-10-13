[![platform-image]][iOS-url]
[![lic-image]](LICENSE)

>---
- **[Introduction](#introduction)**
- **[Requirements](#Requirements)**
- **[Installation](#Installation)**

>---
## Introduction
   Variable functions programming in Swift. For examples:
- **[YSKit](Documentation/Animal.md)**

    This SDK supply some common Swift base functions, like string catgory, data catgory etc. [How to use](Documentation/Animal.md)
- **[YSKit/Rabbit](Documentation/Rabbit.md)**

    A solution for net image likes SDWebImage or Nuke. This SDK include all functions of YSKit. [How to use](Documentation/Rabbit.md)

## Requirements

* Xcode 8.0
* Swift 3.0

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

**Search with `pod search YSKit` `**

* Include **YSKit** functions
```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'YSKit',    '~> 0.0.1'
end
```

* Include **YSKit/Rabbit** functions
```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'YSKit/Rabbit',    '~> 0.0.1'
end
```



[iOS-url]: https://developer.apple.com/library/content/navigation/#section=Platforms&topic=iOS
[lic-image]: https://img.shields.io/dub/l/vibe-d.svg
[platform-image]: https://img.shields.io/badge/platform-iOS-orange.svg
[building-image]: https://img.shields.io/travis/USER/REPO.svg