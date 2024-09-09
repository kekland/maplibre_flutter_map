import 'package:flutter/material.dart';
import 'package:maplibre_flutter_map/maplibre_flutter_map.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapLibreMapPage(),
    );
  }
}

// class MapLibreMapPage extends StatefulWidget {
//   const MapLibreMapPage({super.key});

//   @override
//   State<MapLibreMapPage> createState() => _MapLibreMapPageState();
// }

// class _MapLibreMapPageState extends State<MapLibreMapPage> {
//   late final MapLibreMap _map;

//   @override
//   void initState() {
//     super.initState();
//     _spawn();
//   }

//   Future<void> _spawn() async {
//     _map = MapLibreMap();
//     _map.initialize();
//   }

//   void _createImage() {
//     _map.render();
//   }

//   @override
//   void dispose() {
//     _map.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('MapLibre Map'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('MapLibre Map'),
//             ElevatedButton(
//               onPressed: _createImage,
//               child: const Text('Create Image'),
//             ),
//             ElevatedButton(
//               onPressed: _map.testfn,
//               child: const Text('Testfn'),
//             ),
//             Expanded(
//               child: ValueListenableBuilder(
//                 valueListenable: _map.uiImage,
//                 builder: (context, image, _) {
//                   if (image == null) {
//                     return const CircularProgressIndicator();
//                   }

//                   return RawImage(image: image);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class MapLibreMapPage extends StatelessWidget {
  const MapLibreMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MapLibre Map'),
      ),
      body: const FlutterMaplibreMap(),
    );
  }
}