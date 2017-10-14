
Pod::Spec.new do |s|

  s.name         = "YSKit"
  s.version      = "0.0.1"
  s.summary      = "Variable Solutions for iOS written in Swift"
  s.description  = <<-DESC
  YSKit supply variable function classes for iOS  written in Swift .for examples:
  1.Animal. This SDK supply some common Swift base functions, like string catgory, data catgory etc.
  2.Rabbit. A solution for net image likes SDWebImage or Nuke
  
                   DESC

  s.homepage     = "https://github.com/gb-6k-house/YSKit"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "liukai" => "csu_liukai_web@163.com" }
  s.social_media_url   = "http://www.yourshares.cn"

  s.platform     = :ios, "9.0"
  s.ios.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/gb-6k-house/YSKit.git", :tag => s.version }
  s.default_subspec = "Animal"

  s.subspec "Animal" do |ss|
    ss.source_files  = "Sources/Animal/**/*"
    ss.framework  = "Foundation"
  end

  s.subspec "Rabbit" do |ss|
    ss.source_files = "Sources/Rabbit/"
    ss.dependency "YSKit/Animal"
  end

end
