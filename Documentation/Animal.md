## YsSwift

This library supply some normal Swift base functions, likes String catgory, Data catgory etc.
>---
- **[Usage](#Usage)**
    - ***String Functions or Methods***
    - ***UIView category***
    - ***UIImage category***
>--- 

## Usage

More features, read [Demo](Demo)
### String Functions or Methods

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
[Demo]: https://github.com/gb-6k-house/YsSwift/tree/master/Demo

