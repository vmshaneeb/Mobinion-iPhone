source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'Alamofire', '~> 3.3'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'IQKeyboardManager'
pod 'Cloudinary'
pod 'DBAlertController'
pod 'PhoneNumberKit', '~> 0.7'
pod 'AsyncSwift'
pod 'SDWebImage', '~>3.7'
pod 'GoogleMaps'

post_install do |installer_representation|
    puts "Splitting up Gooogle Framework - It's just too big to be presented in the Github :("
    Dir.chdir("Pods/GoogleMaps/Frameworks/GoogleMaps.framework/Versions/Current") do
        # Remove previous split files if any
        `rm GoogleMaps_Split_*`
        # Split current framework into smaller parts
        `split -b 30m GoogleMaps GoogleMaps_Split_`
    end
end