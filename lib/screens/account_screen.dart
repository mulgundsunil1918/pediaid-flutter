// =============================================================================
// lib/screens/account_screen.dart
//
// Doctor profile screen reached from the drawer's "Account" entry.
//
// Top card:
//   • Emoji avatar (tap to open a picker)
//   • Full name
//   • Email (from AuthService, read-only)
//   • Age, gender, specialty summary
//   • Role badge (reader / author / moderator / admin / pending_*)
//
// Editable sections:
//   • Personal: full name, age, gender
//   • Qualifications: multi-select chips from a curated list + a free-form
//     "Other" chip for rare credentials
//   • Specialty: dropdown of Indian medical specialties, default Paediatrics
//
// Sign out lives at the bottom of the screen, not in the drawer, per the
// current design. Sign out clears the auth session AND pops every pushed
// route so _AuthGate's rebuilt LoginScreen is what the user lands on.
//
// All profile fields (name, age, gender, emoji, qualifications, specialty)
// are persisted locally in SharedPreferences via ProfileStore. They are
// NOT synced to the backend in v1 — the backend only holds identity
// (email, role) via AuthService.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/profile_store.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _editing = false;
  bool _busy = false;

  // Edit-mode buffers — seeded from the current profile on entry
  late String _fullName;
  late int? _age;
  late String? _gender;
  late List<String> _qualifications;
  late String _specialty;

  @override
  void initState() {
    super.initState();
    AuthService.instance.addListener(_onAuthChange);
    ProfileStore.instance.addListener(_onProfileChange);
    // Hydrate the profile store if the user opens Account on a cold start
    // that hadn't touched it yet. Uses the current auth user's name as a
    // fallback for the full-name field.
    if (!ProfileStore.instance.isLoaded) {
      ProfileStore.instance.load(
        fallbackFullName: AuthService.instance.currentUser?.fullName,
      );
    }
    _seedBuffers();
  }

  @override
  void dispose() {
    AuthService.instance.removeListener(_onAuthChange);
    ProfileStore.instance.removeListener(_onProfileChange);
    super.dispose();
  }

  void _onAuthChange() {
    if (mounted) setState(() {});
  }

  void _onProfileChange() {
    if (mounted) {
      setState(() {
        if (!_editing) _seedBuffers();
      });
    }
  }

  void _seedBuffers() {
    final p = ProfileStore.instance.profile;
    final authName = AuthService.instance.currentUser?.fullName;
    _fullName = p.fullName.isNotEmpty
        ? p.fullName
        : (authName ?? '');
    _age = p.age;
    _gender = p.gender;
    _qualifications = List.of(p.qualifications);
    _specialty = p.specialty;
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    final next = ProfileStore.instance.profile.copyWith(
      fullName: _fullName.trim(),
      age: _age,
      clearAge: _age == null,
      gender: _gender,
      clearGender: _gender == null,
      qualifications: _qualifications,
      specialty: _specialty,
    );
    await ProfileStore.instance.save(next);
    if (mounted) {
      setState(() {
        _editing = false;
        _busy = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _cancel() {
    setState(() {
      _editing = false;
      _seedBuffers();
    });
  }

  Future<void> _pickEmoji() async {
    final current = ProfileStore.instance.profile.profileEmoji;
    final picked = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _EmojiPickerSheet(currentEmoji: current),
    );
    if (picked != null) {
      final next = ProfileStore.instance.profile.copyWith(profileEmoji: picked);
      await ProfileStore.instance.save(next);
    }
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Sign out?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          "You'll need to sign in again to access calculators, charts, and academics.",
          style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Sign out',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await AuthService.instance.logout();

    // Pop every pushed route so the user lands on _AuthGate's rebuilt
    // LoginScreen rather than still seeing this AccountScreen sitting on
    // top of the navigator stack.
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = AuthService.instance.currentUser;
    final profile = ProfileStore.instance.profile;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Account')),
        body: Center(
          child: Text(
            "You're not signed in.",
            style: GoogleFonts.plusJakartaSans(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (!_editing)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit profile',
              onPressed: () => setState(() => _editing = true),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          // ── Header card ────────────────────────────────────────────────
          _HeaderCard(
            profile: profile,
            email: user.email,
            role: user.role,
            onTapEmoji: _pickEmoji,
          ),

          const SizedBox(height: 24),

          // ── Personal details ───────────────────────────────────────────
          _SectionHeader(label: 'Personal details'),
          const SizedBox(height: 10),
          _PersonalDetailsCard(
            editing: _editing,
            fullName: _editing ? _fullName : profile.fullName,
            age: _editing ? _age : profile.age,
            gender: _editing ? _gender : profile.gender,
            onNameChanged: (v) => _fullName = v,
            onAgeChanged: (v) => setState(() => _age = v),
            onGenderChanged: (v) => setState(() => _gender = v),
          ),

          const SizedBox(height: 24),

          // ── Qualifications ────────────────────────────────────────────
          _SectionHeader(label: 'Qualifications'),
          const SizedBox(height: 10),
          _QualificationsCard(
            editing: _editing,
            selected: _editing ? _qualifications : profile.qualifications,
            onChanged: (next) => setState(() => _qualifications = next),
          ),

          const SizedBox(height: 24),

          // ── Specialty ─────────────────────────────────────────────────
          _SectionHeader(label: 'Specialty'),
          const SizedBox(height: 10),
          _SpecialtyCard(
            editing: _editing,
            selected: _editing ? _specialty : profile.specialty,
            onChanged: (v) => setState(() => _specialty = v),
          ),

          const SizedBox(height: 28),

          // ── Edit-mode save/cancel row ─────────────────────────────────
          if (_editing) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy ? null : _cancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _busy ? null : _save,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Save changes',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
          ],

          // ── Sign out ──────────────────────────────────────────────────
          if (!_editing) ...[
            const SizedBox(height: 4),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _handleSignOut,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: Text(
                  'Sign out',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "You'll be asked to sign in again the next time you open PediAid.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w800,
        color: cs.primary,
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.profile,
    required this.email,
    required this.role,
    required this.onTapEmoji,
  });

  final DoctorProfile profile;
  final String email;
  final String role;
  final VoidCallback onTapEmoji;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final displayName = profile.fullName.isNotEmpty ? profile.fullName : email;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          // Tap-to-change emoji avatar
          GestureDetector(
            onTap: onTapEmoji,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    profile.profileEmoji,
                    style: const TextStyle(fontSize: 44),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.surfaceContainerHighest, width: 2),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    size: 13,
                    color: cs.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            displayName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: cs.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              _Chip(label: profile.specialty, tone: _ChipTone.primary),
              _Chip(label: _roleLabel(role), tone: _ChipTone.role),
            ],
          ),
        ],
      ),
    );
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'moderator':
        return 'Moderator';
      case 'author':
        return 'Author';
      case 'pending_author':
        return 'Pending author';
      case 'pending_moderator':
        return 'Pending moderator';
      default:
        return 'Reader';
    }
  }
}

enum _ChipTone { primary, role, neutral }

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.tone});
  final String label;
  final _ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final Color bg;
    final Color fg;
    switch (tone) {
      case _ChipTone.primary:
        bg = cs.primary;
        fg = cs.onPrimary;
        break;
      case _ChipTone.role:
        bg = cs.secondaryContainer;
        fg = cs.onSecondaryContainer;
        break;
      case _ChipTone.neutral:
        bg = cs.surfaceContainerHigh;
        fg = cs.onSurface;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Personal details card (name, age, gender)
// ---------------------------------------------------------------------------

class _PersonalDetailsCard extends StatefulWidget {
  const _PersonalDetailsCard({
    required this.editing,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.onNameChanged,
    required this.onAgeChanged,
    required this.onGenderChanged,
  });

  final bool editing;
  final String fullName;
  final int? age;
  final String? gender;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<int?> onAgeChanged;
  final ValueChanged<String?> onGenderChanged;

  @override
  State<_PersonalDetailsCard> createState() => _PersonalDetailsCardState();
}

class _PersonalDetailsCardState extends State<_PersonalDetailsCard> {
  late TextEditingController _nameCtl;
  late TextEditingController _ageCtl;

  @override
  void initState() {
    super.initState();
    _nameCtl = TextEditingController(text: widget.fullName);
    _ageCtl = TextEditingController(text: widget.age?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant _PersonalDetailsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When we leave edit mode, parent passes persisted values back — mirror
    // into the controllers so the read view stays fresh.
    if (!widget.editing && oldWidget.editing) {
      _nameCtl.text = widget.fullName;
      _ageCtl.text = widget.age?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _ageCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget readRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 84,
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              child: Text(
                value.isEmpty ? '—' : value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: widget.editing
          ? Column(
              children: [
                TextField(
                  controller: _nameCtl,
                  textCapitalization: TextCapitalization.words,
                  onChanged: widget.onNameChanged,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ageCtl,
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          final parsed = int.tryParse(v.trim());
                          widget.onAgeChanged(parsed);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: widget.gender,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: Icon(Icons.wc_rounded),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('—'),
                          ),
                          ...kGenderOptions.map(
                            (g) => DropdownMenuItem<String>(
                              value: g,
                              child: Text(g),
                            ),
                          ),
                        ],
                        onChanged: widget.onGenderChanged,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                readRow('Full name', widget.fullName),
                const Divider(height: 1),
                readRow('Age', widget.age?.toString() ?? ''),
                const Divider(height: 1),
                readRow('Gender', widget.gender ?? ''),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Qualifications card — multi-select chips
// ---------------------------------------------------------------------------

class _QualificationsCard extends StatelessWidget {
  const _QualificationsCard({
    required this.editing,
    required this.selected,
    required this.onChanged,
  });

  final bool editing;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (!editing) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: selected.isEmpty
            ? Text(
                'No qualifications added yet.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontStyle: FontStyle.italic,
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selected
                    .map((q) => _Chip(label: q, tone: _ChipTone.neutral))
                    .toList(),
              ),
      );
    }

    // Edit mode: show every common option as a toggleable FilterChip
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tick every qualification that applies.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kCommonQualifications.map((q) {
              final isOn = selected.contains(q);
              return FilterChip(
                label: Text(
                  q,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: isOn,
                onSelected: (v) {
                  final next = List<String>.of(selected);
                  if (v) {
                    if (!next.contains(q)) next.add(q);
                  } else {
                    next.remove(q);
                  }
                  onChanged(next);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Specialty card — dropdown with 30+ Indian specialties
// ---------------------------------------------------------------------------

class _SpecialtyCard extends StatelessWidget {
  const _SpecialtyCard({
    required this.editing,
    required this.selected,
    required this.onChanged,
  });

  final bool editing;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: editing
          ? DropdownButtonFormField<String>(
              initialValue: kMedicalSpecialties.contains(selected)
                  ? selected
                  : 'Paediatrics',
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Specialty',
                prefixIcon: Icon(Icons.medical_services_outlined),
              ),
              items: kMedicalSpecialties
                  .map((s) => DropdownMenuItem<String>(
                        value: s,
                        child: Text(s, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            )
          : Row(
              children: [
                Icon(Icons.medical_services_outlined,
                    size: 18, color: cs.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selected,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Emoji picker bottom sheet
// ---------------------------------------------------------------------------

class _EmojiPickerSheet extends StatelessWidget {
  const _EmojiPickerSheet({required this.currentEmoji});
  final String currentEmoji;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose an avatar',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pick an emoji — you can change it any time.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: kProfileEmojis.map((e) {
                final isCurrent = e == currentEmoji;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(context).pop(e),
                  child: Container(
                    width: 58,
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isCurrent ? cs.primaryContainer : cs.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCurrent ? cs.primary : cs.outlineVariant,
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Text(e, style: const TextStyle(fontSize: 28)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
