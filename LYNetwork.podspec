#
# Be sure to run `pod lib lint LYNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LYNetwork'
  s.version          = '1.2.6'
  s.summary          = '一号社区，网络组件'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitlab.0easy.com/hybrid/LYNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangdaokui' => 'zhangdaokui@0easy.com' }
  s.source           = { :git => 'https://gitlab.0easy.com/hybrid/LYNetwork.git', :tag => s.version.to_s }

  s.ios.deployment_target =   '8.0'
  s.platform              = :ios, '8.0'
  s.requires_arc          = true       #是否支持arc
  
  s.subspec 'Lib' do |lib|
      lib.source_files              = 'LYNetwork/Classes/Lib/**/*.{h,m}'
      lib.public_header_files       = 'LYNetwork/Classes/Lib/**/*.h'
      lib.frameworks                = 'UIKit','Foundation','MobileCoreServices','AVFoundation','Photos','AssetsLibrary','Security','SystemConfiguration'
      lib.dependency                'AFNetworking', '~> 3.1.0'
      lib.dependency                'HappyDNS', '~> 0.3.10'
  end
  
  s.subspec 'Core' do |core|
      core.source_files             = 'LYNetwork/Classes/Core/**/*.{h,m}'
      core.public_header_files      = 'LYNetwork/Classes/Core/**/*.h'
      core.frameworks               = 'UIKit','Foundation','Security','SystemConfiguration','MobileCoreServices'
      core.dependency               'AFNetworking', '~> 3.1.0'
      core.dependency               'SVProgressHUD'
      core.dependency               'LYNetwork/Lib'
  end
  
  s.xcconfig = { 'CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF' => 'NO' }
  
  #s.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => "${PODS_CONFIGURATION_BUILD_DIR}/LYFoundation" }
  #s.xcconfig = { "HEADER_SEARCH_PATHS" => "${PODS_CONFIGURATION_BUILD_DIR}/LYFoundation/LYFoundation.framework/Headers" }

  #s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }

  # s.module_map = "LYNetwork/Classes/CommonCrypto/module.modulemap"

  # s.resource_bundles = {
  #   'LYNetwork' => ['LYNetwork/Assets/*.png']
  # }

  #s.dependency               'LYFoundation'

end
