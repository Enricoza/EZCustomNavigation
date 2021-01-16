Pod::Spec.new do |spec|
  spec.name         = 'EZCustomNavigation'
  spec.author       = { 'Enrico Zannini' => 'enricozannini93@gmail.com' }
  spec.version      = '1.1.2'
  spec.summary      = 'Navigation animation and transition with pan gesture'
  spec.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  spec.platform = :ios
  spec.ios.deployment_target = '10.0'
  spec.swift_version = '5.0'
  spec.source_files = 'EZCustomNavigation/*.{swift}'
  spec.requires_arc = true
  spec.source 	= { :git => 'https://github.com/Enricoza/EZCustomNavigation.git', :tag => "v#{spec.version}" }
  spec.homepage		= 'https://github.com/Enricoza/EZCustomNavigation'
end
