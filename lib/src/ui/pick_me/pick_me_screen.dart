import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nex_fit/src/imports/core_imports.dart';
import 'package:nex_fit/src/imports/imports.dart';
import 'package:nex_fit/src/services/location_service.dart';

class PickMeScreen extends HookWidget {
  const PickMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AppGradientButton(
                label: 'Get my location',
                onPressed: () async {
                  final position = await getLocation();
                  // position.longitude;

                  isLoading.value = true;

                  // print(result);
                  if (!context.mounted) return;
                  showToast(
                    context,
                    message:
                        'latitude: ${position.latitude}, longitude: ${position.longitude}',
                  );
                },
                isLoading: isLoading.value,
                accent: Colors.lightBlueAccent,
                accentDark: const Color.fromARGB(255, 18, 82, 135))
          ],
        ),
      ),
    );
  }
}
