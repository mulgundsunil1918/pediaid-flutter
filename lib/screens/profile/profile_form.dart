// =============================================================================
// screens/profile/profile_form.dart — one profile form, used everywhere
//
// PediAid collected the same profile through two screens that wrote to two
// different places and never read each other:
//
//   ProfileSetupScreen (first run)  name, specialty              -> Firestore
//   Account screen     (settings)   name, age, gender, emoji,
//                                   qualifications, specialty    -> SharedPreferences
//
// So name and specialty existed in both and could disagree — and the Firestore
// copy is the one Academics and the admin screens read, which meant editing
// your name in Settings changed nothing anyone else could see. Age, gender and
// qualifications never left the handset at all.
//
// The fix is not "make the second one write to Firestore too". It is that
// there is one form. Two implementations of one thing is the disease; this
// week alone it also produced two sign-out buttons and two delete-account
// buttons, and in each case exactly one of them was correct.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../providers/auth_provider.dart';
import '../../services/profile_store.dart';
import '../../services/profile_sync.dart';
import '../../services/qualifications_catalogue.dart';
import '../auth/sign_out_flow.dart';

// kGenderOptions and kProfileEmojis both come from profile_store.dart, which
// has defined them since the old Account editor. Declaring a second copy here
// — in the very change meant to end duplicate definitions — would have given
// the two screens different gender lists.

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key, required this.isMandatory, this.onSaved});

  /// When true this is the gate: there is no way past without completing it,
  /// and the only exit offered is signing out. When false it is the editable
  /// copy in Settings and everything may be changed or left alone.
  final bool isMandatory;

  final VoidCallback? onSaved;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _specialty;
  late final TextEditingController _yob;

  String? _gender;
  String _emoji = kProfileEmojis.first;
  final Set<String> _qualifications = {};

  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    final local = ProfileStore.instance.profile;

    // Prefill from Firestore first, then from whatever the device still holds.
    // Someone asked to fill this in again should be confirming, not retyping.
    _name = TextEditingController(
      text: (user?.name.trim().isNotEmpty ?? false)
          ? user!.name
          : local.fullName,
    );
    _email = TextEditingController(text: user?.email ?? '');
    _specialty = TextEditingController(
      text: (user?.specialty?.trim().isNotEmpty ?? false)
          ? user!.specialty!
          : local.specialty,
    );
    _yob = TextEditingController(
      text:
          user?.yearOfBirth?.toString() ??
          (local.age != null
              ? (DateTime.now().year - local.age!).toString()
              : ''),
    );
    _gender = user?.gender ?? local.gender;
    _emoji =
        user?.avatarEmoji ??
        (local.profileEmoji.trim().isEmpty
            ? kProfileEmojis.first
            : local.profileEmoji);

    // Only ids the catalogue still knows. Old free-text values were parked in
    // legacyQualifications rather than guessed at — mapping "MD" onto md_paed
    // would attribute a qualification nobody claimed.
    _qualifications.addAll(
      (user?.qualifications ?? const []).where(kQualificationsById.containsKey),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _specialty.dispose();
    _yob.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (widget.isMandatory && _qualifications.isEmpty) {
      setState(() => _error = 'Choose at least one qualification.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    try {
      await auth.updateProfile(
        name: _name.text.trim(),
        email: _email.text.trim(),
        specialty: _specialty.text.trim(),
        yearOfBirth: int.tryParse(_yob.text.trim()),
        gender: _gender,
        avatarEmoji: _emoji,
        qualifications: _qualifications.toList(),
        profileSchemaVersion: kProfileSchemaVersion,
      );

      // Keep the local cache in step so the home screen paints the new name
      // immediately and offline. It is a cache now, never the source.
      await ProfileStore.instance.save(
        ProfileStore.instance.profile.copyWith(
          fullName: _name.text.trim(),
          specialty: _specialty.text.trim(),
          gender: _gender,
          profileEmoji: _emoji,
          qualifications: labelsFor(_qualifications),
        ),
      );

      // Firestore has it; the form's job is done. The backend copy is what
      // the admin dashboard reads, and it is fired here rather than awaited —
      // telling someone their profile failed to save when it demonstrably did
      // would be worse than a dashboard that is one launch behind.
      final user = auth.currentUser;
      if (user != null) {
        // ignore: unawaited_futures
        syncProfileToBackend(user);
      }

      if (!mounted) return;
      widget.onSaved?.call();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not save. Check your connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          if (widget.isMandatory) ...[
            Text(
              'A few details before you start',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'PediAid is a clinical reference for people who treat children. '
              'These details confirm that, and they are needed once.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 22),
          ],

          _label(cs, 'PROFILE ICON'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kProfileEmojis.map((e) {
              final on = e == _emoji;
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => setState(() => _emoji = e),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: on
                        ? cs.primary.withValues(alpha: 0.18)
                        : cs.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: on ? cs.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(e, style: const TextStyle(fontSize: 22)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Full name',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (v) =>
                (v == null || v.trim().length < 2) ? 'Enter your name' : null,
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              isDense: true,
              // Editable, not read-only: Sign in with Apple may only ever give
              // us a @privaterelay.appleid.com address, and someone who wants
              // to be reachable needs a way to say so.
              helperText:
                  'Change this if you would rather be reached '
                  'somewhere else',
              helperMaxLines: 2,
            ),
            validator: (v) {
              final t = (v ?? '').trim();
              if (t.isEmpty) return 'Enter an email address';
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)) {
                return 'That does not look like an email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _yob,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    labelText: 'Year of birth',
                    border: OutlineInputBorder(),
                    isDense: true,
                    counterText: '',
                  ),
                  // A year, not an age: an age is correct the day it is typed
                  // and wrong a year later, and nothing tells you it has
                  // rotted.
                  validator: (v) {
                    final y = int.tryParse((v ?? '').trim());
                    final now = DateTime.now().year;
                    if (y == null) return 'Enter a year';
                    if (y < now - 100 || y > now - 15) {
                      return 'Enter a year between ${now - 100} and ${now - 15}';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _gender,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: kGenderOptions
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _specialty,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Specialty',
              hintText: 'Paediatrics, Neonatology, Paediatric Surgery…',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (v) => (v == null || v.trim().length < 2)
                ? 'Enter your specialty'
                : null,
          ),
          const SizedBox(height: 22),

          _label(cs, 'QUALIFICATIONS  ·  choose all that apply'),
          const SizedBox(height: 10),
          ...kQualificationGroups.map((g) => _group(cs, g)),

          if (_error != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.errorContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _error!,
                style: TextStyle(fontSize: 13, color: cs.onErrorContainer),
              ),
            ),
          ],

          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.2),
                  )
                : Text(widget.isMandatory ? 'Continue' : 'Save'),
          ),

          // The only way out of a mandatory form. Without it someone who will
          // not complete it is trapped in an app they already use, with no
          // exit and no way to reach their own account.
          if (widget.isMandatory) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: _saving ? null : () => confirmAndSignOut(context),
              child: const Text('Sign out'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _label(ColorScheme cs, String s) => Text(
    s,
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
      color: cs.onSurface.withValues(alpha: 0.5),
    ),
  );

  Widget _group(ColorScheme cs, QualificationGroup g) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          g.title.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: 7),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: g.items.map((q) {
            final on = _qualifications.contains(q.id);
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() {
                on ? _qualifications.remove(q.id) : _qualifications.add(q.id);
                _error = null;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: on
                      ? cs.primary
                      : cs.surfaceContainerHighest.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  q.label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                    color: on ? cs.onPrimary : cs.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
