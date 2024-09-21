import 'dart:ffi' as ffi;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:maplibre_flutter_map/_gen/bindings.dart';

class MapLibreMapWidget extends LeafRenderObjectWidget {
  const MapLibreMapWidget({
    super.key,
    required this.textureId,
    required this.map,
    required this.frontend,
  });

  final int textureId;
  final fml_flutter_renderer_frontend_t frontend;
  final mbgl_map_t map;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MapLibreMapRenderObject(
      frontend: frontend,
      map: map,
      textureId: textureId,
      devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant MapLibreMapRenderObject renderObject,
  ) {
    renderObject
      ..textureId = textureId
      ..devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
  }
}

final bindings = MapLibreFlutterMapBindings(ffi.DynamicLibrary.process());

class MapLibreMapRenderObject extends RenderBox {
  MapLibreMapRenderObject({
    required this.frontend,
    required this.map,
    required int textureId,
    double devicePixelRatio = 1.0,
  })  : _textureId = textureId,
        _devicePixelRatio = devicePixelRatio;

  int get textureId => _textureId;
  int _textureId;
  set textureId(int value) {
    if (value != _textureId) {
      _textureId = value;
      markNeedsPaint();
    }
  }

  double get devicePixelRatio => _devicePixelRatio;
  double _devicePixelRatio = 1.0;
  set devicePixelRatio(double value) {
    if (value != _devicePixelRatio) {
      _devicePixelRatio = value;
      markNeedsLayout();
    }
  }

  final fml_flutter_renderer_frontend_t frontend;
  final mbgl_map_t map;

  @override
  bool get sizedByParent => true;

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  bool get isRepaintBoundary => true;

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    print(size);
    print(devicePixelRatio);

    bindings.flutter_renderer_frontend_set_size(
      frontend,
      map,
      size.width.ceil(),
      size.height.ceil(),
      devicePixelRatio,
    );

    context.addLayer(
      TextureLayer(
        rect: Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
        textureId: _textureId,
        freeze: false,
        filterQuality: FilterQuality.none,
      ),
    );
  }
}
