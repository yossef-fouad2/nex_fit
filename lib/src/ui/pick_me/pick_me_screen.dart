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
                  isLoading.value = true;
                  final position = await getLocation();
                  if (!context.mounted) return;
                  showToast(
                    context,
                    message:
                        'latitude: ${position.latitude}, longitude: ${position.longitude}',
                  );
                  isLoading.value = false;
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
