Pod::Spec.new do |s|
  s.name             = 'MOBCore'
  s.version          = '1.0.0'
  s.summary          = 'A short description of MOBCore.'
  s.homepage         = 'https://github.com/Moballo/MOBCore'
  s.license          = 'MIT'
  s.author           = { 'Jason Morcos' => 'jason.morcos@moballo.com' }
  s.source           = { :git => 'https://github.com/Moballo/MOBCore.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_tid_'

  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'

  s.framework = 'UIKit'
  s.framework = 'CoreLocation'
  s.framework = 'MessageUI'
  s.framework = 'StoreKit'
  s.framework = 'CoreSpotlight'
  s.framework = 'MobileCoreServices'


  s.source_files  = ['Sources/**/*.swift', 'Sources/**/*.h']
end
