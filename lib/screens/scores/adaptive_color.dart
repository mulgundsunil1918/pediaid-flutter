// =============================================================================
// scores/adaptive_color.dart
//
// Semantic colours (green/amber/orange/red bands, module accents) are authored
// for a light background. Painted as TEXT on the app's dark theme they fail
// contrast badly — a #B71C1C red on a near-black surface is barely legible.
//
// adaptInk() lifts a colour's lightness in dark mode so the same semantic hue
// stays readable on both grounds, without every caller keeping two palettes.
// Use it for anything drawn as text/icon; tinted FILLS (alpha ≈ 0.08) can keep
// the raw colour since they sit under adapted text.
// =============================================================================

import 'package:flutter/material.dart';

/// Returns [c] on a light surface; a lightened, slightly desaturated variant on
/// a dark surface so text keeps its meaning and stays legible.
Color adaptInk(BuildContext context, Color c) {
  if (Theme.of(context).brightness != Brightness.dark) return c;
  final hsl = HSLColor.fromColor(c);
  // Target a high-lightness variant; cap saturation so it doesn't glare.
  final l = hsl.lightness < 0.55 ? (hsl.lightness + 0.34) : hsl.lightness;
  return hsl
      .withLightness(l.clamp(0.0, 0.82))
      .withSaturation((hsl.saturation * 0.85).clamp(0.0, 0.75))
      .toColor();
}
