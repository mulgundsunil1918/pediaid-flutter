// =============================================================================
// screens/rabies/rabies_protocol_image.dart — the NRCP poster, as published
//
// WHY THE IMAGE AND NOT A REBUILT VERSION
// ---------------------------------------
// This module previously rebuilt the poster out of widgets: a decision table,
// three regimen boxes, a node tree. It was faithful in content and wrong in
// practice — the tree overflowed sideways on a wide screen and clipped
// "Category III" mid-sentence, and a clinician who knows the poster could not
// find their way around a layout that was not the poster's.
//
// The published artwork already solves the layout problem, has been reviewed by
// the programme that issued it, and is what a clinician recognises. So it is
// shown as it is, zoomable, and the app's job is reduced to presenting it well
// and adding the one thing paper cannot: the tappable assessment on the next
// tab.
//
// The image is a Government of India / NRCP public health document, reproduced
// unaltered and attributed.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

import 'rabies_protocol.dart';
import 'rabies_widgets.dart';

/// Where the poster lives once it is bundled.
const String kRabiesPosterAsset =
    'assets/images/rabies/nrcp_pep_protocol.png';

class RabiesProtocolImage extends StatefulWidget {
  const RabiesProtocolImage({super.key});

  @override
  State<RabiesProtocolImage> createState() => _RabiesProtocolImageState();
}

class _RabiesProtocolImageState extends State<RabiesProtocolImage> {
  /// Null while unknown, then true/false once the bundle has been asked.
  ///
  /// Checked rather than assumed so a missing asset produces an explanation
  /// instead of a broken-image glyph — the poster IS the page here, and a
  /// silent grey box would leave a clinician with nothing and no idea why.
  bool? _present;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    var ok = false;
    try {
      await rootBundle.load(kRabiesPosterAsset);
      ok = true;
    } catch (_) {
      ok = false;
    }
    if (mounted) setState(() => _present = ok);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
      children: [
        Text(
          'Protocol for rabies post-exposure prophylaxis after animal bite',
          style: TextStyle(
              fontSize: 15,
              height: 1.3,
              fontWeight: FontWeight.w900,
              color: cs.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          'National Rabies Control Programme · NCDC · Ministry of Health and '
          'Family Welfare, Government of India',
          style: TextStyle(
              fontSize: 11.5,
              height: 1.4,
              color: cs.onSurface.withValues(alpha: 0.65)),
        ),
        const SizedBox(height: 12),
        if (_present == null)
          const SizedBox(
              height: 200, child: Center(child: CircularProgressIndicator()))
        else if (_present == true)
          _poster(cs)
        else
          _missing(cs),
        const SizedBox(height: 14),
        _references(cs),
        const RabiesDisclaimer(),
      ],
    );
  }

  Widget _poster(ColorScheme cs) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const _FullScreenPoster()),
                ),
                // A poster is unreadable at page width on a phone. Tapping is
                // the obvious gesture and the caption below says so, rather
                // than leaving someone pinching at a thumbnail.
                child: Image.asset(kRabiesPosterAsset, fit: BoxFit.fitWidth),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.zoom_in,
                  size: 15, color: cs.onSurface.withValues(alpha: 0.6)),
              const SizedBox(width: 6),
              Expanded(
                child: Text('Tap the poster to open it full screen, then pinch '
                    'to zoom.',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: cs.onSurface.withValues(alpha: 0.65))),
              ),
            ],
          ),
        ],
      );

  Widget _missing(ColorScheme cs) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCatIIAmber.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kCatIIAmber.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.image_not_supported_outlined,
                    size: 18, color: kCatIIAmber),
                SizedBox(width: 9),
                Expanded(
                  child: Text('Poster not bundled in this build',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: kCatIIAmber)),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              'The published NRCP protocol poster is not included in this '
              'build. Use the Assess tab, which implements the same algorithm, '
              'or open the source document below.',
              style: TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  color: cs.onSurface.withValues(alpha: 0.85)),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () => launchUrl(
                Uri.parse(GuidelineSource.ncdcNrcp.url!),
                mode: LaunchMode.externalApplication,
              ),
              icon: const Icon(Icons.open_in_new, size: 17),
              label: const Text('Open the NRCP protocol'),
            ),
          ],
        ),
      );

  Widget _references(ColorScheme cs) => RabiesCard(
        title: 'References',
        icon: Icons.menu_book_outlined,
        subtitle: 'Checked '
            '${rabiesVerifiedOn.day}/${rabiesVerifiedOn.month}/${rabiesVerifiedOn.year}',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The algorithm, categories, schedules and RIG rules in this '
              'module are the NCDC / NRCP national protocol. IAP 2022 is cited '
              'only where it explains something the national protocol states '
              'without elaboration.',
              style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: cs.onSurface.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 14),
            for (final src in GuidelineSource.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      SourceChip(src),
                      if (src == GuidelineSource.ncdcNrcp) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text('PRIMARY SOURCE',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.4,
                                  color: sourceColor(src))),
                        ),
                      ],
                    ]),
                    const SizedBox(height: 6),
                    Text(src.fullName,
                        style: TextStyle(
                            fontSize: 12.5,
                            height: 1.5,
                            color: cs.onSurface.withValues(alpha: 0.85))),
                    if (src.url != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: InkWell(
                          onTap: () => launchUrl(Uri.parse(src.url!),
                              mode: LaunchMode.externalApplication),
                          child: Text(src.url!,
                              style: TextStyle(
                                  fontSize: 11,
                                  height: 1.4,
                                  decoration: TextDecoration.underline,
                                  color: sourceColor(src))),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      );
}

/// The poster on its own screen, where pinch and pan have nothing to fight.
class _FullScreenPoster extends StatefulWidget {
  const _FullScreenPoster();

  @override
  State<_FullScreenPoster> createState() => _FullScreenPosterState();
}

class _FullScreenPosterState extends State<_FullScreenPoster> {
  final _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // Black, because a poster read at high zoom is easier against a
        // neutral ground than against either theme's surface.
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text('NRCP PEP Protocol',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          actions: [
            IconButton(
              tooltip: 'Reset view',
              onPressed: () =>
                  setState(() => _controller.value = Matrix4.identity()),
              icon: const Icon(Icons.center_focus_strong_outlined),
            ),
          ],
        ),
        body: InteractiveViewer(
          transformationController: _controller,
          minScale: 0.8,
          maxScale: 8,
          child: Center(
            child: Image.asset(kRabiesPosterAsset, fit: BoxFit.contain),
          ),
        ),
      );
}
