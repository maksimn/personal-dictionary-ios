platform :ios, '14.0'

target 'SuperList' do
  use_frameworks!

  pod 'SwiftLint'

  pod 'CoreModule',
    :path => './AppModules/CoreModule'
  pod 'PersonalDictionary',
    :path => './AppModules/PersonalDictionary',
    :testspecs => ['PersonalDictionaryTests']
  pod 'TodoList',
    :path => './AppModules/TodoList',
    :testspecs => ['TodoListTests']

  target 'SuperListTests' do
    inherit! :search_paths

  end

  target 'SuperListUITests' do

  end

  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
   end
  end

end
