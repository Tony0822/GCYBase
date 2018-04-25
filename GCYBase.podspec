#
# Be sure to run `pod lib lint GCYBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GCYBase'
  s.version          = '0.1.4'
  s.summary          = '基础控件集成'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
主要是平常常用的控件, 能让你快速开发, 喜欢开发
                       DESC

  s.homepage         = 'https://github.com/Tony0822/GCYBase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tony0822' => 'constyang@163.com' }
  s.source           = { :git => 'https://github.com/Tony0822/GCYBase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GCYBase', 'GCYBase/**/*'
  
  # s.resource_bundles = {
  #   'GCYBase' => ['GCYBase/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 3.1.0'
end
