#if canImport(Flutter)
import Flutter
#endif

#if canImport(FlutterMacOS)
import FlutterMacOS
#endif

@objc public class FlutterTextureRegistryProxy: NSObject {
    public init(textures: FlutterTextureRegistry) {
        self.textures = textures
    }
    
    let textures: FlutterTextureRegistry;
    
    @objc public func registerTexture(texture: any FlutterTexture) -> Int64 {
        return self.textures.register(texture);
    }
    
    @objc public func textureFrameAvailable(textureId: Int64) {
        return self.textures.textureFrameAvailable(textureId);
    }
    
    @objc public func unregisterTexture(textureId: Int64) {
        return self.textures.unregisterTexture(textureId);
    }
    
    @objc public func createTextureNotifier(textureId: Int64) -> FlutterTextureNotifier {
        return FlutterTextureNotifier(textureId: textureId) {
            self.textureFrameAvailable(textureId: textureId);
        }
    }
}

@objc public class FlutterTextureNotifier : NSObject {
    public init(textureId: Int64, textureFrameAvailableCallback: @escaping () -> Void) {
        self.textureId = textureId;
        self.textureFrameAvailableCallback = textureFrameAvailableCallback;
    }
    
    private let textureId: Int64;
    private let textureFrameAvailableCallback: () -> Void;
    
    @objc public func notify() {
        self.textureFrameAvailableCallback();
    }
}

@objc public class BasicFlutterTexture : NSObject, FlutterTexture {
    private var ptr: UnsafeMutableRawPointer? = nil;
    private var width: Int? = nil;
    private var height: Int? = nil;
    private var channels: Int? = nil;
    
    private var pool: CVPixelBufferPool?;
    private var buffer: CVPixelBuffer?;
    
    @objc public func copyFromBuffer(pointer: UnsafeMutableRawPointer, width: Int, height: Int, channels: Int) {
        print("copyFromBuffer")
        
        var recreateBufferPool = false;
        if (self.width != width || self.height != height || self.channels != channels) {
            recreateBufferPool = true;
        }
        
        self.ptr = pointer;
        self.width = width;
        self.height = height;
        self.channels = channels;
        
        print(recreateBufferPool);
        
        if (recreateBufferPool) {
            let dictionary = [
                 kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
                 kCVPixelBufferWidthKey: width,
                 kCVPixelBufferHeightKey: height,
                 kCVPixelBufferCGBitmapContextCompatibilityKey: true,
                 kCVPixelBufferCGImageCompatibilityKey: true,
                 kCVPixelBufferMetalCompatibilityKey: true,
                 kCVPixelBufferOpenGLCompatibilityKey: true,
            ] as [CFString : Any];
            
            CVPixelBufferPoolCreate(
                kCFAllocatorDefault,
                nil,
                dictionary as CFDictionary,
                &pool
            );
            
            CVPixelBufferPoolCreatePixelBuffer(
                kCFAllocatorDefault,
                self.pool!,
                &buffer
            );
        }
    }
    
    public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        // print("copyPixelBuffer");
        
        if (ptr == nil) {
            // print("ptr nil");
            return nil;
        }
        
        if (self.pool == nil) {
            // print("pool nil");
            return nil;
        }
        
        if (buffer == nil) {
            // print("buffer nil");
            return nil;
        }
        
        CVPixelBufferLockBaseAddress(buffer!, .readOnly);

        let baseAddress = CVPixelBufferGetBaseAddress(buffer!);
        memcpy(baseAddress, ptr, width! * height! * channels!);
        
        CVPixelBufferUnlockBaseAddress(buffer!, .readOnly);

        if (buffer == nil) {
            return nil;
        }
        
        return Unmanaged.passRetained(buffer!);
    }
}
