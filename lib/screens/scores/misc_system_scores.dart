// =============================================================================
// scores/misc_system_scores.dart
//
// Remaining system scores: haematology, endocrine, renal, pain, radiology,
// polysomnography, and the rest of gastroenterology/hepatology.
// Every tool carries its original source citation.
// =============================================================================

import 'package:flutter/material.dart';
import 'score_scaffold.dart';

const _heme = Color(0xFFAD1457);
const _endo = Color(0xFF4527A0);
const _renal = Color(0xFF00695C);
const _pain = Color(0xFFEF6C00);
const _rad = Color(0xFF455A64);
const _sleep = Color(0xFF3949AB);
const _gi = Color(0xFF6A4C00);

// ── Pain ─────────────────────────────────────────────────────────────────────

final flaccScore = ScoreDef(
  title: 'FLACC Pain Scale',
  subtitle:
      'Observational pain score for children aged 2 months–7 years, or any child unable to self-report.',
  system: 'Pain',
  accent: _pain,
  questions: const [
    ScoreQ('Face', [
      ScoreChoice('No particular expression or smile', 0),
      ScoreChoice('Occasional grimace or frown, withdrawn, disinterested', 1),
      ScoreChoice('Frequent to constant frown, clenched jaw, quivering chin', 2),
    ]),
    ScoreQ('Legs', [
      ScoreChoice('Normal position or relaxed', 0),
      ScoreChoice('Uneasy, restless, tense', 1),
      ScoreChoice('Kicking, or legs drawn up', 2),
    ]),
    ScoreQ('Activity', [
      ScoreChoice('Lying quietly, normal position, moves easily', 0),
      ScoreChoice('Squirming, shifting back and forth, tense', 1),
      ScoreChoice('Arched, rigid, or jerking', 2),
    ]),
    ScoreQ('Cry', [
      ScoreChoice('No cry (awake or asleep)', 0),
      ScoreChoice('Moans or whimpers, occasional complaint', 1),
      ScoreChoice('Crying steadily, screams or sobs, frequent complaints', 2),
    ]),
    ScoreQ('Consolability', [
      ScoreChoice('Content, relaxed', 0),
      ScoreChoice('Reassured by touching, hugging or talking to; distractible', 1),
      ScoreChoice('Difficult to console or comfort', 2),
    ]),
  ],
  bands: [
    ScoreBand(0, 'No pain', scGreen, 'FLACC 0 — relaxed and comfortable.'),
    ScoreBand(1, 'Mild discomfort', scGreen,
        'FLACC 1–3 — mild discomfort. Non-pharmacological comfort measures; reassess.'),
    ScoreBand(4, 'Moderate pain', scAmber,
        'FLACC 4–6 — moderate pain. Give analgesia and reassess within 30 minutes.'),
    ScoreBand(7, 'Severe pain', scRed,
        'FLACC 7–10 — severe discomfort/pain. Give prompt analgesia (consider opioid) and reassess frequently.'),
  ],
  notes: const [
    'Total range 0–10. A revised FLACC exists for children with cognitive impairment.',
    'Source: Merkel SI et al. The FLACC: a behavioral scale for scoring postoperative pain in young children. Pediatr Nurs 1997;23:293–7.',
  ],
);

final cheopsScore = ScoreDef(
  title: 'CHEOPS — Post-op Pain (1–7 years)',
  subtitle:
      "Children's Hospital of Eastern Ontario Pain Scale for post-operative pain. Range 4–13.",
  system: 'Pain',
  accent: _pain,
  questions: const [
    ScoreQ('Cry', [
      ScoreChoice('No cry', 1),
      ScoreChoice('Moaning / crying', 2),
      ScoreChoice('Screaming', 3),
    ]),
    ScoreQ('Facial', [
      ScoreChoice('Smiling (positive)', 0),
      ScoreChoice('Composed, neutral', 1),
      ScoreChoice('Grimace (negative)', 2),
    ]),
    ScoreQ('Verbal', [
      ScoreChoice('Positive statements', 0),
      ScoreChoice('Not talking, or other complaints', 1),
      ScoreChoice('Pain complaints', 2),
    ]),
    ScoreQ('Torso', [
      ScoreChoice('Neutral', 1),
      ScoreChoice('Shifting, tense, shivering, upright or restrained', 2),
    ]),
    ScoreQ('Touch', [
      ScoreChoice('Not touching the wound', 1),
      ScoreChoice('Reaching, touching, grabbing the wound, or restrained', 2),
    ]),
    ScoreQ('Legs', [
      ScoreChoice('Neutral', 1),
      ScoreChoice('Squirming, kicking, drawn up, tensed, standing or restrained', 2),
    ]),
  ],
  bands: [
    ScoreBand(4, 'No / minimal pain', scGreen,
        'CHEOPS 4–6 — minimal pain. Continue observation.'),
    ScoreBand(7, 'Analgesia indicated', scAmber,
        'CHEOPS ≥7 — analgesia is indicated. Treat and reassess in 15–20 minutes.'),
    ScoreBand(10, 'Significant pain', scRed,
        'CHEOPS 10–13 — significant pain. Give prompt analgesia and review the analgesic plan.'),
  ],
  notes: const [
    'Minimum score is 4 (not 0) because several items score from 1.',
    'Source: McGrath PJ et al. CHEOPS: a behavioral scale for rating postoperative pain in children. Adv Pain Res Ther 1985;9:395–402.',
  ],
);

// ── Haematology ──────────────────────────────────────────────────────────────

final sickleSevereRiskScore = ScoreDef(
  title: 'Sickle Cell — Risk of Severe Disease (Miller)',
  subtitle:
      'Predicts later severe sickle-cell disease from events in the first two years of life.',
  system: 'Haematology',
  accent: _heme,
  totalLabel: 'risk factors',
  questions: [
    ScoreQ.yesNo('Dactylitis (hand-foot syndrome) before 1 year of age'),
    ScoreQ.yesNo('Haemoglobin < 7 g/dL (baseline, steady state)'),
    ScoreQ.yesNo('Leucocytosis in the absence of infection'),
  ],
  bands: [
    ScoreBand(0, 'Low risk', scGreen,
        'No predictors — low probability of severe disease in later childhood. Continue routine care: penicillin prophylaxis, vaccination, TCD screening.'),
    ScoreBand(1, 'Intermediate', scAmber,
        'One predictor — intermediate risk. Maintain close follow-up and a low threshold for starting hydroxyurea.'),
    ScoreBand(2, 'High risk', scRed,
        'Two or more predictors — high probability of severe disease (adverse outcome by age 10). Strongly consider early hydroxyurea and intensified monitoring.'),
  ],
  notes: const [
    'Derived in the Cooperative Study of Sickle Cell Disease infant cohort.',
    'Source: Miller ST et al. Prediction of adverse outcomes in children with sickle cell disease. N Engl J Med 2000;342:83–9.',
  ],
);

// ── Endocrine ────────────────────────────────────────────────────────────────

final dutchFhScore = ScoreDef(
  title: 'Dutch Lipid Criteria — Familial Hypercholesterolaemia',
  subtitle: 'Dutch Lipid Clinic Network score for diagnosing familial hypercholesterolaemia.',
  system: 'Endocrine',
  accent: _endo,
  questions: const [
    ScoreQ('Family history', [
      ScoreChoice('None', 0),
      ScoreChoice('1st-degree relative with premature CAD/vascular disease, OR LDL > 95th centile', 1),
      ScoreChoice('1st-degree relative with tendon xanthomata/arcus, OR child < 18 y with LDL > 95th centile', 2),
    ]),
    ScoreQ('Clinical history (in the patient)', [
      ScoreChoice('None', 0),
      ScoreChoice('Premature cerebral or peripheral vascular disease', 1),
      ScoreChoice('Premature coronary artery disease', 2),
    ]),
    ScoreQ('Physical examination', [
      ScoreChoice('None', 0),
      ScoreChoice('Corneal arcus below age 45 years', 4),
      ScoreChoice('Tendon xanthomata', 6),
    ]),
    ScoreQ('LDL cholesterol', [
      ScoreChoice('< 155 mg/dL (< 4.0 mmol/L)', 0),
      ScoreChoice('155–189 mg/dL (4.0–4.9 mmol/L)', 1),
      ScoreChoice('190–249 mg/dL (5.0–6.4 mmol/L)', 3),
      ScoreChoice('250–329 mg/dL (6.5–8.4 mmol/L)', 5),
      ScoreChoice('≥ 330 mg/dL (≥ 8.5 mmol/L)', 8),
    ]),
    ScoreQ('DNA analysis', [
      ScoreChoice('Not done / negative', 0),
      ScoreChoice('Functional mutation in LDLR, APOB or PCSK9', 8),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Unlikely', scGreen,
        'Score 0–2 — familial hypercholesterolaemia unlikely. Address secondary causes and lifestyle.'),
    ScoreBand(3, 'Possible FH', scAmber,
        'Score 3–5 — possible FH. Confirm with repeat fasting lipids, family cascade screening.'),
    ScoreBand(6, 'Probable FH', scOrange,
        'Score 6–8 — probable FH. Start lifestyle measures, consider statin therapy from age 8–10 years, and cascade-screen relatives.'),
    ScoreBand(9, 'Definite FH', scRed,
        'Score >8 — definite FH. Statin therapy and specialist lipid referral; cascade screening of all first-degree relatives is essential.'),
  ],
  notes: const [
    'Only the single highest-scoring option per group is counted. Premature = <55 y in men, <60 y in women.',
    'Source: World Health Organization. Familial hypercholesterolaemia: report of a WHO consultation. Geneva 1998 (Dutch Lipid Clinic Network criteria).',
  ],
);

// ── Renal ────────────────────────────────────────────────────────────────────

final prifleScore = ScoreDef(
  title: 'pRIFLE — Paediatric Acute Kidney Injury',
  subtitle:
      'Paediatric-modified RIFLE criteria, staged on estimated creatinine clearance and urine output.',
  system: 'Renal',
  accent: _renal,
  questions: const [
    ScoreQ('Change in estimated creatinine clearance (eCCl)', [
      ScoreChoice('No significant decrease', 0),
      ScoreChoice('Decreased by 25 %  (Risk)', 1),
      ScoreChoice('Decreased by 50 %  (Injury)', 2),
      ScoreChoice('Decreased by 75 % or eCCl < 35 mL/min/1.73 m²  (Failure)', 3),
    ]),
    ScoreQ('Urine output', [
      ScoreChoice('Normal (> 1 mL/kg/h)', 0),
      ScoreChoice('< 0.5 mL/kg/h for 8 hours  (Risk)', 1),
      ScoreChoice('< 0.5 mL/kg/h for 16 hours  (Injury)', 2),
      ScoreChoice('< 0.3 mL/kg/h for 24 h, or anuric for 12 h  (Failure)', 3),
    ]),
    ScoreQ('Duration of failure (if applicable)', [
      ScoreChoice('Not applicable', 0),
      ScoreChoice('Persistent failure > 4 weeks  (Loss)', 4),
      ScoreChoice('End-stage renal disease > 3 months  (End-stage)', 5),
    ]),
  ],
  bands: [
    ScoreBand(0, 'No AKI', scGreen,
        'Neither creatinine-clearance nor urine-output criteria met — no AKI by pRIFLE.'),
    ScoreBand(1, 'RISK', scAmber,
        'pRIFLE class R (Risk). Review nephrotoxins, optimise perfusion and fluid balance, monitor creatinine and urine output closely.'),
    ScoreBand(2, 'INJURY', scOrange,
        'pRIFLE class I (Injury). Stop nephrotoxic drugs, adjust drug dosing for renal function, and involve nephrology.'),
    ScoreBand(3, 'FAILURE', scRed,
        'pRIFLE class F (Failure). Urgent nephrology input; assess need for renal replacement therapy.'),
    ScoreBand(4, 'LOSS', scRed,
        'Class L (Loss) — persistent failure beyond 4 weeks. Ongoing renal replacement and long-term nephrology follow-up.'),
    ScoreBand(5, 'END-STAGE', scRed,
        'Class E (End-stage) — ESRD beyond 3 months. Long-term dialysis or transplant planning.'),
  ],
  notes: const [
    'Class is assigned by the WORSE of the two criteria (creatinine clearance or urine output).',
    'Source: Akcan-Arikan A et al. Modified RIFLE criteria in critically ill children with acute kidney injury. Kidney Int 2007;71:1028–35.',
  ],
);

// ── Radiology / decision rules ───────────────────────────────────────────────

final nexus2Score = ScoreDef(
  title: 'NEXUS II — Paediatric Head CT Rule',
  subtitle:
      'Identifies low-risk blunt head trauma where CT can be avoided. Any positive predictor = not low risk.',
  system: 'Radiology',
  accent: _rad,
  totalLabel: 'predictors',
  questions: [
    ScoreQ.yesNo('Evidence of significant skull fracture'),
    ScoreQ.yesNo('Altered level of alertness'),
    ScoreQ.yesNo('Neurological deficit'),
    ScoreQ.yesNo('Persistent vomiting'),
    ScoreQ.yesNo('Presence of scalp haematoma'),
    ScoreQ.yesNo('Abnormal behaviour'),
    ScoreQ.yesNo('Coagulopathy'),
  ],
  bands: [
    ScoreBand(0, 'Low risk — CT may be avoided', scGreen,
        'No predictors — very low risk of clinically important intracranial injury (sensitivity ~98–100%). CT can reasonably be withheld with observation.'),
    ScoreBand(1, 'Not low risk', scOrange,
        'One or more predictors — NOT low risk. CT head is indicated, or observation with a low threshold to image.'),
  ],
  notes: const [
    'Source: Oman JA et al. Performance of a decision rule to predict need for computed tomography among children with blunt head trauma (NEXUS II). Pediatrics 2006;117:e238–46.',
  ],
);

// ── Polysomnography ──────────────────────────────────────────────────────────

final ahiScore = ScoreDef(
  title: 'Apnoea–Hypopnoea Index (Paediatric OSA)',
  subtitle:
      'Severity of obstructive sleep apnoea in children — events per hour of sleep.',
  system: 'Sleep',
  accent: _sleep,
  totalLabel: 'severity band',
  questions: const [
    ScoreQ('AHI — obstructive apnoeas + hypopnoeas per hour of sleep', [
      ScoreChoice('< 1 /hour — normal', 0),
      ScoreChoice('1–4.9 /hour — mild', 1),
      ScoreChoice('5–9.9 /hour — moderate', 2),
      ScoreChoice('≥ 10 /hour — severe', 3),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Normal', scGreen,
        'AHI <1/hour is normal in children — note that the paediatric threshold is far lower than the adult cut-off of 5.'),
    ScoreBand(1, 'Mild OSA', scAmber,
        'AHI 1–4.9 — mild paediatric OSA. Consider adenotonsillectomy if adenotonsillar hypertrophy is present, or intranasal steroids/montelukast; reassess.'),
    ScoreBand(2, 'Moderate OSA', scOrange,
        'AHI 5–9.9 — moderate OSA. Adenotonsillectomy is usually first-line; arrange post-operative reassessment.'),
    ScoreBand(3, 'Severe OSA', scRed,
        'AHI ≥10 — severe OSA. High peri-operative risk: plan inpatient post-operative monitoring; consider CPAP if surgery is unsuitable or residual disease persists.'),
  ],
  notes: const [
    'Paediatric criteria differ from adults: an obstructive AHI ≥1/hour is already abnormal in a child.',
    'Source: Marcus CL et al. Diagnosis and management of childhood obstructive sleep apnea syndrome. AAP Clinical Practice Guideline. Pediatrics 2012;130:e714–55.',
  ],
);

// ── Remaining GI ─────────────────────────────────────────────────────────────

final glasgowBlatchfordScore = ScoreDef(
  title: 'Glasgow-Blatchford Score (Upper GI Bleed)',
  subtitle:
      'Predicts need for intervention (transfusion, endoscopy, surgery) in upper GI bleeding.',
  system: 'GI & Liver',
  accent: _gi,
  questions: const [
    ScoreQ('Blood urea', [
      ScoreChoice('< 18.2 mg/dL', 0),
      ScoreChoice('18.2–22.3 mg/dL', 2),
      ScoreChoice('22.4–27.9 mg/dL', 3),
      ScoreChoice('28.0–69.9 mg/dL', 4),
      ScoreChoice('≥ 70 mg/dL', 6),
    ]),
    ScoreQ('Haemoglobin', [
      ScoreChoice('Normal for age/sex', 0),
      ScoreChoice('Mildly reduced', 1),
      ScoreChoice('Moderately reduced', 3),
      ScoreChoice('Severely reduced (< 10 g/dL)', 6),
    ]),
    ScoreQ('Systolic blood pressure', [
      ScoreChoice('Normal for age', 0),
      ScoreChoice('Mild hypotension for age', 1),
      ScoreChoice('Moderate hypotension for age', 2),
      ScoreChoice('Severe hypotension / shock', 3),
    ]),
    ScoreQ('Pulse ≥ 100/min (or tachycardia for age)', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 1),
    ]),
    ScoreQ('Melaena', [ScoreChoice('No', 0), ScoreChoice('Yes', 1)]),
    ScoreQ('Syncope', [ScoreChoice('No', 0), ScoreChoice('Yes', 2)]),
    ScoreQ('Hepatic disease', [ScoreChoice('No', 0), ScoreChoice('Yes', 2)]),
    ScoreQ('Cardiac failure', [ScoreChoice('No', 0), ScoreChoice('Yes', 2)]),
  ],
  bands: [
    ScoreBand(0, 'Very low risk', scGreen,
        'Score 0 — very low risk. Outpatient management with early endoscopy may be appropriate in adults; in children, admit if there is any diagnostic doubt.'),
    ScoreBand(1, 'Intermediate risk', scAmber,
        'Score 1–5 — intermediate risk. Admit for observation and plan endoscopy.'),
    ScoreBand(6, 'High risk', scRed,
        'Score ≥6 — high risk of needing intervention. Resuscitate, cross-match, start acid suppression and arrange urgent endoscopy.'),
  ],
  notes: const [
    'Originally derived and validated in adults; paediatric thresholds for haemoglobin and blood pressure must be age-adjusted.',
    'Source: Blatchford O, Murray WR, Blatchford M. A risk score to predict need for treatment for upper-gastrointestinal haemorrhage. Lancet 2000;356:1318–21.',
  ],
);

final romeFunctionalDyspepsiaScore = ScoreDef(
  title: 'Rome IV — Functional Dyspepsia',
  subtitle:
      'Children/adolescents: ≥1 symptom for ≥2 months, at least 4 days per month.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Postprandial fullness'),
    ScoreQ.yesNo('Early satiation'),
    ScoreQ.yesNo('Epigastric pain or burning not associated with defaecation'),
    ScoreQ.yesNo('Symptoms cannot be fully explained by another medical condition after appropriate evaluation'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'At least one symptom plus exclusion of other conditions is required.'),
    ScoreBand(2, 'Criteria met', scOrange,
        'Rome IV functional dyspepsia. Subtypes: postprandial distress syndrome (fullness/early satiety) and epigastric pain syndrome. Consider H. pylori testing where prevalence is high.'),
  ],
  notes: const [
    'Source: Hyams JS et al. Rome IV — Functional disorders: children and adolescents. Gastroenterology 2016;150:1456–68.',
  ],
);

final romeRuminationScore = ScoreDef(
  title: 'Rome IV — Rumination Syndrome',
  subtitle: 'Repeated regurgitation of recently ingested food, for ≥2 months.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Repeated regurgitation and re-chewing or expulsion of food that begins soon after ingestion'),
    ScoreQ.yesNo('Does NOT occur during sleep'),
    ScoreQ.yesNo('Not preceded by retching'),
    ScoreQ.yesNo('Not fully explained by another condition; an eating disorder has been excluded'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'All four criteria must be present for ≥2 months.'),
    ScoreBand(4, 'Criteria met', scOrange,
        'Rome IV rumination syndrome. First-line treatment is diaphragmatic breathing training; behavioural therapy is effective.'),
  ],
  notes: const [
    'Source: Hyams JS et al. Rome IV — Functional disorders: children and adolescents. Gastroenterology 2016;150:1456–68.',
  ],
);

final romeNonRetentiveScore = ScoreDef(
  title: 'Rome IV — Non-Retentive Faecal Incontinence',
  subtitle: 'Children with a developmental age ≥ 4 years; ≥1 month duration.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Defaecation into places inappropriate to the sociocultural context'),
    ScoreQ.yesNo('No evidence of faecal retention'),
    ScoreQ.yesNo('Not explained by another medical condition after appropriate evaluation'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'All three criteria are required. If there IS faecal retention, this is retentive incontinence (functional constipation) instead.'),
    ScoreBand(3, 'Criteria met', scOrange,
        'Rome IV non-retentive faecal incontinence. Manage with toilet-training programmes and behavioural support; laxatives are NOT indicated and may worsen soiling.'),
  ],
  notes: const [
    'Distinguishing this from constipation-associated soiling is essential — the treatments differ completely.',
    'Source: Hyams JS et al. Rome IV — Functional disorders: children and adolescents. Gastroenterology 2016;150:1456–68.',
  ],
);

final romeAerophagiaScore = ScoreDef(
  title: 'Rome IV — Aerophagia',
  subtitle: 'Excessive air swallowing causing abdominal distension; ≥2 months.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Excessive air swallowing'),
    ScoreQ.yesNo('Abdominal distension due to intraluminal air which increases during the day'),
    ScoreQ.yesNo('Repetitive belching and/or increased flatus'),
    ScoreQ.yesNo('Not fully explained by another medical condition'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'At least two of the first three features plus exclusion of other conditions are required.'),
    ScoreBand(3, 'Criteria met', scOrange,
        'Rome IV aerophagia. Common in children with neurodevelopmental disability; address behavioural triggers and consider speech/feeding therapy.'),
  ],
  notes: const [
    'Source: Hyams JS et al. Rome IV — Functional disorders: children and adolescents. Gastroenterology 2016;150:1456–68.',
  ],
);

final romeNauseaVomitingScore = ScoreDef(
  title: 'Rome IV — Functional Nausea / Functional Vomiting',
  subtitle: 'Children and adolescents; symptoms for ≥2 months.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Bothersome nausea as the predominant symptom, occurring at least twice weekly'),
    ScoreQ.yesNo('Generally not related to meals'),
    ScoreQ.yesNo('OR: vomiting on average once or more per week'),
    ScoreQ.yesNo('Absence of self-induced vomiting, eating disorder or rumination'),
    ScoreQ.yesNo('Not fully explained by another medical condition after appropriate evaluation'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Functional nausea requires bothersome nausea ≥2×/week; functional vomiting requires vomiting ≥1×/week — both with other causes excluded.'),
    ScoreBand(3, 'Criteria met', scOrange,
        'Meets Rome IV functional nausea and/or functional vomiting. Address contributors (anxiety, sleep, school avoidance) alongside symptom management.'),
  ],
  notes: const [
    'Source: Hyams JS et al. Rome IV — Functional disorders: children and adolescents. Gastroenterology 2016;150:1456–68.',
  ],
);

final romeFunctionalAbdominalPainScore = ScoreDef(
  title: 'Rome IV — Functional Abdominal Pain (NOS)',
  subtitle:
      'Children/adolescents: symptoms at least 4 times per month for ≥2 months.',
  system: 'GI & Liver',
  accent: _gi,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Episodic or continuous abdominal pain that does not occur solely during physiological events (eating, menses)'),
    ScoreQ.yesNo('Insufficient criteria for IBS, functional dyspepsia or abdominal migraine'),
    ScoreQ.yesNo('Not fully explained by another medical condition after appropriate evaluation'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'All three criteria are required. If IBS, dyspepsia or abdominal-migraine criteria are met, use that diagnosis instead.'),
    ScoreBand(3, 'Criteria met', scOrange,
        'Rome IV functional abdominal pain — not otherwise specified. Positive diagnosis; explain the gut–brain mechanism, avoid repeated investigation, and consider CBT/hypnotherapy.'),
  ],
  notes: const [
    'Red flags requiring investigation: weight loss, GI bleeding, persistent vomiting, nocturnal pain waking the child, fever, arthritis, family history of IBD.',
    'Source: Hyams JS et al. Rome IV — Functional disorders: children and adolescents. Gastroenterology 2016;150:1456–68.',
  ],
);

final nafldActivityScore = ScoreDef(
  title: 'NAFLD Activity Score (NAS)',
  subtitle:
      'Histological activity in non-alcoholic fatty liver disease (NASH CRN system).',
  system: 'GI & Liver',
  accent: _gi,
  questions: const [
    ScoreQ('Steatosis (% of hepatocytes involved)', [
      ScoreChoice('< 5 %', 0),
      ScoreChoice('5–33 %', 1),
      ScoreChoice('34–66 %', 2),
      ScoreChoice('> 66 %', 3),
    ]),
    ScoreQ('Lobular inflammation (foci per 200× field)', [
      ScoreChoice('No foci', 0),
      ScoreChoice('< 2 foci', 1),
      ScoreChoice('2–4 foci', 2),
      ScoreChoice('> 4 foci', 3),
    ]),
    ScoreQ('Hepatocyte ballooning', [
      ScoreChoice('None', 0),
      ScoreChoice('Few balloon cells', 1),
      ScoreChoice('Many cells / prominent ballooning', 2),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Not diagnostic of NASH', scGreen,
        'NAS 0–2 — largely not diagnostic of steatohepatitis.'),
    ScoreBand(3, 'Borderline', scAmber,
        'NAS 3–4 — borderline; correlate with the overall histological pattern rather than the score alone.'),
    ScoreBand(5, 'Consistent with NASH', scRed,
        'NAS ≥5 — mostly diagnosed as steatohepatitis. Fibrosis is staged SEPARATELY (F0–F4) and is the strongest predictor of long-term outcome.'),
  ],
  notes: const [
    'Total range 0–8. NAS was designed to measure disease ACTIVITY for trials, not to replace a diagnostic pathology assessment. Paediatric NAFLD often shows a portal (type 2) pattern.',
    'Source: Kleiner DE et al. Design and validation of a histological scoring system for nonalcoholic fatty liver disease. Hepatology 2005;41:1313–21.',
  ],
);

final List<ScoreDef> painScores = [flaccScore, cheopsScore];
final List<ScoreDef> haematologyScores = [sickleSevereRiskScore];
final List<ScoreDef> endocrineScores = [dutchFhScore];
final List<ScoreDef> renalScores = [prifleScore];
final List<ScoreDef> radiologyScores = [nexus2Score];
final List<ScoreDef> sleepScores = [ahiScore];
final List<ScoreDef> giLiverScores2 = [
  glasgowBlatchfordScore,
  romeFunctionalDyspepsiaScore,
  romeFunctionalAbdominalPainScore,
  romeRuminationScore,
  romeNonRetentiveScore,
  romeAerophagiaScore,
  romeNauseaVomitingScore,
  nafldActivityScore,
];
