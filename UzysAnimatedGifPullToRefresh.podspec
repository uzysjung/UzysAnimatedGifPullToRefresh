Pod::Spec.new do |s|

  s.name         = "UzysAnimatedGifPullToRefresh"
  s.version      = "0.9.6"
  s.summary      = "Add PullToRefresh using animated GIF to any scrollView with just simple code"
  s.author       = { "Uzysjung" => "uzysjung@gmail.com" }

  s.homepage     = "https://github.com/uzysjung/UzysAnimatedGifPullToRefresh"
  s.license     = { :type => "MIT", :file => "LICENSE" }
  
  s.platform     = :ios
  s.source       = { :git => "https://github.com/uzysjung/UzysAnimatedGifPullToRefresh.git", :tag => "0.9.6" }
  s.requires_arc = true
  s.source_files = 'UzysAnimatedGifPullToRefresh/UzysAnimatedGifPullToRefresh/Library'
  s.public_header_files = 'UzysAnimatedGifPullToRefresh/UzysAnimatedGifPullToRefresh/Library/*.h'
  s.dependency 'AnimatedGIFImageSerialization', '~> 0.2.0'  
  s.ios.deployment_target = "6.0"

end
