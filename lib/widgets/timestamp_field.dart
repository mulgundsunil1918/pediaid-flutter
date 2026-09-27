// =============================================================================
// widgets/timestamp_field.dart
//
// Picking a birth time and a sample time, instead of counting hours.
//
// Two screens plot bilirubin against age from birth — the standard calculator
// and the NICE threshold chart — and both originally made you work the age out
// yourself. A baby born 21:40 on Tuesday and sampled 09:15 on Thursday is 35.6
// hours old, and nobody should be doing that arithmetic while holding a chart
// whose thresholds move fastest in exactly that region.
//
// Shared rather than copied. Three separate bugs in this app this week came
// from the same thing existing twice — two sign-out buttons, two delete-account
// buttons, two profile screens — and each time one of the copies was wrong.
// =============================================================================

import 'package:flutter/material.dart';

/// A date-and-time field backed by the platform pickers.
class TimestampField extends StatelessWidget {
  const TimestampField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  static String _fmt(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year}, $h:$m';
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final seed = value ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: seed,
      // Two weeks back covers the whole range the chart plots (0–336 h) and
      // stops a mis-tap landing in the previous decade.
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 1)),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(seed),
    );
    if (time == null) return;

    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final v = value;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
          suffixIcon: v == null
              ? const Icon(Icons.event_outlined, size: 20)
              : IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => onChanged(null),
                ),
        ),
        child: Text(
          v == null ? 'Tap to pick' : _fmt(v),
          style: TextStyle(
            fontSize: 14,
            fontWeight: v == null ? FontWeight.w400 : FontWeight.w600,
            color: v == null
                ? cs.onSurface.withValues(alpha: 0.45)
                : cs.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Shows the age the two timestamps work out to, so the number the chart is
/// actually using is visible rather than implied.
class DerivedAgeBanner extends StatelessWidget {
  const DerivedAgeBanner({super.key, required this.hours});
  final int? hours;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final h = hours;
    final ok = h != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: (ok ? cs.primaryContainer : cs.errorContainer).withValues(
          alpha: 0.45,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.schedule : Icons.error_outline,
            size: 18,
            color: ok ? cs.onPrimaryContainer : cs.onErrorContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ok
                  ? 'Age at sampling: $h hours'
                        '${h >= 24 ? '  (${h ~/ 24} d ${h % 24} h)' : ''}'
                  : 'Set both times. The sample cannot be earlier than the '
                        'birth.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: ok ? FontWeight.w700 : FontWeight.w500,
                color: ok ? cs.onPrimaryContainer : cs.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
