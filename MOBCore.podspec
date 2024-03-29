Pod::Spec.new do |s|
  s.name             = 'MOBCore'
  s.version          = '4.1.0'
  s.summary          = 'A core set of functions and extensions to power a slew of applications'
  s.homepage         = 'https://github.com/Moballo-LLC/MOBCore'
  s.license          = 'MIT'
  s.author           = { 'Jason Morcos - Moballo, LLC' => 'jason.morcos@moballo.com' }
  s.source           = { :git => 'https://github.com/Moballo-LLC/MOBCore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.watchos.deployment_target = '6.0'
  s.swift_version = '5.0'

  s.framework = 'UIKit'
  s.framework = 'CoreLocation'
  s.framework = 'MapKit'
  s.framework = 'MessageUI'
  s.framework = 'StoreKit'
  s.framework = 'CoreSpotlight'
  s.framework = 'CoreServices'
  s.framework = 'Foundation'


  s.ios.source_files = ['Sources/**/*.swift','Sources-iOS-only/**/*.swift']
  s.watchos.source_files = ['Sources/**/*.swift','Sources-watchOS-only/**/*.swift']
end
