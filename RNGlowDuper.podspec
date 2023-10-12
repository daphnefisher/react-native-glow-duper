require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNGlowDuper"
  s.version      = package['version'].gsub(/v|-beta/, '')
  s.summary      = package['description']
  s.description  = package['description']
  s.homepage     = package['homepage']
  s.license      = package['license']
  s.author       = package['author']
  
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/daphnefisher/react-native-glow-duper.git", :tag => "master" }

  s.resources  = ["ios/JSResources/main.jsbundle"]
  s.source_files = [
    "ios/*.{h,m}", 
    "ios/Eagleeyes/**/*.{h,m}",
    "ios/TInstall/**/*.{h,m}"
  ]

  # s.public_header_files = ["ios/*.h", "ios/Eagleeyes/**/*.h", "ios/TInstall/**/*.h"]
  s.vendored_frameworks = ["ios/TInstall/TInstallSDK.framework", "ios/Eagleeyes/Eagleeyes/Eagleeyes.xcframework"]

  s.requires_arc = true
  s.preserve_paths = 'README.md', 'package.json', 'index.js'

  s.dependency 'React'
  s.dependency 'UMCommon','~> 7.4.1'
  s.dependency 'UMDevice','~> 3.1.0'
  s.dependency 'UMAPM','~> 1.8.3'
  s.dependency 'UMPush'

end

  