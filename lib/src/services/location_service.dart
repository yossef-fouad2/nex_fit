import 'package:geolocator/geolocator.dart';
import 'package:nex_fit/src/imports/imports.dart';

Future<Position> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  try {
    if (!serviceEnabled) {}
  } on Exception catch (e) {
    AppErrorHandler.format(e);
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
  // final SharedPreferences preferences = await SharedPreferences.getInstance();
  //moved outside for decoupling and reusabilty
  // await preferences.setDouble('lat', position.latitude);
  // await preferences.setDouble('long', position.longitude);
  print('${position.latitude}: ${position.longitude}: ${position.accuracy}');
  return position;
}

Future<void> saveLocation(Position position) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setDouble('lat', position.latitude);
  await preferences.setDouble('long', position.longitude);
}
