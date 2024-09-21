import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maplibre_flutter_map/_gen/bindings.dart';
import 'package:maplibre_flutter_map/_gen/darwin_bindings.dart';
import 'package:maplibre_flutter_map/map.dart';
import 'package:maplibre_flutter_map/map_isolate.dart';
import 'package:maplibre_flutter_map/widgets/gandon.dart';
import 'package:maplibre_flutter_map/widgets/maplibre_map_render_object.dart';

class FlutterMaplibreMap extends StatefulWidget {
  const FlutterMaplibreMap({super.key});

  @override
  State<FlutterMaplibreMap> createState() => _FlutterMaplibreMapState();
}

class _FlutterMaplibreMapState extends State<FlutterMaplibreMap> {
  final controller = MapController();
  final key = GlobalKey<_MapLibreMapLayerState>();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: FlutterMap(
        mapController: controller,
        options: MapOptions(
          initialCenter: LatLng(0, 0),
          initialZoom: 2.0,
          onMapEvent: (event) {
            final state = key.currentState;
            state?._setCameraPosition(event.camera);
          },
        ),
        children: [
          MapLibreMapLayer(
            key: key,
            controller: controller,
          ),
          // ColorFiltered(
          //   colorFilter: const ColorFilter.matrix(<double>[
          //     -1.0, 0.0, 0.0, 0.0, 255.0, //
          //     0.0, -1.0, 0.0, 0.0, 255.0, //
          //     0.0, 0.0, -1.0, 0.0, 255.0, //
          //     0.0, 0.0, 0.0, 1.0, 0.0, //
          //   ]),
          //   child: IgnorePointer(
          //     child: Opacity(
          //       opacity: 0.5,
          //       child: TileLayer(
          //         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          //         userAgentPackageName: 'com.example.app',
          //         maxNativeZoom: 19,
          //       ),
          //     ),
          //   ),
          // ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                // London
                point: LatLng(51.509364, -0.128928),
                child: const Icon(
                  Icons.location_on,
                  size: 80.0,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const RichAttributionWidget(
            // Include a stylish prebuilt attribution widget that meets all requirments
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
              ),
              // Also add images...
            ],
          ),
        ],
      ),
    );
  }
}

class MapLibreMapLayer extends StatefulWidget {
  const MapLibreMapLayer({super.key, required this.controller});

  final MapController controller;

  @override
  State<MapLibreMapLayer> createState() => _MapLibreMapLayerState();
}

FlutterTextureRegistryProxy getFlutterTextureRegistryProxyInstance() {
  return MaplibreFlutterMapPluginGlobals.getTextureRegistry()!;
}

void hi() {
  print('hi');
}

class _MapLibreMapLayerState extends State<MapLibreMapLayer>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final MapLibreFlutterTexture _texture;
  int? _textureId;
  Ticker? _ticker;

  mbgl_run_loop_t? _runLoop;
  fml_flutter_renderer_frontend_t? _frontend;
  mbgl_map_t? _map;

  final bindings = MapLibreFlutterMapBindings(DynamicLibrary.process());

  var _shouldRender = false;
  var _lastTime = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _setCameraPosition(MapCamera camera) {
    if (_map != null) {
      bindings.map_jump_to(
        _runLoop!,
        _map!,
        camera.center.latitude,
        camera.center.longitude,
        camera.zoom - 1.0,
        -camera.rotation,
        0.0,
      );
    }
  }

  // void _invalidateFlutterTicker() {
  //   _shouldRender = true;
  //   SchedulerBinding.instance.scheduleFrame();
  // }

  // void _onFrameRendered() {
  //   print(bindings.flutter_renderer_frontend_get_image_data_ptr(_frontend!));
  //   _texture.copyFromBufferWithPointer_width_height_channels_(
  //     bindings.flutter_renderer_frontend_get_image_data_ptr(_frontend!).cast(),
  //     512,
  //     512,
  //     4,
  //   );

  //   getFlutterTextureRegistryProxyInstance()
  //       .textureFrameAvailableWithTextureId_(_textureId!);
  // }

  void _spawn() async {
    _texture = MapLibreFlutterTexture.alloc().init();
    _textureId = getFlutterTextureRegistryProxyInstance()
        .registerTextureWithTexture_(_texture);

    print('texture: $_textureId');

    final data = bindings.start_run_loop_thread(
      _textureId!,
      _texture.pointer.cast(),
      NativeCallable<Void Function()>.listener(() {}).nativeFunction,
      NativeCallable<Void Function()>.listener(() {
        print('hi 2');
      }).nativeFunction,
    );

    _runLoop = data.run_loop;
    _frontend = data.frontend;
    _map = data.map;

    final mapCamera = MapCamera.maybeOf(context)!;
    bindings.map_jump_to(
      _runLoop!,
      _map!,
      mapCamera.center.latitude,
      mapCamera.center.longitude,
      mapCamera.zoom - 1.2,
      0.0,
      0.0,
    );

    setState(() {});
  }

  @override
  void didHaveMemoryPressure() {
    bindings.flutter_renderer_frontend_reduce_memory_use(_frontend!);
  }

  @override
  void dispose() {
    // _map?.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final mapCamera = MapCamera.maybeOf(context)!;
    print('didChangeDep');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_textureId != null) ...[
          SizedBox.expand(
            child: MapLibreMapWidget(
              textureId: _textureId!,
              frontend: _frontend!,
              map: _map!,
            ),
          ),
        ],
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // _map?.close();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_frontend != null) {
                  bindings.flutter_renderer_frontend_render_frame(
                    _frontend!,
                  );
                }
              },
              child: const Text('Rend'),
            ),
            ElevatedButton(
              onPressed: () {
                _spawn();
              },
              child: const Text('Create thread'),
            ),
          ],
        ),
      ],
    );
  }
}
