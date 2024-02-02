install! 'cocoapods', :warn_for_unused_master_specs_repo => false
platform :ios, '15.0'
use_frameworks! :linkage => :static
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/sdk-banuba/banuba-sdk-podspecs.git'

target 'TechDemo' do
  pod 'BanubaSdk', '1.8.0'
  pod 'Device', '~> 3.3.0'
  pod 'Firebase', '10.5.0' # https://firebase.google.com/support/release-notes/ios
  pod 'Firebase/Crashlytics' # https://github.com/firebase/firebase-ios-sdk/blob/master/Crashlytics/CHANGELOG.md
  pod 'FirebaseDynamicLinks' # https://github.com/firebase/firebase-ios-sdk/blob/master/FirebaseDynamicLinks/CHANGELOG.md
  pod 'OpenCV', '3.2.0'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
    end
  end
 end
