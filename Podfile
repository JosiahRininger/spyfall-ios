# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
inhibit_all_warnings!

target 'SpyfallFree' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Firebase
  pod 'Firebase/Analytics', '~> 6.0'
  pod 'Firebase/AdMob', '~> 6.0'
  pod 'Firebase/Firestore', '~> 6.0'
  pod 'Firebase/Crashlytics', '~> 6.0'

  pod 'Google-Mobile-Ads-SDK'
  pod 'lottie-ios', '3.1.3'
  pod 'PKHUD', '5.3.0'
  pod 'ReachabilitySwift'
  pod 'SwiftLint', '0.35.0', :configurations => ['Debug']

end

target 'SpyfallPaid' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Firebase
  pod 'Firebase/Analytics', '~> 6.0'
  pod 'Firebase/AdMob', '~> 6.0'
  pod 'Firebase/Firestore', '~> 6.0'
  pod 'Firebase/Crashlytics', '~> 6.0'

  pod 'Google-Mobile-Ads-SDK'
  pod 'lottie-ios', '3.1.3'
  pod 'PKHUD', '5.3.0'
  pod 'ReachabilitySwift'
  pod 'SwiftLint', '0.35.0', :configurations => ['Debug']

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
  end
end
