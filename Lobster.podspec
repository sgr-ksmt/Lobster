Pod::Spec.new do |spec|
  spec.name             = 'Lobster'
  spec.version          = '3.1.0'
  spec.author           = { 'Suguru Kishimoto' => 'melodydance.k.s@gmail.com' }
  spec.summary          = 'The Type-safe Firebase-RemoteConfig helper library'
  spec.homepage         = 'https://github.com/sgr-ksmt/Lobster'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.source           = { :git => 'https://github.com/sgr-ksmt/Lobster.git', :tag => spec.version.to_s }

  spec.ios.deployment_target = '11.0'
  spec.swift_versions    = ['4.2', '5.0']

  spec.requires_arc     = true
  spec.static_framework = true

  spec.dependency 'Firebase/RemoteConfig'

  spec.default_subspecs = 'Core'

  spec.subspec 'Core' do |subspec|
    subspec.source_files = 'Sources/Core/**/*.swift'
  end

  spec.subspec 'Combine' do |subspec|
    subspec.dependency 'Lobster/Core'
    subspec.source_files = 'Sources/Combine/**/*.swift'

    subspec.ios.deployment_target = '13.0'
    subspec.ios.frameworks = 'Combine'
  end
end
