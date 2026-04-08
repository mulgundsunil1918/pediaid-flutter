import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Semantic callout accent colours (used with withValues(alpha:) only) ───────
const _kRed   = Color(0xFFB71C1C);
const _kAmber = Color(0xFFF57C00);
const _kGreen = Color(0xFF2E7D32);

enum _CStyle { critical, lung, bone, warning, note }

class _Callout {
  final _CStyle style;
  final String text;
  const _Callout(this.style, this.text);
}

class _WeekEntry {
  final String chipLabel;
  final String header;
  final int trimester;
  final String? size;
  final List<String> bullets;
  final List<_Callout> callouts;
  const _WeekEntry({
    required this.chipLabel,
    required this.header,
    required this.trimester,
    this.size,
    required this.bullets,
    this.callouts = const [],
  });
}

// ── All chip labels in display order ──────────────────────────────────────────
const _kAllChips = [
  '1&2','3','4','5','6','7','8','9','10','11','12','13',
  '14','15','16','17','18','19','20','21','22','23','24',
  '25','26','27','28','29-31','32-33','34-36','37-38','39-41',
];

// chip "17" maps to the "16" entry (weeks 16-17 are combined)
const _kChipAlias = <String, String>{'17': '16'};

// ── Week data ─────────────────────────────────────────────────────────────────
const List<_WeekEntry> _kWeeks = [
  _WeekEntry(
    chipLabel: '1&2', header: 'WEEKS 1 AND 2', trimester: 1,
    bullets: [
      'During the first two weeks after the last menstrual period, egg follicles mature in the ovaries under the stimulus of follicle-stimulating hormone (FSH), a hormone secreted by the pituitary gland in the brain.',
      'High levels of the hormone estradiol, produced by the developing egg follicle, cause secretion of luteinizing hormone (LH), another hormone from the pituitary gland. LH triggers release of the egg from its follicle (ovulation).',
      'For women with 28-day cycles, ovulation usually occurs on days 13 to 15.',
    ],
  ),
  _WeekEntry(
    chipLabel: '3', header: 'WEEK 3 — Embryonic age 1 week', trimester: 1,
    bullets: [
      'During the third week, if fertilization occurs, the fertilized egg (zygote) begins producing the hormone human chorionic gonadotropin (hCG, the pregnancy hormone).',
      'hCG first becomes detectable in the mother\'s blood and urine between 6 and 14 days after fertilization (3 to 4 weeks gestational age).',
      'During the 3rd week the sex of the fetus is determined by the father\'s sperm, and twins may be formed.',
      'Fatigue and swollen or tender breasts are sometimes the first signs of pregnancy.',
    ],
  ),
  _WeekEntry(
    chipLabel: '4', header: 'WEEK 4 — Embryonic age 2 weeks — 0.9 months', trimester: 1,
    size: 'Approximately the size of a pinhead',
    bullets: [
      'The embryo is approximately the size of a pinhead. Most pregnancy tests are positive at this time.',
    ],
  ),
  _WeekEntry(
    chipLabel: '5', header: 'WEEK 5 — Embryonic age 3 weeks — 1.2 months', trimester: 1,
    bullets: [
      'The brain, spine, and heart have begun to form.',
      'By the end of the week the heart will be pumping blood.',
      'Week 5 is the beginning of the embryonic period, which lasts from the 5th to the 10th week.',
      'It is during this critical period that many birth defects occur in the developing embryo. Most of these birth defects will have no known cause or will be due to a combination of factors (multifactorial).',
    ],
    callouts: [
      _Callout(_CStyle.critical,
          'START OF EMBRYONIC PERIOD (Weeks 5–10): Critical period for birth defects. Most major organ systems are forming during this time.'),
    ],
  ),
  _WeekEntry(
    chipLabel: '6', header: 'WEEK 6 — Embryonic age 4 weeks — 1.4 months', trimester: 1,
    size: 'About the size of a pea (average CRL ~0.5 cm / 0.2 inches)',
    bullets: [
      'The embryo is now about the size of a pea.',
      'The average crown–rump length is about 0.2 inches (0.5 cm).',
      'The eyes, nostrils, and arms are taking shape.',
      'The heart is beating at about 110 beats per minute and sometimes may be seen using a transvaginal ultrasound at this time.',
    ],
  ),
  _WeekEntry(
    chipLabel: '7', header: 'WEEK 7 — Embryonic age 5 weeks — 1.6 months', trimester: 1,
    size: '~0.95 cm (0.37 inches)',
    bullets: [
      'The embryo is now about 0.37 inches (0.95 cm) long.',
      'The hands and feet are forming, as well as the mouth and face.',
      'The heart is beating at about 120 beats per minute. Movement of the embryo can be detected by ultrasound.',
      'By week 7 the trachea and bronchi of the lungs have formed, and the pseudoglandular stage of lung development begins.',
      'Crown–rump length of 7 mm or greater and no heartbeat, or mean sac diameter of 25 mm or greater and no embryo is considered consistent with early pregnancy loss.',
    ],
    callouts: [
      _Callout(_CStyle.lung, 'Pseudoglandular stage of lung development begins at week 7.'),
      _Callout(_CStyle.warning,
          'CRL ≥7 mm with no heartbeat OR mean sac diameter ≥25 mm with no embryo = consistent with early pregnancy loss.'),
    ],
  ),
  _WeekEntry(
    chipLabel: '8', header: 'WEEK 8 — Embryonic age 6 weeks — 1.8 months', trimester: 1,
    size: '~1.6 cm (0.6 inches) — size of a bean',
    bullets: [
      'The average embryo at 8 weeks is 0.6 inches (1.6 cm) long.',
      'The embryo is about the size of a bean. The fingers and toes are developing.',
      'The adrenal glands begin DHEA-S secretion and the testes begin to secrete testosterone.',
      'In a process called physiological gut herniation, the intestine elongates and moves outside the abdomen into the base of the umbilical cord and rotates counter-clockwise at about 8 weeks. The intestine returns into the fetal abdomen by about 12 weeks.',
    ],
  ),
  _WeekEntry(
    chipLabel: '9', header: 'WEEK 9 — Embryonic age 7 weeks — 2.1 months', trimester: 1,
    size: '~2.3 cm (0.9 inches)',
    bullets: [
      'The heart is beating at about 170 beats per minute.',
      'The average embryo at 9 weeks is 0.9 inches (2.3 cm) long.',
    ],
  ),
  _WeekEntry(
    chipLabel: '10', header: 'WEEK 10 — Fetal age 8 weeks — 2.3 months', trimester: 1,
    size: '~3.1 cm (1.22 inches), ~35 grams',
    bullets: [
      'The embryo\'s tail has disappeared and it is now called a fetus. Fingerprints are being formed, and bone cells are replacing cartilage.',
      'The adrenal glands are starting to produce catecholamines and the pituitary is starting to release ADH and oxytocin.',
      'The fetus can make IgM.',
      'The average fetus at 10 weeks is 1.22 inches (3.1 cm) long and weighs about 1.2 ounces (35 grams).',
    ],
  ),
  _WeekEntry(
    chipLabel: '11', header: 'WEEK 11 — Fetal age 9 weeks — 2.5 months', trimester: 1,
    size: '~4.1 cm (1.6 inches), ~45 grams',
    bullets: [
      'The fetus is starting to have breathing movements. It can open its mouth and swallow.',
      'The average fetus at 11 weeks is 1.6 inches (4.1 cm) long and weighs about 1.6 ounces (45 grams).',
    ],
  ),
  _WeekEntry(
    chipLabel: '12', header: 'WEEK 12 — Fetal age 10 weeks — 2.8 months', trimester: 1,
    size: '~5.4 cm (2.1 inches), ~58 grams',
    bullets: [
      'The fetus is starting to make random movements.',
      'The fetus begins to concentrate iodine in its thyroid and produce thyroid hormone at about this time.',
      'The pancreas is beginning to make insulin, and the kidneys are producing urine. The heartbeat can usually be heard with an electronic monitor at this time.',
      'Experimental data suggest that human fetuses are capable of limited IgG synthesis by ~12 weeks\' gestation. However, IgG present in the fetal circulation consist almost entirely of maternally derived IgG transported across the placenta.',
      'The average fetus at 12 weeks is 2.1 inches (5.4 cm) long and weighs about 2.1 ounces (58 grams).',
    ],
  ),
  _WeekEntry(
    chipLabel: '13', header: 'WEEK 13 — Fetal age 12 weeks — 3 months', trimester: 1,
    size: '~6.7 cm (2.6 inches), ~73 grams',
    bullets: [
      'The average fetus at 13 weeks is 2.6 inches (6.7 cm) long and weighs about 2.6 ounces (73 grams).',
      'All major organs are formed now, but they are too immature for the fetus to survive out of the womb.',
      'Physiologic gut herniation should be complete by this time.',
      'The fetal bladder can consistently be seen using ultrasound after 13 weeks.',
    ],
    callouts: [
      _Callout(_CStyle.critical, 'END OF FIRST TRIMESTER'),
    ],
  ),
  _WeekEntry(
    chipLabel: '14',
    header: 'WEEK 14 — Fetal age 12 weeks — 3.2 months — START 2ND TRIMESTER',
    trimester: 2,
    size: '~14.7 cm crown to heel (5.8 inches), ~93 grams',
    bullets: [
      'The fetus\'s toenails are appearing. The gender may sometimes be seen.',
      'The average fetus at 14 weeks is 5.8 inches (14.7 cm) long (crown to heel) and weighs 3.3 ounces (93 grams).',
    ],
    callouts: [
      _Callout(_CStyle.note, 'START OF SECOND TRIMESTER'),
    ],
  ),
  _WeekEntry(
    chipLabel: '15', header: 'WEEK 15 — Fetal age 13 weeks — 3.5 months', trimester: 2,
    size: '~16.7 cm (6.6 inches), ~117 grams',
    bullets: [
      'Fetal movement may be sensed now (called quickening). Some mothers don\'t feel the fetus moving until about 25 weeks.',
      'The average fetus at 15 weeks is 6.6 inches (16.7 cm) long and weighs 4.1 ounces (117 grams).',
    ],
  ),
  _WeekEntry(
    chipLabel: '16',
    header: 'WEEKS 16–17 — Fetal age 14–15 weeks — 3.7 to 3.9 months',
    trimester: 2,
    size: 'Week 16: ~18.6 cm (7.3 in), ~146 g  |  Week 17: ~20.4 cm (8 in), ~181 g',
    bullets: [
      'The average 16-week fetus is 7.3 inches (18.6 cm) long and weighs 5.2 ounces (146 grams).',
      'Hearing is beginning to form.',
      'The pancreas begins to produce exocrine enzymes.',
      'The canalicular period of lung development has started and will continue until about 25 weeks.',
      'The average 17-week fetus is 8 inches (20.4 cm) long and weighs 6.4 ounces (181 grams).',
      'The pseudoglandular stage of lung development ends at about 17 weeks. There are still no alveoli (the air sacs in the lungs where the exchange of oxygen and carbon dioxide occurs), so respiration is not possible at this time.',
    ],
    callouts: [
      _Callout(_CStyle.lung,
          'Canalicular period of lung development begins ~16 weeks and continues to ~25 weeks. Pseudoglandular stage ends at ~17 weeks — no alveoli yet, respiration not possible.'),
    ],
  ),
  _WeekEntry(
    chipLabel: '18', header: 'WEEK 18 — Fetal age 16 weeks — 4.1 months', trimester: 2,
    size: '~22.2 cm (8.7 inches), ~223 grams',
    bullets: [
      'The ears are standing out, and the fetus is beginning to respond to sound.',
      'The average 18-week fetus is 8.7 inches (22.2 cm) long and weighs 7.9 ounces (223 grams).',
      'The thyroid becomes fully functional at 18 to 20 weeks.',
      'The cerebellar vermis can be demonstrated to be fully formed on ultrasound at this age.',
    ],
  ),
  _WeekEntry(
    chipLabel: '19', header: 'WEEK 19 — Fetal age 17 weeks — 4.4 months', trimester: 2,
    size: '~24 cm (9.5 inches), ~273 grams',
    bullets: [
      'The ears, nose, and lips are now recognizable.',
      'The average fetus at 19 weeks is 9.5 inches (24 cm) long and weighs 9.6 ounces (273 grams).',
    ],
  ),
  _WeekEntry(
    chipLabel: '20', header: 'WEEK 20 — Fetal age 18 weeks — 4.6 months', trimester: 2,
    size: '~25.7 cm (10.1 inches), ~331 grams',
    bullets: [
      'The fetus is covered in fine hair (lanugo), has some scalp hair, and is capable of producing IgG and IgM (two types of antibodies).',
      'The parathyroid begins to regulate calcium metabolism.',
      'The adrenal are starting to produce significant levels of cortisol.',
      'The average fetus at 20 weeks is 10.1 inches (25.7 cm) long and weighs 11.7 ounces (331 grams).',
    ],
    callouts: [
      _Callout(_CStyle.lung, 'HALFWAY POINT — 20 weeks'),
    ],
  ),
  _WeekEntry(
    chipLabel: '21', header: 'WEEK 21 — Fetal age 19 weeks — 4.8 months', trimester: 2,
    size: '~27.4 cm (10.8 inches), ~399 grams',
    bullets: [
      'The fetus is now able to suck and grasp, and may have bouts of hiccups. Some women may begin feeling Braxton Hicks contractions at this time.',
      'The average fetus at 21 weeks is 10.8 inches (27.4 cm) long and weighs 14.1 ounces (399 grams).',
    ],
  ),
  _WeekEntry(
    chipLabel: '22', header: 'WEEK 22 — Fetal age 20 weeks — 5.1 months', trimester: 2,
    size: '~29 cm (11.4 inches), ~478 grams',
    bullets: [
      'The average fetus at 22 weeks is 11.4 inches (29 cm) long and weighs 1.1 pounds (478 grams).',
    ],
  ),
  _WeekEntry(
    chipLabel: '23', header: 'WEEK 23 — Fetal age 21 weeks — 5.3 months', trimester: 2,
    size: '~30.6 cm (12.1 inches), ~568 grams',
    bullets: [
      'The fetus is having rapid eye movements during sleep.',
      'The average fetus at 23 weeks is 12.1 inches (30.6 cm) long and weighs 1.3 pounds (568 grams).',
      'The entire corpus callosum may not be seen using transabdominal ultrasound before this age.',
    ],
    callouts: [
      _Callout(_CStyle.warning, 'Approaching viability threshold — ~23 weeks'),
    ],
  ),
  _WeekEntry(
    chipLabel: '24', header: 'WEEK 24 — Fetal age 22 weeks — 5.5 months', trimester: 2,
    size: '~32.2 cm (12.7 inches), ~670 grams',
    bullets: [
      'The average fetus at 24 weeks is 12.7 inches (32.2 cm) long and weighs 1.5 pounds (670 grams).',
      'The terminal saccular stage of lung development has started.',
    ],
    callouts: [
      _Callout(_CStyle.warning, 'VIABILITY THRESHOLD — 24 weeks'),
      _Callout(_CStyle.lung, 'Terminal saccular stage of lung development begins at 24 weeks.'),
    ],
  ),
  _WeekEntry(
    chipLabel: '25', header: 'WEEK 25 — Fetal age 23 weeks — 5.8 months', trimester: 2,
    size: '~33.7 cm (13.3 inches), ~785 grams',
    bullets: [
      'The average fetus at 25 weeks is 13.3 inches (33.7 cm) long and weighs 1.7 pounds (785 grams).',
      'The canalicular period of lung development is ending. Respiration is possible towards the end of this period.',
    ],
    callouts: [
      _Callout(_CStyle.lung,
          'Canalicular period ending — respiration becoming possible towards end of 25 weeks.'),
    ],
  ),
  _WeekEntry(
    chipLabel: '26', header: 'WEEK 26 — Fetal age 24 weeks — 6 months', trimester: 2,
    size: '~35.1 cm (13.8 inches), ~913 grams',
    bullets: [
      'The fetus can respond to sounds that occur in the mother\'s surroundings. Its eyelids can open and close.',
      'The average fetus at 26 weeks is 13.8 inches (35.1 cm) long and weighs about 2 pounds (913 grams).',
      'Survival out of the womb at this age would be expected to be approximately 87%.',
    ],
  ),
  _WeekEntry(
    chipLabel: '27', header: 'WEEK 27 — Fetal age 25 weeks — 6.2 months', trimester: 2,
    size: '~36.6 cm (14.4 inches), ~1055 grams',
    bullets: [
      'The average fetus at 27 weeks is 14.4 inches (36.6 cm) long and weighs 2.3 pounds (1055 grams).',
      'Survival out of the womb at this age would be expected to be approximately 94%.',
    ],
  ),
  _WeekEntry(
    chipLabel: '28',
    header: 'WEEK 28 — Fetal age 26 weeks — 6.4 months — START 3RD TRIMESTER',
    trimester: 3,
    size: '~37.9 cm (14.9 inches), ~1210 grams',
    bullets: [
      'The fetus has eyelashes and its skin is red and covered with vernix caseosa, a waxy substance believed to act as a protective film with anti-infective and waterproofing properties.',
      'The average fetus at 28 weeks is 14.9 inches (37.9 cm) long and weighs 2.7 pounds (1210 grams).',
      'Survival out of the womb at this age would be expected to be approximately 94%.',
    ],
    callouts: [
      _Callout(_CStyle.lung, 'START OF THIRD TRIMESTER — 28 weeks'),
    ],
  ),
  _WeekEntry(
    chipLabel: '29-31',
    header: 'WEEKS 29–31 — Fetal age 27–29 weeks — 6.6 to 7.1 months',
    trimester: 3,
    bullets: [
      'The average fetus at 29 weeks is 15.4 inches (39.2 cm) long and weighs 3 pounds (1379 grams).',
      'The average fetus at 30 weeks is 16 inches (40.5 cm) long and weighs 3.4 pounds (1559 grams).',
      'The average fetus at 31 weeks is 16.5 inches (41.8 cm) long and weighs 3.9 pounds (1751 grams).',
    ],
  ),
  _WeekEntry(
    chipLabel: '32-33',
    header: 'WEEKS 32–33 — Fetal age 30–31 weeks — 7.4 to 7.6 months',
    trimester: 3,
    size: 'Week 32: ~43 cm (16.9 in), ~1953 g  |  Week 33: ~44 cm (17.3 in), ~2162 g',
    bullets: [
      'The fetus is forming muscle and storing body fat. If the fetus is a boy, his testicles are descending.',
      'The average fetus at 32 weeks is 16.9 inches (43 cm) long and weighs 4.3 pounds (1953 grams).',
      'The average fetus at 33 weeks is 17.3 inches (44 cm) long and weighs 4.8 pounds (2162 grams).',
      'The distal femoral epiphysis ossification center can usually be seen in about 72% of fetuses at 33 weeks.',
    ],
    callouts: [
      _Callout(_CStyle.bone,
          'Distal femoral epiphysis ossification center visible in ~72% of fetuses at 33 weeks.'),
    ],
  ),
  _WeekEntry(
    chipLabel: '34-36',
    header: 'WEEKS 34–36 — Fetal age 32–34 weeks — 7.8 to 8.3 months — LATE PRETERM',
    trimester: 3,
    size: 'Week 34: ~45.2 cm/2377 g  |  Week 35: ~46.3 cm/2595 g  |  Week 36: ~47.3 cm/2813 g',
    bullets: [
      'The fetus is now considered to be late preterm.',
      'The average 34-week fetus is 17.8 inches (45.2 cm) long and weighs 5.2 pounds (2377 grams).',
      'The average 35-week fetus is 18.2 inches (46.3 cm) long and weighs 5.7 pounds (2595 grams).',
      'The proximal tibial epiphysis ossification center may be seen in about 35% of fetuses at 35 weeks.',
      'The average 36-week fetus is 18.6 inches (47.3 cm) long and weighs 6.2 pounds (2813 grams).',
    ],
    callouts: [
      _Callout(_CStyle.bone,
          'Proximal tibial epiphysis ossification center visible in ~35% of fetuses at 35 weeks.'),
      _Callout(_CStyle.warning, 'LATE PRETERM (34–36 weeks)'),
    ],
  ),
  _WeekEntry(
    chipLabel: '37-38',
    header: 'WEEKS 37–38 — Fetal age 35–36 weeks — 8.5 to 8.7 months — EARLY TERM',
    trimester: 3,
    size: 'Week 37: ~48.3 cm (19 in), ~3028 g  |  Week 38: ~49.2 cm (19.4 in), ~3236 g',
    bullets: [
      'The fetus is now considered to be early term.',
      'The average 37-week fetus is 19 inches (48.3 cm) long and weighs 6.7 pounds (3028 grams).',
      'The average 38-week fetus is 19.4 inches (49.2 cm) long and weighs 7.1 pounds (3236 grams).',
      'The proximal humeral epiphysis ossification center may be seen at 38 weeks.',
    ],
    callouts: [
      _Callout(_CStyle.bone,
          'Proximal humeral epiphysis ossification center may be seen at 38 weeks.'),
      _Callout(_CStyle.warning, 'EARLY TERM (37–38 weeks)'),
    ],
  ),
  _WeekEntry(
    chipLabel: '39-41',
    header: 'WEEKS 39–41 — Fetal age 37–39 weeks — 9 to 9.4 months — FULL TERM',
    trimester: 3,
    size: 'Week 39: ~50.1 cm/3435 g  |  Week 40: ~51 cm/3619 g  |  Week 41: ~51.8 cm/3787 g',
    bullets: [
      'The fetus is now full term.',
      'The average 39-week fetus is 19.7 inches (50.1 cm) long and weighs 7.6 pounds (3435 grams).',
      'The average 40-week fetus is 20.1 inches (51 cm) long and weighs 8 pounds (3619 grams).',
      'The average 41-week fetus is 20.4 inches (51.8 cm) long and weighs 8.3 pounds (3787 grams).',
    ],
    callouts: [
      _Callout(_CStyle.warning, 'FULL TERM (39–41 weeks)'),
    ],
  ),
];

// ── Critical periods data ─────────────────────────────────────────────────────
const _kCritRows = <List<String>>[
  ['CNS (brain, spinal cord)', '~3–16', '~5–18', 'Functional effects (cognition, behavior, seizures, microcephaly) can occur from ~16 wks conceptional (~18 wks GA) through term.'],
  ['Heart', '~3–6', '~5–8', 'Highest risk for major structural defects (e.g., conotruncal, septal). Minor structural/conduction issues still possible to ~8–10 wks conceptional (~10–12 wks GA).'],
  ['Ears', '~4–9', '~6–11', 'Later (to ~16 wks conceptional / ~18 wks GA): mainly minor anomalies and sensorineural hearing loss risk.'],
  ['Eyes', '~4–8', '~6–10', 'Functional and minor structural effects can extend from ~8 wks conceptional (~10 wks GA) to term.'],
  ['Limbs (upper & lower)', '~4–5', '~6–7', 'High risk for reduction defects and major limb anomalies; smaller minor anomalies possible to ~8 wks conceptional (~10 wks GA).'],
  ['Upper lip', '~5–6', '~7–8', 'Classic window for cleft lip / lip fusion defects.'],
  ['Palate (secondary)', '~6–9', '~8–11', 'Cleft palate risk concentrated in this period.'],
  ['Teeth', '~6–8', '~8–10', 'Disturbances of enamel / tooth development can continue from ~8 wks conceptional (~10 wks GA) into later fetal life.'],
  ['External genitalia', '~7–9', '~9–11', 'Sex differentiation and external genital formation; virilization/undervirilization and some minor anomalies possible from ~9 wks conceptional (~11 wks GA) to term.'],
  ['Urinary tract', '~4–8', '~6–10', 'Major structural anomalies arise primarily in this window; later in gestation, effects are more on growth and function rather than new major malformations.'],
];

// ── Screen ────────────────────────────────────────────────────────────────────

class FetalDevelopmentScreen extends StatefulWidget {
  const FetalDevelopmentScreen({super.key});

  @override
  State<FetalDevelopmentScreen> createState() => _FetalDevelopmentScreenState();
}

class _FetalDevelopmentScreenState extends State<FetalDevelopmentScreen> {
  bool _defExpanded = true;
  late final Map<String, GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _keys = {for (final w in _kWeeks) w.chipLabel: GlobalKey()};
  }

  void _jumpTo(String chip) {
    final resolved = _kChipAlias[chip] ?? chip;
    final key = _keys[resolved];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Fetal Development'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Definition card ───────────────────────────────────────────────
            _buildDefinitionCard(cs),
            const SizedBox(height: 20),

            // ── Trimester headers info ────────────────────────────────────────
            _buildTrimesterHeadersCard(cs),
            const SizedBox(height: 16),

            // ── Jump to week chips ────────────────────────────────────────────
            _buildSectionLabel('Jump to Week', cs),
            const SizedBox(height: 8),
            _buildChipRow(cs),
            const SizedBox(height: 20),

            // ── Week-by-week cards ────────────────────────────────────────────
            _buildSectionLabel('Week-by-Week Development', cs),
            const SizedBox(height: 8),
            _buildWeekList(cs),
            const SizedBox(height: 16),

            // ── Critical periods ──────────────────────────────────────────────
            _buildCriticalPeriodsSection(cs),
            const SizedBox(height: 12),

            // ── Equations ────────────────────────────────────────────────────
            _buildEquationsSection(cs),
            const SizedBox(height: 16),

            // ── Reference footer ──────────────────────────────────────────────
            _buildFooter(cs),
          ],
        ),
      ),
    );
  }

  // ── Definition card ─────────────────────────────────────────────────────────

  Widget _buildDefinitionCard(ColorScheme cs) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cs.outline.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _defExpanded = !_defExpanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.info_outline_rounded, size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('What is Gestational Age?',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: cs.onSurface)),
                ),
                Icon(_defExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: cs.onSurface.withValues(alpha: 0.5)),
              ]),
              if (_defExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  'The actual embryo or fetal age (also known as conceptual age) is the time elapsed from fertilization of the egg near the time of ovulation. '
                  'However, because most women do not know when ovulation occurred, but do know when their last period began, the time elapsed since the first day of the last normal menstrual period, the menstrual age, is used to determine the age of a pregnancy. '
                  'The menstrual age is also known as the gestational age. Gestational age is conventionally expressed as completed weeks. '
                  'Therefore, a 36 week, 6 day fetus is considered to be a 36 week fetus.',
                  style: TextStyle(
                      fontSize: 13, color: cs.onSurface.withValues(alpha: 0.8), height: 1.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Trimester headers card ───────────────────────────────────────────────────

  Widget _buildTrimesterHeadersCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trimester Classification',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurface)),
          const SizedBox(height: 10),
          _trimRow(_kGreen, '1st Trimester', 'Less than 14 weeks 0 days', cs),
          const SizedBox(height: 6),
          _trimRow(_kAmber, '2nd Trimester', '14 weeks 0 days through 27 weeks 6 days', cs),
          const SizedBox(height: 6),
          _trimRow(cs.primary, '3rd Trimester', '28 weeks 0 days through delivery', cs),
        ],
      ),
    );
  }

  Widget _trimRow(Color col, String label, String range, ColorScheme cs) => Row(
    children: [
      Container(
        width: 10, height: 10,
        decoration: BoxDecoration(color: col, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Text(label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: col)),
      const SizedBox(width: 6),
      Expanded(
        child: Text(range,
            style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.7))),
      ),
    ],
  );

  // ── Chip row ─────────────────────────────────────────────────────────────────

  Widget _buildChipRow(ColorScheme cs) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _kAllChips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final chip = _kAllChips[i];
          return InkWell(
            onTap: () => _jumpTo(chip),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
              ),
              child: Text(chip,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary)),
            ),
          );
        },
      ),
    );
  }

  // ── Week list ────────────────────────────────────────────────────────────────

  Widget _buildWeekList(ColorScheme cs) {
    final widgets = <Widget>[];
    int? lastTrimester;

    for (final week in _kWeeks) {
      if (week.trimester != lastTrimester) {
        if (lastTrimester != null) widgets.add(const SizedBox(height: 8));
        widgets.add(_buildTrimesterDivider(week.trimester, cs));
        widgets.add(const SizedBox(height: 8));
        lastTrimester = week.trimester;
      }
      widgets.add(
        Container(
          key: _keys[week.chipLabel],
          child: _buildWeekCard(week, cs),
        ),
      );
      widgets.add(const SizedBox(height: 6));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildTrimesterDivider(int trimester, ColorScheme cs) {
    final col = trimester == 1 ? _kGreen : trimester == 2 ? _kAmber : cs.primary;
    final label = trimester == 1
        ? '1st Trimester (< 14 weeks)'
        : trimester == 2
            ? '2nd Trimester (14 – 27w 6d)'
            : '3rd Trimester (28 weeks → delivery)';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: col.withValues(alpha: 0.25)),
      ),
      child: Row(children: [
        Container(width: 4, height: 14,
            decoration: BoxDecoration(color: col, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: col)),
      ]),
    );
  }

  Widget _buildWeekCard(_WeekEntry week, ColorScheme cs) {
    final trimCol = week.trimester == 1
        ? _kGreen
        : week.trimester == 2
            ? _kAmber
            : cs.primary;
    final badge = week.trimester == 1
        ? '1st'
        : week.trimester == 2
            ? '2nd'
            : '3rd';

    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outline.withValues(alpha: 0.35)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Row(children: [
          Expanded(
            child: Text(week.header,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurface)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: trimCol.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: trimCol.withValues(alpha: 0.3)),
            ),
            child: Text(badge,
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700, color: trimCol)),
          ),
        ]),
        children: [
          if (week.size != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                Icon(Icons.straighten_outlined, size: 13, color: cs.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(week.size!,
                      style: TextStyle(
                          fontSize: 11, color: cs.onSurface.withValues(alpha: 0.75),
                          fontStyle: FontStyle.italic)),
                ),
              ]),
            ),
            const SizedBox(height: 10),
          ],
          ...week.bullets.map((b) => _bullet(b, cs)),
          ...week.callouts.map((c) => _calloutBox(c, cs)),
        ],
      ),
    );
  }

  Widget _bullet(String text, ColorScheme cs) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 5, height: 5,
            decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  fontSize: 13, color: cs.onSurface.withValues(alpha: 0.9), height: 1.5)),
        ),
      ],
    ),
  );

  Widget _calloutBox(_Callout c, ColorScheme cs) {
    final Color bg;
    final Color border;
    final IconData icon;

    switch (c.style) {
      case _CStyle.critical:
        bg = _kRed.withValues(alpha: 0.08);
        border = _kRed.withValues(alpha: 0.3);
        icon = Icons.warning_amber_rounded;
      case _CStyle.lung:
        bg = cs.primary.withValues(alpha: 0.08);
        border = cs.primary.withValues(alpha: 0.3);
        icon = Icons.air_rounded;
      case _CStyle.bone:
        bg = cs.onSurface.withValues(alpha: 0.06);
        border = cs.onSurface.withValues(alpha: 0.2);
        icon = Icons.accessibility_new_rounded;
      case _CStyle.warning:
        bg = _kAmber.withValues(alpha: 0.08);
        border = _kAmber.withValues(alpha: 0.3);
        icon = Icons.info_rounded;
      case _CStyle.note:
        bg = _kGreen.withValues(alpha: 0.08);
        border = _kGreen.withValues(alpha: 0.3);
        icon = Icons.check_circle_outline_rounded;
    }

    final iconColor = c.style == _CStyle.critical
        ? _kRed
        : c.style == _CStyle.lung
            ? cs.primary
            : c.style == _CStyle.bone
                ? cs.onSurface.withValues(alpha: 0.5)
                : c.style == _CStyle.warning
                    ? _kAmber
                    : _kGreen;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(c.text,
                  style: TextStyle(
                      fontSize: 12, color: cs.onSurface.withValues(alpha: 0.85),
                      height: 1.5, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section label ────────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String label, ColorScheme cs) => Text(
    label,
    style: GoogleFonts.plusJakartaSans(
        fontSize: 15, fontWeight: FontWeight.w700, color: cs.onSurface),
  );

  // ── Critical periods section ─────────────────────────────────────────────────

  Widget _buildCriticalPeriodsSection(ColorScheme cs) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cs.outline.withValues(alpha: 0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text('Critical Periods for Teratogenic Effects by Organ System',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurface)),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _kAmber.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kAmber.withValues(alpha: 0.25)),
            ),
            child: Text(
              'Conceptional age ≈ gestational age − 2 weeks. Ranges are approximate.\n'
              'Source: Moore — The Developing Human; Sadler — Langman\'s Medical Embryology.',
              style: TextStyle(
                  fontSize: 11, color: cs.onSurface.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic, height: 1.5),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor:
                  WidgetStateProperty.all(cs.primary.withValues(alpha: 0.08)),
              dataRowColor: WidgetStateProperty.resolveWith((_) => Theme.of(context).cardColor),
              columnSpacing: 14,
              horizontalMargin: 0,
              headingRowHeight: 38,
              dataRowMinHeight: 40,
              dataRowMaxHeight: double.infinity,
              columns: [
                DataColumn(label: _hdrCell('Structure', cs)),
                DataColumn(label: _hdrCell('Critical Period\n(conceptional wks)', cs)),
                DataColumn(label: _hdrCell('GA equivalent\n(LMP wks)', cs)),
                DataColumn(label: _hdrCell('Notes', cs)),
              ],
              rows: _kCritRows.map((row) => DataRow(
                cells: [
                  DataCell(_cellText(row[0], cs, bold: true)),
                  DataCell(_cellText(row[1], cs)),
                  DataCell(_cellText(row[2], cs)),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(row[3],
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurface.withValues(alpha: 0.85),
                                height: 1.45)),
                      ),
                    ),
                  ),
                ],
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hdrCell(String t, ColorScheme cs) => Text(t,
      style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700, color: cs.onSurface));

  Widget _cellText(String t, ColorScheme cs, {bool bold = false}) => Text(t,
      style: TextStyle(
          fontSize: 11,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          color: cs.onSurface.withValues(alpha: 0.85)));

  // ── Equations section ────────────────────────────────────────────────────────

  Widget _buildEquationsSection(ColorScheme cs) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cs.outline.withValues(alpha: 0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text('Reference Equations',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurface)),
        children: [
          _equationBlock(
            '1. Crown-Rump Length → Menstrual Age (Hadlock 1992, valid 5–18 weeks)',
            'LN(MA) = 1.684969 + (0.315646 × CRL) − (0.049306 × CRL²)\n'
                '         + (0.004057 × CRL³) − (0.000120456 × CRL⁴)\n'
                'MA in weeks, CRL in cm.',
            'Hadlock FP et al. Radiology. 1992;182(2):501-5. PMID: 1732970',
            cs,
          ),
          _equationBlock(
            '2. Crown-Heel Length → GA (Fenton)',
            'Length (cm) = −0.0219² × GA(weeks) + 2.5764 × GA(weeks) − 17.059',
            'Fenton TR. BMC Pediatr. 2003;3:13. PMID: 14678563',
            cs,
          ),
          _equationBlock(
            '3. Weight → Gestational Age (Hadlock 1991)',
            'ln weight(g) = 0.578 + 0.332 × MA − 0.00354 × MA²',
            'Hadlock FP et al. Radiology. 1991;181(1):129-33. PMID: 1887021',
            cs,
          ),
        ],
      ),
    );
  }

  Widget _equationBlock(String title, String formula, String ref, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.85))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
            ),
            child: Text(formula,
                style: TextStyle(
                    fontSize: 12, color: cs.onSurface,
                    fontFamily: 'monospace', height: 1.5)),
          ),
          const SizedBox(height: 4),
          Text('Reference: $ref',
              style: TextStyle(
                  fontSize: 11, color: cs.onSurface.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  // ── Reference footer ─────────────────────────────────────────────────────────

  Widget _buildFooter(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.menu_book_outlined, size: 15, color: cs.primary),
            const SizedBox(width: 8),
            Text('Sources', style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: cs.primary)),
          ]),
          const SizedBox(height: 6),
          Text(
            'Perinatology.com — Fetal Development (Curran MA, M.D., F.A.C.O.G.). '
            'Moore KL — The Developing Human. Sadler TW — Langman\'s Medical Embryology. '
            'Hadlock FP et al. Radiology 1992 & 1991. Fenton TR. BMC Pediatr 2003. '
            'Reviewed: December 2025.',
            style: TextStyle(
                fontSize: 11, color: cs.onSurface.withValues(alpha: 0.55),
                height: 1.5, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
