## YSKit

This SDK supply some common Swift base functions, like string catgory, data catgory etc

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

## Usage
### String Functions or Methods

```swift
import YSKit

let s = "         hello world      "
print("\(s.ys.trim())")   // hello world

```
