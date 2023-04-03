platform :ios, '13.4'

target 'SuperList' do
  use_frameworks!

  pod 'SwiftLint'

  pod 'CoreModule',
    :path => './AppModules/CoreModule'
  pod 'PersonalDictionary',
    :path => './AppModules/PersonalDictionary',
    :testspecs => ['Tests'] 
  pod 'TodoList',
    :path => './AppModules/TodoList'

  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.4'
    end
   end
  end

end
