// =============================================================================
// lib/screens/cme/widgets/cme_event_card.dart
//
// Dynamic CME / webinar / conference card that mirrors the original hardcoded
// PEDICON-style (blue) and NeoUpdate-style (teal) cards from the static
// Flutter screen. Variant is chosen from CmeEvent.eventType:
//   - conference / workshop → blue gradient "conference" layout
//   - webinar / course      → teal gradient "webinar" layout
//
// Two footer buttons are driven by the data:
//   - If brochureUrl set     → "Get Details"
//   - If registrationUrl set → "Register Now"
//   - If eventType == 'webinar' AND onlineUrl set → "Join Webinar Now"
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/calendar_export.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/cme_service.dart';

class CmeEventCard extends StatelessWidget {
  const CmeEventCard({super.key, required this.event, this.onTap});

  final CmeEvent event;
  final VoidCallback? onTap;

  bool get _isWebinar =>
      event.eventType == 'webinar' || event.eventType == 'course';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(event: event, isWebinar: _isWebinar),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.subtitle != null && event.subtitle!.isNotEmpty) ...[
                    Text(
                      '"${event.description ?? event.subtitle!}"',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: cs.primary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                  _PillRow(event: event, isWebinar: _isWebinar),
                  const SizedBox(height: 14),
                  if (!_isWebinar) _ConferenceBody(event: event),
                  if (_isWebinar) _WebinarBody(event: event),
                  const SizedBox(height: 14),
                  _FooterButtons(event: event, isWebinar: _isWebinar),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header (gradient)
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.event, required this.isWebinar});
  final CmeEvent event;
  final bool isWebinar;

  @override
  Widget build(BuildContext context) {
    final gradient = isWebinar
        ? const LinearGradient(
            colors: [Color(0xFF0F766E), Color(0xFF0E7490)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (event.isExample)
                _Tag(text: 'EXAMPLE', bg: const Color(0xFF7C3AED)),
              if (event.isExample) const SizedBox(width: 8),
              if (isWebinar)
                _Tag(text: '● UPCOMING', bg: const Color(0xFFF59E0B)),
              if (isWebinar) const SizedBox(width: 8),
              _Tag(
                text: event.eventType.toUpperCase(),
                bg: Colors.white.withValues(alpha: 0.2),
              ),
            ],
          ),
          if (event.isExample) ...[
            const SizedBox(height: 8),
            Text(
              'Sample listing to show what an approved submission looks like — not a real event.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontStyle: FontStyle.italic,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            event.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (event.subtitle != null && event.subtitle!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              event.subtitle!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.bg});
  final String text;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pill row (date / time / venue or online)
// ---------------------------------------------------------------------------

class _PillRow extends StatelessWidget {
  const _PillRow({required this.event, required this.isWebinar});
  final CmeEvent event;
  final bool isWebinar;

  @override
  Widget build(BuildContext context) {
    final localStart = event.startsAt.toLocal();
    final localEnd = event.endsAt.toLocal();
    final dateStr = DateFormat('d MMM yyyy').format(localStart);
    final timeStr =
        '${DateFormat('h:mm a').format(localStart)} – ${DateFormat('h:mm a').format(localEnd)}';

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _Pill(icon: Icons.calendar_today_rounded, text: dateStr),
        _Pill(icon: Icons.access_time_rounded, text: timeStr),
        if (isWebinar && event.onlineUrl != null && event.onlineUrl!.isNotEmpty)
          _Pill(icon: Icons.videocam_rounded, text: 'Online'),
        if (!isWebinar && event.venue != null && event.venue!.isNotEmpty)
          _Pill(icon: Icons.location_on_outlined, text: event.city ?? 'Venue'),
        if (event.creditHours != null)
          _Pill(
            icon: Icons.school_outlined,
            text: '${event.creditHours!.toStringAsFixed(0)} CME Credits',
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body — conference variant
// ---------------------------------------------------------------------------

class _ConferenceBody extends StatelessWidget {
  const _ConferenceBody({required this.event});
  final CmeEvent event;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.venue != null && event.venue!.isNotEmpty) ...[
          _LabelRow(
            icon: Icons.apartment_rounded,
            label: 'Venue',
            value:
                '${event.venue}${event.address != null ? '\n${event.address}' : ''}${event.city != null ? '\n${event.city}${event.country.isNotEmpty ? ' — ${event.country}' : ''}' : ''}',
          ),
          const SizedBox(height: 10),
        ],
        if (event.organisedBy != null && event.organisedBy!.isNotEmpty) ...[
          _LabelRow(
            icon: Icons.groups_2_rounded,
            label: 'Organised By',
            value: event.organisedBy!,
          ),
          const SizedBox(height: 10),
        ],
        if (event.description != null && event.description!.isNotEmpty) ...[
          Text(
            'About the ${event.eventType == 'conference' ? 'Conference' : 'Event'}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event.description!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              height: 1.55,
              color: cs.onSurface.withValues(alpha: 0.82),
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
        ],
        if (event.tags.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: event.tags
                .map(
                  (t) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        if (event.coordinators.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Coordinator${event.coordinators.length > 1 ? 's' : ''}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 6),
                ...event.coordinators.map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (c.name.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.person_outline_rounded,
                                  size: 12,
                                  color: cs.onSurface.withValues(alpha: 0.6)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (c.email != null && c.email!.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.mail_outline_rounded,
                                  size: 12,
                                  color: cs.onSurface.withValues(alpha: 0.6)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.email!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color:
                                        cs.onSurface.withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (c.phone != null && c.phone!.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.phone_outlined,
                                  size: 12,
                                  color: cs.onSurface.withValues(alpha: 0.6)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.phone!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color:
                                        cs.onSurface.withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 14, color: cs.onSurface.withValues(alpha: 0.6)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  height: 1.4,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Body — webinar variant
// ---------------------------------------------------------------------------

class _WebinarBody extends StatelessWidget {
  const _WebinarBody({required this.event});
  final CmeEvent event;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.speakerName != null && event.speakerName!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.person_rounded,
                      size: 18, color: cs.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.speakerName!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                      if (event.speakerCredentials != null &&
                          event.speakerCredentials!.isNotEmpty)
                        Text(
                          event.speakerCredentials!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: cs.onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                      if (event.speakerBio != null &&
                          event.speakerBio!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            event.speakerBio!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: cs.onSurface.withValues(alpha: 0.75),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (event.description != null && event.description!.isNotEmpty) ...[
          Text(
            'About the Webinar',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event.description!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              height: 1.55,
              color: cs.onSurface.withValues(alpha: 0.82),
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
        ],
        if (event.tags.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: event.tags
                .map(
                  (t) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        if (event.onlineUrl != null && event.onlineUrl!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 14, color: Color(0xFF92400E)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Online link will be shared via email upon registration.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Footer buttons
// ---------------------------------------------------------------------------

class _FooterButtons extends StatelessWidget {
  const _FooterButtons({required this.event, required this.isWebinar});
  final CmeEvent event;
  final bool isWebinar;

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link.')),
        );
      }
    }
  }

  /// Asks which calendar, then creates the entry there.
  ///
  /// Previously this always produced an .ics file, which browsers *download* —
  /// leaving the user to find the file and open it, when what they asked for
  /// was the event in their calendar. Google Calendar is offered first because
  /// it opens the event already filled in, one Save away, and on Android the
  /// Google Calendar app claims the link so its own editor opens rather than a
  /// browser. The .ics file remains for Apple Calendar and Outlook, which is
  /// the only mechanism those accept.
  Future<void> _addToCalendar(BuildContext context) async {
    final messenger = ScaffoldMessenger.maybeOf(context);

    // Venue first, falling back to the join link for online events, so an
    // entry always says where to actually be.
    final location = (event.venue != null && event.venue!.isNotEmpty)
        ? [event.venue, event.address, event.city]
            .where((p) => p != null && p.isNotEmpty)
            .join(', ')
        : event.onlineUrl;
    final description = event.description ?? event.subtitle;
    final url = event.registrationUrl ?? event.onlineUrl;

    // Android and iOS can insert straight into the device calendar: the OS's
    // own new-event screen opens filled in, one tap saves it, and it lands in
    // whichever calendar the user actually uses. That is what "add to calendar"
    // is supposed to do, so it happens without asking anything first.
    //
    // Only web needs the chooser below, because no browser API can write to a
    // calendar — there the best available is a pre-filled link or a file.
    if (!kIsWeb) {
      final added = await addToDeviceCalendar(
        title: event.title,
        startsAt: event.startsAt,
        endsAt: event.endsAt,
        description: description,
        location: location,
      );
      if (added) return;
      // No calendar app, or permission refused — fall through to the chooser
      // rather than leaving the tap with nothing to show for it.
    }

    if (!context.mounted) return;

    final useGoogle = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.event_available_rounded),
              title: Text('Google Calendar',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700, fontSize: 15)),
              subtitle: Text('Opens with the details already filled in',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
              onTap: () => Navigator.pop(sheetContext, true),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_rounded),
              title: Text('Apple Calendar, Outlook or other',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700, fontSize: 15)),
              subtitle: Text('Sends a calendar file your app can import',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
              onTap: () => Navigator.pop(sheetContext, false),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (useGoogle == null) return; // dismissed

    try {
      if (useGoogle) {
        final opened = await addToGoogleCalendar(
          title: event.title,
          startsAt: event.startsAt,
          endsAt: event.endsAt,
          description: description,
          location: location,
          url: url,
        );
        if (opened) return;
        // Nothing could handle the link — fall through to the file rather than
        // leaving the tap with no result at all.
      }
      await addToCalendar(
        uid: event.id,
        title: event.title,
        startsAt: event.startsAt,
        endsAt: event.endsAt,
        description: description,
        location: location,
        url: url,
      );
    } catch (_) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Could not open your calendar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primaryColor = isWebinar ? const Color(0xFF0F766E) : cs.primary;

    final brochure = event.brochureUrl;
    final register = event.registrationUrl;
    final online = event.onlineUrl;

    final actions = <Widget>[];

    // Add to calendar, given its own full-width row above the other actions.
    //
    // Deliberately prominent rather than tucked in beside Get Details: for a
    // conference months away, saving the date is the single most useful thing
    // someone can do on this card, and it is the action they are most likely
    // to forget. Register Now stays the primary CTA below.
    final calendarRow = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: primaryColor.withValues(alpha: 0.7), width: 1.4),
            foregroundColor: primaryColor,
            backgroundColor: primaryColor.withValues(alpha: 0.06),
          ),
          onPressed: () => _addToCalendar(context),
          icon: const Icon(Icons.event_available_rounded, size: 18),
          label: Text(
            'Add to my calendar',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );

    if (brochure != null && brochure.isNotEmpty) {
      actions.add(Expanded(
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
            foregroundColor: primaryColor,
          ),
          onPressed: () => _open(context, brochure),
          icon: const Icon(Icons.info_outline_rounded, size: 16),
          label: Text(
            'Get Details',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ));
    }

    // For webinars with both onlineUrl and registrationUrl, show "Join" as the
    // primary CTA. Otherwise show "Register Now".
    if (isWebinar && online != null && online.isNotEmpty) {
      if (actions.isNotEmpty) actions.add(const SizedBox(width: 10));
      actions.add(Expanded(
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            backgroundColor: primaryColor,
          ),
          onPressed: () => _open(context, online),
          icon: const Icon(Icons.videocam_rounded, size: 16),
          label: Text(
            'Join Webinar Now',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ));
    } else if (register != null && register.isNotEmpty) {
      if (actions.isNotEmpty) actions.add(const SizedBox(width: 10));
      actions.add(Expanded(
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            backgroundColor: primaryColor,
          ),
          onPressed: () => _open(context, register),
          icon: const Icon(Icons.person_add_alt_rounded, size: 16),
          label: Text(
            'Register Now',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ));
    }

    if (actions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [calendarRow, Row(children: actions)],
    );
  }
}
