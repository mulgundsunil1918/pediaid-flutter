// =============================================================================
// widgets/cme_filter_bar.dart
//
// Search, state and mode filters for the in-app CME list.
//
// The equivalent bar was built for the academics website first, which was the
// wrong order: the cards on the home screen open THIS screen, so the app is
// where people actually browse events. Both now talk to the same endpoint and
// the same indexes, so behaviour cannot drift between them.
//
// Filtering happens server-side, not over an already-fetched list. That is the
// whole point: at a thousand events the client must never have to hold them
// all in memory to narrow them down.
// =============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Attendance modes, matching the API vocabulary exactly.
const kCmeModes = <String, String>{
  'online': 'Online',
  'in_person': 'In person',
  'hybrid': 'Hybrid',
};

/// Indian states and union territories, keyed by ISO 3166-2:IN code.
///
/// Mirrors the server list in academics/cme/locations.ts. Held here rather
/// than fetched so the filter renders instantly and still works offline; the
/// server remains the authority and rejects anything it does not recognise.
const kIndianStates = <String, String>{
  'AP': 'Andhra Pradesh', 'AR': 'Arunachal Pradesh', 'AS': 'Assam',
  'BR': 'Bihar', 'CT': 'Chhattisgarh', 'GA': 'Goa', 'GJ': 'Gujarat',
  'HR': 'Haryana', 'HP': 'Himachal Pradesh', 'JH': 'Jharkhand',
  'KA': 'Karnataka', 'KL': 'Kerala', 'MP': 'Madhya Pradesh',
  'MH': 'Maharashtra', 'MN': 'Manipur', 'ML': 'Meghalaya', 'MZ': 'Mizoram',
  'NL': 'Nagaland', 'OR': 'Odisha', 'PB': 'Punjab', 'RJ': 'Rajasthan',
  'SK': 'Sikkim', 'TN': 'Tamil Nadu', 'TG': 'Telangana', 'TR': 'Tripura',
  'UP': 'Uttar Pradesh', 'UT': 'Uttarakhand', 'WB': 'West Bengal',
  'AN': 'Andaman & Nicobar Islands', 'CH': 'Chandigarh',
  'DH': 'Dadra & Nagar Haveli and Daman & Diu', 'DL': 'Delhi',
  'JK': 'Jammu & Kashmir', 'LA': 'Ladakh', 'LD': 'Lakshadweep',
  'PY': 'Puducherry',
};

class CmeFilterBar extends StatefulWidget {
  const CmeFilterBar({
    super.key,
    required this.state,
    required this.mode,
    required this.query,
    required this.onStateChanged,
    required this.onModeChanged,
    required this.onQueryChanged,
    this.showLocationFilters = true,
    this.searchHint = 'Search by title, speaker, venue or city…',
  });

  final String? state;
  final String? mode;
  final String query;
  final ValueChanged<String?> onStateChanged;
  final ValueChanged<String?> onModeChanged;

  /// Fires debounced, not on every keystroke.
  final ValueChanged<String> onQueryChanged;

  /// Never Again reuses this bar for search alone — it is anonymous, and a
  /// location filter there would help identify the person who posted.
  final bool showLocationFilters;
  final String searchHint;

  @override
  State<CmeFilterBar> createState() => _CmeFilterBarState();
}

class _CmeFilterBarState extends State<CmeFilterBar> {
  late final TextEditingController _ctl;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _ctl = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctl.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    // A full-text query per character would mean one request per letter, and
    // the answer for "neon" is discarded the moment "neona" is typed.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) widget.onQueryChanged(value);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _ctl.clear();
    widget.onQueryChanged('');
    if (widget.showLocationFilters) {
      widget.onStateChanged(null);
      widget.onModeChanged(null);
    }
  }

  bool get _hasFilters =>
      _ctl.text.isNotEmpty ||
      (widget.showLocationFilters &&
          (widget.state != null || widget.mode != null));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _ctl,
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: widget.searchHint,
              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13.5),
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _ctl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: _clear,
                      tooltip: 'Clear',
                    ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          if (widget.showLocationFilters) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _Dropdown<String>(
                    value: widget.state,
                    hint: 'Any state',
                    icon: Icons.place_outlined,
                    items: kIndianStates.entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value,
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: widget.onStateChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Dropdown<String>(
                    value: widget.mode,
                    hint: 'Online or in person',
                    icon: Icons.devices_outlined,
                    items: kCmeModes.entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value,
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: widget.onModeChanged,
                  ),
                ),
              ],
            ),
            // Filtering to a state hides online events, which is rarely what
            // someone means — say so rather than let them wonder.
            if (widget.state != null && widget.mode == null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Online events have no location — choose "Online" to see those.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
          if (_hasFilters)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.close_rounded, size: 15),
                label: Text(
                  'Clear filters',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  final T? value;
  final String hint;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      hint: Text(hint,
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
          overflow: TextOverflow.ellipsis),
      icon: const Icon(Icons.expand_more_rounded, size: 20),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 18),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: [
        DropdownMenuItem<T>(
          value: null,
          child: Text(hint, style: GoogleFonts.plusJakartaSans(fontSize: 13)),
        ),
        ...items,
      ],
      onChanged: onChanged,
    );
  }
}
