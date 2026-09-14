// =============================================================================
// screens/auth/sign_out_flow.dart — one sign-out, used everywhere
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
