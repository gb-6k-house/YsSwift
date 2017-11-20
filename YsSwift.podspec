
Pod::Spec.new do |s|

  s.name         = "YsSwift"
  s.version      = "0.3.2"
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
    ss.dependency 'RxCocoa', '3.6.1'
    ss.dependency 'Moya/RxSwift', '8.0.5'
    ss.dependency 'SnapKit', '3.2.0'
    ss.dependency 'SwiftyJSON', '~> 3.1.1'
    ss.dependency 'IQKeyboardManagerSwift', '~> 4.0.13'
    ss.dependency 'libPhoneNumber-iOS', '~> 0.8'
    ss.dependency 'ObjectMapper', '2.1.0'
    ss.dependency 'FCUUID'
    ss.dependency 'MJRefresh'
    ss.dependency 'FDFullscreenPopGesture'
  end

end
