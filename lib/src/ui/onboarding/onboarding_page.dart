import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_fit/src/imports/imports.dart';

import 'liquid_page.dart';
import 'wave_painter.dart';

// ── Onboarding Page Gradient Definitions ────────────────────────────────────

/// Each page's gradient stop-colors. Dark, gym-energy palettes.
const _kPageGradients = [
  // Page 1 – Deep indigo → electric blue (power / strength)
  [Color(0xFF0D0D2B), Color(0xFF1A1A6E), Color(0xFF2563EB)],
  // Page 2 – Dark charcoal → vivid coral-orange (energy / heat)
  [Color(0xFF1A0A00), Color(0xFF7C2D12), Color(0xFFEA580C)],
  // Page 3 – Deep teal → electric mint (recovery / refresh)
  [Color(0xFF011F1F), Color(0xFF065F46), Color(0xFF10B981)],
];

/// Text colors (high contrast on dark gradients).
const _kPageTextColors = [
  Colors.white,
  Colors.white,
  Colors.white,
];

/// Accent colors used in the page indicator and button gradient.
const _kPageAccents = [
  Color(0xFF2563EB),
  Color(0xFFEA580C),
  Color(0xFF10B981),
];

/// Dark companion shades for the button gradient (left stop).
const _kPageAccentsDark = [
  Color(0xFF1E3A8A),
  Color(0xFF9A3412),
  Color(0xFF065F46),
];

// ── Main Widget ─────────────────────────────────────────────────────────────

class OnboardingPage extends HookWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final pageController = usePageController();
    final currentIndex = useState(0);

    // ── Wave ripple controller ──────────────────────────────────────────────
    final wavePhaseController = useAnimationController(
      duration: const Duration(milliseconds: 2500),
    );

    // ── Text entrance controller ────────────────────────────────────────────
    final textEntranceController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    )..forward(from: 0);

    useEffect(() {
      textEntranceController.forward(from: 0);
      return null;
    }, [currentIndex.value]);

    // ── Floating particle controller ────────────────────────────────────────
    final particleController = useAnimationController(
      duration: const Duration(milliseconds: 8000),
    )..repeat();

    // ── Loading state for Get Started morph ────────────────────────────────
    final isLoading = useState(false);

    // Page data
    final List<Map<String, dynamic>> onboardingData = useMemoized(() => [
          {
            'title': 'onboarding.onboarding_title_1'.tr(),
            'subtitle': 'onboarding.onboarding_subtitle_1'.tr(),
            'pageWidget': Lottie.asset(AppAssets.squatAnimation, repeat: true),
            'gradients': _kPageGradients[0],
            'accent': _kPageAccents[0],
            'accentDark': _kPageAccentsDark[0],
          },
          {
            'title': 'onboarding.onboarding_title_2'.tr(),
            'subtitle': 'onboarding.onboarding_subtitle_2'.tr(),
            'pageWidget':
                Lottie.asset(AppAssets.gymDumbbellAnimation, repeat: true),
            'gradients': _kPageGradients[1],
            'accent': _kPageAccents[1],
            'accentDark': _kPageAccentsDark[1],
          },
          {
            'title': 'onboarding.onboarding_title_3'.tr(),
            'subtitle': 'onboarding.onboarding_subtitle_3'.tr(),
            'pageWidget':
                Lottie.asset(AppAssets.scheduleAnimation, repeat: true),
            'gradients': _kPageGradients[2],
            'accent': _kPageAccents[2],
            'accentDark': _kPageAccentsDark[2],
          },
        ]);

    void onGetStarted() {
      if (isLoading.value) return;
      isLoading.value = true;
      // Navigate after the morph animation settles
      Future.delayed(const Duration(milliseconds: 1200), () {
        appRouter.pushReplacement(AppRoutes.login);
      });
    }

    void onSkip() {
      HapticFeedback.lightImpact();
      appRouter.pushReplacement(AppRoutes.login);
    }

    return _OnboardingView(
      theme: theme,
      colorScheme: colorScheme,
      textTheme: textTheme,
      pageController: pageController,
      currentIndex: currentIndex.value,
      onboardingData: onboardingData,
      onPageChanged: (index) {
        currentIndex.value = index;
        HapticFeedback.selectionClick();
      },
      onGetStarted: onGetStarted,
      onSkip: onSkip,
      isLoading: isLoading.value,
      wavePhaseController: wavePhaseController,
      textEntranceController: textEntranceController,
      particleController: particleController,
    );
  }
}

// ── View ─────────────────────────────────────────────────────────────────────

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
    required this.onSkip,
    required this.isLoading,
    required this.wavePhaseController,
    required this.textEntranceController,
    required this.particleController,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final PageController pageController;
  final int currentIndex;
  final List<Map<String, dynamic>> onboardingData;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onGetStarted;
  final VoidCallback onSkip;
  final bool isLoading;
  final AnimationController wavePhaseController;
  final AnimationController textEntranceController;
  final AnimationController particleController;

  Color _accent(int index) =>
      onboardingData[index.clamp(0, onboardingData.length - 1)]['accent']
          as Color;

  Color _accentDark(int index) =>
      onboardingData[index.clamp(0, onboardingData.length - 1)]['accentDark']
          as Color;

  Widget _buildPageContent(int index, {double parallaxOffset = 0.0}) {
    final safeIndex = index.clamp(0, onboardingData.length - 1);
    final data = onboardingData[safeIndex];
    final gradients = data['gradients'] as List<Color>;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradients,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: particleController,
                builder: (_, __) => CustomPaint(
                  painter: _ParticlePainter(
                    progress: particleController.value,
                    color: gradients.last,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: AppSpacing.lg.h,
                    bottom: AppSpacing.md.h,
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white, gradients.last],
                    ).createShader(bounds),
                    child: Text(
                      'Nex Fit',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 22.sp,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Transform.translate(
                    offset: Offset(parallaxOffset * 60.0, 0),
                    child: Center(
                      child: SizedBox(
                        height: 0.42.sh,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg.w,
                          ),
                          child: data['pageWidget'] as Widget,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 130.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentIndex == onboardingData.length - 1;
    final currentAccent = _accent(currentIndex);
    final currentAccentDark = _accentDark(currentIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: Liquid wave transition stack
          AnimatedBuilder(
            animation: Listenable.merge([pageController, wavePhaseController]),
            builder: (context, _) {
              final page = pageController.hasClients
                  ? (pageController.page ?? 0.0)
                  : 0.0;
              final baseIndex = page.floor();
              final fraction = page - baseIndex;
              final nextIndex =
                  (baseIndex + 1).clamp(0, onboardingData.length - 1);

              if (fraction > 0.005 && fraction < 0.995) {
                if (!wavePhaseController.isAnimating) {
                  wavePhaseController.repeat();
                }
              } else {
                if (wavePhaseController.isAnimating) {
                  wavePhaseController.stop();
                }
              }

              final phase = wavePhaseController.value;
              final nextParallax = -(1.0 - fraction) * 0.4;
              final baseParallax = fraction * 0.4;

              return Stack(
                children: [
                  Positioned.fill(
                    child: _buildPageContent(nextIndex,
                        parallaxOffset: nextParallax),
                  ),
                  Positioned.fill(
                    child: LiquidPage(
                      progress: fraction,
                      phase: phase,
                      child: _buildPageContent(baseIndex,
                          parallaxOffset: baseParallax),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WavePainter(
                        progress: fraction,
                        phase: phase,
                        shadowColor: Colors.black.withValues(alpha: 0.18),
                        shadowBlurRadius: 5,
                        shadowWidth: 3,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // LAYER 2: Invisible PageView for drag physics
          PageView.builder(
            controller: pageController,
            itemCount: onboardingData.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, __) => const SizedBox.shrink(),
          ),

          // LAYER 3: Skip button
          if (!isLastPage && !isLoading)
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg.w,
                    vertical: AppSpacing.sm.h,
                  ),
                  child: TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.70),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // LAYER 4: Staggered text entrance overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 130.h,
            child: AnimatedBuilder(
              animation: textEntranceController,
              builder: (context, _) {
                final t = textEntranceController.value;
                final titleCurve =
                    Curves.easeOutCubic.transform(t.clamp(0.0, 1.0));
                final subtitleCurve = Curves.easeOutCubic
                    .transform(((t - 0.15) / 0.85).clamp(0.0, 1.0));
                final safeIndex =
                    currentIndex.clamp(0, onboardingData.length - 1);
                final data = onboardingData[safeIndex];
                final textColor = _kPageTextColors[safeIndex];

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
                  child: Column(
                    children: [
                      Opacity(
                        opacity: titleCurve,
                        child: Transform.translate(
                          offset: Offset(0, 24.0 * (1.0 - titleCurve)),
                          child: Text(
                            data['title'] as String,
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: textColor,
                              height: 1.15,
                              fontSize: 36.sp,
                              letterSpacing: -0.5,
                              fontFamily: GoogleFonts.anybody(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ).fontFamily,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      Opacity(
                        opacity: subtitleCurve,
                        child: Transform.translate(
                          offset: Offset(0, 24.0 * (1.0 - subtitleCurve)),
                          child: Text(
                            data['subtitle'] as String,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: textColor.withValues(alpha: 0.90),
                              height: 1.6,
                              fontSize: 14.sp,
                              fontFamily: GoogleFonts.anybody().fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // LAYER 5: Fixed bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.25, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0),
                    Colors.black.withValues(alpha: 0.70),
                    Colors.black.withValues(alpha: 0.92),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xl.w,
                    AppSpacing.md.h,
                    AppSpacing.xl.w,
                    AppSpacing.lg.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Page indicator fades out during loading morph
                      AnimatedOpacity(
                        duration: AppDurations.normal,
                        opacity: isLoading ? 0.0 : 1.0,
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: onboardingData.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 8.h,
                            dotWidth: 8.w,
                            expansionFactor: 3.5,
                            spacing: 6.w,
                            activeDotColor: currentAccent,
                            dotColor: Colors.white.withValues(alpha: 0.30),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg.h),

                      // Bespoke onboarding button
                      AppGradientButton(
                        label: isLastPage
                            ? 'shared.get_started'.tr()
                            : 'shared.next'.tr(),
                        trailingIcon: isLastPage
                            ? null
                            : const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                        isLoading: isLoading,
                        accent: currentAccent,
                        accentDark: currentAccentDark,
                        onPressed: () {
                          if (isLastPage) {
                            onGetStarted();
                          } else {
                            pageController.nextPage(
                              duration: AppDurations.medium,
                              curve: Curves.easeOutCubic,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Floating Particle Painter ────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  static const _particles = [
    (dx: 0.15, dy: 0.20, r: 60.0, speed: 0.30, phase: 0.00),
    (dx: 0.80, dy: 0.10, r: 40.0, speed: 0.20, phase: 0.25),
    (dx: 0.65, dy: 0.55, r: 80.0, speed: 0.15, phase: 0.50),
    (dx: 0.30, dy: 0.75, r: 50.0, speed: 0.25, phase: 0.75),
    (dx: 0.90, dy: 0.80, r: 35.0, speed: 0.35, phase: 0.10),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final dy = size.height * p.dy +
          math.sin(t * 2 * math.pi) * size.height * 0.04;
      final dx = size.width * p.dx;
      final opacity = 0.06 + 0.04 * math.sin(t * math.pi);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

      canvas.drawCircle(Offset(dx, dy), p.r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
