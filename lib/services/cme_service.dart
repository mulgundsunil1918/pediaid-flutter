// =============================================================================
// lib/services/cme_service.dart
//
// Singleton HTTP client for GET/POST/PUT/DELETE on /api/academics/cme/events.
// Uses AuthService.instance.authHeaders for the authenticated endpoints so a
// single shared JWT powers the whole app.
//
// The backend POST forces status='pending' regardless of what we send, so the
// client-side input type intentionally omits it.
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

// ---------------------------------------------------------------------------
// Data classes — shapes mirror the backend toCmeEventJson() output exactly.
// ---------------------------------------------------------------------------

class CmeCoordinator {
  final String name;
  final String? email;
  final String? phone;
  const CmeCoordinator({required this.name, this.email, this.phone});

  factory CmeCoordinator.fromJson(Map<String, dynamic> json) => CmeCoordinator(
        name: (json['name'] as String?) ?? '',
        email: json['email'] as String?,
        phone: json['phone'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (email != null && email!.isNotEmpty) 'email': email,
        if (phone != null && phone!.isNotEmpty) 'phone': phone,
      };
}

class CmeEvent {
  final String id;
  final String slug;
  final String title;
  final String? subtitle;
  final String eventType; // conference | webinar | workshop | course
  final String status;    // pending | published | rejected | cancelled | archived
  final String? description;
  final String? longDescription;
  final DateTime startsAt;
  final DateTime endsAt;
  final String timezone;
  final String? venue;
  final String? address;
  final String? city;
  final String country;
  final String? onlineUrl;
  final String? organisedBy;
  final String? speakerName;
  final String? speakerCredentials;
  final String? speakerBio;
  final double? creditHours;
  final String? creditType;
  final int? maxAttendees;
  final double price;
  final String currency;
  final String? coverImageUrl;
  final String? brochureUrl;
  final String? registrationUrl;
  final List<String> tags;
  final List<CmeCoordinator> coordinators;
  final String? rejectionReason;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CmeEvent({
    required this.id,
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.eventType,
    required this.status,
    required this.description,
    required this.longDescription,
    required this.startsAt,
    required this.endsAt,
    required this.timezone,
    required this.venue,
    required this.address,
    required this.city,
    required this.country,
    required this.onlineUrl,
    required this.organisedBy,
    required this.speakerName,
    required this.speakerCredentials,
    required this.speakerBio,
    required this.creditHours,
    required this.creditType,
    required this.maxAttendees,
    required this.price,
    required this.currency,
    required this.coverImageUrl,
    required this.brochureUrl,
    required this.registrationUrl,
    required this.tags,
    required this.coordinators,
    required this.rejectionReason,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CmeEvent.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return CmeEvent(
      id: json['id'] as String,
      slug: (json['slug'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      subtitle: json['subtitle'] as String?,
      eventType: (json['eventType'] as String?) ?? 'conference',
      status: (json['status'] as String?) ?? 'pending',
      description: json['description'] as String?,
      longDescription: json['longDescription'] as String?,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      timezone: (json['timezone'] as String?) ?? 'Asia/Kolkata',
      venue: json['venue'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: (json['country'] as String?) ?? 'India',
      onlineUrl: json['onlineUrl'] as String?,
      organisedBy: json['organisedBy'] as String?,
      speakerName: json['speakerName'] as String?,
      speakerCredentials: json['speakerCredentials'] as String?,
      speakerBio: json['speakerBio'] as String?,
      creditHours: parseDouble(json['creditHours']),
      creditType: json['creditType'] as String?,
      maxAttendees: json['maxAttendees'] as int?,
      price: parseDouble(json['price']) ?? 0,
      currency: (json['currency'] as String?) ?? 'INR',
      coverImageUrl: json['coverImageUrl'] as String?,
      brochureUrl: json['brochureUrl'] as String?,
      registrationUrl: json['registrationUrl'] as String?,
      tags: ((json['tags'] as List<dynamic>?) ?? const [])
          .whereType<String>()
          .toList(),
      coordinators: ((json['coordinators'] as List<dynamic>?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(CmeCoordinator.fromJson)
          .toList(),
      rejectionReason: json['rejectionReason'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// Payload shape for creating a new event. `status` is omitted on purpose —
/// the backend always forces it to 'pending'.
class CmeEventInput {
  final String title;
  final String? subtitle;
  final String eventType;
  final String description;
  final String? longDescription;
  final DateTime startsAt;
  final DateTime endsAt;
  final String timezone;
  final String? venue;
  final String? address;
  final String? city;
  final String country;
  final String? onlineUrl;
  final String? organisedBy;
  final String? speakerName;
  final String? speakerCredentials;
  final String? speakerBio;
  final double? creditHours;
  final String? creditType;
  final int? maxAttendees;
  final double price;
  final String currency;
  final String? coverImageUrl;
  final String? brochureUrl;
  final String? registrationUrl;
  final List<String> tags;
  final List<CmeCoordinator> coordinators;

  const CmeEventInput({
    required this.title,
    this.subtitle,
    required this.eventType,
    required this.description,
    this.longDescription,
    required this.startsAt,
    required this.endsAt,
    this.timezone = 'Asia/Kolkata',
    this.venue,
    this.address,
    this.city,
    this.country = 'India',
    this.onlineUrl,
    this.organisedBy,
    this.speakerName,
    this.speakerCredentials,
    this.speakerBio,
    this.creditHours,
    this.creditType,
    this.maxAttendees,
    this.price = 0,
    this.currency = 'INR',
    this.coverImageUrl,
    this.brochureUrl,
    this.registrationUrl,
    this.tags = const [],
    this.coordinators = const [],
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (subtitle != null && subtitle!.isNotEmpty) 'subtitle': subtitle,
        'eventType': eventType,
        'description': description,
        if (longDescription != null && longDescription!.isNotEmpty)
          'longDescription': longDescription,
        'startsAt': startsAt.toUtc().toIso8601String(),
        'endsAt': endsAt.toUtc().toIso8601String(),
        'timezone': timezone,
        if (venue != null && venue!.isNotEmpty) 'venue': venue,
        if (address != null && address!.isNotEmpty) 'address': address,
        if (city != null && city!.isNotEmpty) 'city': city,
        'country': country,
        if (onlineUrl != null && onlineUrl!.isNotEmpty) 'onlineUrl': onlineUrl,
        if (organisedBy != null && organisedBy!.isNotEmpty)
          'organisedBy': organisedBy,
        if (speakerName != null && speakerName!.isNotEmpty)
          'speakerName': speakerName,
        if (speakerCredentials != null && speakerCredentials!.isNotEmpty)
          'speakerCredentials': speakerCredentials,
        if (speakerBio != null && speakerBio!.isNotEmpty)
          'speakerBio': speakerBio,
        if (creditHours != null) 'creditHours': creditHours,
        if (creditType != null && creditType!.isNotEmpty) 'creditType': creditType,
        if (maxAttendees != null) 'maxAttendees': maxAttendees,
        'price': price,
        'currency': currency,
        if (coverImageUrl != null && coverImageUrl!.isNotEmpty)
          'coverImageUrl': coverImageUrl,
        if (brochureUrl != null && brochureUrl!.isNotEmpty)
          'brochureUrl': brochureUrl,
        if (registrationUrl != null && registrationUrl!.isNotEmpty)
          'registrationUrl': registrationUrl,
        'tags': tags,
        'coordinators': coordinators.map((c) => c.toJson()).toList(),
      };
}

// ---------------------------------------------------------------------------
// CmeException — user-facing error with a readable message.
// ---------------------------------------------------------------------------

class CmeException implements Exception {
  final String message;
  const CmeException(this.message);
  @override
  String toString() => message;
}

// ---------------------------------------------------------------------------
// CmeService singleton
// ---------------------------------------------------------------------------

class CmeService {
  CmeService._();
  static final CmeService instance = CmeService._();

  String get _base => AuthService.apiBase;

  /// Public list of published events, optionally filtered by eventType.
  Future<List<CmeEvent>> list({String? eventType}) async {
    final url = Uri.parse(
      '$_base/api/academics/cme/events${eventType != null ? '?eventType=$eventType' : ''}',
    );
    final res = await http.get(url).timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw CmeException(_extractError(res, 'Failed to load events.'));
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(CmeEvent.fromJson)
        .toList();
    return data;
  }

  /// Events posted by the current user across every status.
  Future<List<CmeEvent>> listMine() async {
    if (!AuthService.instance.isLoggedIn) return const [];
    final res = await http
        .get(
          Uri.parse('$_base/api/academics/cme/my-events'),
          headers: AuthService.instance.authHeaders,
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 401) {
      await AuthService.instance.logout();
      return const [];
    }
    if (res.statusCode != 200) {
      throw CmeException(_extractError(res, 'Failed to load your events.'));
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(CmeEvent.fromJson)
        .toList();
    return data;
  }

  /// Fetch a single event by slug or id. Published events are public; owners
  /// and admins/mods can also fetch their own pending/rejected rows.
  Future<CmeEvent> getBySlug(String slugOrId) async {
    final headers = AuthService.instance.isLoggedIn
        ? AuthService.instance.authHeaders
        : const {'Content-Type': 'application/json'};
    final res = await http
        .get(
          Uri.parse('$_base/api/academics/cme/events/$slugOrId'),
          headers: headers,
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw CmeException(_extractError(res, 'Event not found.'));
    }
    return CmeEvent.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Create a new event. Requires auth. Returns the inserted row's id+slug.
  Future<({String id, String slug})> create(CmeEventInput input) async {
    if (!AuthService.instance.isLoggedIn) {
      throw const CmeException('Please sign in to post an event.');
    }
    final res = await http
        .post(
          Uri.parse('$_base/api/academics/cme/events'),
          headers: AuthService.instance.authHeaders,
          body: jsonEncode(input.toJson()),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 201) {
      throw CmeException(_extractError(res, 'Could not submit the event.'));
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (
      id: body['id'] as String,
      slug: body['slug'] as String,
    );
  }

  /// Update a pending or rejected event. Bounces it back to 'pending' so
  /// admins re-review.
  Future<void> update(String eventId, Map<String, dynamic> changes) async {
    if (!AuthService.instance.isLoggedIn) {
      throw const CmeException('Please sign in to edit this event.');
    }
    final res = await http
        .put(
          Uri.parse('$_base/api/academics/cme/events/$eventId'),
          headers: AuthService.instance.authHeaders,
          body: jsonEncode(changes),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw CmeException(_extractError(res, 'Could not update the event.'));
    }
  }

  /// Soft-delete (status='cancelled'). Owner-only.
  Future<void> cancel(String eventId) async {
    if (!AuthService.instance.isLoggedIn) return;
    final res = await http
        .delete(
          Uri.parse('$_base/api/academics/cme/events/$eventId'),
          headers: AuthService.instance.authHeaders,
        )
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw CmeException(_extractError(res, 'Could not cancel the event.'));
    }
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  String _extractError(http.Response res, String fallback) {
    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final msg = body['message'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    } catch (_) {}
    return fallback;
  }
}
