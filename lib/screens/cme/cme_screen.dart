import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CmeScreen extends StatelessWidget {
  const CmeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('CME, Conferences & Webinars'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w700),
            unselectedLabelStyle:
                GoogleFonts.plusJakartaSans(fontSize: 13),
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurface.withValues(alpha: 0.5),
            indicatorColor: cs.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.event_rounded, size: 18), text: 'Conferences'),
              Tab(icon: Icon(Icons.video_call_rounded, size: 18), text: 'Webinars'),
            ],
          ),
        ),
        body: SafeArea(
          bottom: true,
          child: TabBarView(
            children: [
              _ConferencesTab(cs: cs),
              _WebinarsTab(cs: cs),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Conferences Tab ───────────────────────────────────────────────────────────

class _ConferencesTab extends StatelessWidget {
  final ColorScheme cs;
  const _ConferencesTab({required this.cs});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
      children: [
        _PediconCard(cs: cs),
      ],
    );
  }
}

class _PediconCard extends StatelessWidget {
  final ColorScheme cs;
  const _PediconCard({required this.cs});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Gradient header ────────────────────────────────────────────────
          Container(
            height: 130,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: -30, right: -30,
                    child: _Circle(120, 0.08)),
                Positioned(
                    bottom: -20, right: 60,
                    child: _Circle(70, 0.06)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3)),
                          ),
                          child: Text('NATIONAL CONFERENCE',
                              style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD600).withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: const Color(0xFFFFD600).withValues(alpha: 0.5)),
                          ),
                          child: Text('IAP',
                              style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFFFFD600),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8)),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Text('PEDICON 2026',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          )),
                      Text(
                          '64th Annual National Conference of Indian Academy of Pediatrics',
                          style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Theme banner ───────────────────────────────────────────────────
          Container(
            color: const Color(0xFF1976D2).withValues(alpha: isDark ? 0.25 : 0.08),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(children: [
              const Icon(Icons.format_quote_rounded,
                  color: Color(0xFF1565C0), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '"Paediatrics 2.0 — Bridging Science with Practice"',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1565C0),
                  ),
                ),
              ),
            ]),
          ),

          // ── Details ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Key info chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: '5th April 2026',
                        color: const Color(0xFF1565C0)),
                    _InfoChip(
                        icon: Icons.location_on_rounded,
                        label: 'Bengaluru, Karnataka',
                        color: const Color(0xFF1565C0)),
                    _InfoChip(
                        icon: Icons.schedule_rounded,
                        label: '8:00 AM – 6:00 PM',
                        color: const Color(0xFF1565C0)),
                  ],
                ),
                const SizedBox(height: 16),

                // Venue
                _DetailRow(
                  icon: Icons.business_rounded,
                  label: 'Venue',
                  value:
                      'Bengaluru International Exhibition Centre (BIEC)\nTumkur Road, Bengaluru — 560 073, Karnataka',
                  cs: cs,
                ),
                const SizedBox(height: 12),

                // Organiser
                _DetailRow(
                  icon: Icons.group_rounded,
                  label: 'Organised By',
                  value:
                      'Indian Academy of Pediatrics — Karnataka State Branch\nin collaboration with IAP National',
                  cs: cs,
                ),
                const SizedBox(height: 16),

                // Description
                Text('About the Conference',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface)),
                const SizedBox(height: 6),
                Text(
                  "India's premier annual paediatric conference, PEDICON 2026 brings together over 3,000 clinicians, researchers, and academicians. Featuring state-of-the-art lectures, hands-on workshops, and cutting-edge research presentations across neonatology, paediatric critical care, infectious diseases, neurology, nutrition, and more.",
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      height: 1.55,
                      color: cs.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 12),

                // Sessions
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    'Neonatology',
                    'Critical Care',
                    'Infectious Disease',
                    'Neurology',
                    'Nutrition',
                    'Emergency Paediatrics',
                    'Hands-on Workshops',
                  ].map((s) => _SessionChip(label: s, cs: cs)).toList(),
                ),
                const SizedBox(height: 20),

                // Contact section
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: cs.outline.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Event Coordinator',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface.withValues(alpha: 0.5))),
                      const SizedBox(height: 8),
                      _ContactRow(
                          icon: Icons.person_rounded,
                          text: 'Dr. Jayashree Murali, MD (Paediatrics)',
                          cs: cs),
                      const SizedBox(height: 5),
                      _ContactRow(
                          icon: Icons.email_rounded,
                          text: 'pedicon2026@iapkarnataka.org',
                          cs: cs),
                      const SizedBox(height: 5),
                      _ContactRow(
                          icon: Icons.phone_rounded,
                          text: '+91 80 2355 7890',
                          cs: cs),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Action buttons
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDetails(context),
                      icon: const Icon(Icons.info_outline_rounded, size: 18),
                      label: Text('Get Details',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1565C0),
                        side: const BorderSide(color: Color(0xFF1565C0)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => _register(context),
                      icon: const Icon(Icons.how_to_reg_rounded, size: 18),
                      label: Text('Register Now',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        elevation: 2,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        final cs = Theme.of(context).colorScheme;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text('PEDICON 2026 — Details',
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700, color: const Color(0xFF1565C0))),
          content: SingleChildScrollView(
            child: Text(
              '• Date: 5th April 2026\n'
              '• Venue: BIEC, Tumkur Road, Bengaluru\n'
              '• CME Credits: 8 Credits (IAP Accredited)\n'
              '• Registration Fee:\n'
              '   – IAP Members: ₹2,500/-\n'
              '   – Non-members: ₹3,500/-\n'
              '   – PGs & Residents: ₹1,500/-\n\n'
              '• Scientific Programme:\n'
              '   – 6 Plenary Sessions\n'
              '   – 12 Symposia\n'
              '   – 8 Hands-on Workshops\n'
              '   – Free Paper Presentations\n\n'
              '• Abstract Submission Deadline: 1st March 2026',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.6),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close',
                  style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  void _register(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        final cs = Theme.of(context).colorScheme;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(children: [
            const Icon(Icons.how_to_reg_rounded, color: Color(0xFF1565C0)),
            const SizedBox(width: 10),
            Text('Register for PEDICON 2026',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700, fontSize: 15,
                    color: const Color(0xFF1565C0))),
          ]),
          content: Text(
            'Registration portal opens on 1st February 2026.\n\n'
            'To pre-register, contact:\n'
            '📧 pedicon2026@iapkarnataka.org\n'
            '📞 +91 80 2355 7890\n\n'
            'Early bird discounts available for IAP members registering before 28th February 2026.',
            style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.55),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close',
                  style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () => Navigator.pop(context),
              child: Text('Got It',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }
}

// ── Webinars Tab ──────────────────────────────────────────────────────────────

class _WebinarsTab extends StatelessWidget {
  final ColorScheme cs;
  const _WebinarsTab({required this.cs});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
      children: [
        _WebinarCard(cs: cs),
      ],
    );
  }
}

class _WebinarCard extends StatelessWidget {
  final ColorScheme cs;
  const _WebinarCard({required this.cs});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const accent = Color(0xFF00838F);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Gradient header ────────────────────────────────────────────────
          Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00838F), Color(0xFF00695C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: -25, right: -25,
                    child: _Circle(100, 0.08)),
                Positioned(
                    bottom: -10, left: 40,
                    child: _Circle(60, 0.06)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        // Upcoming badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6F00).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.circle, color: Colors.white, size: 6),
                            const SizedBox(width: 4),
                            Text('UPCOMING',
                                style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8)),
                          ]),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('NEONATOLOGY',
                              style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8)),
                        ),
                      ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shock in Neonates: The Update',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              )),
                          Text('NeoUpdate Webinar Series 2026',
                              style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Details ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Key chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: '20th April 2026',
                        color: accent),
                    _InfoChip(
                        icon: Icons.schedule_rounded,
                        label: '4:00 – 6:00 PM IST',
                        color: accent),
                    _InfoChip(
                        icon: Icons.videocam_rounded,
                        label: 'Zoom Webinar',
                        color: accent),
                    _InfoChip(
                        icon: Icons.school_rounded,
                        label: '2 CME Credits',
                        color: accent),
                  ],
                ),
                const SizedBox(height: 16),

                // Speaker
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: isDark ? 0.15 : 0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: accent.withValues(alpha: 0.25)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.person_rounded, color: accent, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. Arvind Shenoi',
                              style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: cs.onSurface)),
                          Text('MD, DM (Neonatology)',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: cs.onSurface.withValues(alpha: 0.55))),
                          Text(
                              'Senior Consultant Neonatologist\nManipal Hospitals, Bengaluru',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: cs.onSurface.withValues(alpha: 0.45))),
                        ],
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // Description
                Text('About the Webinar',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface)),
                const SizedBox(height: 6),
                Text(
                  'A comprehensive evidence-based update on the recognition, classification, and current management of shock in neonates. Topics include distributive, cardiogenic, obstructive, and hypovolemic shock — with a focus on point-of-care diagnostics, vasopressor use, targeted neonatal echocardiography (TnECHO), and near-infrared spectroscopy (NIRS).',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      height: 1.55,
                      color: cs.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 12),

                // Topics
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    'Distributive Shock',
                    'Cardiogenic Shock',
                    'Vasopressors',
                    'TnECHO',
                    'NIRS',
                    'Volume Resuscitation',
                  ].map((s) => _SessionChip(label: s, cs: cs)).toList(),
                ),
                const SizedBox(height: 20),

                // Zoom note
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF57C00).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFFF57C00).withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.info_outline_rounded,
                        color: Color(0xFFF57C00), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Zoom link will be shared via email upon registration. Ensure you register to receive the link.',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: const Color(0xFFF57C00),
                            height: 1.4),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                // Action buttons
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _register(context),
                      icon: const Icon(Icons.app_registration_rounded, size: 18),
                      label: Text('Register',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accent,
                        side: const BorderSide(color: accent),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => _joinNow(context),
                      icon: const Icon(Icons.video_call_rounded, size: 18),
                      label: Text('Join Webinar Now',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        elevation: 2,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _register(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Register for Webinar',
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF00838F))),
        content: Text(
          'To register for "Shock in Neonates: The Update" webinar:\n\n'
          '📧 cme@neowebinars.in\n'
          '📞 +91 98XXX XXXXX\n\n'
          'Registration is FREE for IAP members.\n'
          'Non-members: ₹200/-\n\n'
          '2 CME credits (IAP accredited) will be awarded on attendance.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.55),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: TextStyle(
                    color: cs.primary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00838F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () => Navigator.pop(context),
            child: Text('Got It',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _joinNow(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(children: [
          const Icon(Icons.video_call_rounded, color: Color(0xFF00838F)),
          const SizedBox(width: 10),
          Text('Join Webinar',
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: const Color(0xFF00838F))),
        ]),
        content: Text(
          'The webinar is scheduled for 20th April 2026 at 4:00 PM IST.\n\n'
          'The Zoom link will be active on the day of the webinar and will be shared with all registered participants via email.\n\n'
          'Please ensure you have registered to receive the link.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.55),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: TextStyle(
                    color: cs.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _Circle extends StatelessWidget {
  final double size;
  final double alpha;
  const _Circle(this.size, this.alpha);

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: color)),
      ]),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;
  const _DetailRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 16, color: cs.onSurface.withValues(alpha: 0.45)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.45))),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: cs.onSurface.withValues(alpha: 0.85))),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme cs;
  const _ContactRow(
      {required this.icon, required this.text, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: cs.onSurface.withValues(alpha: 0.4)),
      const SizedBox(width: 8),
      Expanded(
          child: Text(text,
              style: TextStyle(
                  fontSize: 12.5, color: cs.onSurface.withValues(alpha: 0.75)))),
    ]);
  }
}

class _SessionChip extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  const _SessionChip({required this.label, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: cs.primary)),
    );
  }
}
