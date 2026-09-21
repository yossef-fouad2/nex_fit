import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OpenMapStreet extends StatelessWidget {
  const OpenMapStreet({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(29.9737, 32.5263),
          initialZoom: 10,
          minZoom: 7,
          maxZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.nex_fit',
          )
        ]);
  }
}
