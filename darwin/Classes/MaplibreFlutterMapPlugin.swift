#if canImport(Flutter)
import Flutter

private func textureRegistryExtractor(registrar: FlutterPluginRegistrar) -> FlutterTextureRegistry {
    return registrar.textures()
}
#endif

#if canImport(FlutterMacOS)
import FlutterMacOS

private func textureRegistryExtractor(registrar: FlutterPluginRegistrar) -> FlutterTextureRegistry {
    return registrar.textures
}
#endif

import Foundation

@objc public class MaplibreFlutterMapPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MaplibreFlutterMapPlugin();
        MaplibreFlutterMapPluginGlobals.textureRegistry = FlutterTextureRegistryProxy(textures: textureRegistryExtractor(registrar: registrar));
    }
}
