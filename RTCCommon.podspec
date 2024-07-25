Pod::Spec.new do |spec|
	
  spec.name         = "RTCCommon"
  spec.version      = "1.0.3"
  spec.platform     = :ios
  spec.ios.deployment_target = '12.0'
  spec.license      = { :type => 'Proprietary',
      :text => <<-LICENSE
        copyright 2017 tencent Ltd. All rights reserved.
        LICENSE
       }
  spec.homepage     = 'https://github.com/Tencent-RTC/uikit-common.git'
  spec.documentation_url = 'https://github.com/Tencent-RTC/uikit-common.git'
  spec.authors      = 'tencent rtc uikit'
  spec.summary      = 'RTCCommon'
  spec.swift_version = '5.0'
  
  spec.source = { :git => 'https://github.com/Tencent-RTC/uikit-common.git', :tag => 'v1.0.3' }
  spec.source_files = 'Source/**/**/*.*', 'Source/Utils/**/*.*'
  
  spec.dependency 'SnapKit'
end
