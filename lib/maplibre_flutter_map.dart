import 'dart:ffi';

import 'package:maplibre_flutter_map/_gen/bindings.dart';

void testFn() {
  final bindings = MapLibreFlutterMapBindings(DynamicLibrary.process());
  print(bindings.test_function());
}
