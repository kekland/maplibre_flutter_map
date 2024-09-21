
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

@immutable
class _Transformation {
  final double a;
  final double b;
  final double c;
  final double d;

  const _Transformation(this.a, this.b, this.c, this.d);

  @nonVirtual
  (double, double) transform(double x, double y, double scale) => (
        scale * (a * x + b),
        scale * (c * y + d),
      );

  @nonVirtual
  (double, double) untransform(double x, double y, double scale) => (
        (x / scale - b) / a,
        (y / scale - d) / c,
      );
}

/// Internal base class for CRS with a single zoom-level independent transformation.
@immutable
abstract class CrsWithStaticTransformation extends Crs {
  @nonVirtual
  @protected
  final _Transformation _transformation;

  @override
  final Projection projection;

  const CrsWithStaticTransformation._({
    required _Transformation transformation,
    required this.projection,
    required super.code,
    required super.infinite,
    super.wrapLng,
    super.wrapLat,
  }) : _transformation = transformation;

  @override
  (double, double) transform(double x, double y, double scale) =>
      _transformation.transform(x, y, scale);

  @override
  (double, double) untransform(double x, double y, double scale) =>
      _transformation.untransform(x, y, scale);

  @override
  (double, double) latLngToXY(LatLng latlng, double scale) {
    final (x, y) = projection.projectXY(latlng);
    return _transformation.transform(x, y, scale);
  }

  @override
  LatLng pointToLatLng(Point point, double zoom) {
    final (x, y) = _transformation.untransform(
      point.x.toDouble(),
      point.y.toDouble(),
      scale(zoom),
    );
    return projection.unprojectXY(x, y);
  }

  @override
  Bounds<double>? getProjectedBounds(double zoom) {
    if (infinite) return null;

    final b = projection.bounds!;
    final s = scale(zoom);
    final (minx, miny) = _transformation.transform(b.min.x, b.min.y, s);
    final (maxx, maxy) = _transformation.transform(b.max.x, b.max.y, s);
    return Bounds<double>(
      Point<double>(minx, miny),
      Point<double>(maxx, maxy),
    );
  }
}

/// EPSG:3857, The most common CRS used for rendering maps.
@immutable
class MyEpsg3857 extends CrsWithStaticTransformation {
  static const double _scale = 1.0 / (pi * SphericalMercator.r);

  /// Create a new [Epsg3857] object.
  const MyEpsg3857()
      : super._(
          code: 'EPSG:3857',
          transformation: const _Transformation(_scale, 0.5, -_scale, 0.5),
          projection: const SphericalMercator(),
          infinite: false,
          wrapLng: const (-180, 180),
        );

  @override
  (double, double) latLngToXY(LatLng latlng, double scale) =>
      _transformation.transform(
        SphericalMercator.projectLng(latlng.longitude),
        SphericalMercator.projectLat(latlng.latitude),
        scale,
      );

  @override
  Point<double> latLngToPoint(LatLng latlng, double zoom) {
    final (x, y) = _transformation.transform(
      SphericalMercator.projectLng(latlng.longitude),
      SphericalMercator.projectLat(latlng.latitude),
      scale(zoom),
    );
    return Point<double>(x, y);
  }
}
