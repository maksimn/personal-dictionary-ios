Pod::Spec.new do |spec|

  spec.name         = "CoreModule"
  spec.version      = "0.1.0"
  spec.summary      = "SuperList app core types"

  spec.description  = <<-DESC
                       SuperList app core types (iOS App).
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

  spec.dependency 'RxCocoa', '6.5.0'
  spec.dependency 'RxSwift', '6.5.0'

end
