
Pod::Spec.new do |s|

  s.name         = "YsSwift"
  s.version      = "1.1.0"
  s.summary      = "Variable Solutions written in Swift"
  s.description  = <<-DESC
  YsSwift. supply variable function classes  written in Swift .for examples:
  1.Animal. This SDK supply some common Swift base functions, like string catgory, data catgory etc.
  2.Rabbit. A solution for net image likes SDWebImage or Nuke
  
                   DESC

  s.homepage     = "https://github.com/gb-6k-house/YsSwift"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "liukai" => "csu_liukai_web@163.com" }
  s.social_media_url   = "http://www.yourshares.cn"

  s.platform     = :ios, "9.0"
  s.ios.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/gb-6k-house/YsSwift.git", :tag => s.version }
  # s.source       = { :git => "https://github.com/gb-6k-house/YsSwift.git", :commit => "2e8cf21"}
  # s.source       = { :git => "https://github.com/gb-6k-house/YsSwift.git", :branch => "master"}

  s.default_subspec = "Animal"

  s.subspec "Animal" do |ss|
    ss.source_files  = "Sources/Animal/**/*"
    ss.framework  = "Foundation"
    ss.framework  = "UIKit"
    ss.dependency "Result", "~> 3.0"
  end

  s.subspec "Rabbit" do |ss|
    ss.source_files = "Sources/Rabbit/"
    ss.dependency "YsSwift/Animal"
  end

  s.subspec "Peacock" do |ss|
    ss.source_files = "Sources/Peacock/**/*"
    ss.dependency "YsSwift/Animal"
    ss.dependency 'Moya', '9.0.0'
    ss.dependency 'RxSwift', '4.0.0'
    ss.dependency 'RxCocoa', '4.0.0'
    ss.dependency 'SnapKit', '~> 4.0.0'
    ss.dependency 'ObjectMapper', '2.1.0'
    ss.dependency 'SwiftyJSON', '~> 3.1.1'
    ss.dependency 'IQKeyboardManagerSwift', '5.0.0' 
    ss.dependency 'libPhoneNumber-iOS', '~> 0.8'
    ss.dependency 'FCUUID', '1.3.1'
    ss.dependency 'MJRefresh','~> 3.1.15.1'
    ss.dependency 'FDFullscreenPopGesture', '~> 1.1'
  end

end
