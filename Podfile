# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'BPNBTV' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  # Pods for BPNBTV
  pod 'Alamofire', '~> 4.4'
  pod 'SwiftyJSON'
  pod 'Kingfisher', '~> 3.0'
  pod 'SideMenu'
  pod 'youtube-ios-player-helper', '~> 0.1.4'
  pod 'ReachabilitySwift', '~> 3'
  pod 'PKHUD', '~> 4.0'
  pod 'BMPlayer'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'ImageSlideshow', '~> 1.3'
  pod 'ImageSlideshow/Kingfisher'
  target 'BPNBTVTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BPNBTVUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
