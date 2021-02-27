platform :ios, '11'

inhibit_all_warnings!
use_frameworks!

target 'Lobster' do
  pod 'Firebase/RemoteConfig', '~> 7.7.0'
  target 'LobsterTests' do
    inherit! :search_paths
  end
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    end
  end
end