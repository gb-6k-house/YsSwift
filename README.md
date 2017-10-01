>---
- **[Introduction](#introduction)**
- **[Requirements](#Requirements)**
- **[Installation](#Installation)**

>---
## Introduction
    YSKit supply variable function classes for iOS  written in Swift .for examples:
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