#
# Be sure to run `pod lib lint ZYTextInputAvoidKeyboard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZYTextInputAvoidKeyboard'
  s.version          = '0.2.0'
  s.summary          = 'Adjust textView`s position well to avoid input cursor being covered.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'ZYTextInputAvoidKeyboard is designed for textView or containerView with textView on ScrollView. In order to adjust textView`s position well to avoid input cursor being covered.'

  s.homepage         = 'https://github.com/wustzhy/ZYTextInputAvoidKeyboard'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '赵洋' => 'zhaoyang@deepleaper.com' }
  s.source           = { :git => 'https://github.com/wustzhy/ZYTextInputAvoidKeyboard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZYTextInputAvoidKeyboard/Classes/**/*'
  
  s.dependency 'KVOController', '~> 1.2.0'
  
  # s.resource_bundles = {
  #   'ZYTextInputAvoidKeyboard' => ['ZYTextInputAvoidKeyboard/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
