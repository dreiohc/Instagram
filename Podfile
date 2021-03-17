# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'InstagramFirestore' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for InstagramFirestore
  
  # Firebase pods
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/Auth'
  
  # Other Pods
	pod 'JGProgressHUD', '~>2.0.3'
	pod 'SDWebImage', '~>4.4.2'
	pod 'ActiveLabel'
	pod 'YPImagePicker'
	
	post_install do |installer|
	 installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
		 config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
		end
	 end
	end

end
