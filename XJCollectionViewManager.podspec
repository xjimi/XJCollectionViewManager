#
# Be sure to run `pod lib lint XJCollectionViewManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XJCollectionViewManager'
  s.version          = '0.1.58'
  s.summary          = 'Easy to use UICollectionView'
  s.homepage         = 'https://github.com/xjimi/XJCollectionViewManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xjimi' => 'fn5128@gmail.com' }
  s.source           = { :git => 'https://github.com/xjimi/XJCollectionViewManager.git', :tag => s.version.to_s }
  s.source_files     = "XJCollectionViewManager", "Sources/**/*.{h,m}"
  s.requires_arc     = true
  s.frameworks       = 'UIKit', 'Foundation'
  s.ios.deployment_target = '11.0'

  # s.resource_bundles = {
  #   'XJCollectionViewManager' => ['XJCollectionViewManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
