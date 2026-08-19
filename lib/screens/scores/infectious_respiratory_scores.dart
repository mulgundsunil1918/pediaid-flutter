// =============================================================================
// scores/infectious_respiratory_scores.dart
//
// Infectious-disease and respiratory scores. Each carries its primary source
// citation in `notes` — original paper or society guideline.
// =============================================================================

import 'package:flutter/material.dart';
import 'score_scaffold.dart';

const _inf = Color(0xFF00695C);
const _resp = Color(0xFF0277BD);

// ── Infectious ───────────────────────────────────────────────────────────────

final kawasakiScore = ScoreDef(
  title: 'Kawasaki Disease Criteria',
  subtitle:
      'Classic KD = fever ≥5 days PLUS ≥4 of the 5 principal clinical features.',
  system: 'Infectious',
  accent: _inf,
  totalLabel: 'principal features',
  questions: [
    ScoreQ.yesNo('Fever persisting ≥5 days'),
    ScoreQ.yesNo('Bilateral bulbar conjunctival injection, without exudate'),
    ScoreQ.yesNo('Oral changes — cracked red lips, strawberry tongue, mucosal erythema'),
    ScoreQ.yesNo('Polymorphous rash (maculopapular, diffuse erythroderma or EM-like)'),
    ScoreQ.yesNo('Extremity changes — palmar/plantar erythema, oedema, or later periungual peeling'),
    ScoreQ.yesNo('Cervical lymphadenopathy ≥1.5 cm, usually unilateral'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Does not meet classic KD criteria. If fever ≥5 days persists with 2–3 features, consider INCOMPLETE Kawasaki — check CRP/ESR and echocardiography per the AHA algorithm.'),
    ScoreBand(5, 'Classic KD likely', scRed,
        'Fever ≥5 days plus ≥4 principal features = classic Kawasaki disease. Start IVIG 2 g/kg + aspirin and arrange echocardiography urgently — treatment within 10 days of fever onset reduces coronary aneurysm risk.'),
  ],
  notes: const [
    'Count fever as one item here: classic KD needs fever ≥5 days PLUS ≥4 of the other 5 features (total 5 on this screen).',
    'Incomplete KD: fever ≥5 days with only 2–3 features — supported by CRP ≥3 mg/dL or ESR ≥40, plus supplementary labs and echo.',
    'Source: McCrindle BW et al. Diagnosis, Treatment, and Long-Term Management of Kawasaki Disease. AHA Scientific Statement. Circulation 2017;135:e927–e999.',
  ],
);

final westleyCroupScore = ScoreDef(
  title: 'Westley Croup Score',
  subtitle: 'Severity of croup (laryngotracheobronchitis).',
  system: 'Infectious',
  accent: _inf,
  questions: const [
    ScoreQ('Level of consciousness', [
      ScoreChoice('Normal (including asleep)', 0),
      ScoreChoice('Disoriented', 5),
    ]),
    ScoreQ('Cyanosis', [
      ScoreChoice('None', 0),
      ScoreChoice('With agitation', 4),
      ScoreChoice('At rest', 5),
    ]),
    ScoreQ('Stridor', [
      ScoreChoice('None', 0),
      ScoreChoice('With agitation', 1),
      ScoreChoice('At rest', 2),
    ]),
    ScoreQ('Air entry', [
      ScoreChoice('Normal', 0),
      ScoreChoice('Decreased', 1),
      ScoreChoice('Markedly decreased', 2),
    ]),
    ScoreQ('Retractions', [
      ScoreChoice('None', 0),
      ScoreChoice('Mild', 1),
      ScoreChoice('Moderate', 2),
      ScoreChoice('Severe', 3),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Mild', scGreen,
        'Score ≤2 — mild croup. Single dose dexamethasone 0.15–0.6 mg/kg PO; usually suitable for discharge with safety-netting.'),
    ScoreBand(3, 'Moderate', scAmber,
        'Score 3–5 — moderate croup. Dexamethasone and observe; consider nebulised adrenaline if stridor at rest persists.'),
    ScoreBand(6, 'Severe', scOrange,
        'Score 6–11 — severe croup. Nebulised adrenaline + dexamethasone, close monitoring, prepare for escalation.'),
    ScoreBand(12, 'Impending respiratory failure', scRed,
        'Score ≥12 — impending respiratory failure. Urgent senior/anaesthetic help, adrenaline, oxygen, prepare for airway support.'),
  ],
  notes: const [
    'Total range 0–17.',
    'Source: Westley CR, Cotton EK, Brooks JG. Nebulized racemic epinephrine by IPPB for the treatment of croup. Am J Dis Child 1978;132:484–7.',
  ],
);

final kocherScore = ScoreDef(
  title: 'Kocher Criteria (Septic Arthritis)',
  subtitle:
      'Differentiates septic arthritis of the hip from transient synovitis in a limping child.',
  system: 'Infectious',
  accent: _inf,
  totalLabel: 'predictors',
  questions: [
    ScoreQ.yesNo('Non-weight-bearing on the affected side'),
    ScoreQ.yesNo('Temperature > 38.5 °C'),
    ScoreQ.yesNo('ESR > 40 mm/hr'),
    ScoreQ.yesNo('Serum WBC > 12 000 /µL'),
  ],
  bands: [
    ScoreBand(0, '< 0.2 % probability', scGreen,
        '0 predictors — septic arthritis very unlikely (<0.2%). Transient synovitis more likely; reassess if the child deteriorates.'),
    ScoreBand(1, '≈ 3 % probability', scAmber,
        '1 predictor — roughly 3% probability. Observe closely; consider ultrasound and repeat examination.'),
    ScoreBand(2, '≈ 40 % probability', scOrange,
        '2 predictors — roughly 40% probability. Strongly consider joint aspiration and orthopaedic referral.'),
    ScoreBand(3, '≈ 93 % probability', scRed,
        '3 predictors — roughly 93% probability. Urgent orthopaedic referral and joint aspiration.'),
    ScoreBand(4, '≈ 99 % probability', scRed,
        'All 4 predictors — approximately 99% probability of septic arthritis. Emergency orthopaedic referral for aspiration/washout.'),
  ],
  notes: const [
    'Derived for the paediatric hip; CRP >20 mg/L is a further independent predictor in later validation studies.',
    'Source: Kocher MS, Zurakowski D, Kasser JR. Differentiating between septic arthritis and transient synovitis of the hip in children. J Bone Joint Surg Am 1999;81:1662–70.',
  ],
);

final centorScore = ScoreDef(
  title: 'Centor Score (McIsaac modified)',
  subtitle: 'Likelihood of group A streptococcal pharyngitis.',
  system: 'Infectious',
  accent: _inf,
  questions: const [
    ScoreQ('Tonsillar exudate or swelling', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 1),
    ]),
    ScoreQ('Tender / swollen anterior cervical nodes', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 1),
    ]),
    ScoreQ('History of fever > 38 °C', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 1),
    ]),
    ScoreQ('Cough', [
      ScoreChoice('Cough present', 0),
      ScoreChoice('Absent (no cough)', 1),
    ]),
    ScoreQ('Age', [
      ScoreChoice('3–14 years', 1),
      ScoreChoice('15–44 years', 0),
      ScoreChoice('≥ 45 years', 0),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Low risk', scGreen,
        'Score ≤1 — roughly 1–10% risk of strep. No testing or antibiotics required.'),
    ScoreBand(2, 'Intermediate', scAmber,
        'Score 2–3 — roughly 11–35% risk. Perform rapid antigen test or throat culture and treat if positive.'),
    ScoreBand(4, 'High risk', scOrange,
        'Score ≥4 — roughly 50% risk. Test and treat if positive; empirical antibiotics considered in some settings.'),
  ],
  notes: const [
    'The McIsaac modification adds the age adjustment (−1 point for age ≥45, not scored negatively here).',
    'Source: McIsaac WJ et al. The validity of a sore throat score in family practice. CMAJ 2000;163:811–5.',
  ],
);

final feverPainScore = ScoreDef(
  title: 'FeverPAIN Score',
  subtitle: 'Streptococcal pharyngitis likelihood — used in NICE sore-throat guidance.',
  system: 'Infectious',
  accent: _inf,
  questions: [
    ScoreQ.yesNo('Fever in the past 24 hours'),
    ScoreQ.yesNo('Purulence (pus on tonsils)'),
    ScoreQ.yesNo('Attended rapidly — symptoms ≤3 days before presentation'),
    ScoreQ.yesNo('Severely Inflamed tonsils'),
    ScoreQ.yesNo('No cough or coryza'),
  ],
  bands: [
    ScoreBand(0, 'Low (13–18 %)', scGreen,
        'Score 0–1 — 13–18% streptococcal likelihood. Antibiotics not indicated; give self-care advice.'),
    ScoreBand(2, 'Intermediate (34–40 %)', scAmber,
        'Score 2–3 — 34–40% likelihood. Consider a delayed ("back-up") antibiotic prescription.'),
    ScoreBand(4, 'High (62–65 %)', scOrange,
        'Score 4–5 — 62–65% likelihood. Consider immediate antibiotics if severely unwell.'),
  ],
  notes: const [
    'Source: Little P et al. PRISM study — clinical score and rapid antigen detection test to guide antibiotic use for sore throats. BMJ 2013;347:f5806. Adopted in NICE NG84.',
  ],
);

final rochesterScore = ScoreDef(
  title: 'Rochester Criteria (Febrile Infant)',
  subtitle:
      'Identifies febrile infants ≤60 days at LOW risk of serious bacterial infection. All criteria must be met.',
  system: 'Infectious',
  accent: _inf,
  totalLabel: 'low-risk criteria met',
  questions: [
    ScoreQ.yesNo('Infant appears generally well'),
    ScoreQ.yesNo('Previously healthy — term (≥37 wk), no perinatal antibiotics, no underlying disease, not hospitalised longer than mother'),
    ScoreQ.yesNo('No skin, soft-tissue, bone, joint or ear infection on examination'),
    ScoreQ.yesNo('WBC 5 000–15 000 /µL'),
    ScoreQ.yesNo('Absolute band count ≤ 1 500 /µL'),
    ScoreQ.yesNo('Urine ≤ 10 WBC per high-power field'),
    ScoreQ.yesNo('Stool ≤ 5 WBC per high-power field (only if diarrhoea)'),
  ],
  bands: [
    ScoreBand(0, 'NOT low risk', scRed,
        'One or more low-risk criteria are not met — this infant is NOT low risk. Full sepsis evaluation, empirical antibiotics and admission per local protocol.'),
    ScoreBand(7, 'Low risk', scGreen,
        'All criteria met — low risk of serious bacterial infection (negative predictive value ≈98.9%). Some protocols permit observation without empirical antibiotics; always follow local guidance and ensure reliable follow-up.'),
  ],
  notes: const [
    'ALL criteria must be satisfied to call an infant low risk — a partial count is not meaningful.',
    'Source: Jaskiewicz JA et al. Febrile infants at low risk for serious bacterial infection. Pediatrics 1994;94:390–6.',
  ],
);

final stepByStepScore = ScoreDef(
  title: 'Step-by-Step (Febrile Infant ≤90 days)',
  subtitle:
      'Sequential European approach to the well-appearing febrile young infant. Work down in order — the first positive step decides risk.',
  system: 'Infectious',
  accent: _inf,
  totalLabel: 'risk flags',
  questions: [
    ScoreQ.yesNo('Step 1 — Ill appearing', pts: 8),
    ScoreQ.yesNo('Step 2 — Age ≤ 21 days', pts: 4),
    ScoreQ.yesNo('Step 3 — Leukocyturia (positive urine dipstick/microscopy)', pts: 2),
    ScoreQ.yesNo('Step 4 — Procalcitonin ≥ 0.5 ng/mL', pts: 2),
    ScoreQ.yesNo('Step 5 — CRP > 20 mg/L or ANC > 10 000 /µL', pts: 1),
  ],
  bands: [
    ScoreBand(0, 'Low risk', scGreen,
        'No flags — low risk of invasive bacterial infection (NPV ≈99.3%). Well infants >21 days with normal biomarkers may be managed without empirical antibiotics with close follow-up, per local policy.'),
    ScoreBand(1, 'Intermediate risk', scAmber,
        'CRP >20 mg/L or ANC >10 000 only — intermediate risk. Observation ± admission; consider lumbar puncture and antibiotics per local protocol.'),
    ScoreBand(2, 'High risk', scOrange,
        'Leukocyturia or procalcitonin ≥0.5 — high risk. Full septic work-up including urine culture, blood culture ± LP, and empirical antibiotics.'),
    ScoreBand(4, 'High risk — young age', scRed,
        'Age ≤21 days — treat as high risk regardless of biomarkers: full sepsis work-up including lumbar puncture, admit and start empirical antibiotics.'),
    ScoreBand(8, 'High risk — ill appearing', scRed,
        'Ill-appearing infant — highest risk. Immediate full sepsis evaluation, empirical antibiotics and admission.'),
  ],
  notes: const [
    'Steps are hierarchical: assess in order and stop at the first positive step.',
    'Source: Gomez B et al. Validation of the "Step-by-Step" approach in the management of young febrile infants. Pediatrics 2016;138:e20154381.',
  ],
);

final lymeRuleOf7sScore = ScoreDef(
  title: 'Rule of 7s (Lyme Meningitis)',
  subtitle:
      'Distinguishes Lyme meningitis from aseptic meningitis in endemic areas. Low risk only if ALL three are absent.',
  system: 'Infectious',
  accent: _inf,
  totalLabel: 'risk factors',
  questions: [
    ScoreQ.yesNo('Headache for ≥ 7 days'),
    ScoreQ.yesNo('CSF mononuclear cells ≥ 70 %'),
    ScoreQ.yesNo('Seventh (or other) cranial-nerve palsy'),
  ],
  bands: [
    ScoreBand(0, 'Low risk', scGreen,
        'None of the three present — low risk for Lyme meningitis (NPV ≈100%). Outpatient management pending serology may be reasonable in endemic areas.'),
    ScoreBand(1, 'Not low risk', scOrange,
        'One or more present — not low risk. Send Lyme serology and manage as possible Lyme meningitis pending results.'),
  ],
  notes: const [
    'Applies to children in Lyme-endemic regions presenting with CSF pleocytosis. Not applicable in non-endemic settings.',
    'Source: Garro AC et al. Prospective validation of a clinical prediction model for Lyme meningitis in children. Pediatrics 2009;123:e829–34.',
  ],
);

final silcScore = ScoreDef(
  title: 'SILC Score (Lyme Carditis)',
  subtitle:
      'Suspicious Index in Lyme Carditis — pre-test probability in a patient with new high-degree AV block.',
  system: 'Infectious',
  accent: _inf,
  questions: const [
    ScoreQ('Constitutional symptoms (fever, malaise, arthralgia, dyspnoea)', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 2),
    ]),
    ScoreQ('Erythema migrans rash', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 4),
    ]),
    ScoreQ('Outdoor activity or residence in an endemic area', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 1),
    ]),
    ScoreQ('Male sex', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 1),
    ]),
    ScoreQ('Age < 50 years', [
      ScoreChoice('No', 0),
      ScoreChoice('Yes', 1),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Low probability', scGreen,
        'Score 0–2 — low probability of Lyme carditis. Investigate other causes of AV block; a permanent pacemaker may be appropriate.'),
    ScoreBand(3, 'Intermediate', scAmber,
        'Score 3–6 — intermediate probability. Send Lyme serology and consider empirical antibiotics before committing to a permanent pacemaker.'),
    ScoreBand(7, 'High probability', scOrange,
        'Score ≥7 — high probability of Lyme carditis. Treat with antibiotics; AV block is usually reversible, so avoid a permanent pacemaker until treated.'),
  ],
  notes: const [
    'Purpose is to avoid unnecessary permanent pacemakers — Lyme-related AV block usually resolves with antibiotic therapy.',
    'Source: Besant G et al. Suspicious index in Lyme carditis: systematic review and proposed new risk score. Clin Cardiol 2018;41:1611–1616.',
  ],
);

// ── Respiratory ──────────────────────────────────────────────────────────────

final pramScore = ScoreDef(
  title: 'PRAM Score',
  subtitle: 'Preschool Respiratory Assessment Measure — asthma exacerbation severity.',
  system: 'Respiratory',
  accent: _resp,
  questions: const [
    ScoreQ('Suprasternal retractions', [
      ScoreChoice('Absent', 0),
      ScoreChoice('Present', 2),
    ]),
    ScoreQ('Scalene muscle contraction', [
      ScoreChoice('Absent', 0),
      ScoreChoice('Present', 2),
    ]),
    ScoreQ('Air entry', [
      ScoreChoice('Normal', 0),
      ScoreChoice('Decreased at the bases', 1),
      ScoreChoice('Decreased at apex and base', 2),
      ScoreChoice('Minimal or absent', 3),
    ]),
    ScoreQ('Wheezing', [
      ScoreChoice('Absent', 0),
      ScoreChoice('Expiratory only', 1),
      ScoreChoice('Inspiratory and expiratory', 2),
      ScoreChoice('Audible without stethoscope, or silent chest', 3),
    ]),
    ScoreQ('Oxygen saturation on room air', [
      ScoreChoice('≥ 95 %', 0),
      ScoreChoice('92–94 %', 1),
      ScoreChoice('< 92 %', 2),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Mild', scGreen,
        'PRAM 0–3 — mild exacerbation. Inhaled short-acting beta-agonist; usually dischargeable after response.'),
    ScoreBand(4, 'Moderate', scAmber,
        'PRAM 4–7 — moderate exacerbation. Frequent bronchodilators plus systemic corticosteroid; observe for response.'),
    ScoreBand(8, 'Severe', scRed,
        'PRAM 8–12 — severe exacerbation. Continuous bronchodilators, systemic steroid, consider magnesium sulphate, oxygen and admission/HDU.'),
  ],
  notes: const [
    'Total range 0–12. Validated for children aged roughly 2–17 years.',
    'Source: Chalut DS, Ducharme FM, Davis GM. The Preschool Respiratory Assessment Measure (PRAM). J Pediatr 2000;137:762–8.',
  ],
);

final passScore = ScoreDef(
  title: 'PASS — Pediatric Asthma Severity Score',
  subtitle: 'Three-item bedside severity score for an asthma exacerbation.',
  system: 'Respiratory',
  accent: _resp,
  questions: const [
    ScoreQ('Wheezing', [
      ScoreChoice('None / mild', 0),
      ScoreChoice('Moderate', 1),
      ScoreChoice('Severe (or silent chest)', 2),
    ]),
    ScoreQ('Work of breathing / retractions', [
      ScoreChoice('None / mild', 0),
      ScoreChoice('Moderate', 1),
      ScoreChoice('Severe', 2),
    ]),
    ScoreQ('Prolonged expiration', [
      ScoreChoice('None / mild', 0),
      ScoreChoice('Moderate', 1),
      ScoreChoice('Severe', 2),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Mild', scGreen,
        'PASS 0–1 — mild exacerbation. Short-acting beta-agonist and reassess.'),
    ScoreBand(2, 'Moderate', scAmber,
        'PASS 2–3 — moderate exacerbation. Bronchodilators plus systemic corticosteroid.'),
    ScoreBand(4, 'Severe', scRed,
        'PASS 4–6 — severe exacerbation. Intensive bronchodilator therapy, steroids, oxygen, consider magnesium and admission.'),
  ],
  notes: const [
    'Total range 0–6.',
    'Source: Gorelick MH et al. Performance of a novel clinical score, the Pediatric Asthma Severity Score (PASS). Acad Emerg Med 2004;11:10–18.',
  ],
);

final apiScore = ScoreDef(
  title: 'Asthma Predictive Index (API)',
  subtitle:
      'Predicts later school-age asthma in a preschool child with recurrent wheeze.',
  system: 'Respiratory',
  accent: _resp,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('≥3 episodes of wheezing per year during the first 3 years (required)', pts: 4),
    ScoreQ.yesNo('MAJOR — parent with physician-diagnosed asthma', pts: 2),
    ScoreQ.yesNo('MAJOR — physician-diagnosed atopic dermatitis in the child', pts: 2),
    ScoreQ.yesNo('MINOR — peripheral blood eosinophilia ≥ 4 %'),
    ScoreQ.yesNo('MINOR — wheezing apart from colds'),
    ScoreQ.yesNo('MINOR — allergic rhinitis diagnosed in the child'),
  ],
  bands: [
    ScoreBand(0, 'Negative', scGreen,
        'Frequent-wheeze criterion plus ≥1 major OR ≥2 minor criteria are needed for a positive index.'),
    ScoreBand(6, 'Positive API', scOrange,
        'Positive stringent API — substantially higher risk of asthma at school age (about 4–10× that of a negative index). Supports closer follow-up and a controller trial when symptoms warrant.'),
  ],
  notes: const [
    'Positive (stringent) API = frequent wheezing PLUS ≥1 major OR ≥2 minor criteria.',
    'A negative API has a strong negative predictive value (~95%) for school-age asthma.',
    'Source: Castro-Rodríguez JA et al. A clinical index to define risk of asthma in young children with recurrent wheezing. Am J Respir Crit Care Med 2000;162:1403–6.',
  ],
);

final mApiScore = ScoreDef(
  title: 'Modified API (mAPI)',
  subtitle: 'Modified Asthma Predictive Index — adds aeroallergen and food sensitisation.',
  system: 'Respiratory',
  accent: _resp,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('≥4 wheezing episodes in the past year, at least one physician-confirmed (required)', pts: 4),
    ScoreQ.yesNo('MAJOR — parental history of asthma', pts: 2),
    ScoreQ.yesNo('MAJOR — physician-diagnosed atopic dermatitis', pts: 2),
    ScoreQ.yesNo('MAJOR — sensitisation to ≥1 aeroallergen', pts: 2),
    ScoreQ.yesNo('MINOR — wheezing apart from colds'),
    ScoreQ.yesNo('MINOR — blood eosinophilia ≥ 4 %'),
    ScoreQ.yesNo('MINOR — sensitisation to milk, egg or peanut'),
  ],
  bands: [
    ScoreBand(0, 'Negative', scGreen,
        'Requires ≥4 wheezing episodes/year PLUS ≥1 major OR ≥2 minor criteria.'),
    ScoreBand(6, 'Positive mAPI', scOrange,
        'Positive mAPI — increased likelihood of persistent asthma. Used as an entry criterion in several paediatric asthma trials.'),
  ],
  notes: const [
    'Source: Guilbert TW et al. Atopic characteristics of children with recurrent wheezing at high risk for the development of childhood asthma. J Allergy Clin Immunol 2004;114:1282–7.',
  ],
);

final pediatricAsthmaScore = ScoreDef(
  title: 'Pediatric Asthma Score (PAS)',
  subtitle: 'Five-domain severity score used to guide asthma pathway treatment.',
  system: 'Respiratory',
  accent: _resp,
  questions: const [
    ScoreQ('Respiratory rate (for age)', [
      ScoreChoice('Normal', 1),
      ScoreChoice('Mildly increased', 2),
      ScoreChoice('Markedly increased', 3),
    ]),
    ScoreQ('Oxygen requirement', [
      ScoreChoice('None, SpO₂ >95 % on air', 1),
      ScoreChoice('SpO₂ 90–95 % on air', 2),
      ScoreChoice('SpO₂ <90 % on air or needs oxygen', 3),
    ]),
    ScoreQ('Auscultation', [
      ScoreChoice('Normal / end-expiratory wheeze', 1),
      ScoreChoice('Expiratory wheeze', 2),
      ScoreChoice('Inspiratory + expiratory wheeze, or diminished breath sounds', 3),
    ]),
    ScoreQ('Retractions', [
      ScoreChoice('None or intercostal', 1),
      ScoreChoice('Intercostal + substernal', 2),
      ScoreChoice('Plus supraclavicular / nasal flaring', 3),
    ]),
    ScoreQ('Dyspnoea (speech)', [
      ScoreChoice('Speaks in sentences / normal feeding', 1),
      ScoreChoice('Partial sentences / short cry', 2),
      ScoreChoice('Single words or short phrases / difficulty feeding', 3),
    ]),
  ],
  bands: [
    ScoreBand(5, 'Mild', scGreen,
        'PAS 5–7 — mild. Short-acting beta-agonist, reassess; usually suitable for discharge with a plan.'),
    ScoreBand(8, 'Moderate', scAmber,
        'PAS 8–11 — moderate. Frequent bronchodilators, systemic corticosteroid, observe.'),
    ScoreBand(12, 'Severe', scRed,
        'PAS 12–15 — severe. Continuous bronchodilators, steroids, oxygen, consider magnesium and critical-care input.'),
  ],
  notes: const [
    'Total range 5–15 (each domain scores 1–3).',
    'Source: Kelly CS et al. / Pediatric asthma severity pathways — as implemented in paediatric asthma clinical pathways (e.g. Cincinnati Children’s).',
  ],
);

final List<ScoreDef> infectiousScores = [
  kawasakiScore,
  westleyCroupScore,
  kocherScore,
  centorScore,
  feverPainScore,
  rochesterScore,
  stepByStepScore,
  lymeRuleOf7sScore,
  silcScore,
];

final List<ScoreDef> respiratoryScores = [
  pramScore,
  passScore,
  pediatricAsthmaScore,
  apiScore,
  mApiScore,
];
