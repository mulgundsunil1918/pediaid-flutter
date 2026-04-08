import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Suggest a Feature — shared bottom sheet ───────────────────────────────────

const List<_Category> _kCategories = [
  _Category('Calculator',  Icons.calculate_rounded,    Color(0xFF1565C0)),
  _Category('Guide',       Icons.menu_book_outlined,   Color(0xFF6D4C41)),
  _Category('Chart/Graph', Icons.show_chart_rounded,   Color(0xFF6A1B9A)),
  _Category('Feature',     Icons.stars_rounded,        Color(0xFF00695C)),
  _Category('Other',       Icons.more_horiz_rounded,   Color(0xFF546E7A)),
];

class _Category {
  final String label;
  final IconData icon;
  final Color color;
  const _Category(this.label, this.icon, this.color);
}

/// Call this to show the suggestion bottom sheet from anywhere.
void showSuggestSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => const _SuggestSheet(),
  );
}

class _SuggestSheet extends StatefulWidget {
  const _SuggestSheet();

  @override
  State<_SuggestSheet> createState() => _SuggestSheetState();
}

class _SuggestSheetState extends State<_SuggestSheet> {
  int _selectedCategory = 0;
  final _ctrl = TextEditingController();
  bool _submitted = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Please describe your suggestion.');
      return;
    }
    setState(() { _submitting = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() { _submitting = false; _submitted = true; });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24 + viewInsets.bottom),
      child: _submitted ? _buildSuccess(cs) : _buildForm(cs),
    );
  }

  Widget _buildForm(ColorScheme cs) {
    final cat = _kCategories[_selectedCategory];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
                color: cs.outline, borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const SizedBox(height: 16),

        // Header
        Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lightbulb_outline_rounded,
                color: Color(0xFF1565C0), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Suggest a Feature',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 17, fontWeight: FontWeight.w800,
                      color: cs.onSurface)),
              Text('Help us build a better PediAid',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.5))),
            ]),
          ),
        ]),
        const SizedBox(height: 20),

        // Category label
        Text('What would you like us to add?',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.75))),
        const SizedBox(height: 10),

        // Category chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_kCategories.length, (i) {
            final c = _kCategories[i];
            final selected = _selectedCategory == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: selected
                      ? c.color.withValues(alpha: 0.15)
                      : cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? c.color.withValues(alpha: 0.55)
                        : cs.outline.withValues(alpha: 0.25),
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(c.icon,
                      size: 14,
                      color: selected
                          ? c.color
                          : cs.onSurface.withValues(alpha: 0.45)),
                  const SizedBox(width: 5),
                  Text(c.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? c.color
                            : cs.onSurface.withValues(alpha: 0.6),
                      )),
                ]),
              ),
            );
          }),
        ),

        const SizedBox(height: 18),

        // Text field
        Text('Describe your suggestion',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.75))),
        const SizedBox(height: 8),
        TextField(
          controller: _ctrl,
          maxLines: 4,
          maxLength: 500,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          decoration: InputDecoration(
            hintText:
                'E.g. "Add a Ballard score calculator for gestational age assessment…"',
            hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.35)),
            filled: true,
            fillColor: cs.surface,
            errorText: _error,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: cs.outline.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: cs.outline.withValues(alpha: 0.25)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cat.color, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.error),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Submit
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _submitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: cat.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _submitting
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.send_rounded, size: 16),
                    const SizedBox(width: 8),
                    Text('Submit Suggestion',
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                  ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess(ColorScheme cs) {
    const green = Color(0xFF2E7D32);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
                color: cs.outline, borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const SizedBox(height: 36),
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: green.withValues(alpha: 0.3), width: 2),
          ),
          child: const Icon(Icons.check_rounded, color: green, size: 36),
        ),
        const SizedBox(height: 18),
        Text('Thank you!',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 20, fontWeight: FontWeight.w800, color: cs.onSurface)),
        const SizedBox(height: 8),
        Text(
          'Your suggestion has been received.\nWe review all feedback to improve PediAid.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: cs.onSurface.withValues(alpha: 0.6),
              height: 1.5),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('Done',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
