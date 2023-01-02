target 'MOBCore_iOS' do
	platform :ios, '11.0'
	use_frameworks!
  
end

target 'MOBCore_WatchOS' do
	platform :watchos, '6.0'
	use_frameworks!
  
end
  
post_install do |installer|
	installer.pods_project.targets.each do |target|
	  target.build_configurations.each do |config|
		config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  
		# build active architecture only (Debug build all)
		config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
		config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
	  end
	end
end
  