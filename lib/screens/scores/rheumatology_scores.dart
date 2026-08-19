// =============================================================================
// scores/rheumatology_scores.dart
//
// Paediatric rheumatology classification criteria and activity indices.
// Classification criteria are designed for research cohorts — they support,
// but do not replace, a clinical diagnosis. Citations included.
// =============================================================================

import 'package:flutter/material.dart';
import 'score_scaffold.dart';

const _rheum = Color(0xFF00838F);

final hspScore = ScoreDef(
  title: 'IgA Vasculitis (HSP) Criteria',
  subtitle:
      'EULAR/PRINTO/PRES paediatric criteria — purpura is MANDATORY plus ≥1 of the four other features.',
  system: 'Rheumatology',
  accent: _rheum,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('MANDATORY — Palpable purpura or petechiae with lower-limb predominance, without thrombocytopenia', pts: 4),
    ScoreQ.yesNo('Diffuse abdominal pain of acute onset'),
    ScoreQ.yesNo('Histopathology: leucocytoclastic vasculitis or proliferative glomerulonephritis with predominant IgA deposits'),
    ScoreQ.yesNo('Arthritis or arthralgia of acute onset'),
    ScoreQ.yesNo('Renal involvement — proteinuria and/or haematuria'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Purpura with lower-limb predominance is MANDATORY. Without it the criteria cannot be met — consider other causes of vasculitis or purpura.'),
    ScoreBand(4, 'Purpura only', scAmber,
        'Mandatory purpura present but no additional criterion yet. At least one of abdominal pain, arthritis/arthralgia, renal involvement or typical histology is required.'),
    ScoreBand(5, 'Criteria MET', scOrange,
        'Purpura plus ≥1 additional criterion — classifies as IgA vasculitis (HSP). Monitor blood pressure and urinalysis regularly for at least 6 months to detect nephritis.'),
  ],
  notes: const [
    'Sensitivity 100%, specificity 87% in the validation cohort.',
    'Source: Ozen S et al. EULAR/PRINTO/PRES criteria for Henoch-Schönlein purpura, childhood polyarteritis nodosa, childhood Wegener granulomatosis and childhood Takayasu arteritis: Ankara 2008. Ann Rheum Dis 2010;69:798–806.',
  ],
);

final sledaiScore = ScoreDef(
  title: 'SLEDAI-2K — SLE Disease Activity Index',
  subtitle: 'Disease activity in the preceding 10 days. Weighted descriptors.',
  system: 'Rheumatology',
  accent: _rheum,
  questions: [
    ScoreQ.yesNo('Seizure (recent onset, excluding metabolic/infectious/drug causes)', pts: 8),
    ScoreQ.yesNo('Psychosis', pts: 8),
    ScoreQ.yesNo('Organic brain syndrome', pts: 8),
    ScoreQ.yesNo('Visual disturbance (retinal changes of SLE)', pts: 8),
    ScoreQ.yesNo('Cranial nerve disorder', pts: 8),
    ScoreQ.yesNo('Lupus headache (severe, persistent, narcotic-resistant)', pts: 8),
    ScoreQ.yesNo('Cerebrovascular accident', pts: 8),
    ScoreQ.yesNo('Vasculitis (ulceration, gangrene, nail-fold infarcts, biopsy-proven)', pts: 8),
    ScoreQ.yesNo('Arthritis (≥2 joints with pain and inflammatory signs)', pts: 4),
    ScoreQ.yesNo('Myositis (proximal weakness with raised CK/aldolase or typical EMG/biopsy)', pts: 4),
    ScoreQ.yesNo('Urinary casts (heme-granular or red cell casts)', pts: 4),
    ScoreQ.yesNo('Haematuria (> 5 RBC/hpf)', pts: 4),
    ScoreQ.yesNo('Proteinuria (> 0.5 g/24 h)', pts: 4),
    ScoreQ.yesNo('Pyuria (> 5 WBC/hpf, infection excluded)', pts: 4),
    ScoreQ.yesNo('New rash (inflammatory lupus rash)', pts: 2),
    ScoreQ.yesNo('Alopecia (abnormal patchy or diffuse hair loss)', pts: 2),
    ScoreQ.yesNo('Mucosal ulcers (oral or nasal)', pts: 2),
    ScoreQ.yesNo('Pleurisy (pleuritic chest pain with rub/effusion/thickening)', pts: 2),
    ScoreQ.yesNo('Pericarditis (pain with rub/effusion or ECG/echo confirmation)', pts: 2),
    ScoreQ.yesNo('Low complement (decreased CH50, C3 or C4)', pts: 2),
    ScoreQ.yesNo('Increased anti-dsDNA binding', pts: 2),
    ScoreQ.yesNo('Fever > 38 °C (infection excluded)'),
    ScoreQ.yesNo('Thrombocytopenia < 100 000 /µL'),
    ScoreQ.yesNo('Leucopenia < 3 000 /µL (not drug-related)'),
  ],
  bands: [
    ScoreBand(0, 'No activity', scGreen,
        'SLEDAI 0 — no disease activity in the last 10 days.'),
    ScoreBand(1, 'Mild activity', scAmber,
        'SLEDAI 1–5 — mild activity. Usually managed with hydroxychloroquine ± low-dose steroid.'),
    ScoreBand(6, 'Moderate activity', scOrange,
        'SLEDAI 6–10 — moderate activity. Escalate immunosuppression; a change of ≥4 points indicates a clinically meaningful flare.'),
    ScoreBand(11, 'High activity', scRed,
        'SLEDAI 11–19 — high activity. Intensive immunosuppression required.'),
    ScoreBand(20, 'Very high activity', scRed,
        'SLEDAI ≥20 — very high activity, often with major organ involvement. Urgent intensive therapy and specialist input.'),
  ],
  notes: const [
    'Total possible 105. SLEDAI-2K differs from the original by allowing persistent (not only new) rash, alopecia, mucosal ulcers and proteinuria to score.',
    'Source: Gladman DD, Ibañez D, Urowitz MB. Systemic lupus erythematosus disease activity index 2000. J Rheumatol 2002;29:288–91.',
  ],
);

final sleClassificationScore = ScoreDef(
  title: 'EULAR/ACR SLE Classification (2019)',
  subtitle:
      'Entry criterion: ANA ≥ 1:80. Then weighted criteria — only the HIGHEST-weighted item in each domain counts; ≥10 points classifies SLE.',
  system: 'Rheumatology',
  accent: _rheum,
  questions: [
    ScoreQ.yesNo('ENTRY — ANA ≥ 1:80 on HEp-2 cells (required)', pts: 0),
    ScoreQ.yesNo('Constitutional — fever', pts: 2),
    ScoreQ.yesNo('Haematological — leucopenia (2) / thrombocytopenia (4) / autoimmune haemolysis (4)', pts: 4),
    ScoreQ.yesNo('Neuropsychiatric — delirium (2) / psychosis (3) / seizure (5)', pts: 5),
    ScoreQ.yesNo('Mucocutaneous — non-scarring alopecia (2) / oral ulcers (2) / subacute or discoid lupus (4) / acute cutaneous lupus (6)', pts: 6),
    ScoreQ.yesNo('Serosal — pleural or pericardial effusion (5) / acute pericarditis (6)', pts: 6),
    ScoreQ.yesNo('Musculoskeletal — joint involvement (≥2 joints with synovitis or tenderness plus stiffness)', pts: 6),
    ScoreQ.yesNo('Renal — proteinuria > 0.5 g/24 h (4) / class II or V nephritis (8) / class III or IV nephritis (10)', pts: 10),
    ScoreQ.yesNo('Antiphospholipid antibodies — anticardiolipin, anti-β2GP1 or lupus anticoagulant', pts: 2),
    ScoreQ.yesNo('Complement — low C3 OR low C4 (3) / low C3 AND low C4 (4)', pts: 4),
    ScoreQ.yesNo('SLE-specific antibodies — anti-dsDNA or anti-Smith', pts: 6),
  ],
  bands: [
    ScoreBand(0, 'Does not classify', scGreen,
        'Fewer than 10 points, or ANA negative. Without a positive ANA (≥1:80) the criteria cannot be applied at all.'),
    ScoreBand(10, 'Classifies as SLE', scOrange,
        '≥10 points with a positive ANA and at least one clinical criterion — classifies as SLE (sensitivity 96%, specificity 93%). Classification supports, but does not replace, clinical diagnosis.'),
  ],
  notes: const [
    'Each toggle here carries the HIGHEST weight in its domain — deselect and use clinical judgement if only a lower-weighted item in that domain is present.',
    'At least one CLINICAL criterion is required; criteria need not occur simultaneously. Do not count a criterion if a more likely explanation exists.',
    'Source: Aringer M et al. 2019 EULAR/ACR classification criteria for systemic lupus erythematosus. Ann Rheum Dis 2019;78:1151–9.',
  ],
);

final panScore = ScoreDef(
  title: 'Childhood Polyarteritis Nodosa Criteria',
  subtitle:
      'EULAR/PRINTO/PRES — mandatory histology or angiographic abnormality PLUS ≥1 of five features.',
  system: 'Rheumatology',
  accent: _rheum,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('MANDATORY — Necrotising vasculitis on biopsy OR angiographic abnormality (aneurysm/stenosis/occlusion)', pts: 4),
    ScoreQ.yesNo('Skin involvement — livedo reticularis, nodules, superficial or deep infarcts'),
    ScoreQ.yesNo('Myalgia or muscle tenderness'),
    ScoreQ.yesNo('Hypertension for age'),
    ScoreQ.yesNo('Peripheral neuropathy — sensory or motor mononeuritis multiplex'),
    ScoreQ.yesNo('Renal involvement — proteinuria, haematuria or impaired renal function'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'The mandatory histological or angiographic criterion is absent — childhood PAN cannot be classified.'),
    ScoreBand(4, 'Mandatory only', scAmber,
        'Histology/angiography present but no additional feature yet — at least one of the five clinical criteria is required.'),
    ScoreBand(5, 'Criteria MET', scOrange,
        'Classifies as childhood polyarteritis nodosa (sensitivity 89.6%, specificity 99.6%). Treat with corticosteroids plus cyclophosphamide in severe disease; assess for hepatitis B.'),
  ],
  notes: const [
    'Source: Ozen S et al. EULAR/PRINTO/PRES Ankara 2008 criteria. Ann Rheum Dis 2010;69:798–806.',
  ],
);

final gpaScore = ScoreDef(
  title: 'Granulomatosis with Polyangiitis (Wegener)',
  subtitle: 'EULAR/PRINTO/PRES paediatric criteria — ≥3 of 6 features classify GPA.',
  system: 'Rheumatology',
  accent: _rheum,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Histopathology — granulomatous inflammation within the vessel wall or peri/extravascular area'),
    ScoreQ.yesNo('Upper airway involvement — nasal discharge, recurrent epistaxis, crusts, sinus inflammation, subglottic/tracheal stenosis'),
    ScoreQ.yesNo('Laryngo-tracheo-bronchial stenosis'),
    ScoreQ.yesNo('Pulmonary involvement — chest X-ray or CT showing nodules, cavities or fixed infiltrates'),
    ScoreQ.yesNo('ANCA positivity (by immunofluorescence or ELISA — MPO/p-ANCA or PR3/c-ANCA)'),
    ScoreQ.yesNo('Renal involvement — proteinuria, haematuria/red-cell casts, necrotising pauci-immune glomerulonephritis'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Fewer than 3 criteria — does not classify as childhood GPA.'),
    ScoreBand(3, 'Criteria MET', scOrange,
        '≥3 of 6 criteria — classifies as childhood granulomatosis with polyangiitis (sensitivity 93%, specificity 99%). Induction with corticosteroids plus rituximab or cyclophosphamide.'),
  ],
  notes: const [
    'Source: Ozen S et al. EULAR/PRINTO/PRES Ankara 2008 criteria. Ann Rheum Dis 2010;69:798–806.',
  ],
);

final egpaScore = ScoreDef(
  title: 'Eosinophilic Granulomatosis with Polyangiitis (Churg-Strauss)',
  subtitle: 'ACR criteria — ≥4 of 6 features classify EGPA.',
  system: 'Rheumatology',
  accent: _rheum,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('Asthma'),
    ScoreQ.yesNo('Eosinophilia > 10 % on differential white cell count'),
    ScoreQ.yesNo('Mononeuropathy or polyneuropathy'),
    ScoreQ.yesNo('Migratory or transient pulmonary infiltrates on imaging'),
    ScoreQ.yesNo('Paranasal sinus abnormality'),
    ScoreQ.yesNo('Biopsy containing a blood vessel with extravascular eosinophils'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Fewer than 4 criteria — does not classify as EGPA.'),
    ScoreBand(4, 'Criteria MET', scOrange,
        '≥4 of 6 criteria — classifies as EGPA (sensitivity 85%, specificity 99.7%). Assess for cardiac involvement, which drives mortality.'),
  ],
  notes: const [
    'Rare in children; asthma and eosinophilia usually precede the vasculitic phase.',
    'Source: Masi AT et al. The ACR 1990 criteria for the classification of Churg-Strauss syndrome. Arthritis Rheum 1990;33:1094–100.',
  ],
);

final behcetScore = ScoreDef(
  title: 'Behçet Disease — ISG Criteria',
  subtitle:
      'International Study Group criteria: recurrent oral ulceration is MANDATORY plus ≥2 other features.',
  system: 'Rheumatology',
  accent: _rheum,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('MANDATORY — Recurrent oral ulceration ≥ 3 times in 12 months', pts: 4),
    ScoreQ.yesNo('Recurrent genital ulceration or scarring'),
    ScoreQ.yesNo('Eye lesions — anterior/posterior uveitis, cells in vitreous, or retinal vasculitis'),
    ScoreQ.yesNo('Skin lesions — erythema nodosum, pseudofolliculitis, papulopustular lesions, acneiform nodules'),
    ScoreQ.yesNo('Positive pathergy test read at 24–48 hours'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'Recurrent oral ulceration is mandatory — without it, Behçet disease cannot be classified by ISG criteria.'),
    ScoreBand(4, 'Oral ulcers only', scAmber,
        'Mandatory oral ulceration present, but ≥2 additional features are required to classify.'),
    ScoreBand(6, 'Criteria MET', scOrange,
        'Recurrent oral ulceration plus ≥2 additional criteria — classifies as Behçet disease. Assess for ocular, neurological and vascular involvement.'),
  ],
  notes: const [
    'Paediatric-specific PEDBD criteria also exist and may perform better in children.',
    'Source: International Study Group for Behçet\'s Disease. Criteria for diagnosis of Behçet\'s disease. Lancet 1990;335:1078–80.',
  ],
);

final juvenileSclerodermaScore = ScoreDef(
  title: 'Juvenile Systemic Sclerosis Criteria',
  subtitle:
      'PRES/ACR/EULAR paediatric criteria — the mandatory major criterion plus ≥2 of 20 minor criteria.',
  system: 'Rheumatology',
  accent: _rheum,
  totalLabel: 'criteria',
  questions: [
    ScoreQ.yesNo('MAJOR (mandatory) — Proximal skin sclerosis/induration of the skin proximal to MCP or MTP joints', pts: 4),
    ScoreQ.yesNo('Cutaneous — sclerodactyly'),
    ScoreQ.yesNo('Vascular — Raynaud phenomenon'),
    ScoreQ.yesNo('Vascular — nailfold capillary abnormalities or digital-tip ulcers'),
    ScoreQ.yesNo('Gastrointestinal — dysphagia or gastro-oesophageal reflux'),
    ScoreQ.yesNo('Renal — renal crisis or new-onset arterial hypertension'),
    ScoreQ.yesNo('Cardiac — arrhythmia or heart failure'),
    ScoreQ.yesNo('Respiratory — pulmonary fibrosis on HRCT/radiograph, reduced DLCO, or pulmonary hypertension'),
    ScoreQ.yesNo('Musculoskeletal — tendon friction rubs, arthritis or myositis'),
    ScoreQ.yesNo('Neurological — neuropathy or carpal tunnel syndrome'),
    ScoreQ.yesNo('Serological — antinuclear antibodies, or SSc-selective antibodies (anti-centromere, anti-topoisomerase I/Scl-70, anti-RNA polymerase, anti-fibrillarin, anti-PM-Scl)'),
  ],
  bands: [
    ScoreBand(0, 'Criteria not met', scGreen,
        'The major criterion (proximal skin sclerosis) is mandatory — without it juvenile systemic sclerosis cannot be classified.'),
    ScoreBand(4, 'Major only', scAmber,
        'Major criterion present but fewer than 2 minor criteria — at least 2 minor criteria are required.'),
    ScoreBand(6, 'Criteria MET', scOrange,
        'Major criterion plus ≥2 minor criteria — classifies as juvenile systemic sclerosis (sensitivity 90%, specificity 96%). Screen for pulmonary, cardiac and renal involvement at baseline.'),
  ],
  notes: const [
    'Onset must be before the 16th birthday for the juvenile classification.',
    'Source: Zulian F et al. The Pediatric Rheumatology European Society/ACR/EULAR provisional classification criteria for juvenile systemic sclerosis. Arthritis Rheum 2007;57:203–12.',
  ],
);

final sjogrenScore = ScoreDef(
  title: 'Sjögren Syndrome — ACR/EULAR 2016',
  subtitle:
      'Weighted classification criteria; a total of ≥ 4 classifies primary Sjögren syndrome.',
  system: 'Rheumatology',
  accent: _rheum,
  questions: [
    ScoreQ.yesNo('Labial salivary gland biopsy with focal lymphocytic sialadenitis, focus score ≥ 1 foci/4 mm²', pts: 3),
    ScoreQ.yesNo('Anti-SSA/Ro antibody positive', pts: 3),
    ScoreQ.yesNo('Ocular staining score ≥ 5 (or van Bijsterveld ≥ 4) in at least one eye'),
    ScoreQ.yesNo('Schirmer test ≤ 5 mm/5 min in at least one eye'),
    ScoreQ.yesNo('Unstimulated whole saliva flow rate ≤ 0.1 mL/min'),
  ],
  bands: [
    ScoreBand(0, 'Does not classify', scGreen,
        'Total <4 — does not classify as primary Sjögren syndrome.'),
    ScoreBand(4, 'Classifies as Sjögren', scOrange,
        'Total ≥4 — classifies as primary Sjögren syndrome (sensitivity 96%, specificity 95%). In children, recurrent parotitis is a more common presentation than sicca symptoms.'),
  ],
  notes: const [
    'Applies to patients with at least one symptom of ocular or oral dryness, or suspicion from the ESSDAI. Exclusions include prior head/neck radiation, active hepatitis C, AIDS, sarcoidosis, amyloidosis, GVHD and IgG4-related disease.',
    'Source: Shiboski CH et al. 2016 ACR/EULAR classification criteria for primary Sjögren\'s syndrome. Ann Rheum Dis 2017;76:9–16.',
  ],
);

final List<ScoreDef> rheumatologyScores = [
  hspScore,
  sleClassificationScore,
  sledaiScore,
  panScore,
  gpaScore,
  egpaScore,
  behcetScore,
  juvenileSclerodermaScore,
  sjogrenScore,
];
