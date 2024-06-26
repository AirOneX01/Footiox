# Uncomment the next line to define a global platform for your project
# platform :ios, '16.0'

platform :ios, '15.0' # set IPHONEOS_DEPLOYMENT_TARGET for the pods project
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

target 'My Score' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'FirebaseAnalytics'
  pod 'FirebaseDatabase'
  # Pods for My Score

end

