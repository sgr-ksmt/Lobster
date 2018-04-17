Pod::Spec.new do |s|
  s.name             = "Lobster"
  s.version          = "1.0"
  s.summary          = "Type-safe Firebase-RemoteConfig helper library"
  s.homepage         = "https://github.com/sgr-ksmt/Lobster"
  s.license          = 'MIT'
  s.author           = { "Suguru Kishimoto" => "melodydance.k.s@gmail.com" }
  s.source           = { :git => "https://github.com/sgr-ksmt/Lobster.git", :tag => s.version.to_s }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.source_files     = "Sources/**/*"
  s.static_framework = true
  s.dependency "Firebase/RemoteConfig"
end
