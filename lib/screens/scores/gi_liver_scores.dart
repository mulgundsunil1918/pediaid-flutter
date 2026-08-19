// =============================================================================
// scores/gi_liver_scores.dart
//
// Gastroenterology & hepatology scores, each with its original citation.
// =============================================================================

import 'package:flutter/material.dart';
import 'score_scaffold.dart';

const _gi = Color(0xFF6A4C00);

// ── Appendicitis ─────────────────────────────────────────────────────────────

final pediatricAppendicitisScore = ScoreDef(
  title: 'Pediatric Appendicitis Score (PAS)',
  subtitle: 'Likelihood of acute appendicitis in a child with abdominal pain.',
  system: 'GI & Liver',
  accent: _gi,
  questions: const [
    ScoreQ('Cough / percussion / hopping tenderness in RLQ', [
      ScoreChoice('Absent', 0),
      ScoreChoice('Present', 2),
    ]),
    ScoreQ('Right lower quadrant tenderness', [
      ScoreChoice('Absent', 0),
      ScoreChoice('Present', 2),
    ]),
    ScoreQ('Anorexia', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Pyrexia ≥ 38 °C', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Nausea or vomiting', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Migration of pain to RLQ', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Leucocytosis ≥ 10 000 /µL', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Neutrophilia ≥ 7 500 /µL', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
  ],
  bands: [
    ScoreBand(0, 'Low risk', scGreen,
        'PAS ≤3 — appendicitis unlikely. Consider discharge with review, or observation if the story is atypical.'),
    ScoreBand(4, 'Equivocal', scAmber,
        'PAS 4–6 — equivocal. Imaging (ultrasound first in children) and/or serial examination with surgical input.'),
    ScoreBand(7, 'High risk', scRed,
        'PAS ≥7 — appendicitis likely. Surgical referral; many centres proceed without further imaging.'),
  ],
  notes: const [
    'Total range 0–10.',
    'Source: Samuel M. Pediatric appendicitis score. J Pediatr Surg 2002;37:877–81.',
  ],
);

final alvaradoScore = ScoreDef(
  title: 'Alvarado Score (MANTRELS)',
  subtitle: 'Classic clinical score for the likelihood of acute appendicitis.',
  system: 'GI & Liver',
  accent: _gi,
  questions: const [
    ScoreQ('Migration of pain to RLQ', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Anorexia', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Nausea or vomiting', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Tenderness in RLQ', [ScoreChoice('No', 0), ScoreChoice('Yes', 2)]),
    ScoreQ('Rebound pain', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Elevated temperature ≥ 37.3 °C', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Leucocytosis > 10 000 /µL', [ScoreChoice('No', 0), ScoreChoice('Yes', 2)]),
    ScoreQ('Shift to the left (neutrophils > 75 %)', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
  ],
  bands: [
    ScoreBand(0, 'Unlikely', scGreen,
        'Score 0–4 — appendicitis unlikely. Consider discharge with safety-netting or an alternative diagnosis.'),
    ScoreBand(5, 'Possible', scAmber,
        'Score 5–6 — compatible with appendicitis. Observation and/or imaging recommended.'),
    ScoreBand(7, 'Probable', scOrange,
        'Score 7–8 — probable appendicitis. Surgical referral.'),
    ScoreBand(9, 'Very probable', scRed,
        'Score 9–10 — very probable appendicitis. Urgent surgical referral.'),
  ],
  notes: const [
    'Total range 0–10. Less well validated in young children than the Paediatric Appendicitis Score.',
    'Source: Alvarado A. A practical score for the early diagnosis of acute appendicitis. Ann Emerg Med 1986;15:557–64.',
  ],
);

final airScore = ScoreDef(
  title: 'AIR Score (Appendicitis Inflammatory Response)',
  subtitle: 'Inflammation-weighted appendicitis score, useful for risk stratification.',
  system: 'GI & Liver',
  accent: _gi,
  questions: const [
    ScoreQ('Vomiting', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Pain in the right iliac fossa', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Rebound tenderness or muscular defence', [
      ScoreChoice('None', 0),
      ScoreChoice('Light', 1),
      ScoreChoice('Medium', 2),
      ScoreChoice('Strong', 3),
    ]),
    ScoreQ('Body temperature ≥ 38.5 °C', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Polymorphonuclear leucocytes', [
      ScoreChoice('< 70 %', 0),
      ScoreChoice('70–84 %', 1),
      ScoreChoice('≥ 85 %', 2),
    ]),
    ScoreQ('White blood cell count', [
      ScoreChoice('< 10 ×10⁹/L', 0),
      ScoreChoice('10.0–14.9 ×10⁹/L', 1),
      ScoreChoice('≥ 15 ×10⁹/L', 2),
    ]),
    ScoreQ('C-reactive protein', [
      ScoreChoice('< 10 mg/L', 0),
      ScoreChoice('10–49 mg/L', 1),
      ScoreChoice('≥ 50 mg/L', 2),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Low probability', scGreen,
        'AIR 0–4 — low probability. Outpatient follow-up if the patient is well; consider discharge with review.'),
    ScoreBand(5, 'Indeterminate', scAmber,
        'AIR 5–8 — indeterminate group. Admit for observation, serial examination and/or imaging.'),
    ScoreBand(9, 'High probability', scRed,
        'AIR 9–12 — high probability of appendicitis. Surgical exploration is generally indicated.'),
  ],
  notes: const [
    'Total range 0–12. Performs well in children and adults, particularly for advanced appendicitis.',
    'Source: Andersson M, Andersson RE. The appendicitis inflammatory response score. World J Surg 2008;32:1843–9.',
  ],
);

// ── Liver ────────────────────────────────────────────────────────────────────

final childPughScore = ScoreDef(
  title: 'Child-Pugh Score',
  subtitle: 'Severity of chronic liver disease and prognosis in cirrhosis.',
  system: 'GI & Liver',
  accent: _gi,
  questions: const [
    ScoreQ('Total bilirubin', [
      ScoreChoice('< 2 mg/dL', 1),
      ScoreChoice('2–3 mg/dL', 2),
      ScoreChoice('> 3 mg/dL', 3),
    ]),
    ScoreQ('Serum albumin', [
      ScoreChoice('> 3.5 g/dL', 1),
      ScoreChoice('2.8–3.5 g/dL', 2),
      ScoreChoice('< 2.8 g/dL', 3),
    ]),
    ScoreQ('INR', [
      ScoreChoice('< 1.7', 1),
      ScoreChoice('1.7–2.3', 2),
      ScoreChoice('> 2.3', 3),
    ]),
    ScoreQ('Ascites', [
      ScoreChoice('None', 1),
      ScoreChoice('Mild / diuretic-responsive', 2),
      ScoreChoice('Moderate–severe / refractory', 3),
    ]),
    ScoreQ('Hepatic encephalopathy', [
      ScoreChoice('None', 1),
      ScoreChoice('Grade I–II', 2),
      ScoreChoice('Grade III–IV', 3),
    ]),
  ],
  bands: [
    ScoreBand(5, 'Class A', scGreen,
        'Score 5–6 — Child-Pugh A (well-compensated). Approximately 100% one-year survival in adult series.'),
    ScoreBand(7, 'Class B', scAmber,
        'Score 7–9 — Child-Pugh B (significant functional compromise). Around 80% one-year survival; consider transplant assessment.'),
    ScoreBand(10, 'Class C', scRed,
        'Score 10–15 — Child-Pugh C (decompensated). Approximately 45% one-year survival; transplant evaluation indicated.'),
  ],
  notes: const [
    'Total range 5–15. In children, PELD is generally preferred for transplant listing.',
    'Source: Pugh RNH et al. Transection of the oesophagus for bleeding oesophageal varices. Br J Surg 1973;60:646–9.',
  ],
);

final kingsCollegeParacetamolScore = ScoreDef(
  title: "King's College Criteria — Paracetamol ALF",
  subtitle:
      'Predicts poor prognosis in paracetamol-induced acute liver failure — indication for transplant referral.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Arterial pH < 7.30 after adequate fluid resuscitation', pts: 4),
    ScoreQ.yesNo('Arterial lactate > 3.0 mmol/L after fluid resuscitation', pts: 4),
    ScoreQ.yesNo('INR > 6.5 (prothrombin time > 100 s)'),
    ScoreQ.yesNo('Serum creatinine > 3.4 mg/dL (300 µmol/L)'),
    ScoreQ.yesNo('Grade III–IV hepatic encephalopathy'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Transplant criteria not met on current values. Continue N-acetylcysteine and supportive care; repeat assessment — parameters can evolve rapidly.'),
    ScoreBand(3, 'Criteria MET', scRed,
        'All three of INR >6.5, creatinine >3.4 mg/dL and grade III–IV encephalopathy — poor prognosis. Refer urgently to a liver transplant centre.'),
    ScoreBand(4, 'Criteria MET', scRed,
        'pH <7.30 (or lactate >3.0) after resuscitation — poor prognosis independent of other values. Refer urgently to a liver transplant centre.'),
  ],
  notes: const [
    'Criteria are met by EITHER: arterial pH <7.30 (or lactate >3.0 after resuscitation) alone, OR all three of INR >6.5, creatinine >3.4 mg/dL and grade III–IV encephalopathy.',
    'Source: O’Grady JG et al. Early indicators of prognosis in fulminant hepatic failure. Gastroenterology 1989;97:439–45.',
  ],
);

final kingsCollegeNonParacetamolScore = ScoreDef(
  title: "King's College Criteria — Non-Paracetamol ALF",
  subtitle:
      'Poor-prognosis criteria in non-paracetamol acute liver failure — indication for transplant referral.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('INR > 6.5 (prothrombin time > 100 s), regardless of encephalopathy grade', pts: 4),
    ScoreQ.yesNo('Age < 10 or > 40 years'),
    ScoreQ.yesNo('Aetiology: non-A non-B hepatitis, halothane, or idiosyncratic drug reaction'),
    ScoreQ.yesNo('Jaundice to encephalopathy interval > 7 days'),
    ScoreQ.yesNo('INR > 3.5 (prothrombin time > 50 s)'),
    ScoreQ.yesNo('Serum bilirubin > 17.5 mg/dL (300 µmol/L)'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Criteria not met on current values. Continue intensive supportive care and reassess frequently.'),
    ScoreBand(3, 'Criteria MET', scRed,
        'Any 3 of the 5 minor criteria — poor prognosis. Refer urgently to a liver transplant centre.'),
    ScoreBand(4, 'Criteria MET', scRed,
        'INR >6.5 alone meets the criteria in non-paracetamol ALF — refer urgently to a liver transplant centre.'),
  ],
  notes: const [
    'Criteria met by EITHER INR >6.5 alone, OR any 3 of: age <10 or >40 y, unfavourable aetiology, jaundice-to-encephalopathy >7 days, INR >3.5, bilirubin >17.5 mg/dL.',
    'Source: O’Grady JG et al. Gastroenterology 1989;97:439–45.',
  ],
);

final wilsonLeipzigScore = ScoreDef(
  title: 'Leipzig Score (Wilson Disease)',
  subtitle: 'Diagnostic scoring system for Wilson disease.',
  system: 'GI & Liver',
  accent: _gi,
  questions: const [
    ScoreQ('Kayser-Fleischer rings', [
      ScoreChoice('Absent', 0),
      ScoreChoice('Present', 2),
    ]),
    ScoreQ('Neurological symptoms or typical MRI brain changes', [
      ScoreChoice('Absent', 0),
      ScoreChoice('Mild', 1),
      ScoreChoice('Severe / typical', 2),
    ]),
    ScoreQ('Serum caeruloplasmin', [
      ScoreChoice('Normal (> 0.2 g/L)', 0),
      ScoreChoice('0.1–0.2 g/L', 1),
      ScoreChoice('< 0.1 g/L', 2),
    ]),
    ScoreQ('Coombs-negative haemolytic anaemia', [
      ScoreChoice('Absent', 0),
      ScoreChoice('Present', 1),
    ]),
    ScoreQ('Liver copper (in the absence of cholestasis)', [
      ScoreChoice('Normal (< 0.8 µmol/g)', -1),
      ScoreChoice('Up to 5× ULN (0.8–4 µmol/g)', 1),
      ScoreChoice('> 5× ULN (> 4 µmol/g)', 2),
    ]),
    ScoreQ('Rhodanine-positive granules (if copper unavailable)', [
      ScoreChoice('Absent', 0),
      ScoreChoice('Present', 1),
    ]),
    ScoreQ('Urinary copper (in the absence of acute hepatitis)', [
      ScoreChoice('Normal', 0),
      ScoreChoice('1–2× ULN', 1),
      ScoreChoice('> 2× ULN, or normal but > 5× ULN after penicillamine', 2),
    ]),
    ScoreQ('ATP7B mutation analysis', [
      ScoreChoice('No mutations detected', 0),
      ScoreChoice('One chromosome affected', 1),
      ScoreChoice('Both chromosomes affected', 4),
    ]),
  ],
  bands: [
    ScoreBand(-1, 'Unlikely', scGreen,
        'Score 0–1 — Wilson disease unlikely. Consider alternative causes of liver disease.'),
    ScoreBand(2, 'Possible', scAmber,
        'Score 2–3 — possible Wilson disease; more investigations needed (24-h urinary copper, penicillamine challenge, liver biopsy, ATP7B sequencing).'),
    ScoreBand(4, 'Highly likely', scRed,
        'Score ≥4 — diagnosis of Wilson disease established. Start chelation/zinc therapy, screen siblings, and refer to hepatology.'),
  ],
  notes: const [
    'Agreed at the 8th International Meeting on Wilson Disease, Leipzig 2001.',
    'Source: Ferenci P et al. Diagnosis and phenotypic classification of Wilson disease. Liver Int 2003;23:139–42.',
  ],
);

// ── IBD ──────────────────────────────────────────────────────────────────────

final pucaiScore = ScoreDef(
  title: 'PUCAI — Paediatric Ulcerative Colitis Activity Index',
  subtitle: 'Disease activity in paediatric ulcerative colitis; guides escalation in acute severe colitis.',
  system: 'GI & Liver',
  accent: _gi,
  questions: const [
    ScoreQ('Abdominal pain', [
      ScoreChoice('No pain', 0),
      ScoreChoice('Pain can be ignored', 5),
      ScoreChoice('Pain cannot be ignored', 10),
    ]),
    ScoreQ('Rectal bleeding', [
      ScoreChoice('None', 0),
      ScoreChoice('Small amount, in < 50 % of stools', 10),
      ScoreChoice('Small amount with most stools', 20),
      ScoreChoice('Large amount (> 50 % of stool content)', 30),
    ]),
    ScoreQ('Stool consistency of most stools', [
      ScoreChoice('Formed', 0),
      ScoreChoice('Partially formed', 5),
      ScoreChoice('Completely unformed', 10),
    ]),
    ScoreQ('Number of stools per 24 hours', [
      ScoreChoice('0–2', 0),
      ScoreChoice('3–5', 5),
      ScoreChoice('6–8', 10),
      ScoreChoice('> 8', 15),
    ]),
    ScoreQ('Nocturnal stools (any episode causing waking)', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 10),
    ]),
    ScoreQ('Activity level', [
      ScoreChoice('No limitation of activity', 0),
      ScoreChoice('Occasional limitation of activity', 5),
      ScoreChoice('Severe restricted activity', 10),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Remission', scGreen,
        'PUCAI <10 — clinical remission.'),
    ScoreBand(10, 'Mild', scAmber,
        'PUCAI 10–34 — mild disease.'),
    ScoreBand(35, 'Moderate', scOrange,
        'PUCAI 35–64 — moderate disease. Optimise therapy and arrange close review.'),
    ScoreBand(65, 'Severe', scRed,
        'PUCAI ≥65 — severe (acute severe colitis). Admit for IV corticosteroids; PUCAI >45 on day 3 and >65 on day 5 predicts steroid failure and should trigger second-line therapy planning.'),
  ],
  notes: const [
    'Total range 0–85.',
    'Source: Turner D et al. Development, validation and evaluation of a paediatric ulcerative colitis activity index. Gastroenterology 2007;133:423–32.',
  ],
);

final pcdaiScore = ScoreDef(
  title: 'PCDAI — Paediatric Crohn’s Disease Activity Index',
  subtitle: 'Abbreviated disease-activity index for paediatric Crohn’s disease.',
  system: 'GI & Liver',
  accent: _gi,
  questions: const [
    ScoreQ('Abdominal pain', [
      ScoreChoice('None', 0),
      ScoreChoice('Mild — brief, does not interfere with activity', 5),
      ScoreChoice('Moderate/severe — daily, longer lasting, affects activity', 10),
    ]),
    ScoreQ('Stools per day', [
      ScoreChoice('0–1 liquid stools, no blood', 0),
      ScoreChoice('Up to 2 semi-formed with small blood, or 2–5 liquid', 5),
      ScoreChoice('Gross bleeding, or ≥6 liquid, or nocturnal diarrhoea', 10),
    ]),
    ScoreQ('General wellbeing', [
      ScoreChoice('Well, no limitation of activity', 0),
      ScoreChoice('Occasional difficulty maintaining activities, below par', 5),
      ScoreChoice('Frequent limitation of activity, very poor', 10),
    ]),
    ScoreQ('Weight', [
      ScoreChoice('Weight gain, or voluntary weight loss', 0),
      ScoreChoice('Involuntary weight stable, or loss 1–9 %', 5),
      ScoreChoice('Weight loss ≥ 10 %', 10),
    ]),
    ScoreQ('Height (at diagnosis) or height velocity (follow-up)', [
      ScoreChoice('< 1 channel decrease, or height velocity ≥ −1 SD', 0),
      ScoreChoice('1 to < 2 channel decrease, or velocity −1 to −2 SD', 5),
      ScoreChoice('≥ 2 channel decrease, or velocity < −2 SD', 10),
    ]),
    ScoreQ('Abdomen on examination', [
      ScoreChoice('No tenderness, no mass', 0),
      ScoreChoice('Tenderness, or mass without tenderness', 5),
      ScoreChoice('Tenderness, involuntary guarding, definite mass', 10),
    ]),
    ScoreQ('Peri-rectal disease', [
      ScoreChoice('None, or asymptomatic tags', 0),
      ScoreChoice('1–2 indolent fistulae, scant drainage, no tenderness', 5),
      ScoreChoice('Active fistula, drainage, tenderness or abscess', 10),
    ]),
    ScoreQ('Extra-intestinal manifestations (fever, arthritis, uveitis, EN, PG)', [
      ScoreChoice('None', 0),
      ScoreChoice('One', 5),
      ScoreChoice('Two or more', 10),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Remission', scGreen,
        'PCDAI ≤10 — clinical remission (some authors use <10).'),
    ScoreBand(11, 'Mild', scAmber,
        'PCDAI 11–30 — mild disease activity.'),
    ScoreBand(31, 'Moderate–severe', scRed,
        'PCDAI >30 — moderate to severe disease. Escalate therapy and involve paediatric gastroenterology.'),
  ],
  notes: const [
    'This is the abbreviated (clinical) PCDAI; the original also includes haematocrit, ESR and albumin.',
    'Source: Hyams JS et al. Development and validation of a pediatric Crohn’s disease activity index. J Pediatr Gastroenterol Nutr 1991;12:439–47.',
  ],
);

// ── Functional GI (Rome IV) ──────────────────────────────────────────────────

final romeConstipationScore = ScoreDef(
  title: 'Rome IV — Functional Constipation',
  subtitle:
      'Children ≥4 years: ≥2 criteria at least once weekly for ≥1 month, without meeting IBS criteria.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('≤ 2 defaecations in the toilet per week'),
    ScoreQ.yesNo('At least one episode of faecal incontinence per week'),
    ScoreQ.yesNo('History of retentive posturing or excessive volitional stool retention'),
    ScoreQ.yesNo('History of painful or hard bowel movements'),
    ScoreQ.yesNo('Presence of a large faecal mass in the rectum'),
    ScoreQ.yesNo('History of large-diameter stools that can obstruct the toilet'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Fewer than 2 criteria — Rome IV functional constipation not met. Reassess symptoms and consider other causes.'),
    ScoreBand(2, 'Criteria met', scOrange,
        '≥2 criteria fulfilled for at least 1 month — functional constipation. Treat with disimpaction if needed, maintenance laxatives (PEG first line), toilet training and dietary advice.'),
  ],
  notes: const [
    'For children <4 years the same criteria apply but require ≥1 month duration with ≥2 criteria (developmental age-appropriate).',
    'Always exclude red flags: delayed meconium, ribbon stools, failure to thrive, abnormal neurology, anal abnormalities.',
    'Source: Hyams JS et al. Functional disorders: children and adolescents. Rome IV. Gastroenterology 2016;150:1456–68.',
  ],
);

final romeIbsScore = ScoreDef(
  title: 'Rome IV — Irritable Bowel Syndrome',
  subtitle: 'Children/adolescents: criteria fulfilled ≥2 months before diagnosis.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Abdominal pain at least 4 days per month', pts: 2),
    ScoreQ.yesNo('Pain related to defaecation'),
    ScoreQ.yesNo('Change in frequency of stool'),
    ScoreQ.yesNo('Change in form (appearance) of stool'),
    ScoreQ.yesNo('In children with constipation, the pain does not resolve when the constipation resolves'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Abdominal pain ≥4 days/month plus at least one associated feature is required.'),
    ScoreBand(3, 'Criteria met', scOrange,
        'Rome IV IBS criteria met — abdominal pain ≥4 days/month associated with defaecation and/or a change in stool frequency or form, for ≥2 months. Specify subtype (IBS-C, IBS-D, IBS-M) using the Bristol stool scale.'),
  ],
  notes: const [
    'Diagnosis requires that symptoms cannot be fully explained by another medical condition after appropriate evaluation.',
    'Source: Hyams JS et al. Rome IV — Functional disorders: children and adolescents. Gastroenterology 2016;150:1456–68.',
  ],
);

final romeCyclicVomitingScore = ScoreDef(
  title: 'Rome IV — Cyclic Vomiting Syndrome',
  subtitle: 'Stereotypical episodes of intense vomiting with well periods in between.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('≥ 2 periods of intense, unremitting nausea and paroxysmal vomiting lasting hours to days, within a 6-month period'),
    ScoreQ.yesNo('Episodes are stereotypical in each patient'),
    ScoreQ.yesNo('Episodes are separated by weeks to months with return to baseline health'),
    ScoreQ.yesNo('Symptoms cannot be attributed to another medical condition after appropriate evaluation'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'All four criteria are required for a Rome IV diagnosis of cyclic vomiting syndrome.'),
    ScoreBand(4, 'Criteria met', scOrange,
        'All criteria met — cyclic vomiting syndrome. Consider prophylaxis (cyproheptadine <5 y, amitriptyline ≥5 y, propranolol) and an abortive plan with early rehydration.'),
  ],
  notes: const [
    'Source: Hyams JS et al. Rome IV — Functional disorders: children and adolescents. Gastroenterology 2016;150:1456–68.',
  ],
);

final romeAbdominalMigraineScore = ScoreDef(
  title: 'Rome IV — Abdominal Migraine',
  subtitle: 'Paroxysmal episodes of intense periumbilical abdominal pain.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Paroxysmal episodes of intense, acute periumbilical, midline or diffuse abdominal pain lasting ≥ 1 hour'),
    ScoreQ.yesNo('Episodes are separated by weeks to months'),
    ScoreQ.yesNo('Pain is incapacitating and interferes with normal activities'),
    ScoreQ.yesNo('Stereotypical pattern and symptoms in the individual patient'),
    ScoreQ.yesNo('Pain associated with ≥2 of: anorexia, nausea, vomiting, headache, photophobia, pallor'),
    ScoreQ.yesNo('Symptoms cannot be attributed to another condition after appropriate evaluation'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'All criteria must be fulfilled, occurring at least twice in the preceding 6 months.'),
    ScoreBand(6, 'Criteria met', scOrange,
        'All criteria met — abdominal migraine. Consider migraine-style prophylaxis and trigger avoidance; many children later develop typical migraine.'),
  ],
  notes: const [
    'Source: Hyams JS et al. Rome IV — Functional disorders: children and adolescents. Gastroenterology 2016;150:1456–68.',
  ],
);

final bristolStoolScore = ScoreDef(
  title: 'Bristol Stool Form Scale',
  subtitle: 'Classifies stool form — used to characterise constipation and diarrhoea.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'type',
  questions: const [
    ScoreQ('Stool appearance', [
      ScoreChoice('Type 1 — separate hard lumps, like nuts', 1),
      ScoreChoice('Type 2 — sausage-shaped but lumpy', 2),
      ScoreChoice('Type 3 — sausage with cracks on the surface', 3),
      ScoreChoice('Type 4 — smooth, soft sausage or snake', 4),
      ScoreChoice('Type 5 — soft blobs with clear-cut edges', 5),
      ScoreChoice('Type 6 — fluffy pieces with ragged edges, mushy', 6),
      ScoreChoice('Type 7 — watery, no solid pieces, entirely liquid', 7),
    ]),
  ],
  bands: [
    ScoreBand(1, 'Constipation', scOrange,
        'Types 1–2 indicate constipation — hard, difficult to pass stools. Consider laxative therapy and dietary/fluid review.'),
    ScoreBand(3, 'Normal', scGreen,
        'Types 3–4 are normal, with type 4 considered ideal.'),
    ScoreBand(5, 'Tending to loose', scAmber,
        'Type 5 — lacking fibre; may indicate a tendency to loose stools or urgency.'),
    ScoreBand(6, 'Diarrhoea', scOrange,
        'Types 6–7 indicate diarrhoea. Assess hydration, duration and infective causes; type 7 is entirely liquid.'),
  ],
  notes: const [
    'A modified version for infants and toddlers exists, since breastfed infants normally pass loose stools.',
    'Source: Lewis SJ, Heaton KW. Stool form scale as a useful guide to intestinal transit time. Scand J Gastroenterol 1997;32:920–4.',
  ],
);

final List<ScoreDef> giLiverScores = [
  pediatricAppendicitisScore,
  alvaradoScore,
  airScore,
  childPughScore,
  kingsCollegeParacetamolScore,
  kingsCollegeNonParacetamolScore,
  wilsonLeipzigScore,
  pucaiScore,
  pcdaiScore,
  romeConstipationScore,
  romeIbsScore,
  romeCyclicVomitingScore,
  romeAbdominalMigraineScore,
  bristolStoolScore,
];
