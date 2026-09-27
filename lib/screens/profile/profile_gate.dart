// =============================================================================
// screens/profile/profile_gate.dart
//
// Nobody reaches the app without a complete profile.
//
// Sits between the auth gate and the home screen: signed in but incomplete
// gets the form, and there is no way past it except completing it or signing
// out. Sunil's call, and it applies on every platform.
//
// "Complete" is versioned rather than a fixed set of non-null checks. When a
// field is added to the mandatory set, kProfileSchemaVersion moves and
// everyone below it is asked once more, prefilled with what is already known —
// which is what makes adding a field a re-collection instead of a silent gap
// in the data.
//
// The watch is on AuthProvider, so the moment the form writes and notifies,
// this rebuilds and the child appears. No navigation, nothing to pop.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'profile_form.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    // Not signed in is not this gate's business — the auth gate above has
    // already decided that, and answering it here would race with it.
    if (user == null) return child;

    if (user.isProfileComplete) return child;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete your profile'),
        automaticallyImplyLeading: false,
      ),
      body: const SafeArea(child: ProfileForm(isMandatory: true)),
    );
  }
}
