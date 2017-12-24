## YsSwift/Rabbit

Ligtly and extensional library for downloading and caching images from the web, likes [Nuke](Nuke).  

>---
- **[Usage](#Usage)**
- **[Thanks](#Thanks)**
>---
## Usage

More features, read [Demo](Demo)
### Base Features

```swift
//loading iamge from web
 self.imageView.ys.loadImage(with: URL(string: "your webimage url")!)
```
or add a placeholder image like this
```swift
self.imageView.ys.loadImage(with: URL(string: "your webimage url")!, placeholder: UIImage(named:"rabbit_1"))
```
### Advance Features

Downloading web image for any objects becomes easy with Rabbit. For example make UIButton has this capability.

```swift
extension UIButton : YsSwift.Target {
    
    public func handle(response: Result<Image, YsSwift.RequestError>, isFromMemoryCache: Bool) {
        guard let image = response.value else { return }
        self.setImage(image, for: .normal)
    }
}
```
then use API from Rabbit to dowload image for UIButton
```swift
Rabbit.loadImage(with: URL(string: "your webimage url")!, into: self.button)

```
## Thanks
Thank [@kean](https://github.com/kean), this project copy some code from [Nuke](Nuke)

[Nuke]: https://github.com/kean/Nuke
[Demo]: https://github.com/gb-6k-house/YsSwift/tree/master/Demo