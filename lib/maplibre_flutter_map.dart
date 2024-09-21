import 'dart:ffi';
import 'package:maplibre_flutter_map/_gen/bindings.dart';

export 'map.dart';
export 'map_isolate.dart';

export 'widgets/maplibre_map.dart';

void testFn() {
  final bindings = MapLibreFlutterMapBindings(DynamicLibrary.process());
  print(bindings.test_function());
}
