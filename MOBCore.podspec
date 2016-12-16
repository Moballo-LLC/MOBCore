Pod::Spec.new do |s|
  s.name             = 'MOBCore'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MOBCore.'
  s.homepage         = 'https://github.com/Moballo/MOBCore'
  s.license          = 'MIT'
  s.author           = { 'Jason Morcos' => 'jason.morcos@moballo.com' }
  s.source           = { :git => 'https://github.com/Moballo/MOBCore.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_tid_'

  s.ios.deployment_target = '8.0'

  s.framework = 'UIKit'
  s.framework = 'GoogleMobileAds'
  s.vendored_frameworks = 'GoogleMobileAds.framework'

  s.source_files  = ['Sources/**/*.swift', 'Sources/**/*.h']
end
