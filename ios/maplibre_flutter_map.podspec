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
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.frameworks = 'CoreLocation', 'SystemConfiguration', 'Metal', 'MetalKit'

  s.vendored_libraries = 'Libraries/libmaplibre_flutter_map_ios.dylib'
  s.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load $(PODS_TARGET_SRCROOT)/Libraries/libmaplibre_flutter_map_ios.dylib" }
  s.preserve_paths = 'Libraries/*'
end
