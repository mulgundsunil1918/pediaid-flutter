// =============================================================================
// screens/auth/sign_out_flow.dart — one sign-out and one delete, used everywhere
//
// WHY THIS EXISTS
// ---------------
// There were two Sign out buttons and they did different things.
//
// Account → Sign out went through AuthProvider.signOut(), which signs out of
// Firebase, clears the legacy JWT session, nulls the current user and notifies
// the listeners that _AuthGate watches — so the app actually returned to the
// login screen.
//
// Settings → Danger zone → Sign out called AuthService.instance.logout() and
// nothing else. That clears the legacy tokens, but leaves the Firebase session
// signed in, leaves AuthProvider._currentUser populated, never notifies the
// gate, and never navigates. The gate therefore still reported isLoggedIn, and
// the user stayed exactly where they were, signed in. The FAQ sent people to
// that button.
//
// Two buttons for one action is how that happens, so there is now one function
// and both call it. It owns the confirmation, the sign-out and the navigation
// together, because doing any of the three without the others is the bug.
//
// DELETE ACCOUNT HAD THE SAME DISEASE, AND IT WAS WORSE
// ----------------------------------------------------
// Settings → Danger zone → Delete account called
// AuthService.instance.deleteAccount(), which deletes the row on the Academics
// backend and clears the legacy tokens — and touches neither Firebase Auth nor
// the Firestore profile document. So it reported "Account deleted. Goodbye.",
// left the Firebase account and the profile fully intact, left the user signed
// IN and sitting on the home screen, and destroyed only their backend row,
// which is the half that breaks CME and Academics for them.
//
// Account → Delete account did the whole job. Same disease, same file, same
// shape: two buttons, one correct.
//
// The confirmation dialogs differ on purpose — Settings makes you type DELETE
// — so only the ACTION is shared here. That is the part that must never have
// two versions.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

/// Confirms, signs out, and returns to the first route.
///
/// Returns true when the user signed out, false when they cancelled.
///
/// The navigation is part of the contract, not a caller's responsibility.
/// `_AuthGate` swaps HomeScreen for LoginScreen on its own once the provider
/// notifies, but any screens pushed on top of it would still be sitting there —
/// so the stack is unwound to the gate.
Future<bool> confirmAndSignOut(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Sign out?',
          style: TextStyle(fontWeight: FontWeight.w700)),
      content: const Text(
        "You'll need to sign in again to access your account, saved items and "
        'academics.',
        style: TextStyle(fontSize: 14, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel',
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Sign out',
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );

  if (confirmed != true) return false;
  if (!context.mounted) return false;

  // AuthProvider.signOut does all three halves: Firebase, the legacy JWT
  // session, and the provider state the gate reads. Calling any one of them
  // alone is what left people signed in.
  await context.read<AuthProvider>().signOut();

  if (context.mounted) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  return true;
}


/// Re-authenticates if required, deletes the account everywhere, and returns
/// to the first route.
///
/// The caller owns the confirmation; this owns the deletion. "Everywhere" is
/// the point: Firebase Auth, the Firestore profile document AND the legacy
/// backend row. Deleting any subset is what left accounts half-alive.
///
/// Returns true when the account was deleted.
Future<bool> performAccountDeletion(BuildContext context) async {
  final auth = context.read<AuthProvider>();

  // Email/password accounts must prove themselves again; Google and Apple
  // re-authenticate inside deleteAccount() without a prompt.
  String? password;
  if (auth.isEmailUser) {
    final ctl = TextEditingController();
    password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm your password',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctl,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Current password',
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancel',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.of(ctx).pop(ctl.text),
            child: const Text('Continue',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    ctl.dispose();
    if (password == null) return false; // cancelled
    if (!context.mounted) return false;
  }

  final ok = await auth.deleteAccount(password: password);
  if (!context.mounted) return ok;

  if (!ok) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(auth.error ?? 'Could not delete the account. Try again.'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
    return false;
  }

  Navigator.of(context).popUntil((route) => route.isFirst);
  return true;
}
