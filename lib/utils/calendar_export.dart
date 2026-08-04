// =============================================================================
// utils/calendar_export.dart
//
// "Add to my calendar" for CME events.
//
// Emits a real .ics file (RFC 5545) rather than a Google Calendar link. A
// Google URL only serves people who use Google Calendar — an iPhone user on
// Apple Calendar, or a hospital account on Outlook, would be sent somewhere
// they cannot save anything. Every calendar app on every platform imports .ics.
//
// Times are written in India Standard Time, declared with a VTIMEZONE block.
//
// That is both what the audience expects and correct, because India has no
// daylight saving: the offset is +05:30, always, so the block is four static
// lines with no rules to get wrong. Every event on the platform is scheduled
// in IST anyway.
//
// The declaration matters. A bare local time with no timezone ("floating") is
// interpreted by calendars as the VIEWER's local time, so an 8am Bengaluru
// conference would show as 8am to someone in London. With TZID it shows as
// 8am IST to an Indian user and the correct converted time to everyone else.
//
// The event's own `timezone` field is deliberately ignored: it is free text
// ("Asia/Kolkata", "IST", sometimes blank), and generating a VTIMEZONE from an
// unvalidated label is how files end up silently an hour out.
// =============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io' show File;

/// RFC 5545 escaping: backslash, semicolon, comma and newline are delimiters.
String _esc(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  return raw
      .replaceAll('\\', '\\\\')
      .replaceAll(';', '\\;')
      .replaceAll(',', '\\,')
      .replaceAll('\r\n', '\\n')
      .replaceAll('\n', '\\n');
}

String _pad(int n, [int w = 2]) => n.toString().padLeft(w, '0');

/// UTC with the Z suffix — used only for DTSTAMP, which is a creation
/// timestamp rather than something a user reads.
String _utc(DateTime dt) {
  final u = dt.toUtc();
  return '${_pad(u.year, 4)}${_pad(u.month)}${_pad(u.day)}'
      'T${_pad(u.hour)}${_pad(u.minute)}${_pad(u.second)}Z';
}

/// IST wall-clock, no suffix — paired with TZID=Asia/Kolkata on the property.
String _ist(DateTime dt) {
  final i = dt.toUtc().add(const Duration(hours: 5, minutes: 30));
  return '${_pad(i.year, 4)}${_pad(i.month)}${_pad(i.day)}'
      'T${_pad(i.hour)}${_pad(i.minute)}${_pad(i.second)}';
}

/// India never observes daylight saving, so this is fixed and complete.
const _vtimezone = [
  'BEGIN:VTIMEZONE',
  'TZID:Asia/Kolkata',
  'BEGIN:STANDARD',
  'DTSTART:19700101T000000',
  'TZOFFSETFROM:+0530',
  'TZOFFSETTO:+0530',
  'TZNAME:IST',
  'END:STANDARD',
  'END:VTIMEZONE',
];

/// Builds the .ics payload. Pure, so it can be checked without a device.
String buildIcs({
  required String uid,
  required String title,
  required DateTime startsAt,
  required DateTime endsAt,
  String? description,
  String? location,
  String? url,
}) {
  // An end at or before the start makes some clients drop the event outright;
  // an hour is a safer assumption than a zero-length appointment.
  final end = endsAt.isAfter(startsAt) ? endsAt : startsAt.add(const Duration(hours: 1));

  final lines = <String>[
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//PediAid//CME//EN',
    'CALSCALE:GREGORIAN',
    'METHOD:PUBLISH',
    ..._vtimezone,
    'BEGIN:VEVENT',
    'UID:$uid@pediaid.bridgr.co.in',
    'DTSTAMP:${_utc(DateTime.now())}',
    'DTSTART;TZID=Asia/Kolkata:${_ist(startsAt)}',
    'DTEND;TZID=Asia/Kolkata:${_ist(end)}',
    'SUMMARY:${_esc(title)}',
    if (description != null && description.isNotEmpty)
      'DESCRIPTION:${_esc(description)}',
    if (location != null && location.isNotEmpty) 'LOCATION:${_esc(location)}',
    if (url != null && url.isNotEmpty) 'URL:${_esc(url)}',
    // A day-before reminder is what someone adding a conference actually wants.
    'BEGIN:VALARM',
    'TRIGGER:-P1D',
    'ACTION:DISPLAY',
    'DESCRIPTION:${_esc(title)}',
    'END:VALARM',
    'END:VEVENT',
    'END:VCALENDAR',
  ];
  // CRLF is required by the spec; some Windows clients reject bare LF.
  return '${lines.join('\r\n')}\r\n';
}

/// Hands the .ics to the platform so the user can save it.
///
/// Web downloads it, which every desktop and mobile browser then opens in the
/// default calendar. Native shares the file, letting the OS offer whichever
/// calendar apps are installed rather than us guessing.
Future<void> addToCalendar({
  required String uid,
  required String title,
  required DateTime startsAt,
  required DateTime endsAt,
  String? description,
  String? location,
  String? url,
}) async {
  final ics = buildIcs(
    uid: uid,
    title: title,
    startsAt: startsAt,
    endsAt: endsAt,
    description: description,
    location: location,
    url: url,
  );

  final safeName =
      '${title.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-').toLowerCase()}.ics';

  if (kIsWeb) {
    final uri = Uri.parse(
      'data:text/calendar;charset=utf-8;base64,${base64Encode(utf8.encode(ics))}',
    );
    await launchUrl(uri, webOnlyWindowName: '_self');
    return;
  }

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$safeName');
  await file.writeAsString(ics);
  await Share.shareXFiles(
    [XFile(file.path, mimeType: 'text/calendar')],
    subject: title,
  );
}
