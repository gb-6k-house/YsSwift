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

//string to double
var d = "0.11"
print("\(d.ys.double())") //0.11
d = "abc"
print("\(d.ys.double())") //0.0
```
### UIView category
```swift
let v = UIView()
let s = v.ys.screenshot()
```
### UIImage category
```swift
//resize image
image.ys.resizeImage(size: size)
//compress image to count
image.ys.compressImage(length: 1024)

```

