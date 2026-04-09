// =============================================================================
// lib/screens/cme/post_event_screen.dart
//
// Form for any signed-in user to submit a new CME / webinar / workshop /
// conference. Fields are grouped into sections, with conditional fields per
// event type (venue for in-person, online URL for webinars). On submit, the
// backend forces status='pending'; admins moderate from PendingCmeEventsPage.
// Coordinators repeat as a dynamic list (min 1 required). Brochure / cover /
// registration links are free-form URLs — the helper text tells the user to
// upload to Google Drive and paste the shared link so we don't store files
// on the server.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/cme_service.dart';

class PostEventScreen extends StatefulWidget {
  const PostEventScreen({super.key});

  @override
  State<PostEventScreen> createState() => _PostEventScreenState();
}

class _PostEventScreenState extends State<PostEventScreen> {
  final _formKey = GlobalKey<FormState>();

  // ---------------- Type ----------------
  String _eventType = 'conference';

  // ---------------- Basics ----------------
  final _titleCtl = TextEditingController();
  final _subtitleCtl = TextEditingController();
  final _descriptionCtl = TextEditingController();

  // ---------------- When ----------------
  DateTime? _startsAt;
  DateTime? _endsAt;

  // ---------------- Where ----------------
  final _venueCtl = TextEditingController();
  final _addressCtl = TextEditingController();
  final _cityCtl = TextEditingController();
  final _onlineUrlCtl = TextEditingController();

  // ---------------- Organiser + speaker ----------------
  final _organisedByCtl = TextEditingController();
  final _speakerNameCtl = TextEditingController();
  final _speakerCredsCtl = TextEditingController();
  final _speakerBioCtl = TextEditingController();

  // ---------------- Tags ----------------
  final _tagInputCtl = TextEditingController();
  final List<String> _tags = [];
  static const _suggestedTags = [
    'Neonatology',
    'Critical Care',
    'Infectious Disease',
    'Neurology',
    'Nutrition',
    'Emergency Paediatrics',
    'Hands-on Workshops',
    'Cardiology',
    'Pulmonology',
    'Endocrinology',
    'Gastroenterology',
    'Hematology',
    'Oncology',
  ];

  // ---------------- Coordinators ----------------
  final List<_CoordinatorInput> _coordinators = [_CoordinatorInput()];

  // ---------------- Links ----------------
  final _coverImageUrlCtl = TextEditingController();
  final _brochureUrlCtl = TextEditingController();
  final _registrationUrlCtl = TextEditingController();

  // ---------------- CME ----------------
  final _creditHoursCtl = TextEditingController();

  bool _submitting = false;
  String? _submitError;
  bool _submitted = false;

  @override
  void dispose() {
    _titleCtl.dispose();
    _subtitleCtl.dispose();
    _descriptionCtl.dispose();
    _venueCtl.dispose();
    _addressCtl.dispose();
    _cityCtl.dispose();
    _onlineUrlCtl.dispose();
    _organisedByCtl.dispose();
    _speakerNameCtl.dispose();
    _speakerCredsCtl.dispose();
    _speakerBioCtl.dispose();
    _tagInputCtl.dispose();
    _coverImageUrlCtl.dispose();
    _brochureUrlCtl.dispose();
    _registrationUrlCtl.dispose();
    _creditHoursCtl.dispose();
    for (final c in _coordinators) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _isInPerson =>
      _eventType == 'conference' || _eventType == 'workshop';

  Future<void> _pickStart() async {
    final now = DateTime.now();
    final initial = _startsAt ?? now.add(const Duration(days: 7));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    setState(() {
      _startsAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _endsAt ??= _startsAt!.add(const Duration(hours: 2));
    });
  }

  Future<void> _pickEnd() async {
    final initial = _endsAt ?? (_startsAt ?? DateTime.now()).add(const Duration(hours: 2));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _startsAt ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    setState(() {
      _endsAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _addTag(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return;
    if (!_tags.contains(t)) {
      setState(() {
        _tags.add(t);
        _tagInputCtl.clear();
      });
    }
  }

  void _toggleSuggestedTag(String t) {
    setState(() {
      if (_tags.contains(t)) {
        _tags.remove(t);
      } else {
        _tags.add(t);
      }
    });
  }

  Future<void> _submit() async {
    setState(() => _submitError = null);
    if (!_formKey.currentState!.validate()) return;
    if (_startsAt == null || _endsAt == null) {
      setState(() => _submitError = 'Please pick start and end times.');
      return;
    }
    if (!_endsAt!.isAfter(_startsAt!)) {
      setState(() => _submitError = 'End time must be after start time.');
      return;
    }

    final validCoords = _coordinators
        .map((c) => c.snapshot())
        .where((c) => c.name.trim().isNotEmpty)
        .toList();
    if (validCoords.isEmpty) {
      setState(() => _submitError = 'Add at least one coordinator with a name.');
      return;
    }

    final creditHours = double.tryParse(_creditHoursCtl.text.trim());

    final input = CmeEventInput(
      title: _titleCtl.text.trim(),
      subtitle: _subtitleCtl.text.trim().isEmpty ? null : _subtitleCtl.text.trim(),
      eventType: _eventType,
      description: _descriptionCtl.text.trim(),
      startsAt: _startsAt!,
      endsAt: _endsAt!,
      venue: _isInPerson && _venueCtl.text.trim().isNotEmpty
          ? _venueCtl.text.trim()
          : null,
      address: _isInPerson && _addressCtl.text.trim().isNotEmpty
          ? _addressCtl.text.trim()
          : null,
      city: _isInPerson && _cityCtl.text.trim().isNotEmpty
          ? _cityCtl.text.trim()
          : null,
      onlineUrl: !_isInPerson && _onlineUrlCtl.text.trim().isNotEmpty
          ? _onlineUrlCtl.text.trim()
          : null,
      organisedBy: _organisedByCtl.text.trim().isEmpty
          ? null
          : _organisedByCtl.text.trim(),
      speakerName: _speakerNameCtl.text.trim().isEmpty
          ? null
          : _speakerNameCtl.text.trim(),
      speakerCredentials: _speakerCredsCtl.text.trim().isEmpty
          ? null
          : _speakerCredsCtl.text.trim(),
      speakerBio: _speakerBioCtl.text.trim().isEmpty
          ? null
          : _speakerBioCtl.text.trim(),
      creditHours: creditHours,
      tags: _tags,
      coordinators: validCoords,
      coverImageUrl: _coverImageUrlCtl.text.trim().isEmpty
          ? null
          : _coverImageUrlCtl.text.trim(),
      brochureUrl: _brochureUrlCtl.text.trim().isEmpty
          ? null
          : _brochureUrlCtl.text.trim(),
      registrationUrl: _registrationUrlCtl.text.trim().isEmpty
          ? null
          : _registrationUrlCtl.text.trim(),
    );

    setState(() => _submitting = true);
    try {
      await CmeService.instance.create(input);
      if (mounted) setState(() => _submitted = true);
    } on CmeException catch (e) {
      if (mounted) setState(() => _submitError = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _submitError = 'Network error. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _SuccessView();

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post an event',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              _sectionLabel('Event type', cs),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _TypeChip(
                    label: 'Conference',
                    value: 'conference',
                    selected: _eventType == 'conference',
                    onTap: () => setState(() => _eventType = 'conference'),
                  ),
                  _TypeChip(
                    label: 'Webinar',
                    value: 'webinar',
                    selected: _eventType == 'webinar',
                    onTap: () => setState(() => _eventType = 'webinar'),
                  ),
                  _TypeChip(
                    label: 'Workshop',
                    value: 'workshop',
                    selected: _eventType == 'workshop',
                    onTap: () => setState(() => _eventType = 'workshop'),
                  ),
                  _TypeChip(
                    label: 'Course',
                    value: 'course',
                    selected: _eventType == 'course',
                    onTap: () => setState(() => _eventType = 'course'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _sectionLabel('Basics', cs),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleCtl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  hintText: 'e.g. PEDICON 2026',
                ),
                validator: (v) {
                  if ((v ?? '').trim().length < 5) {
                    return 'Title must be at least 5 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subtitleCtl,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  hintText: 'e.g. 64th Annual National Conference of IAP',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionCtl,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'About the event *',
                  hintText: 'Describe the event in a few sentences…',
                  alignLabelWithHint: true,
                ),
                validator: (v) {
                  if ((v ?? '').trim().length < 20) {
                    return 'Please write at least 20 characters.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              _sectionLabel('When', cs),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _dateTimeField(
                    label: 'Starts *',
                    value: _startsAt,
                    onTap: _pickStart,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _dateTimeField(
                    label: 'Ends *',
                    value: _endsAt,
                    onTap: _pickEnd,
                  )),
                ],
              ),

              const SizedBox(height: 24),
              _sectionLabel('Where', cs),
              const SizedBox(height: 10),
              if (_isInPerson) ...[
                TextFormField(
                  controller: _venueCtl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Venue',
                    hintText: 'e.g. BIEC',
                    prefixIcon: Icon(Icons.apartment_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressCtl,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Street / area',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cityCtl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    hintText: 'e.g. Bengaluru',
                  ),
                ),
              ] else ...[
                TextFormField(
                  controller: _onlineUrlCtl,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Online URL',
                    hintText: 'Zoom / Google Meet / Teams link',
                    prefixIcon: Icon(Icons.videocam_rounded),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'For webinars, the join link is hidden from unregistered users on the public card — they only see "Register Now".',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.55),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              const SizedBox(height: 24),
              _sectionLabel('Organiser', cs),
              const SizedBox(height: 10),
              TextFormField(
                controller: _organisedByCtl,
                decoration: const InputDecoration(
                  labelText: 'Organised by',
                  hintText: 'e.g. Indian Academy of Paediatrics',
                  prefixIcon: Icon(Icons.groups_2_rounded),
                ),
              ),
              if (_eventType == 'webinar') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _speakerNameCtl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Speaker name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _speakerCredsCtl,
                  decoration: const InputDecoration(
                    labelText: 'Speaker credentials',
                    hintText: 'e.g. MD, DM (Neonatology)',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _speakerBioCtl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Speaker bio',
                    hintText: 'e.g. Senior Consultant Neonatologist…',
                  ),
                ),
              ],

              const SizedBox(height: 24),
              _sectionLabel('Tags', cs),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _suggestedTags.map((t) {
                  final selected = _tags.contains(t);
                  return FilterChip(
                    label: Text(t,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                    selected: selected,
                    onSelected: (_) => _toggleSuggestedTag(t),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagInputCtl,
                      decoration: const InputDecoration(
                        labelText: 'Add a custom tag',
                        hintText: 'Press enter to add',
                      ),
                      onFieldSubmitted: _addTag,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(Icons.add_rounded),
                    onPressed: () => _addTag(_tagInputCtl.text),
                  ),
                ],
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _tags
                      .map(
                        (t) => Chip(
                          label: Text(
                            t,
                            style: GoogleFonts.plusJakartaSans(fontSize: 11),
                          ),
                          onDeleted: () => setState(() => _tags.remove(t)),
                          deleteIcon: const Icon(Icons.close, size: 14),
                        ),
                      )
                      .toList(),
                ),
              ],

              const SizedBox(height: 24),
              _sectionLabel('Coordinators', cs),
              const SizedBox(height: 6),
              Text(
                'At least one coordinator with a name is required. Add as many as you like.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(_coordinators.length, (i) {
                final ctl = _coordinators[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: ctl.name,
                              decoration: InputDecoration(
                                labelText: 'Name${i == 0 ? ' *' : ''}',
                                isDense: true,
                              ),
                              validator: (v) {
                                if (i == 0 && (v ?? '').trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          if (_coordinators.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded),
                              onPressed: () {
                                setState(() {
                                  _coordinators.removeAt(i).dispose();
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: ctl.email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: ctl.phone,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              OutlinedButton.icon(
                onPressed: () => setState(() => _coordinators.add(_CoordinatorInput())),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  'Add another coordinator',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _sectionLabel('Links', cs),
              const SizedBox(height: 4),
              Text(
                'Upload your PDF or image to Google Drive → right-click → Share → Anyone with the link → paste the link here. PediAid doesn\'t store the file, only the link — so the app stays fast.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.6),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _coverImageUrlCtl,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Cover image URL',
                  hintText: 'https://…',
                  prefixIcon: Icon(Icons.image_outlined),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _brochureUrlCtl,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Brochure (Google Drive link)',
                  hintText: 'https://drive.google.com/…',
                  prefixIcon: Icon(Icons.picture_as_pdf_outlined),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _registrationUrlCtl,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Registration URL',
                  hintText: 'Google Form, event page, etc.',
                  prefixIcon: Icon(Icons.open_in_new_rounded),
                ),
              ),

              const SizedBox(height: 24),
              _sectionLabel('CME credits (optional)', cs),
              const SizedBox(height: 10),
              TextFormField(
                controller: _creditHoursCtl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Credit hours',
                  hintText: 'e.g. 2',
                ),
              ),

              const SizedBox(height: 24),
              if (_submitError != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _submitError!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: cs.onErrorContainer,
                    ),
                  ),
                ),
              if (_submitError != null) const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit for review',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'An admin will review your submission before it goes live.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, ColorScheme cs) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: cs.primary,
      ),
    );
  }

  Widget _dateTimeField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_month_rounded),
        ),
        child: Text(
          value == null
              ? 'Tap to pick'
              : DateFormat('d MMM yyyy, h:mm a').format(value),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: value == null
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Type chip
// ---------------------------------------------------------------------------

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? cs.onPrimary : cs.onSurface,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Coordinator input row
// ---------------------------------------------------------------------------

class _CoordinatorInput {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  CmeCoordinator snapshot() => CmeCoordinator(
        name: name.text.trim(),
        email: email.text.trim().isEmpty ? null : email.text.trim(),
        phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
      );

  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
  }
}

// ---------------------------------------------------------------------------
// Success view
// ---------------------------------------------------------------------------

class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 56,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Thank you for posting!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your event is awaiting admin review. We'll notify you by email and in-app once it's approved, and it'll show up in the public CME list.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.55,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: Text(
                      'Back to CME',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
