Pod::Spec.new do |spec|
	
  spec.name         = "RTCCommon"
  spec.version      = "1.0.0"
  spec.platform     = :ios
  spec.ios.deployment_target = '11.0'
  spec.license      = { :type => 'Proprietary',
      :text => <<-LICENSE
        copyright 2017 tencent Ltd. All rights reserved.
        LICENSE
       }
  spec.homepage     = 'https://github.com/Tencent-RTC/uikit-common.git'
  spec.documentation_url = 'https://github.com/Tencent-RTC/uikit-common.git'
  spec.authors      = 'tencent rtc uikit'
  spec.summary      = 'RTCCommon'
  spec.xcconfig     = { 'VALID_ARCHS' => 'armv7 arm64 x86_64' }
  spec.swift_version = '5.0'
  
  # spec.source = { :path => './'}
  spec.source = { :git => 'https://github.com/Tencent-RTC/uikit-common.git', :tag => '1.0.0' }
  spec.source_files = 'Source/**/**/*.*', 'Source/Utils/**/*.*'
  
  spec.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.dependency 'SnapKit'
end
