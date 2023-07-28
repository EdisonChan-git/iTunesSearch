platform :ios, '12.0'

target 'iTunesSearch' do
# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

# Pods for iTunesSearch
pod 'Alamofire', '~> 5.4'
pod 'SDWebImage', '~> 5.0'
pod 'RxSwift', '~> 5.1'
pod 'RxCocoa', '~> 5.1'
pod 'SVProgressHUD'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end

end