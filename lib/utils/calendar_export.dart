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
  final end = endsAt.isAfter(startsAt)
      ? endsAt
      : startsAt.add(const Duration(hours: 1));

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

/// Direct insert into the device calendar — not currently available.
///
/// Returns false everywhere, so callers fall through to the pre-filled Google
/// Calendar link or the .ics file.
///
/// The obvious package for this (add_2_calendar) cannot be used: its own Gradle
/// script calls APIs that are hard errors under the Gradle 8.14 / AGP 8.11
/// toolchain that targetSdk 36 requires, so adding it fails the Android build
/// outright. Doing this properly means a small platform channel — an
/// ACTION_INSERT intent on Android, EventKit on iOS — rather than a dependency
/// that pins the build to an old toolchain. Kept as a seam so that change is
/// local to this function.
Future<bool> addToDeviceCalendar({
  required String title,
  required DateTime startsAt,
  required DateTime endsAt,
  String? description,
  String? location,
}) async => false;

/// Builds a Google Calendar "create event" link.
///
/// This exists because handing a browser a `data:text/calendar` URL makes it
/// *download a file*, which is not what someone who tapped "Add to calendar"
/// wanted — they then have to find the download and open it. This link instead
/// opens the event already filled in, one Save away.
///
/// On Android the Google Calendar app claims this URL, so the app's own event
/// editor opens rather than a browser. That is the closest thing to a direct
/// insert available without native calendar permissions.
///
/// Times go out in UTC (the trailing Z), which is unambiguous: Google renders
/// them in the viewer's own timezone, so an 09:00 IST event reads as 09:00 for
/// a doctor in India without us declaring a timezone at all.
String buildGoogleCalendarUrl({
  required String title,
  required DateTime startsAt,
  required DateTime endsAt,
  String? description,
  String? location,
  String? url,
}) {
  // Mirrors the .ics fallback: a non-positive duration becomes one hour rather
  // than an event that ends before it starts.
  final end = endsAt.isAfter(startsAt)
      ? endsAt
      : startsAt.add(const Duration(hours: 1));

  final details = [
    if (description != null && description.trim().isNotEmpty)
      description.trim(),
    if (url != null && url.trim().isNotEmpty) url.trim(),
  ].join('\n\n');

  return Uri.https('calendar.google.com', '/calendar/render', {
    'action': 'TEMPLATE',
    'text': title,
    'dates': '${_utc(startsAt)}/${_utc(end)}',
    if (details.isNotEmpty) 'details': details,
    if (location != null && location.trim().isNotEmpty)
      'location': location.trim(),
  }).toString();
}

/// Opens the event pre-filled in Google Calendar (its app on Android, the web
/// UI elsewhere). Returns false if no handler could be launched, so the caller
/// can fall back to the .ics file.
Future<bool> addToGoogleCalendar({
  required String title,
  required DateTime startsAt,
  required DateTime endsAt,
  String? description,
  String? location,
  String? url,
}) async {
  final uri = Uri.parse(
    buildGoogleCalendarUrl(
      title: title,
      startsAt: startsAt,
      endsAt: endsAt,
      description: description,
      location: location,
      url: url,
    ),
  );
  try {
    return await launchUrl(
      uri,
      mode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
      webOnlyWindowName: kIsWeb ? '_blank' : null,
    );
  } catch (_) {
    return false;
  }
}

/// Hands the .ics to the platform so the user can save it.
///
/// The fallback path, for Apple Calendar and Outlook users. Native shares the
/// file, letting the OS offer whichever calendar apps are installed rather than
/// us guessing.
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
  await Share.shareXFiles([
    XFile(file.path, mimeType: 'text/calendar'),
  ], subject: title);
}
