// =============================================================================
// lib/services/submissions_service.dart
//
// Cross-module "My Submissions" — one list covering Never Again posts and all
// four CME event types (conference / webinar / workshop / course).
//
// Hybrid identity, because the two modules disagree by design: Never Again is
// anonymous and keyed on a locally-stored device_id, while CME submissions
// belong to a real account. This sends whichever it has — the device_id
// always, the auth token when signed in — and the backend returns the union.
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'never_again_service.dart';

/// The shared moderation vocabulary. Wider than what either module can
/// actually produce today (neither has draft-saving or a review-claiming
/// step), so unknown values degrade to a readable label rather than throwing.
enum SubmissionStatus {
  draft,
  submitted,
  underReview,
  needsEdit,
  approved,
  published,
  rejected,
  archived,
}

SubmissionStatus _statusFromApi(String raw) {
  switch (raw) {
    case 'draft':
      return SubmissionStatus.draft;
    case 'submitted':
      return SubmissionStatus.submitted;
    case 'under_review':
      return SubmissionStatus.underReview;
    case 'needs_edit':
      return SubmissionStatus.needsEdit;
    case 'approved':
      return SubmissionStatus.approved;
    case 'published':
      return SubmissionStatus.published;
    case 'rejected':
      return SubmissionStatus.rejected;
    case 'archived':
      return SubmissionStatus.archived;
    default:
      return SubmissionStatus.submitted;
  }
}

String submissionStatusLabel(SubmissionStatus s) {
  switch (s) {
    case SubmissionStatus.draft:
      return 'Draft';
    case SubmissionStatus.submitted:
      return 'Submitted';
    case SubmissionStatus.underReview:
      return 'Under Review';
    case SubmissionStatus.needsEdit:
      return 'Needs Edit';
    case SubmissionStatus.approved:
      return 'Approved';
    case SubmissionStatus.published:
      return 'Published';
    case SubmissionStatus.rejected:
      return 'Rejected';
    case SubmissionStatus.archived:
      return 'Archived';
  }
}

enum SubmissionModule { neverAgain, conference, webinar, workshop, course }

SubmissionModule _moduleFromApi(String raw) {
  switch (raw) {
    case 'never_again':
      return SubmissionModule.neverAgain;
    case 'conference':
      return SubmissionModule.conference;
    case 'webinar':
      return SubmissionModule.webinar;
    case 'workshop':
      return SubmissionModule.workshop;
    case 'course':
      return SubmissionModule.course;
    default:
      return SubmissionModule.neverAgain;
  }
}

String submissionModuleLabel(SubmissionModule m) {
  switch (m) {
    case SubmissionModule.neverAgain:
      return 'Never Again';
    case SubmissionModule.conference:
      return 'Conference';
    case SubmissionModule.webinar:
      return 'Webinar';
    case SubmissionModule.workshop:
      return 'Workshop';
    case SubmissionModule.course:
      return 'Course';
  }
}

class Submission {
  final String submissionId;
  final SubmissionModule module;
  final String title;
  final SubmissionStatus status;
  final DateTime createdAt;
  final String? adminFeedback;
  final String? slug;

  const Submission({
    required this.submissionId,
    required this.module,
    required this.title,
    required this.status,
    required this.createdAt,
    this.adminFeedback,
    this.slug,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      submissionId: (json['submissionId'] ?? '') as String,
      module: _moduleFromApi((json['moduleType'] ?? '') as String),
      title: (json['title'] ?? '') as String,
      status: _statusFromApi((json['status'] ?? 'submitted') as String),
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
      adminFeedback: json['adminFeedback'] as String?,
      slug: json['slug'] as String?,
    );
  }
}

class SubmissionsService {
  SubmissionsService._();
  static final SubmissionsService instance = SubmissionsService._();

  String get _apiBase => AuthService.apiBase;

  /// Fetches everything this person has submitted, from either identity.
  ///
  /// Returns an empty list rather than throwing when there is nothing to
  /// identify them by — a signed-out user on a fresh device genuinely has
  /// no submissions, which is not an error worth surfacing.
  Future<List<Submission>> getMySubmissions() async {
    // NeverAgainService.init() is what generates/loads the device_id; calling
    // it here makes this screen safe to open before the Never Again feed has
    // ever been visited.
    await NeverAgainService.instance.init();
    final deviceId = NeverAgainService.instance.deviceId;
    final token = AuthService.instance.accessToken;

    if (deviceId.isEmpty && token == null) return [];

    final uri = Uri.parse('$_apiBase/api/me/submissions').replace(
      queryParameters: {if (deviceId.isNotEmpty) 'device_id': deviceId},
    );

    final res = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 20));

    if (res.statusCode != 200) {
      throw Exception('Could not load your submissions (${res.statusCode}).');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['submissions'] as List? ?? [])
        .cast<Map<String, dynamic>>()
        .map(Submission.fromJson)
        .toList();
  }
}
