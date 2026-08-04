// A wrong offset here silently puts every saved event at the wrong hour, which
// is worse than no calendar button at all.
import 'package:flutter_test/flutter_test.dart';
import 'package:pediaid_app/utils/calendar_export.dart';

void main() {
  // Must read the field from inside VEVENT. The VTIMEZONE block that precedes
  // it carries its own DTSTART (19700101T000000), so a naive "first line
  // starting with DTSTART" reads the timezone definition instead of the event.
  String field(String ics, String name) {
    final lines = ics.split('\r\n');
    final start = lines.indexOf('BEGIN:VEVENT');
    return lines
        .sublist(start < 0 ? 0 : start)
        .firstWhere((l) => l.startsWith(name), orElse: () => '');
  }

  test('PEDICON 8am IST is written as 08:00 IST, not UTC', () {
    // 08:00 IST == 02:30 UTC on 5 Apr 2026.
    final ics = buildIcs(
      uid: 'x',
      title: 'PEDICON 2026',
      startsAt: DateTime.utc(2026, 4, 5, 2, 30),
      endsAt: DateTime.utc(2026, 4, 5, 12, 30),
    );
    expect(field(ics, 'DTSTART'), 'DTSTART;TZID=Asia/Kolkata:20260405T080000');
    expect(field(ics, 'DTEND'), 'DTEND;TZID=Asia/Kolkata:20260405T180000');
  });

  test('crossing midnight IST rolls the date forward', () {
    // 20:00 UTC on 4 Apr == 01:30 IST on 5 Apr.
    final ics = buildIcs(
      uid: 'x', title: 'Late webinar',
      startsAt: DateTime.utc(2026, 4, 4, 20, 0),
      endsAt: DateTime.utc(2026, 4, 4, 21, 0),
    );
    expect(field(ics, 'DTSTART'), 'DTSTART;TZID=Asia/Kolkata:20260405T013000');
  });

  test('a local-time input is converted, not copied verbatim', () {
    final ics = buildIcs(
      uid: 'x', title: 'T',
      startsAt: DateTime.utc(2026, 1, 1, 0, 0),
      endsAt: DateTime.utc(2026, 1, 1, 1, 0),
    );
    expect(field(ics, 'DTSTART'), 'DTSTART;TZID=Asia/Kolkata:20260101T053000');
  });

  test('timezone is declared, so clients do not treat it as floating', () {
    final ics = buildIcs(
      uid: 'x', title: 'T',
      startsAt: DateTime.utc(2026, 4, 5, 2, 30),
      endsAt: DateTime.utc(2026, 4, 5, 3, 30),
    );
    expect(ics.contains('BEGIN:VTIMEZONE'), true);
    expect(ics.contains('TZID:Asia/Kolkata'), true);
    expect(ics.contains('TZOFFSETTO:+0530'), true);
  });

  test('end not after start falls back to one hour', () {
    final ics = buildIcs(
      uid: 'x', title: 'T',
      startsAt: DateTime.utc(2026, 4, 5, 2, 30),
      endsAt: DateTime.utc(2026, 4, 5, 2, 30),
    );
    expect(field(ics, 'DTEND'), 'DTEND;TZID=Asia/Kolkata:20260405T090000');
  });
}
