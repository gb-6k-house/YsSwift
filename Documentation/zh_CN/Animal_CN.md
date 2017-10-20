## YsSwift

YsSwift包括大量iOS开发中常用的一些功能。YsSwift主要目的是对现有的Cocoa框架做一些扩展，比如对UIImage扩展，提供了压缩图片等等大量的方法。


>---
- **[版本要求](#版本要求)**
- **[安装说明](#安装说明)**
- **[使用说明](#使用说明)**
    - ***[String扩展](#String扩展)***
    - ***[UIView的扩展](#UIView的扩展)***
    - ***[UIImage的扩展](#UIImage的扩展)***
>--- 

## 版本要求

* Xcode 8.0 或 之后的版本
* Swift 3.2 或 之后的版本

## 安装说明

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

**Search with `pod search YsSwift` `**

* Include **YsSwift** functions
```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'YsSwift',    '~> 0.2.1'
end
```

## 使用说明

下面是部分功能的说明。更多的功能使用请参照[Demo][Demo]

### String扩展

```swift
import YsSwift

let s = "         hello world      "
print("\(s.ys.trim())")   // hello world

//string to double
var d = "0.11"
print("\(d.ys.double())") //0.11
d = "abc"
print("\(d.ys.double())") //0.0
```
### UIView的扩展
```swift
let v = UIView()
//屏幕截图
let image = v.ys.screenshot()
```
### UIImage的扩展
```swift
//resize image
image.ys.resizeImage(size: size)
//compress image to count
image.ys.compressImage(length: 1024)

```

[Demo]: https://github.com/gb-6k-house/YsSwift/tree/master/Demo
