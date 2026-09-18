import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

class OpenMapStreet extends StatelessWidget {
  const OpenMapStreet({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlutterMap(options: MapOptions(), children: []);
  }
}
