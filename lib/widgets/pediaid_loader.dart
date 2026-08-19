// =============================================================================
// widgets/pediaid_loader.dart
//
// A branded loading screen, reused wherever the app has to do a visible bit of
// work before content appears (the WHO and IAP growth charts parse their data
// and spin up a WebView, which takes a beat). It mirrors the app's boot loader
// in web/index.html — the same deep-blue field and the "PediAid" wordmark with
// a light sweeping across it — so the in-app wait reads as part of the same
// product, not a bare Material spinner.
//
// The animation is intentionally indeterminate: chart parsing gives us no real
// progress fraction, so a looping shimmer is honest where a climbing percentage
// would be invented. One AnimationController drives the wordmark sheen, the
// slider bar, and the trailing dots together.
// =============================================================================

import 'package:flutter/material.dart';

class PediAidLoader extends StatefulWidget {
  const PediAidLoader({super.key, this.message = 'Loading'});

  /// Caption under the wordmark, e.g. 'Preparing WHO growth charts'.
  /// Do not add a trailing ellipsis — the loader animates its own dots.
  final String message;

  @override
  State<PediAidLoader> createState() => _PediAidLoaderState();
}

class _PediAidLoaderState extends State<PediAidLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Boot-loader palette (web/index.html): deep navy field, cool-white sheen.
  static const _navyTop = Color(0xFF24487A);
  static const _navyMid = Color(0xFF16304F);
  static const _navyDeep = Color(0xFF0C1E33);
  static const _wordBase = Color(0xFF5C8FD0); // resting wordmark tint
  static const _sheen = Color(0xFFEAF4FF); // moving highlight

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.4, -0.7),
          radius: 1.4,
          colors: [_navyTop, _navyMid, _navyDeep],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                // Slide a 2-unit-wide gradient across the wordmark; the white
                // stop at 0.5 sits at the centre, so the highlight tracks `dx`.
                final dx = _ctrl.value * 2 - 1; // -1 → 1
                return ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment(dx - 1, 0),
                    end: Alignment(dx + 1, 0),
                    colors: const [_wordBase, _sheen, _wordBase],
                    stops: const [0.4, 0.5, 0.6],
                  ).createShader(bounds),
                  child: const Text(
                    'PediAid',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 22),
            // Slim indeterminate track with a gliding segment.
            SizedBox(
              width: 150,
              height: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Stack(
                  children: [
                    Container(color: Colors.white.withValues(alpha: 0.12)),
                    AnimatedBuilder(
                      animation: _ctrl,
                      builder: (context, _) => Align(
                        alignment: Alignment(_ctrl.value * 2 - 1, 0),
                        child: FractionallySizedBox(
                          widthFactor: 0.4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              gradient: const LinearGradient(colors: [
                                Color(0x0067A0E0),
                                _sheen,
                                Color(0x0067A0E0),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                final dots = '.' * (((_ctrl.value * 3).floor() % 3) + 1);
                return Text(
                  '${widget.message}$dots',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 13,
                    letterSpacing: 0.3,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
