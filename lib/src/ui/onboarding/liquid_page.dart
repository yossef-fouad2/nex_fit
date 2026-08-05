import 'package:flutter/material.dart';

import 'wave_clipper.dart';

/// Wraps page content with a [ClipPath] driven by [WaveClipper].
///
/// Ensures anti-aliased smooth wave edges during page transitions.
class LiquidPage extends StatelessWidget {
  const LiquidPage({
    super.key,
    required this.progress,
    required this.child,
  });

  /// Transition progress (0.0 → 1.0) passed to [WaveClipper].
  final double progress;

  /// Page content widget to clip.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(progress: progress),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
