// =============================================================================
// _emergency_guide_widgets.dart
//
// Shared visual helpers for the family of emergency-protocol guides
// (DKA, Snake envenomation, Scorpion sting, Poisoning + Antidotes,
// Acute Severe Asthma). Each guide is its own screen file but uses
// these primitives so the look + feel is uniform across the protocol set.
// =============================================================================

import 'package:flutter/material.dart';

const Color emergencyBrand = Color(0xFF6A1B9A);          // Source brochure purple
const Color emergencyBrandLight = Color(0xFFE1BEE7);
const Color emergencyRed = Color(0xFFB71C1C);
const Color emergencyAmber = Color(0xFFEF6C00);
const Color emergencyGreen = Color(0xFF2E7D32);
const Color emergencyBlue = Color(0xFF1565C0);

class EgScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  const EgScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
        backgroundColor: emergencyBrand,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
        children: [
          if (subtitle != null)
            Container(
              color: emergencyBrand,
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
              child: Text(
                subtitle!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

class EgSectionLabel extends StatelessWidget {
  final String tag;
  final String title;
  const EgSectionLabel(this.tag, [this.title = '']);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: emergencyBrand.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tag.toUpperCase(),
              style: const TextStyle(
                color: emergencyBrand,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          if (title.isNotEmpty)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  title,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class EgCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  const EgCard({super.key, required this.child, this.borderColor});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
              color: borderColor ?? cs.onSurface.withValues(alpha: 0.10)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

class EgBlock extends StatelessWidget {
  final String title;
  final List<String> lines;
  const EgBlock({super.key, required this.title, required this.lines});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            )),
        const SizedBox(height: 8),
        EgBulletList(items: lines),
      ],
    );
  }
}

class EgBulletList extends StatelessWidget {
  final List<String> items;
  final bool white;
  final bool numbered;
  const EgBulletList(
      {super.key,
      required this.items,
      this.white = false,
      this.numbered = false});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = white ? Colors.white : cs.onSurface.withValues(alpha: 0.85);
    int n = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((line) {
        if (line.isEmpty) return const SizedBox(height: 8);
        n++;
        final prefix = numbered ? '$n.' : '•';
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: numbered ? 18 : 14,
                child: Text(prefix,
                    style: TextStyle(
                        color: fg.withValues(alpha: 0.55),
                        fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(line,
                    style: TextStyle(
                      color: fg,
                      fontSize: 13,
                      height: 1.5,
                    )),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class EgBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final Color color;
  const EgBanner({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.color = emergencyBrand,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ]),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(body!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class EgPearl extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const EgPearl(
      {super.key,
      this.icon = Icons.lightbulb_outline,
      required this.title,
      required this.body});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: dark
              ? emergencyBrand.withValues(alpha: 0.18)
              : emergencyBrandLight.withValues(alpha: 0.4),
          border: Border.all(color: emergencyBrand.withValues(alpha: 0.25)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: emergencyBrand, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                      color: emergencyBrand,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    )),
              ),
            ]),
            const SizedBox(height: 6),
            Text(body,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.85),
                  fontSize: 12.5,
                  height: 1.55,
                )),
          ],
        ),
      ),
    );
  }
}

class EgDontDoCard extends StatelessWidget {
  final String title;
  final List<String> items;
  const EgDontDoCard({super.key, required this.title, required this.items});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: emergencyRed.withValues(alpha: 0.08),
          border: Border.all(color: emergencyRed.withValues(alpha: 0.40)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.block, color: emergencyRed, size: 20),
              const SizedBox(width: 8),
              Text(title.toUpperCase(),
                  style: const TextStyle(
                    color: emergencyRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  )),
            ]),
            const SizedBox(height: 8),
            EgBulletList(items: items, numbered: true),
          ],
        ),
      ),
    );
  }
}

class EgReferenceCard extends StatelessWidget {
  final String text;
  const EgReferenceCard({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.04),
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.55),
            fontSize: 11,
            fontStyle: FontStyle.italic,
            height: 1.55,
          ),
        ),
      ),
    );
  }
}
