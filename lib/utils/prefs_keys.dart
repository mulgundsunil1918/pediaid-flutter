// =============================================================================
// utils/prefs_keys.dart
// Centralised SharedPreferences key constants — VERSIONED by design.
//
// Every "show this once" flag (onboarding, coachmark tour, what's-new dialog)
// gets a `_v1` / `_v2` / ... suffix. Bumping the suffix is the only way to
// re-show the experience to existing users after a redesign — checking a
// non-versioned key like 'onboarding_done' would silently keep them locked
// out of the new flow.
//
// Usage:
//   final prefs = await SharedPreferences.getInstance();
//   if (!(prefs.getBool(PrefsKeys.onboardingComplete) ?? false)) {
//     // show slides
//     await prefs.setBool(PrefsKeys.onboardingComplete, true);
//   }
// =============================================================================

class PrefsKeys {
  PrefsKeys._();

  // ── First-launch experience ──────────────────────────────────────────────
  /// Set when the user finishes (or skips) the slide-based onboarding.
  /// Bump the version suffix on a redesign to re-show.
  static const String onboardingComplete = 'onboarding_complete_v1';

  /// Set when the user completes the in-app coachmark tour on the home
  /// screen. Independent from the slides so each can be reset / replayed
  /// in isolation.
  static const String interactiveTutorialDone = 'interactive_tutorial_done_v1';

  /// Set when the user dismisses the per-OEM background-reliability wizard
  /// (autostart, battery optimisation exemption, protected apps, etc.).
  static const String oemReliabilityWizardSeen = 'oem_reliability_wizard_seen_v1';

  // ── Rating loop ──────────────────────────────────────────────────────────
  /// First-launch timestamp (millis since epoch). Used to gate the in-app
  /// review prompt — never ask before the install is N days old.
  static const String firstLaunchAt = 'first_launch_at_v1';

  /// Last time we showed (or attempted to show) the in-app review dialog.
  /// Used to throttle prompts to once per N days.
  static const String lastReviewPromptAt = 'last_review_prompt_at_v1';

  /// User-controllable toggle in Profile. When false, never auto-prompt
  /// for a review.
  static const String reviewPromptsEnabled = 'review_prompts_enabled_v1';

  // ── Theme + accessibility ────────────────────────────────────────────────
  /// Stored theme choice: 'system' | 'light' | 'dark'.
  static const String themeMode = 'theme_mode_v1';

  /// Text-scale multiplier, persisted across sessions. Range 1.0 – 1.5.
  static const String textScale = 'text_scale_v1';

  // ── Auth (Remember me) ───────────────────────────────────────────────────
  /// Last successfully-used email on the sign-in form (never the password).
  /// Only stored when the user ticks "Remember me on this device".
  static const String rememberedEmail = 'remembered_email_v1';
}
