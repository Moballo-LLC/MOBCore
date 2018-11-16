Pod::Spec.new do |s|
  s.name             = 'MOBCore'
  s.version          = '2.5.3'
  s.summary          = 'A core set of functions and extensions to power a slew of applications'
  s.homepage         = 'https://github.com/Moballo-LLC/MOBCore'
  s.license          = 'MIT'
  s.author           = { 'Jason Morcos - Moballo, LLC' => 'jason.morcos@moballo.com' }
  s.source           = { :git => 'https://github.com/Moballo-LLC/MOBCore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '3.0'
  s.swift_version = '4.2'

  s.framework = 'UIKit'
  s.framework = 'CoreLocation'
  s.framework = 'MapKit'
  s.framework = 'MessageUI'
  s.framework = 'StoreKit'
  s.framework = 'CoreSpotlight'
  s.framework = 'MobileCoreServices'
  s.framework = 'Foundation'


  s.source_files  = ['Sources/**/*.swift']
  s.ios.source_files= 'Sources-iOS-only/**/*.swift'
  s.watchos.source_files= 'Sources-watchOS-only/**/*.swift'
end
