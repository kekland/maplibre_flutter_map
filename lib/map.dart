// import 'dart:async';
// import 'dart:ffi';
// import 'dart:isolate';
// import 'dart:math';
// import 'dart:ui' as ui;

// import 'package:ffi/ffi.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/widgets.dart';
// import 'package:maplibre_flutter_map/_gen/bindings.dart';
// import 'package:maplibre_flutter_map/_gen/darwin_bindings.dart';

// final _bindings = MapLibreFlutterMapBindings(DynamicLibrary.process());

// FlutterTextureRegistryProxy getFlutterTextureRegistryProxyInstance() {
//   return MaplibreFlutterMapPluginGlobals.getTextureRegistry()!;
// }

// class MapLibreMap {
//   MapLibreMap();

//   late final BasicFlutterTexture _texture;
//   late final int _textureId;
//   late final mbgl_run_loop_t _runLoop;
//   late final mbgl_headless_frontend_t _frontend;
//   late final mbgl_map_observer_t _observer;
//   late final mbgl_tile_server_options_t _options;
//   late final mbgl_map_t _map;

//   final uiImage = ValueNotifier<ui.Image?>(null);

//   void _scheduleRunLoopTask() async {
//     while (true) {
//       await SchedulerBinding.instance.scheduleTask(() {
//         _bindings.run_loop_run_once(_runLoop);
//       }, Priority.idle - 1000);
//     }
//   }

//   void initialize() {
//     _runLoop = _bindings.run_loop_create();
//     _scheduleRunLoopTask();

//     _texture = BasicFlutterTexture.alloc().init();
//     _textureId = getFlutterTextureRegistryProxyInstance()
//         .registerTextureWithTexture_(_texture);

//     _frontend = _bindings.headless_frontend_create(
//       1920,
//       1080,
//       1.0,
//     );

//     _observer = _bindings.map_observer_create(
//       NativeCallable<Void Function()>.listener(() {
//         copyToBuffer();
//       }).nativeFunction,
//     );

//     _options = _bindings.tile_server_options_map_tiler_create();

//     _map = _bindings.map_create(
//       _frontend,
//       _observer,
//       0,
//       1.0,
//       "5IZuFl4CkB3Io0SjxUVJ".toNativeUtf8().cast(),
//       _options,
//     );

//     _bindings.map_set_style(
//       _map,
//       "https://api.maptiler.com/maps/7d5f4aed-f3bb-4c46-8dee-e1e79cd2e12b/style.json?key=5IZuFl4CkB3Io0SjxUVJ"
//           .toNativeUtf8()
//           .cast(),
//     );

//     _bindings.map_jump_to(
//       _map,
//       43.1991413838172,
//       76.85274264579952,
//       10.0,
//       0.0,
//       0.0,
//     );

//     _bindings.run_loop_run_once(_runLoop);
//   }

//   void testfn() {
//     _bindings.map_jump_to(
//       _map,
//       Random().nextDouble() * 90,
//       Random().nextDouble() * 180,
//       6.0,
//       0.0,
//       0.0,
//     );
//   }

//   void setCamera(double lat, double lon, double zoom) {
//     _bindings.map_jump_to(
//       _map,
//       lat,
//       lon,
//       zoom,
//       0.0,
//       0.0,
//     );
//   }

//   Future<void> copyToBuffer() async {
//     _texture.copyFromBufferWithPointer_width_height_channels_(
//       _bindings.headless_frontend_get_image_data_ptr(_frontend).cast(),
//       1920,
//       1080,
//       4,
//     );

//     getFlutterTextureRegistryProxyInstance()
//         .textureFrameAvailableWithTextureId_(_textureId);
//   }

//   void dispose() {
//     _bindings.run_loop_destroy(_runLoop);
//     _bindings.map_destroy(_map);
//     _bindings.map_observer_destroy(_observer);
//     _bindings.tile_server_options_destroy(_options);
//     _bindings.headless_frontend_destroy(_frontend);

//     getFlutterTextureRegistryProxyInstance()
//         .unregisterTextureWithTextureId_(_textureId);
//   }

//   Widget build() {
//     return AspectRatio(
//       aspectRatio: 1920 / 1080,
//       child: Texture(
//         textureId: _textureId,
//       ),
//     );
//   }
// }
