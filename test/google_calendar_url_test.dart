// Tests for the Google Calendar "create event" link.
//
// This link replaced handing the browser a `data:text/calendar` URL, which
// browsers download as a file rather than opening a calendar — so a user who
// tapped "Add to calendar" got a file in their Downloads folder instead.
//
// The risk in this code is the timezone: PediAid's events are quoted in IST,
// Google's `dates` parameter is UTC, and a silent 5h30m error would put a
// conference on the wrong morning. That is what these tests guard.

import 'package:flutter_test/flutter_test.dart';
import 'package:pediaid_app/utils/calendar_export.dart';

/// The `dates` query value, decoded.
String _dates(String url) =>
    Uri.parse(url).queryParameters['dates'] ?? (throw 'no dates param');

void main() {
  // 5 Apr 2026, 08:00 IST — PEDICON's real start time.
  final istStart = DateTime.utc(2026, 4, 5, 2, 30); // 08:00 IST
  final istEnd = DateTime.utc(2026, 4, 5, 12, 30); // 18:00 IST

  test('IST start time is converted to UTC, not copied verbatim', () {
    final d = _dates(buildGoogleCalendarUrl(
      title: 'PEDICON 2026',
      startsAt: istStart,
      endsAt: istEnd,
    ));
    // 08:00 IST == 02:30 UTC. Writing 0800 here would shift the event 5h30m.
    expect(d, '20260405T023000Z/20260405T123000Z');
  });

  test('an event ending before it starts falls back to one hour', () {
    final d = _dates(buildGoogleCalendarUrl(
      title: 'Broken',
      startsAt: istStart,
      endsAt: istStart.subtract(const Duration(hours: 3)),
    ));
    expect(d, '20260405T023000Z/20260405T033000Z');
  });

  test('a zero-length event also gets one hour', () {
    final d = _dates(buildGoogleCalendarUrl(
      title: 'Instant',
      startsAt: istStart,
      endsAt: istStart,
    ));
    expect(d, endsWith('T033000Z'));
  });

  test('title, location and details survive the round trip', () {
    final q = Uri.parse(buildGoogleCalendarUrl(
      title: 'PEDICON 2026 — Paediatrics 2.0',
      startsAt: istStart,
      endsAt: istEnd,
      location: 'BIEC, Tumkur Road, Bengaluru',
      description: 'Annual conference',
      url: 'https://pedicon.example/register',
    )).queryParameters;

    expect(q['text'], 'PEDICON 2026 — Paediatrics 2.0');
    expect(q['location'], 'BIEC, Tumkur Road, Bengaluru');
    expect(q['details'], contains('Annual conference'));
    expect(q['details'], contains('https://pedicon.example/register'));
    expect(q['action'], 'TEMPLATE');
  });

  test('ampersands in a title cannot break the query string', () {
    // A naive string-concatenated URL would truncate the title here and
    // silently invent a query parameter.
    final q = Uri.parse(buildGoogleCalendarUrl(
      title: 'Neonatology & Critical Care',
      startsAt: istStart,
      endsAt: istEnd,
    )).queryParameters;
    expect(q['text'], 'Neonatology & Critical Care');
  });

  test('empty optional fields are omitted rather than sent blank', () {
    final q = Uri.parse(buildGoogleCalendarUrl(
      title: 'Webinar',
      startsAt: istStart,
      endsAt: istEnd,
      location: '   ',
      description: '',
      url: null,
    )).queryParameters;
    expect(q.containsKey('location'), isFalse);
    expect(q.containsKey('details'), isFalse);
  });

  test('it points at Google Calendar over https', () {
    final u = Uri.parse(buildGoogleCalendarUrl(
      title: 'X',
      startsAt: istStart,
      endsAt: istEnd,
    ));
    expect(u.scheme, 'https');
    expect(u.host, 'calendar.google.com');
    expect(u.path, '/calendar/render');
  });
}
