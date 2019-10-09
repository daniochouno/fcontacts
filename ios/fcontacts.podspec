#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'fcontacts'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for accessing to all available data from your phone contacts. Supports iOS and Android.'
  s.description      = <<-DESC
A Flutter plugin for accessing to all available data from your phone contacts. Supports iOS and Android.
                       DESC
  s.homepage         = 'https://github.com/daniochouno/fcontacts'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Daniel Martínez' => 'dmartinez@danielmartinez.info' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '9.0'
end

