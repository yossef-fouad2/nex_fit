import 'package:flutter/material.dart';

import 'wave_clipper.dart';

/// A [CustomPainter] that renders a soft dark ambient shadow along the liquid wave edge.
class WavePainter extends CustomPainter {
  const WavePainter({
    required this.progress,
    this.phase = 0.0,
    this.shadowColor = const Color(0x1E000000),
    this.shadowBlurRadius = 4.0,
    this.shadowWidth = 2.5,
  });

  /// Transition progress (0.0 to 1.0) synced with [WaveClipper].
  final double progress;

  /// Looping ripple phase — must match the value passed to [WaveClipper].
  final double phase;

  /// Color of the soft ambient shadow.
  final Color shadowColor;

  /// Blur radius of the edge shadow.
  final double shadowBlurRadius;

  /// Stroke width of the shadow band along the wave path.
  final double shadowWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Hide shadow at transition endpoints
    if (progress <= 0.001 || progress >= 0.999) return;

    final path = WaveClipper.buildWavePath(size, progress, phase: phase);

    // Soft dark shadow stroke along the wave edge for depth
    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = shadowWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);

    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.phase != phase ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.shadowBlurRadius != shadowBlurRadius ||
        oldDelegate.shadowWidth != shadowWidth;
  }
}
