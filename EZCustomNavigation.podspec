Pod::Spec.new do |spec|
  spec.name         = 'EZCustomNavigation'
  spec.author       = { 'Enrico Zannini' => 'enricozannini93@gmail.com' }
  spec.version      = '0.0.1'
  spec.summary      = 'Navigation animation and transition with pan gesture'
  spec.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  spec.platform = :ios
  spec.ios.deployment_target = '10.0'
  spec.source_files = 'EZCustomNavigation/*.{swift}'
  spec.requires_arc = true
  spec.source 	= { :git => 'https://github.com/Enricoza/EZCustomNavigation.git', :tag => "v#{spec.version}" }
  spec.homepage		= 'https://github.com/Enricoza/EZCustomNavigation'
end
