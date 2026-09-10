import 'package:geolocator/geolocator.dart';
import 'package:nex_fit/src/imports/core_imports.dart';
import 'package:nex_fit/src/shared/widgets/widgets.dart';

Future<Position> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location is not enabled');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission is denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  final position = await Geolocator.getCurrentPosition();
  // ToastCard(
  //   title: Text('Location'),
  //   leading: Text('${position.longitude} : ${position.altitude}'),
  // );
  showGlobalToast(message: '${position.longitude} : ${position.altitude}');
  print('${position.latitude}: ${position.longitude}: ${position.accuracy}');
  return position;
}
