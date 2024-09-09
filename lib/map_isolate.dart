// import 'dart:async';
// import 'dart:ffi';
// import 'dart:isolate';

// import 'package:ffi/ffi.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:maplibre_flutter_map/_gen/bindings.dart';

// final _bindings = MapLibreFlutterMapBindings(DynamicLibrary.process());

// class MapIsolate {
//   final SendPort _commands;
//   final ReceivePort _responses;
//   final Pointer<Void> _runLoop;
//   final Map<int, Completer<Object?>> _activeRequests = {};
//   int _idCounter = 0;
//   bool _closed = false;

//   static Future<MapIsolate> spawn() async {
//     // Create a receive port and add its initial message handler
//     final initPort = RawReceivePort();
//     final connection = Completer<(ReceivePort, SendPort, Pointer<Void>)>.sync();
//     initPort.handler = (initialMessage) {
//       final commandPort = initialMessage.$1 as SendPort;
//       final runLoop = initialMessage.$2 as Pointer<Void>;

//       connection.complete((
//         ReceivePort.fromRawReceivePort(initPort),
//         commandPort,
//         runLoop,
//       ));
//     };

//     // Spawn the isolate.
//     try {
//       await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
//     } on Object {
//       initPort.close();
//       rethrow;
//     }

//     final (ReceivePort receivePort, SendPort sendPort, Pointer<Void> runLoop) =
//         await connection.future;

//     return MapIsolate._(receivePort, sendPort, runLoop);
//   }

//   MapIsolate._(this._responses, this._commands, this._runLoop) {
//     _responses.listen(_handleResponsesFromIsolate);
//   }

//   void _handleResponsesFromIsolate(dynamic message) {
//     final (int id, Object? response) = message as (int, Object?);
//     final completer = _activeRequests.remove(id)!;

//     if (response is RemoteError) {
//       completer.completeError(response);
//     } else {
//       completer.complete(response);
//     }

//     if (_closed && _activeRequests.isEmpty) _responses.close();
//   }

//   static Future<void> _startRemoteIsolate(SendPort sendPort) async {
//     final receivePort = ReceivePort();

//     final runLoop = _bindings.run_loop_create();

//     sendPort.send((receivePort.sendPort, runLoop));

//     final frontend = _bindings.headless_frontend_create(
//       1080,
//       1920,
//       1.0,
//     );

//     final observer = _bindings.map_observer_create(
//       NativeCallable<Void Function()>.listener(() {
//         print("Map changed");
//       }).nativeFunction,
//     );

//     final options = _bindings.tile_server_options_map_tiler_create();

//     final map = _bindings.map_create(
//       frontend,
//       observer,
//       0,
//       1.0,
//       "5IZuFl4CkB3Io0SjxUVJ".toNativeUtf8().cast(),
//       options,
//     );

//     _bindings.map_set_style(
//       map,
//       "https://api.maptiler.com/maps/7d5f4aed-f3bb-4c46-8dee-e1e79cd2e12b/style.json?key=5IZuFl4CkB3Io0SjxUVJ"
//           .toNativeUtf8()
//           .cast(),
//     );

//     _bindings.map_jump_to(
//       map,
//       43.1991413838172,
//       76.85274264579952,
//       14.0,
//       0.0,
//       0.0,
//     );

//     receivePort.listen((message) {
//       print(message);

//       if (message == 'shutdown') {
//         print('shutdown!');
//         receivePort.close();

//         return;
//       }

//       final (int id, String jsonText) = message as (int, String);

//       try {
//         print('--- command received --- ');
//       } catch (e) {
//         sendPort.send((id, RemoteError(e.toString(), '')));
//       }
//     });

//     print('--- run loop run --- ');
//     while (true) {
//       final completer = Completer();

//       Future.delayed(Duration.zero, () {
//         print('exec');
//         _bindings.run_loop_wait_for_empty(runLoop);
//         print('ret');
//         completer.complete();
//       });

//       await completer.future;
//     }
//   }

//   void close() {
//     if (!_closed) {
//       _closed = true;

//       _bindings.run_loop_stop(_runLoop);
//       _commands.send('shutdown');

//       if (_activeRequests.isEmpty) _responses.close();
//       print('--- port closed --- ');
//     }
//   }
// }
