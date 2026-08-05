import 'package:nex_fit/src/imports/imports.dart';

import 'liquid_page.dart';
import 'wave_painter.dart';

class OnboardingPage extends HookWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final pageController = usePageController();
    final currentIndex = useState(0);

    // Page data with distinct container colors so liquid wave clipping is visible
    final List<Map<String, dynamic>> onboardingData = useMemoized(() => [
          {
            'title': 'onboarding.onboarding_title_1'.tr(),
            'subtitle': 'onboarding.onboarding_subtitle_1'.tr(),
            'pageWidget': const FlutterLogo(size: 200),
            'color': colorScheme.primaryContainer,
          },
          {
            'title': 'onboarding.onboarding_title_2'.tr(),
            'subtitle': 'onboarding.onboarding_subtitle_2'.tr(),
            'pageWidget': const FlutterLogo(size: 200),
            'color': colorScheme.secondaryContainer,
          },
          {
            'title': 'onboarding.onboarding_title_3'.tr(),
            'subtitle': 'onboarding.onboarding_subtitle_3'.tr(),
            'pageWidget': const FlutterLogo(size: 200),
            'color': colorScheme.tertiaryContainer,
          },
        ]);

    void onGetStarted() {
      appRouter.pushReplacement(AppRoutes.login);
    }

    return _OnboardingView(
      theme: theme,
      colorScheme: colorScheme,
      textTheme: textTheme,
      pageController: pageController,
      currentIndex: currentIndex.value,
      onboardingData: onboardingData,
      onPageChanged: (index) => currentIndex.value = index,
      onGetStarted: onGetStarted,
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView({
    required this.theme,
    required this.colorScheme,
    required this.textTheme,
    required this.pageController,
    required this.currentIndex,
    required this.onboardingData,
    required this.onPageChanged,
    required this.onGetStarted,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final PageController pageController;
  final int currentIndex;
  final List<Map<String, dynamic>> onboardingData;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onGetStarted;

  /// Helper building full-screen content for a given page index.
  Widget _buildPageContent(int index) {
    final safeIndex = index.clamp(0, onboardingData.length - 1);
    final data = onboardingData[safeIndex];

    return ColoredBox(
      color: data['color'] as Color,
      child: SafeArea(
        child: Column(
          children: [
            // Top branding title
            Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.lg.h,
                bottom: AppSpacing.md.h,
              ),
              child: Text(
                'NexFit',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                  fontSize: 22.sp,
                ),
              ),
            ),

            // Dynamic Illustration Section
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg.w,
                  ),
                  child: data['pageWidget'] as Widget,
                ),
              ),
            ),

            // Text Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl.w,
              ),
              child: Column(
                children: [
                  Text(
                    data['title'] as String,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      height: 1.2,
                      fontSize: 24.sp,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Text(
                    data['subtitle'] as String,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentIndex == onboardingData.length - 1;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // ── LAYER 1: Liquid Page Reveal Transition Stack ─────────────────
          // AnimatedBuilder listens to PageController scroll changes.
          // Updates on every frame during user drag gestures.
          AnimatedBuilder(
            animation: pageController,
            builder: (context, _) {
              final page = pageController.hasClients
                  ? (pageController.page ?? 0.0)
                  : 0.0;

              final baseIndex = page.floor();
              final fraction = page - baseIndex;
              final nextIndex = (baseIndex + 1).clamp(0, onboardingData.length - 1);

              return Stack(
                children: [
                  // Bottom Layer: Next Page (revealed underneath)
                  Positioned.fill(
                    child: _buildPageContent(nextIndex),
                  ),

                  // Top Layer: Current Page (clipped by WaveClipper)
                  Positioned.fill(
                    child: LiquidPage(
                      progress: fraction,
                      child: _buildPageContent(baseIndex),
                    ),
                  ),

                  // Wave Edge Shadow Overlay (minimal subtle depth)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WavePainter(
                        progress: fraction,
                        shadowColor: Colors.black.withValues(alpha: 0.04),
                        shadowBlurRadius: 1,
                        shadowWidth: 1,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── LAYER 2: Invisible PageView for touch & drag physics ─────────
          PageView.builder(
            controller: pageController,
            itemCount: onboardingData.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, __) => const SizedBox.shrink(),
          ),

          // ── LAYER 3: Fixed Bottom Controls (Button & Navigation) ─────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      label: isLastPage
                          ? 'shared.get_started'.tr()
                          : 'shared.next'.tr(),
                      onPressed: () {
                        if (isLastPage) {
                          onGetStarted();
                        } else {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      },
                      variant: ButtonVariant.primary,
                      width: ButtonSize.medium,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
