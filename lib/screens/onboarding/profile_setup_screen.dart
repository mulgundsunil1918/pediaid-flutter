// =============================================================================
// screens/onboarding/profile_setup_screen.dart
//
// Asked once, straight after a first sign-in: name and specialty.
//
// The slide-based OnboardingScreen runs before sign-in, so it cannot collect
// anything about the person — there is no account to attach it to yet. This is
// the other half: the first moment we have both a signed-in user and their
// attention.
//
// Google and Apple hand back a name and an email and nothing else, so without
// this step a social sign-up leaves specialty permanently empty unless the
// user goes looking for Account settings, which almost nobody does.
//
// Skippable on purpose. It stands between someone who just signed in and the
// thing they actually opened the app for, so blocking here turns a completed
// sign-up into an abandoned one. Anything skipped stays editable in Account.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

/// Common paediatric sub-specialties, offered as suggestions rather than a
/// closed list — it will never be complete, and forcing an approximate choice
/// produces worse data than letting someone type their own.
const _specialtySuggestions = <String>[
  'General Paediatrics',
  'Neonatology',
  'Paediatric Cardiology',
  'Paediatric Neurology',
  'Paediatric Intensive Care',
  'Paediatric Pulmonology',
  'Paediatric Gastroenterology',
  'Paediatric Nephrology',
  'Paediatric Endocrinology',
  'Paediatric Haematology & Oncology',
  'Paediatric Infectious Diseases',
  'Paediatric Surgery',
  'Developmental Paediatrics',
  'Adolescent Medicine',
  'Paediatric Resident / Trainee',
  'Medical Student',
];

/// True when this account has not told us what they do yet.
bool needsProfileSetup(AuthProvider auth) {
  final user = auth.currentUser;
  if (user == null) return false;
  return (user.specialty ?? '').trim().isEmpty;
}

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late final TextEditingController _nameCtl;
  late final TextEditingController _specialtyCtl;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    // Google and Apple already gave us a name — start from it rather than an
    // empty box the user has to retype.
    _nameCtl = TextEditingController(text: user?.name ?? '');
    _specialtyCtl = TextEditingController(text: user?.specialty ?? '');
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _specialtyCtl.dispose();
    super.dispose();
  }

  void _finish() {
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _save() async {
    final name = _nameCtl.text.trim();
    final specialty = _specialtyCtl.text.trim();

    // Nothing entered is the same as skipping — don't blank out the name
    // Google gave us by writing an empty string over it.
    if (name.isEmpty && specialty.isEmpty) {
      _finish();
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().updateProfile(
            name: name.isEmpty ? null : name,
            specialty: specialty.isEmpty ? null : specialty,
          );
      _finish();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not save. You can add this later from Account.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.badge_rounded,
                      color: cs.onPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'A few details',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This helps us show you the guidelines and CME that match '
                    'your practice. You can change it any time in Account.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      height: 1.55,
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 28),

                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _error!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: cs.onErrorContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  TextField(
                    controller: _nameCtl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Autocomplete rather than a dropdown: the list is a hint,
                  // not a constraint, so anything can still be typed.
                  Autocomplete<String>(
                    initialValue:
                        TextEditingValue(text: _specialtyCtl.text),
                    optionsBuilder: (value) {
                      final q = value.text.trim().toLowerCase();
                      if (q.isEmpty) return _specialtySuggestions;
                      return _specialtySuggestions.where(
                        (s) => s.toLowerCase().contains(q),
                      );
                    },
                    onSelected: (v) => _specialtyCtl.text = v,
                    fieldViewBuilder:
                        (context, controller, focusNode, onSubmitted) {
                      controller.addListener(
                        () => _specialtyCtl.text = controller.text,
                      );
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Specialty',
                          hintText: 'e.g. General Paediatrics',
                          prefixIcon:
                              const Icon(Icons.medical_services_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Save and continue',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _saving ? null : _finish,
                    child: Text(
                      'Skip for now',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
