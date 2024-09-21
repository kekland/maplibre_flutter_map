#if canImport(Flutter)
import Flutter
#endif

#if canImport(FlutterMacOS)
import FlutterMacOS
#endif

@_cdecl("flutter_texture_frame_available")
public func flutterTextureFrameAvailable(textureId: Int64) {
    print("HELLO FROM SWIFT!");
    MaplibreFlutterMapPluginGlobals.textureRegistry?.textureFrameAvailable(textureId: textureId);
}

@objc public class FlutterTextureRegistryProxy: NSObject {
    public init(textures: FlutterTextureRegistry) {
        self.textures = textures
    }
    
    let textures: FlutterTextureRegistry;
    
    @objc public func registerTexture(texture: any FlutterTexture) -> Int64 {
        return self.textures.register(texture);
    }
    
    @objc public func textureFrameAvailable(textureId: Int64) {
        print("textureFrameAvailable: \(textureId)");
        return self.textures.textureFrameAvailable(textureId);
    }
    
    @objc public func unregisterTexture(textureId: Int64) {
        return self.textures.unregisterTexture(textureId);
    }
}
