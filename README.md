[![travis-image]][travis-url]
[![platform-image]][iOS-url]
[![lic-image]](LICENSE)

>---
- **[Introduction](#introduction)**
- **[Requirements](#Requirements)**
- **[Installation](#Installation)**

>---
## Introduction
   Variable functions programming in Swift. For examples:
- **[YsSwift](Documentation/Animal.md)**

    This SDK supply some common Swift base functions, like string catgory, data catgory etc. [How to use](Documentation/Animal.md)
- **[YsSwift/Rabbit](Documentation/Rabbit.md)**

    A solution for net image likes SDWebImage or Nuke. This SDK include all functions of YSKit. [How to use](Documentation/Rabbit.md)

## Requirements

* Xcode 8.0
* Swift 3.0

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

**Search with `pod search YsSwift` `**

* Include **YsSwift** functions
```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'YsSwift',    '~> 0.0.1'
end
```

* Include **YsSwift/Rabbit** functions
```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'YsSwift/Rabbit',    '~> 0.0.1'
end
```



[iOS-url]: https://developer.apple.com/library/content/navigation/#section=Platforms&topic=iOS

[travis-url]: https://travis-ci.org/gb-6k-house/YsSwift
[lic-image]: https://img.shields.io/dub/l/vibe-d.svg
[platform-image]: https://img.shields.io/badge/platform-iOS-orange.svg
[travis-image]: https://travis-ci.org/gb-6k-house/YsSwift.svg?branch=master
