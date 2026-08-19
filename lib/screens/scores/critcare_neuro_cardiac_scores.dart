// =============================================================================
// scores/critcare_neuro_cardiac_scores.dart
//
// Critical-care, neurology/trauma and cardiac scores. Every score carries its
// original source citation.
// =============================================================================

import 'package:flutter/material.dart';
import 'score_scaffold.dart';

const _crit = Color(0xFFC62828);
const _neuro = Color(0xFF283593);
const _cardio = Color(0xFFAD1457);

// ── Critical care ────────────────────────────────────────────────────────────

final pewsScore = ScoreDef(
  title: 'PEWS — Paediatric Early Warning Score',
  subtitle: 'Bedside score to detect clinical deterioration on the ward.',
  system: 'Critical care',
  accent: _crit,
  questions: const [
    ScoreQ('Behaviour', [
      ScoreChoice('Playing / appropriate', 0),
      ScoreChoice('Sleeping', 1),
      ScoreChoice('Irritable', 2),
      ScoreChoice('Lethargic, confused, or reduced response to pain', 3),
    ]),
    ScoreQ('Cardiovascular', [
      ScoreChoice('Pink, or capillary refill 1–2 s', 0),
      ScoreChoice('Pale, or capillary refill 3 s', 1),
      ScoreChoice('Grey, or refill 4 s, or HR 20 above normal', 2),
      ScoreChoice('Grey/mottled, refill ≥5 s, HR 30 above normal, or bradycardia', 3),
    ]),
    ScoreQ('Respiratory', [
      ScoreChoice('Within normal parameters, no recession', 0),
      ScoreChoice('RR >10 above normal, accessory muscles, or FiO₂ ≥30 % / 3 L/min', 1),
      ScoreChoice('RR >20 above normal, recessing, or FiO₂ ≥40 % / 6 L/min', 2),
      ScoreChoice('RR ≥5 below normal with recession/grunting, or FiO₂ ≥50 % / 8 L/min', 3),
    ]),
    ScoreQ('Additional — ¼-hourly nebulisers or persistent post-op vomiting', [
      ScoreChoice('Neither', 0),
      ScoreChoice('Present', 2),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Low concern', scGreen,
        'Score 0–2 — continue routine observations at the usual frequency.'),
    ScoreBand(3, 'Caution', scAmber,
        'Score 3 — increase observation frequency and inform the nurse in charge; review by the treating team.'),
    ScoreBand(4, 'Urgent review', scOrange,
        'Score 4–6 — urgent medical review, increase monitoring, consider escalation to the paediatric team/outreach.'),
    ScoreBand(7, 'Emergency', scRed,
        'Score ≥7 — emergency call, immediate senior review and consider PICU/rapid-response activation.'),
  ],
  notes: const [
    'Total range 0–11 (Brighton PEWS). Escalation thresholds vary between hospitals — follow your local policy.',
    'Source: Monaghan A. Detecting and managing deterioration in children. Paediatr Nurs 2005;17:32–5 (Brighton PEWS).',
  ],
);

final pediatricSirsScore = ScoreDef(
  title: 'Paediatric SIRS / Sepsis Criteria',
  subtitle:
      'International paediatric consensus definitions. SIRS = ≥2 criteria, one of which must be abnormal temperature or leucocyte count.',
  system: 'Critical care',
  accent: _crit,
  totalLabel: 'SIRS criteria',
  questions: [
    ScoreQ.yesNo('Core temperature > 38.5 °C or < 36 °C', pts: 2),
    ScoreQ.yesNo('Leucocyte count elevated or depressed for age, or > 10 % immature neutrophils', pts: 2),
    ScoreQ.yesNo('Tachycardia >2 SD above normal for age (or bradycardia if < 1 year)'),
    ScoreQ.yesNo('Tachypnoea >2 SD above normal for age, or mechanical ventilation for an acute process'),
  ],
  bands: [
    ScoreBand(0, 'SIRS not met', scGreen,
        'Fewer than 2 criteria, or neither temperature nor leucocyte count abnormal — paediatric SIRS criteria not met.'),
    ScoreBand(3, 'SIRS present', scAmber,
        'SIRS criteria met. SEPSIS = SIRS plus suspected or proven infection. SEVERE SEPSIS = sepsis plus cardiovascular dysfunction, ARDS, or ≥2 other organ dysfunctions. SEPTIC SHOCK = sepsis plus cardiovascular dysfunction.'),
    ScoreBand(4, 'SIRS present — multiple criteria', scOrange,
        'Several SIRS criteria met. If infection is suspected, treat as sepsis: cultures, early broad-spectrum antibiotics within 1 hour, fluid resuscitation and lactate.'),
  ],
  notes: const [
    'At least one criterion MUST be abnormal temperature or abnormal leucocyte count — the first two items carry 2 points to encode that requirement.',
    'Age-specific vital-sign thresholds must be used; see the Paediatric Parameters table in Guides.',
    'Source: Goldstein B, Giroir B, Randolph A. International pediatric sepsis consensus conference. Pediatr Crit Care Med 2005;6:2–8.',
  ],
);

// ── Neurology / head trauma ──────────────────────────────────────────────────

final pecarnUnder2Score = ScoreDef(
  title: 'PECARN Head Injury — Age < 2 years',
  subtitle:
      'Identifies children under 2 at very low risk of clinically-important traumatic brain injury (ciTBI).',
  system: 'Neurology & trauma',
  accent: _neuro,
  totalLabel: 'predictors',
  questions: [
    ScoreQ.yesNo('GCS ≤ 14, altered mental status, or palpable skull fracture', pts: 8),
    ScoreQ.yesNo('Occipital, parietal or temporal scalp haematoma'),
    ScoreQ.yesNo('Loss of consciousness ≥ 5 seconds'),
    ScoreQ.yesNo('Severe mechanism of injury'),
    ScoreQ.yesNo('Not acting normally according to the parent'),
  ],
  bands: [
    ScoreBand(0, 'CT not recommended', scGreen,
        'No predictors — risk of ciTBI <0.02%. CT is not recommended; discharge with head-injury advice is appropriate.'),
    ScoreBand(1, 'Observation vs CT', scAmber,
        'Intermediate group — ciTBI risk ≈0.9%. Observation in the emergency department is preferred; CT if multiple findings, worsening symptoms, age <3 months, or parental preference.'),
    ScoreBand(8, 'CT recommended', scRed,
        'GCS ≤14, altered mental status or palpable skull fracture — ciTBI risk ≈4.4%. CT head is recommended.'),
  ],
  notes: const [
    'Severe mechanism: MVC with ejection/rollover/death of another passenger; pedestrian or cyclist without helmet struck by a vehicle; fall >0.9 m (3 ft) under 2 years; head struck by a high-impact object.',
    'Source: Kuppermann N et al. Identification of children at very low risk of clinically-important brain injuries after head trauma: a prospective cohort study (PECARN). Lancet 2009;374:1160–70.',
  ],
);

final pecarnOver2Score = ScoreDef(
  title: 'PECARN Head Injury — Age ≥ 2 years',
  subtitle:
      'Identifies children 2 years and older at very low risk of clinically-important traumatic brain injury.',
  system: 'Neurology & trauma',
  accent: _neuro,
  totalLabel: 'predictors',
  questions: [
    ScoreQ.yesNo('GCS ≤ 14, altered mental status, or signs of basilar skull fracture', pts: 8),
    ScoreQ.yesNo('History of loss of consciousness'),
    ScoreQ.yesNo('History of vomiting'),
    ScoreQ.yesNo('Severe mechanism of injury'),
    ScoreQ.yesNo('Severe headache'),
  ],
  bands: [
    ScoreBand(0, 'CT not recommended', scGreen,
        'No predictors — risk of ciTBI <0.05%. CT is not recommended.'),
    ScoreBand(1, 'Observation vs CT', scAmber,
        'Intermediate group — ciTBI risk ≈0.9%. Observation is preferred over immediate CT; escalate if symptoms progress.'),
    ScoreBand(8, 'CT recommended', scRed,
        'GCS ≤14, altered mental status or basilar skull fracture signs — ciTBI risk ≈4.3%. CT head is recommended.'),
  ],
  notes: const [
    'Severe mechanism: MVC with ejection/rollover/death of another passenger; pedestrian or cyclist without helmet struck by a vehicle; fall >1.5 m (5 ft) at ≥2 years; head struck by a high-impact object.',
    'Source: Kuppermann N et al. PECARN head-injury prediction rules. Lancet 2009;374:1160–70.',
  ],
);

final catchScore = ScoreDef(
  title: 'CATCH Rule (Paediatric Head Injury)',
  subtitle:
      'Canadian Assessment of Tomography for Childhood Head injury — who needs a CT after minor head injury.',
  system: 'Neurology & trauma',
  accent: _neuro,
  totalLabel: 'risk factors',
  questions: [
    ScoreQ.yesNo('HIGH — GCS < 15 at two hours after injury', pts: 4),
    ScoreQ.yesNo('HIGH — Suspected open or depressed skull fracture', pts: 4),
    ScoreQ.yesNo('HIGH — Worsening headache', pts: 4),
    ScoreQ.yesNo('HIGH — Irritability on examination', pts: 4),
    ScoreQ.yesNo('MEDIUM — Any sign of basal skull fracture'),
    ScoreQ.yesNo('MEDIUM — Large, boggy scalp haematoma'),
    ScoreQ.yesNo('MEDIUM — Dangerous mechanism of injury'),
  ],
  bands: [
    ScoreBand(0, 'CT not indicated', scGreen,
        'No high- or medium-risk factors — CT head not indicated by the CATCH rule. Observe and give head-injury advice.'),
    ScoreBand(1, 'Medium risk — consider CT', scAmber,
        'Medium-risk factor present — CT is recommended to detect brain injury on imaging (sensitivity ~98% for the full rule).'),
    ScoreBand(4, 'High risk — CT required', scRed,
        'High-risk factor present — CT head required; predicts need for neurological intervention (sensitivity 100% in the derivation cohort).'),
  ],
  notes: const [
    'Applies to minor head injury: witnessed LOC, amnesia, disorientation, persistent vomiting or persistent irritability, with GCS 13–15.',
    'Dangerous mechanism: MVC, fall from ≥0.9 m (3 ft) or 5 stairs, fall from a bicycle with no helmet.',
    'Source: Osmond MH et al. CATCH: a clinical decision rule for the use of computed tomography in children with minor head injury. CMAJ 2010;182:341–8.',
  ],
);

final palchakScore = ScoreDef(
  title: 'Palchak (UC Davis) Rule',
  subtitle: 'Predicts traumatic brain injury on CT in children with blunt head trauma.',
  system: 'Neurology & trauma',
  accent: _neuro,
  totalLabel: 'predictors',
  questions: [
    ScoreQ.yesNo('Abnormal mental status'),
    ScoreQ.yesNo('Clinical signs of skull fracture'),
    ScoreQ.yesNo('History of vomiting'),
    ScoreQ.yesNo('Scalp haematoma (in children ≤ 2 years)'),
    ScoreQ.yesNo('Headache'),
  ],
  bands: [
    ScoreBand(0, 'Very low risk', scGreen,
        'None of the five predictors — negative predictive value ≈100% for traumatic brain injury on CT. Imaging can reasonably be withheld.'),
    ScoreBand(1, 'Not low risk', scOrange,
        'One or more predictors present — the rule does not exclude TBI; consider CT or observation per clinical judgement and local guidance.'),
  ],
  notes: const [
    'Source: Palchak MJ et al. A decision rule for identifying children at low risk for brain injuries after blunt head trauma. Ann Emerg Med 2003;42:492–506.',
  ],
);

final bacterialMeningitisScore = ScoreDef(
  title: 'Bacterial Meningitis Score',
  subtitle:
      'In a child with CSF pleocytosis, identifies very low risk of BACTERIAL (as opposed to aseptic) meningitis.',
  system: 'Neurology & trauma',
  accent: _neuro,
  totalLabel: 'predictors',
  questions: [
    ScoreQ.yesNo('Positive CSF Gram stain'),
    ScoreQ.yesNo('CSF absolute neutrophil count ≥ 1 000 cells/µL'),
    ScoreQ.yesNo('CSF protein ≥ 80 mg/dL'),
    ScoreQ.yesNo('Peripheral blood absolute neutrophil count ≥ 10 000 cells/µL'),
    ScoreQ.yesNo('Seizure at or before presentation'),
  ],
  bands: [
    ScoreBand(0, 'Very low risk', scGreen,
        'No predictors — very low risk of bacterial meningitis (sensitivity ~99–100%, NPV ~99.9%). Many protocols allow observation off antibiotics with close follow-up.'),
    ScoreBand(1, 'Not low risk', scRed,
        'One or more predictors — NOT low risk. Treat as bacterial meningitis: empirical antibiotics and admission pending cultures.'),
  ],
  notes: const [
    'Applies to children aged 29 days–19 years with CSF pleocytosis who are not critically ill, not pre-treated with antibiotics, without purpura, immunosuppression, VP shunt or recent neurosurgery.',
    'Source: Nigrovic LE et al. Clinical prediction rule for identifying children with CSF pleocytosis at very low risk of bacterial meningitis. JAMA 2007;297:52–60.',
  ],
);

// ── Cardiac ──────────────────────────────────────────────────────────────────

final dukeCriteriaScore = ScoreDef(
  title: 'Modified Duke Criteria (Endocarditis)',
  subtitle: 'Diagnosis of infective endocarditis from major and minor criteria.',
  system: 'Cardiac',
  accent: _cardio,
  totalLabel: 'weighted points',
  questions: [
    ScoreQ.yesNo('MAJOR — Typical organism from 2 separate blood cultures, or persistently positive cultures', pts: 3),
    ScoreQ.yesNo('MAJOR — Evidence of endocardial involvement (vegetation, abscess, new dehiscence, or new valvular regurgitation)', pts: 3),
    ScoreQ.yesNo('MINOR — Predisposing heart condition or injection drug use'),
    ScoreQ.yesNo('MINOR — Fever > 38 °C'),
    ScoreQ.yesNo('MINOR — Vascular phenomena (emboli, septic infarcts, Janeway lesions, mycotic aneurysm)'),
    ScoreQ.yesNo('MINOR — Immunologic phenomena (glomerulonephritis, Osler nodes, Roth spots, rheumatoid factor)'),
    ScoreQ.yesNo('MINOR — Microbiological evidence not meeting a major criterion'),
  ],
  bands: [
    ScoreBand(0, 'Not met', scGreen,
        'Neither possible nor definite endocarditis by the modified Duke criteria — consider alternative diagnoses.'),
    ScoreBand(3, 'Possible IE', scAmber,
        'POSSIBLE infective endocarditis = 1 major + 1 minor, or 3 minor criteria. Continue cultures and repeat echocardiography.'),
    ScoreBand(6, 'Definite IE', scRed,
        'DEFINITE infective endocarditis = 2 major, OR 1 major + 3 minor, OR 5 minor criteria. Start therapy and involve cardiology/ID; consider surgical review.'),
  ],
  notes: const [
    'Weighting here: each major = 3 points, each minor = 1 point, so definite (2 major = 6; 1 major + 3 minor = 6; 5 minor = 5) and possible (1 major + 1 minor = 4; 3 minor = 3) fall into the bands shown. Always confirm against the published criteria.',
    'Source: Li JS et al. Proposed modifications to the Duke criteria for the diagnosis of infective endocarditis. Clin Infect Dis 2000;30:633–8.',
  ],
);

final jonesCriteriaScore = ScoreDef(
  title: 'Jones Criteria (Acute Rheumatic Fever)',
  subtitle:
      'Revised 2015 Jones criteria — MODERATE/HIGH-risk population thresholds (applicable to India).',
  system: 'Cardiac',
  accent: _cardio,
  totalLabel: 'weighted points',
  questions: [
    ScoreQ.yesNo('MAJOR — Carditis (clinical and/or subclinical on echo)', pts: 3),
    ScoreQ.yesNo('MAJOR — Arthritis: mono- or polyarthritis, or polyarthralgia', pts: 3),
    ScoreQ.yesNo('MAJOR — Chorea', pts: 3),
    ScoreQ.yesNo('MAJOR — Erythema marginatum', pts: 3),
    ScoreQ.yesNo('MAJOR — Subcutaneous nodules', pts: 3),
    ScoreQ.yesNo('MINOR — Monoarthralgia'),
    ScoreQ.yesNo('MINOR — Fever ≥ 38 °C'),
    ScoreQ.yesNo('MINOR — ESR ≥ 30 mm/h and/or CRP ≥ 3 mg/dL'),
    ScoreQ.yesNo('MINOR — Prolonged PR interval for age'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Does not meet the revised Jones criteria. Note that ALL diagnoses additionally require evidence of preceding group A streptococcal infection (ASO/anti-DNase B rise, positive throat culture or RADT).'),
    ScoreBand(5, 'Criteria met', scOrange,
        'Meets Jones criteria (2 major, OR 1 major + 2 minor) — with evidence of preceding GAS infection this supports acute rheumatic fever. Start penicillin, anti-inflammatory therapy and echocardiography; plan secondary prophylaxis.'),
    ScoreBand(6, 'Criteria met — multiple major', scRed,
        'Two or more major manifestations — acute rheumatic fever highly likely with evidence of preceding GAS infection. Echocardiography is mandatory; arrange cardiology review and secondary prophylaxis.'),
  ],
  notes: const [
    'India is a MODERATE/HIGH-risk population, so these relaxed thresholds apply: monoarthritis and polyarthralgia count as major; monoarthralgia, fever ≥38 °C and ESR ≥30 count as minor.',
    'Diagnosis requires 2 major, or 1 major + 2 minor, PLUS evidence of preceding group A streptococcal infection.',
    'Source: Gewitz MH et al. Revision of the Jones Criteria for the diagnosis of acute rheumatic fever in the era of Doppler echocardiography. AHA Scientific Statement. Circulation 2015;131:1806–18.',
  ],
);

final List<ScoreDef> criticalCareScores = [pewsScore, pediatricSirsScore];

final List<ScoreDef> neuroTraumaScores = [
  pecarnUnder2Score,
  pecarnOver2Score,
  catchScore,
  palchakScore,
  bacterialMeningitisScore,
];

final List<ScoreDef> cardiacScores = [dukeCriteriaScore, jonesCriteriaScore];
