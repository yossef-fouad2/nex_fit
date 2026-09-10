import '../../imports/imports.dart';

/// A full-width gradient pill button that collapses into a loading circle.
///
/// Behaviour:
/// - Horizontal gradient from [accentDark] to [accent] with a soft shadow.
/// - `AnimatedScale(0.97)` on press at 140 ms `easeOutCubic`.
/// - When [isLoading] becomes true:
///   - Width contracts from full to a circle in 400 ms `easeOutCubic`.
///   - AnimatedSwitcher crossfades label → spinner (220 ms).
class AppGradientButton extends HookWidget {
  const AppGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.accent,
    required this.accentDark,
    this.trailingIcon,
    this.isLoading = false,
    this.height,
    this.borderRadius = 16,
  });

  final String label;
  final VoidCallback onPressed;
  final Color accent;
  final Color accentDark;
  final Widget? trailingIcon;
  final bool isLoading;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);
    final buttonH = height ?? 56.h;

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;

        return GestureDetector(
          onTapDown: (_) {
            if (!isLoading) isPressed.value = true;
          },
          onTapUp: (_) {
            isPressed.value = false;
            if (!isLoading) onPressed();
          },
          onTapCancel: () => isPressed.value = false,
          child: AnimatedScale(
            scale: isPressed.value ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              // Width morphs: full-width → circle height (square) when loading
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              width: isLoading ? buttonH : fullWidth,
              height: buttonH,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentDark, accent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(
                  isLoading ? buttonH / 2 : borderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.38),
                    blurRadius: 22,
                    spreadRadius: -2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  isLoading ? buttonH / 2 : borderRadius,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: isLoading
                        ? SizedBox(
                            key: const ValueKey('spinner'),
                            width: 24.w,
                            height: 24.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Padding(
                            key: const ValueKey('label'),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    label,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  if (trailingIcon != null) ...[
                                    SizedBox(width: 8.w),
                                    trailingIcon!,
                                  ],
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
