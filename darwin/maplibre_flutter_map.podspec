Pod::Spec.new do |s|
  s.name             = 'maplibre_flutter_map'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'

  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.14'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.ios.frameworks = 'CoreLocation', 'SystemConfiguration', 'Metal', 'MetalKit', 'CoreImage'

  s.ios.vendored_libraries = 'Libraries/ios/libmaplibre_flutter_map_ios.dylib'
  s.ios.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load $(PODS_TARGET_SRCROOT)/Libraries/ios/libmaplibre_flutter_map_ios.dylib" }
  s.ios.preserve_paths = 'Libraries/ios/*'

  s.osx.vendored_libraries = 'Libraries/macos/libmaplibre_flutter_map_macos.dylib'
  s.osx.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load $(PODS_TARGET_SRCROOT)/Libraries/macos/libmaplibre_flutter_map_macos.dylib" }
  s.osx.preserve_paths = 'Libraries/macos/*'
end
