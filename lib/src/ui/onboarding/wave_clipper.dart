import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// A [CustomClipper<Path>] that defines an organic liquid wave clip mask.
///
/// Driven by [progress], which ranges from 0.0 (current page fully visible)
/// to 1.0 (current page completely clipped away to reveal the page underneath).
class WaveClipper extends CustomClipper<Path> {
  const WaveClipper({required this.progress});

  /// Transition progress between 0.0 (no swipe) and 1.0 (swiped away).
  final double progress;

  /// Helper generating the liquid wave [Path] for a given [size] and [progress].
  /// Shared between [WaveClipper] and [WavePainter].
  static Path buildWavePath(Size size, double progress) {
    final path = Path();
    final p = progress.clamp(0.0, 1.0);

    // ── Edge Position ────────────────────────────────────────────────────────
    final edgeX = lerpDouble(size.width, 0.0, p)!;

    // ── Liquid Bulge Magnitude ───────────────────────────────────────────────
    final bulge = size.width * 0.30 * math.sin(p * math.pi);

    // ── Counter-dip Depth ───────────────────────────────────────────────────
    final dip = bulge * 0.18;

    // ── Path Construction (Double Wave with Middle Inward Curve) ───────────
    path.moveTo(0, 0);
    path.lineTo(edgeX, 0);

    // 1. Upper Wave: Top edge -> Upper Bulge Peak (at ~22% height)
    path.cubicTo(
      edgeX - dip,
      size.height * 0.08,
      edgeX + bulge,
      size.height * 0.15,
      edgeX + bulge,
      size.height * 0.22,
    );

    // 2. Middle Inward Curve: Upper Bulge -> Inward Waist (at ~50% height)
    path.cubicTo(
      edgeX + bulge,
      size.height * 0.32,
      edgeX + (bulge * 0.1),
      size.height * 0.42,
      edgeX + (bulge * 0.15),
      size.height * 0.50,
    );

    // 3. Lower Wave: Inward Waist -> Lower Bulge Peak (at ~78% height)
    path.cubicTo(
      edgeX + (bulge * 0.1),
      size.height * 0.58,
      edgeX + bulge,
      size.height * 0.68,
      edgeX + bulge,
      size.height * 0.78,
    );

    // 4. Bottom Curve: Lower Bulge -> Bottom Edge (at 100% height)
    path.cubicTo(
      edgeX + bulge,
      size.height * 0.86,
      edgeX - dip,
      size.height * 0.94,
      edgeX,
      size.height,
    );

    // Bottom-left corner and close path
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  Path getClip(Size size) {
    return buildWavePath(size, progress);
  }

  @override
  bool shouldReclip(covariant WaveClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
