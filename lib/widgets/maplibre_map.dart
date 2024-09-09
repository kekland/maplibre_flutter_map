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

class FlutterMaplibreMap extends StatelessWidget {
  const FlutterMaplibreMap({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(51.509364, -0.128928),
        initialZoom: 9.2,
      ),
      children: [
        MapLibreMapLayer(),
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
    );
  }
}

class MapLibreMapLayer extends StatefulWidget {
  const MapLibreMapLayer({super.key});

  @override
  State<MapLibreMapLayer> createState() => _MapLibreMapLayerState();
}

FlutterTextureRegistryProxy getFlutterTextureRegistryProxyInstance() {
  return MaplibreFlutterMapPluginGlobals.getTextureRegistry()!;
}

class _MapLibreMapLayerState extends State<MapLibreMapLayer>
    with SingleTickerProviderStateMixin {
  late final BasicFlutterTexture _texture;
  int? _textureId;
  Ticker? _ticker;

  mbgl_run_loop_t? _runLoop;
  mbgl_headless_frontend_t? _frontend;
  mbgl_map_t? _map;

  final bindings = MapLibreFlutterMapBindings(DynamicLibrary.process());

  @override
  void initState() {
    super.initState();

    // _ticker = createTicker((elapsed) {
    //   print('tick');

    //   if (_frontend != null) {
    //     bindings.headless_frontend_render_frame(_runLoop!, _frontend!);
    //   }
    // });

    // _ticker?.start();
  }

  void _spawn() async {
    _texture = BasicFlutterTexture.alloc().init();
    _textureId = getFlutterTextureRegistryProxyInstance()
        .registerTextureWithTexture_(_texture);

    _runLoop = bindings.start_run_loop_thread();

    _frontend = bindings.headless_frontend_create(
      _runLoop!,
      1000,
      1000,
      1.0,
    );

    final mapObserver = bindings.map_observer_create(
      NativeCallable<Void Function()>.listener(
        () {
          print('hi');
          _texture.copyFromBufferWithPointer_width_height_channels_(
            bindings.headless_frontend_get_image_data_ptr(_frontend!).cast(),
            1000,
            1000,
            4,
          );

          getFlutterTextureRegistryProxyInstance()
              .textureFrameAvailableWithTextureId_(_textureId!);
        },
      ).nativeFunction,
    );

    final options = bindings.tile_server_options_map_tiler_create();

    _map = bindings.map_create(
      _runLoop!,
      _frontend!,
      mapObserver,
      0,
      1.0,
      '5IZuFl4CkB3Io0SjxUVJ'.toNativeUtf8().cast(),
      options,
    );

    bindings.map_set_style(
      _runLoop!,
      _map!,
      "https://api.maptiler.com/maps/7d5f4aed-f3bb-4c46-8dee-e1e79cd2e12b/style.json?key=5IZuFl4CkB3Io0SjxUVJ"
          .toNativeUtf8()
          .cast(),
    );

    bindings.map_jump_to(
      _runLoop!,
      _map!,
      43.1991413838172,
      76.85274264579952,
      10.0,
      0.0,
      0.0,
    );

    setState(() {});
  }

  @override
  void dispose() {
    // _map?.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final mapCamera = MapCamera.maybeOf(context)!;

    if (_map != null) {
      print('map jump');
      bindings.map_jump_to(
        _runLoop!,
        _map!,
        mapCamera.center.latitude,
        mapCamera.center.longitude,
        mapCamera.zoom,
        0.0,
        0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_textureId != null)
          SizedBox(
            width: 320,
            height: 320,
            child: AspectRatio(
              aspectRatio: 1,
              child: Texture(textureId: _textureId!),
            ),
          ),
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
                  bindings.headless_frontend_render_frame(
                    _runLoop!,
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
              child: const Text('Copy to buffer'),
            ),
          ],
        ),
      ],
    );
  }
}
