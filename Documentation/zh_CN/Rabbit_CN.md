## YsSwift/Rabbit

Rabbit是纯Swift编写的轻量级，易扩展的网络图片加载框架，支持内存缓存和硬盘缓存等功能。Rabbit参照了业界一些优秀的网络图片加载库,尤其是[Nuke](Nuke). Rabbit参照和使用了大量Nuke的源代码，并在Nuke做了大量的改进和优化。


>---
- **[版本要求](#版本要求)**
- **[安装说明](#安装说明)**
- **[使用说明](#使用说明)**
- **[特别鸣谢](#特别鸣谢)**
>---

## 版本要求

* Xcode 8.0 或 之后的版本
* Swift 3.2 或 之后的版本

## 安装说明

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

**Search with `pod search YsSwift`**

Include **YsSwift/Rabbit** functions
```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'YsSwift/Rabbit',    '~> 0.2.0'
end
```

## 使用说明
下面是部分功能的说明。更多的功能使用请参照[Demo][Demo]

### 基础使用
Rabbit对UIImageView提供了加载网络图片的接口，使用如下
```swift
//UIImageView加载网络图片
 self.imageView.ys.loadImage(with: URL(string: "your webimage url")!)
```
或者设置placehold图片

```swift
self.imageView.ys.loadImage(with: URL(string: "your webimage url")!, placeholder: UIImage(named:"rabbit_1"))
```
### 高级使用
Rabbit库易扩展，你可以给任意对象实现网络图片加载的功能，只需要实现Target协议
比如给UIButton提供加载网络图片的功能，首先扩展UIButton实现Target协议
```swift
extension UIButton : YsSwift.Target {
    
    public func handle(response: YsSwift.Result<YsSwift.Image>, isFromMemoryCache: Bool) {
        guard let image = response.value else { return }
        self.setImage(image, for: .normal)
    }
}
```
然后调用库方法，加载网络图片
```swift
Rabbit.loadImage(with: URL(string: "your webimage url")!, into: self.button)

```


## 特别鸣谢

感谢[@kean](https://github.com/kean)大神的[Nuke](Nuke)项目


[Nuke]: https://github.com/kean/Nuke
[Demo]: https://github.com/gb-6k-house/YsSwift/tree/master/Demo