//
//  MapLibreFlutterTexture.swift
//  maplibre_flutter_map
//
//  Created by Erzhan Kabdykairov on 9/18/24.
//

#if canImport(Flutter)
import Flutter
#endif

#if canImport(FlutterMacOS)
import FlutterMacOS
#endif

import Foundation
import CoreImage

@_cdecl("mapLibreFlutterTexture_setRenderCallback")
public func mapLibreFlutterTexture_setRenderCallback(_ ptr: UnsafeMutableRawPointer, frontendPtr: UnsafeMutableRawPointer, _ callback: @convention(c) @escaping (UnsafeMutableRawPointer) -> UnsafeMutableRawPointer?) {
    let texture = Unmanaged<MapLibreFlutterTexture>.fromOpaque(ptr).takeUnretainedValue();
    texture.setRenderCallback(frontendPtr: frontendPtr, callback: callback);
}

@_cdecl("mapLibreFlutterTexture_createBuffer")
public func mapLibreFlutterTexture_createBuffer(_ ptr: UnsafeMutableRawPointer, _ width: Int64, _ height: Int64, _ channels: Int64) {
    let texture = Unmanaged<MapLibreFlutterTexture>.fromOpaque(ptr).takeUnretainedValue();
    texture.createBuffer(width: Int(width), height: Int(height), channels: Int(channels));
}

@objc public class MapLibreFlutterTexture : NSObject, FlutterTexture {
    public override init() {
        self.ciContext = CIContext();
        super.init();
    }
    
    private var width: Int? = nil;
    private var height: Int? = nil;
    private var channels: Int? = nil;
    
    private var pool: CVPixelBufferPool?;
    private var buffer: CVPixelBuffer?;
    private var pixelBuffer: Data?;
    
    private var frontendPtr: UnsafeMutableRawPointer?;
    private var renderCallback: ((UnsafeMutableRawPointer) -> UnsafeMutableRawPointer?)?;
    
    private let ciContext: CIContext;

    @objc public func setRenderCallback(frontendPtr: UnsafeMutableRawPointer, callback: @escaping ((UnsafeMutableRawPointer) -> UnsafeMutableRawPointer?)) {
        print("render callback set")
        self.frontendPtr = frontendPtr
        self.renderCallback = callback
    }
    
    @objc public func createBuffer(width: Int, height: Int, channels: Int) {
        print("createBuffer")
        
        if (self.width != width || self.height != height || self.channels != channels) {
            print("buffer not equal");

            self.width = width;
            self.height = height;
            self.channels = channels;
            
            print("created buffer: \(width) \(height) \(channels)");
            
            let dictionary = [
                kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
                kCVPixelBufferWidthKey: width,
                kCVPixelBufferHeightKey: height,
                kCVPixelBufferBytesPerRowAlignmentKey: 4,
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
            
            pixelBuffer = Data(count: width * height * channels);
        }
    }
    
    public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        print("copyPixelBuffer");
        
        if (self.renderCallback == nil) {
            print("render callback nil");
            return nil;
        }
        
        if (self.pool == nil) {
            print("pool nil");
            return nil;
        }
        
        if (buffer == nil) {
            print("buffer nil");
            return nil;
        }
        
        if (pixelBuffer == nil) {
            print("pixelBuffer nil");
        }
        
        let mapLibreBuffer = renderCallback!(frontendPtr!);
        
        if (mapLibreBuffer == nil) {
            print("mapLibreBuffer nil");
            return nil;
        }
        
        let count = pixelBuffer!.count
        pixelBuffer!.withUnsafeMutableBytes { ptr in
            guard let destPtr = ptr.baseAddress else { return }
            destPtr.copyMemory(from: mapLibreBuffer!, byteCount: count)
        }

        // Free the allocated memory from C++
        mapLibreBuffer!.deallocate()

        CVPixelBufferLockBaseAddress(buffer!, .readOnly);
        
        let image = CIImage(bitmapData: pixelBuffer!, bytesPerRow: width! * 4, size: CGSize(width: width!, height: height!), format: CIFormat.RGBA8, colorSpace: nil);
        ciContext.render(image, to: buffer!);
        
        CVPixelBufferUnlockBaseAddress(buffer!, .readOnly);
        
        return Unmanaged.passRetained(buffer!);
    }
}
