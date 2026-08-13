import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
/// A [CustomClipper<Path>] that defines an organic liquid wave clip mask.
///
/// Driven by [progress], which ranges from 0.0 (current page fully visible)
/// to 1.0 (current page completely clipped away to reveal the page underneath).
///
/// [phase] is a looping value (0.0 → 1.0, driven by an [AnimationController]
/// with `repeat()`) that shifts the wave's control points along the Y-axis,
/// giving the edge a living, rippling quality while the finger holds.
class WaveClipper extends CustomClipper<Path> {
  const WaveClipper({required this.progress, this.phase = 0.0});

  /// Transition progress between 0.0 (no swipe) and 1.0 (swiped away).
  final double progress;

  /// Looping phase value (0.0 → 1.0) from a repeating [AnimationController].
  /// Controls the traveling wave ripple along the clip edge.
  /// When 0.0, no ripple is applied.
  final double phase;

  /// Helper generating the liquid wave [Path] for a given [size], [progress],
  /// and optional [phase]. Shared between [WaveClipper] and [WavePainter].
  static Path buildWavePath(Size size, double progress, {double phase = 0.0}) {
    final path = Path();
    final p = progress.clamp(0.0, 1.0);

    // ── Edge Position ────────────────────────────────────────────────────────
    final edgeX = lerpDouble(size.width, 0.0, p)!;

    // ── Liquid Bulge Magnitude ───────────────────────────────────────────────
    final bulge = size.width * 0.30 * math.sin(p * math.pi);

    // ── Counter-dip Depth ───────────────────────────────────────────────────
    final dip = bulge * 0.18;

    // ── Ripple Amplitude ────────────────────────────────────────────────────
    // The ripple is active only when progress is non-zero (finger is dragging).
    // Amplitude is modulated by sin(p*π) so it fades at both ends of the swipe,
    // keeping the wave perfectly still when the page is fully settled.
    final rippleAmplitude = size.height * 0.018 * math.sin(p * math.pi);

    // Each control point gets a phase-shifted sine offset so the undulation
    // appears to travel downward along the edge (a "traveling wave").
    // spacing = π/3 ≈ 60° per point creates a visible wave direction.
    const phaseSpacing = math.pi / 3.0;
    const tau = 2.0 * math.pi;

    double yOff(int pointIndex) =>
        rippleAmplitude * math.sin(tau * phase + pointIndex * phaseSpacing);

    // ── Path Construction (Double Wave with Middle Inward Curve) ───────────
    path.moveTo(0, 0);
    path.lineTo(edgeX, 0);

    // 1. Upper Wave: Top edge -> Upper Bulge Peak (at ~22% height)
    path.cubicTo(
      edgeX - dip,
      size.height * 0.08 + yOff(0),
      edgeX + bulge,
      size.height * 0.15 + yOff(1),
      edgeX + bulge,
      size.height * 0.22 + yOff(2),
    );

    // 2. Middle Inward Curve: Upper Bulge -> Inward Waist (at ~50% height)
    path.cubicTo(
      edgeX + bulge,
      size.height * 0.32 + yOff(3),
      edgeX + (bulge * 0.1),
      size.height * 0.42 + yOff(4),
      edgeX + (bulge * 0.15),
      size.height * 0.50 + yOff(5),
    );

    // 3. Lower Wave: Inward Waist -> Lower Bulge Peak (at ~78% height)
    path.cubicTo(
      edgeX + (bulge * 0.1),
      size.height * 0.58 + yOff(6),
      edgeX + bulge,
      size.height * 0.68 + yOff(7),
      edgeX + bulge,
      size.height * 0.78 + yOff(8),
    );

    // 4. Bottom Curve: Lower Bulge -> Bottom Edge (at 100% height)
    path.cubicTo(
      edgeX + bulge,
      size.height * 0.86 + yOff(9),
      edgeX - dip,
      size.height * 0.94 + yOff(10),
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
    return buildWavePath(size, progress, phase: phase);
  }

  @override
  bool shouldReclip(covariant WaveClipper oldClipper) {
    return oldClipper.progress != progress || oldClipper.phase != phase;
  }
}
