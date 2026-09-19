import 'package:nex_fit/src/imports/imports.dart';
import 'package:nex_fit/src/services/location_service.dart';

class PickMeScreen extends HookWidget {
  const PickMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    return Scaffold(
      body: Column(
        children: [
          const Text('Pick me up'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(32),
            child: AppGradientButton(
                label: 'Get my location',
                onPressed: () async {
                  isLoading.value = true;
                  try {
                    final position = await getLocation();
                    await saveLocation(position);
                    if (context.mounted) {
                      showToast(
                        context,
                        message:
                            'latitude: ${position.latitude}, longitude: ${position.longitude}',
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showToast(
                        context,
                        message: AppErrorHandler.format(e),
                        status: 'error',
                      );
                    }
                  } finally {
                    isLoading.value = false;
                  }
                },
                isLoading: isLoading.value,
                accent: Colors.lightBlueAccent,
                accentDark: const Color.fromARGB(255, 18, 82, 135)),
          )
        ],
      ),
    );
  }
}
