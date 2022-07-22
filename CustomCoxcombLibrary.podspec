#
# Be sure to run `pod lib lint CustomCoxcombLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CustomCoxcombLibrary'
  s.version          = '0.1.0'
  s.summary          = 'A Custom pie chart with different radius and value'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'This library make create different arcs based on the value, colors and images by the user.'
                       DESC

  s.homepage         = 'https://github.com/jatinverma007/CustomCoxcombLibrary'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jatinverma007' => 'jatin.verma@eroute.in' }
  s.source           = { :git => 'https://github.com/jatinverma007/CustomCoxcombLibrary.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'CustomCoxcombLibrary/Classes/CustomCell/OCGraphLabelCollectionViewCell'
  s.source_files = 'CustomCoxcombLibrary/Classes/CustomClasses/CXShapeLayer'
  s.source_files = 'CustomCoxcombLibrary/Classes/CustomClasses/CXLabel'
  s.source_files = 'CustomCoxcombLibrary/Classes/CustomClasses/CXCustomGraph'
  
  s.swift_version = '5.0'
  
  s.platforms = {
      "ios": "13.0"
  }
  
  # s.resource_bundles = {
  #   'CustomCoxcombLibrary' => ['CustomCoxcombLibrary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
