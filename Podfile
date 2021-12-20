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

end
