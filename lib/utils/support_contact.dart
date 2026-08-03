// =============================================================================
// lib/utils/support_contact.dart
//
// The single company inbox for everything user-facing: support, feedback,
// suggestions, issue reports, and account queries.
//
// Kept in one place because this address was previously hardcoded in five
// separate screens across two different accounts, so updating "the support
// email" meant finding all of them. Mirrors SUPPORT_EMAIL in the backend's
// notifications/mailer.ts.
//
// Note: the in-app "Report an issue" overlay does NOT use this — it POSTs to
// /api/feedback/report and the backend decides the destination. This constant
// is only for `mailto:` links, which open the user's own mail client.
// =============================================================================

const String kSupportEmail = 'help@bridgr.co.in';
