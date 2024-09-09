#if canImport(Flutter)
import Flutter
#endif

#if canImport(FlutterMacOS)
import FlutterMacOS
#endif

@objc public class MaplibreFlutterMapPluginGlobals: NSObject {
    @objc public static var textureRegistry: FlutterTextureRegistryProxy?;
}
