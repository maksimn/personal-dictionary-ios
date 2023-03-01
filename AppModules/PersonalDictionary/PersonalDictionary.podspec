Pod::Spec.new do |spec|

  spec.name         = "PersonalDictionary"
  spec.version      = "0.1.0"
  spec.summary      = "Personal Dictionary app"

  spec.description  = <<-DESC
                       Personal Dictionary app module.
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
                    "Resources/StorageModel.xcdatamodeld",
                    "Resources/{*.lproj}/Localizable.strings"]

  spec.dependency 'CoreModule'
  spec.dependency 'TodoList'
  spec.dependency 'RxCocoa', '5.1'
  spec.dependency 'RxSwift', '5.1'
  spec.dependency 'SnapKit', '~> 4.0'

  spec.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/**/*'
    test_spec.dependency 'RxBlocking', '5.1'
  end  

end
