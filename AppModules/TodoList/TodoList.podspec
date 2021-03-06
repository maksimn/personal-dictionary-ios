Pod::Spec.new do |spec|

  spec.name         = "TodoList"
  spec.version      = "0.1.0"
  spec.summary      = "TodoList app"

  spec.description  = <<-DESC
                       TodoList app module for the SuperApp.
                      DESC

  spec.homepage     = "http://maksimn.github.io/"
  spec.license      = "MIT License"
  spec.author       = { "Maksim Ivanov" => "mmaksmn@gmail.com" }
  spec.platform     = :ios

  spec.requires_arc  = true
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '14.0'
  spec.source_files  = 'Source/**/*'
  spec.source = { :path => '.' }

  spec.resources = ["Resources/{*.xcassets}", 
                    "Resources/TodoList.xcdatamodeld"]

  spec.dependency 'CoreModule'
  spec.dependency 'SnapKit', '~> 4.0'

  spec.test_spec 'TodoListTests' do |test_spec|
    test_spec.source_files = 'Tests/**/*'
  end

end
