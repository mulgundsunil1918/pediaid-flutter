// =============================================================================
// scores/oncology_scores.dart
//
// Paediatric oncology staging and prognostic tools. The Toronto Childhood
// Cancer Staging Guidelines define a Tier-1 stage per tumour for registry and
// clinical use; each tool below asks the discriminating question(s) and returns
// the stage with its management implication. Citations included.
// =============================================================================

import 'package:flutter/material.dart';
import 'score_scaffold.dart';

const _onc = Color(0xFF7B1FA2);

const _torontoRef =
    'Source: Gupta S, Aitken JF, Bartels U et al. Paediatric cancer stage in population-based cancer registries: the Toronto consensus principles and guidelines. Lancet Oncol 2016;17:e163–72.';

/// Single-question staging tool: each choice's value IS the stage.
ScoreDef _stage({
  required String title,
  required String subtitle,
  required String question,
  required List<ScoreChoice> options,
  required List<ScoreBand> bands,
  List<String> notes = const [],
}) =>
    ScoreDef(
      title: title,
      subtitle: subtitle,
      system: 'Oncology',
      accent: _onc,
      totalLabel: 'stage',
      questions: [ScoreQ(question, options)],
      bands: bands,
      notes: [...notes, _torontoRef],
    );

// ── Prognostic score ─────────────────────────────────────────────────────────

final chipsScore = ScoreDef(
  title: 'CHIPS — Childhood Hodgkin Prognostic Score',
  subtitle:
      'Predicts event-free survival in intermediate-risk paediatric Hodgkin lymphoma.',
  system: 'Oncology',
  accent: _onc,
  questions: [
    ScoreQ.yesNo('Stage 4 disease'),
    ScoreQ.yesNo('Large mediastinal mass'),
    ScoreQ.yesNo('Serum albumin < 3.5 g/dL'),
    ScoreQ.yesNo('Fever (B symptom)'),
  ],
  bands: [
    ScoreBand(0, 'Low risk', scGreen,
        'CHIPS 0 — approximately 93% 4-year event-free survival. Standard therapy.'),
    ScoreBand(1, 'Intermediate', scAmber,
        'CHIPS 1 — approximately 89% 4-year EFS.'),
    ScoreBand(2, 'Higher risk', scOrange,
        'CHIPS 2 — approximately 81% 4-year EFS. Consider response-adapted intensification.'),
    ScoreBand(3, 'High risk', scRed,
        'CHIPS 3–4 — approximately 70% 4-year EFS. Higher-intensity therapy and close response assessment.'),
  ],
  notes: const [
    'Derived in COG AHOD0031 (intermediate-risk Hodgkin lymphoma).',
    'Source: Schwartz CL et al. A risk-adapted, response-based approach for intermediate-risk Hodgkin lymphoma: CHIPS. Blood 2017;129:3193–3197.',
  ],
);

// ── Leukaemias ───────────────────────────────────────────────────────────────

final allRiskScore = ScoreDef(
  title: 'ALL — NCI/Rome Risk & Toronto Stage',
  subtitle:
      'Acute lymphoblastic leukaemia: NCI risk group plus Toronto CNS-based stage.',
  system: 'Oncology',
  accent: _onc,
  totalLabel: 'risk points',
  questions: const [
    ScoreQ('Age at diagnosis', [
      ScoreChoice('1 to < 10 years', 0),
      ScoreChoice('< 1 year or ≥ 10 years', 2),
    ]),
    ScoreQ('Presenting white cell count', [
      ScoreChoice('< 50 000 /µL', 0),
      ScoreChoice('≥ 50 000 /µL', 2),
    ]),
    ScoreQ('CNS status (Toronto stage)', [
      ScoreChoice('CNS1 — no blasts in CSF (Stage I)', 0),
      ScoreChoice('CNS2 — < 5 WBC/µL with blasts', 1),
      ScoreChoice('CNS3 — ≥ 5 WBC/µL with blasts, or cranial nerve palsy (Stage II)', 1),
    ]),
  ],
  bands: [
    ScoreBand(0, 'Standard risk · Stage I', scGreen,
        'NCI standard risk (age 1–9.99 y AND WBC <50 000) with no CNS disease — Toronto Stage I. Best prognosis; standard-intensity therapy.'),
    ScoreBand(1, 'Standard risk · CNS involvement', scAmber,
        'NCI standard risk but with CNS blasts — Toronto Stage II. Intensified CNS-directed therapy required.'),
    ScoreBand(2, 'High risk', scOrange,
        'NCI high risk (age <1 or ≥10 years, or WBC ≥50 000). Augmented therapy; check cytogenetics and MRD response.'),
    ScoreBand(3, 'High risk · CNS involvement', scRed,
        'NCI high risk with CNS disease — Toronto Stage II. Most intensive therapy including CNS-directed treatment; MRD-guided escalation.'),
  ],
  notes: const [
    'Toronto Tier-1 stage for ALL: Stage I = no CNS disease (CNS1/CNS2); Stage II = CNS disease (CNS3).',
    'NCI/Rome criteria: standard risk requires BOTH age 1–9.99 years and WBC <50 000/µL.',
    'Source (risk): Smith M et al. Uniform approach to risk classification and treatment assignment for children with ALL. J Clin Oncol 1996;14:18–24. $_torontoRef',
  ],
);

final amlStageScore = _stage(
  title: 'AML — Toronto Stage',
  subtitle: 'Acute myeloid leukaemia is staged by CNS involvement.',
  question: 'CNS status at diagnosis',
  options: const [
    ScoreChoice('No CNS disease (CNS1 / CNS2)', 1),
    ScoreChoice('CNS disease present (CNS3 — ≥5 WBC/µL with blasts, or chloroma)', 2),
  ],
  bands: const [
    ScoreBand(1, 'Stage I', scGreen,
        'Stage I — no CNS involvement. Standard AML induction with intrathecal prophylaxis per protocol.'),
    ScoreBand(2, 'Stage II', scOrange,
        'Stage II — CNS involvement. Requires intensified CNS-directed intrathecal therapy alongside systemic treatment.'),
  ],
);

// ── Lymphomas ────────────────────────────────────────────────────────────────

final hodgkinStageScore = _stage(
  title: 'Hodgkin Lymphoma — Ann Arbor Stage',
  subtitle: 'Ann Arbor staging (Toronto Tier 1) with Cotswolds modification.',
  question: 'Extent of disease',
  options: const [
    ScoreChoice('Stage I — one lymph node region or a single extralymphatic site', 1),
    ScoreChoice('Stage II — ≥2 node regions on the SAME side of the diaphragm', 2),
    ScoreChoice('Stage III — node regions on BOTH sides of the diaphragm', 3),
    ScoreChoice('Stage IV — disseminated extralymphatic involvement (marrow, liver, lung)', 4),
  ],
  bands: const [
    ScoreBand(1, 'Stage I', scGreen,
        'Stage I — limited disease. Usually low-risk therapy: short chemotherapy ± involved-site radiotherapy.'),
    ScoreBand(2, 'Stage II', scAmber,
        'Stage II — favourable or unfavourable depending on bulk and B symptoms; therapy is response-adapted.'),
    ScoreBand(3, 'Stage III', scOrange,
        'Stage III — advanced disease. Multi-agent chemotherapy with response-adapted radiotherapy.'),
    ScoreBand(4, 'Stage IV', scRed,
        'Stage IV — disseminated. High-risk multi-agent chemotherapy; consider CHIPS for prognostication.'),
  ],
  notes: const [
    'Suffix A = no systemic symptoms; B = fever >38 °C, drenching night sweats, or >10% weight loss in 6 months. Suffix E = limited contiguous extranodal extension; X = bulky disease.',
  ],
);

final nhlStageScore = _stage(
  title: 'Non-Hodgkin Lymphoma — St Jude (Murphy) Stage',
  subtitle: 'Paediatric NHL staging (Toronto Tier 1).',
  question: 'Extent of disease',
  options: const [
    ScoreChoice('Stage I — single tumour or single nodal area, excluding mediastinum/abdomen', 1),
    ScoreChoice('Stage II — single tumour with regional nodes, or ≥2 areas same side of diaphragm, or resected primary GI tumour', 2),
    ScoreChoice('Stage III — both sides of diaphragm, all primary intrathoracic, extensive unresectable abdominal, paraspinal or epidural', 3),
    ScoreChoice('Stage IV — CNS and/or bone marrow involvement (< 25 % blasts)', 4),
  ],
  bands: const [
    ScoreBand(1, 'Stage I', scGreen,
        'Stage I — limited disease; excellent prognosis with short-course therapy.'),
    ScoreBand(2, 'Stage II', scAmber,
        'Stage II — limited disease, generally treated on low-risk protocols.'),
    ScoreBand(3, 'Stage III', scOrange,
        'Stage III — advanced disease requiring intensified multi-agent chemotherapy.'),
    ScoreBand(4, 'Stage IV', scRed,
        'Stage IV — CNS and/or marrow involvement. Highest-intensity therapy with CNS-directed treatment; marrow blasts ≥25 % is classified as leukaemia instead.'),
  ],
  notes: const [
    'Source (staging): Murphy SB. Classification, staging and end results of treatment of childhood non-Hodgkin lymphomas. Semin Oncol 1980;7:332–9.',
  ],
);

// ── Solid tumours ────────────────────────────────────────────────────────────

final wilmsStageScore = _stage(
  title: 'Wilms Tumour — Toronto / COG Stage',
  subtitle: 'Nephroblastoma staging after upfront nephrectomy (COG convention).',
  question: 'Surgical and pathological extent',
  options: const [
    ScoreChoice('Stage I — limited to kidney, completely resected, capsule intact', 1),
    ScoreChoice('Stage II — extends beyond kidney but completely resected, negative margins', 2),
    ScoreChoice('Stage III — residual tumour in abdomen: positive nodes/margins, spillage, biopsy, or piecemeal removal', 3),
    ScoreChoice('Stage IV — haematogenous metastases (lung, liver, bone, brain) or extra-abdominal nodes', 4),
    ScoreChoice('Stage V — bilateral renal involvement at diagnosis', 5),
  ],
  bands: const [
    ScoreBand(1, 'Stage I', scGreen,
        'Stage I — excellent prognosis (>90% survival with favourable histology). Nephrectomy plus short chemotherapy.'),
    ScoreBand(2, 'Stage II', scGreen,
        'Stage II — completely resected beyond the kidney. Chemotherapy without flank radiotherapy in favourable histology.'),
    ScoreBand(3, 'Stage III', scOrange,
        'Stage III — residual abdominal disease. Chemotherapy PLUS flank/abdominal radiotherapy.'),
    ScoreBand(4, 'Stage IV', scRed,
        'Stage IV — distant metastases. Intensified chemotherapy plus radiotherapy to metastatic sites as indicated.'),
    ScoreBand(5, 'Stage V', scRed,
        'Stage V — bilateral disease. Nephron-sparing strategy with pre-operative chemotherapy; each kidney is also staged individually.'),
  ],
  notes: const [
    'Histology (favourable vs anaplastic) is as important as stage for risk assignment.',
  ],
);

final neuroblastomaStageScore = _stage(
  title: 'Neuroblastoma — INRGSS Stage',
  subtitle:
      'International Neuroblastoma Risk Group Staging System — pre-treatment, imaging-based.',
  question: 'Extent of disease on imaging',
  options: const [
    ScoreChoice('L1 — localised, confined to one body compartment, NO image-defined risk factors', 1),
    ScoreChoice('L2 — locoregional with ≥1 image-defined risk factor (IDRF)', 2),
    ScoreChoice('M — distant metastatic disease (except MS)', 3),
    ScoreChoice('MS — age < 18 months with metastases confined to skin, liver and/or bone marrow (< 10 %)', 4),
  ],
  bands: const [
    ScoreBand(1, 'Stage L1', scGreen,
        'L1 — localised without IDRFs. Surgery alone is often curative in low-risk biology.'),
    ScoreBand(2, 'Stage L2', scAmber,
        'L2 — locoregional with IDRFs; upfront complete resection is hazardous. Neoadjuvant chemotherapy usually precedes surgery.'),
    ScoreBand(3, 'Stage M', scRed,
        'M — metastatic disease. High-risk therapy: induction chemotherapy, surgery, high-dose therapy with stem-cell rescue, radiotherapy, immunotherapy and retinoic acid.'),
    ScoreBand(4, 'Stage MS', scAmber,
        'MS — special metastatic pattern in infants; frequently has an excellent outcome and can spontaneously regress, but assess MYCN and symptomatic hepatomegaly.'),
  ],
  notes: const [
    'Risk group also depends on age, MYCN amplification, histology, ploidy and 11q aberration.',
    'Source: Monclair T et al. The International Neuroblastoma Risk Group (INRG) staging system. J Clin Oncol 2009;27:298–303.',
  ],
);

final retinoblastomaStageScore = _stage(
  title: 'Retinoblastoma — Toronto Stage',
  subtitle: 'Post-enucleation staging of retinoblastoma.',
  question: 'Extent of disease',
  options: const [
    ScoreChoice('Stage 0 — intraocular tumour, eye NOT enucleated (conservative therapy)', 1),
    ScoreChoice('Stage I — eye enucleated, completely resected histologically', 2),
    ScoreChoice('Stage II — eye enucleated, microscopic residual tumour', 3),
    ScoreChoice('Stage III — regional extension (orbital disease or preauricular/cervical nodes)', 4),
    ScoreChoice('Stage IV — distant metastatic disease (haematogenous or CNS)', 5),
  ],
  bands: const [
    ScoreBand(1, 'Stage 0', scGreen,
        'Stage 0 — eye-preserving therapy (systemic/intra-arterial chemotherapy, focal therapy). Excellent survival in high-income settings.'),
    ScoreBand(2, 'Stage I', scGreen,
        'Stage I — completely resected after enucleation. Usually no adjuvant therapy unless high-risk histology.'),
    ScoreBand(3, 'Stage II', scAmber,
        'Stage II — microscopic residual disease. Adjuvant chemotherapy indicated.'),
    ScoreBand(4, 'Stage III', scOrange,
        'Stage III — regional extension. Intensive chemotherapy plus orbital radiotherapy.'),
    ScoreBand(5, 'Stage IV', scRed,
        'Stage IV — metastatic. High-dose chemotherapy with stem-cell rescue; CNS disease carries a very poor prognosis.'),
  ],
);

final hepatoblastomaStageScore = _stage(
  title: 'Hepatoblastoma — PRETEXT Group',
  subtitle:
      'PRE-Treatment EXTent of tumour — number of contiguous liver sections FREE of tumour determines the group.',
  question: 'Liver sections involved (of the four sections)',
  options: const [
    ScoreChoice('PRETEXT I — three adjoining sections free of tumour', 1),
    ScoreChoice('PRETEXT II — two adjoining sections free', 2),
    ScoreChoice('PRETEXT III — one section free, or two non-adjoining sections free', 3),
    ScoreChoice('PRETEXT IV — no section free (all four involved)', 4),
  ],
  bands: const [
    ScoreBand(1, 'PRETEXT I', scGreen,
        'PRETEXT I — upfront resection usually feasible; excellent prognosis.'),
    ScoreBand(2, 'PRETEXT II', scGreen,
        'PRETEXT II — resectable at diagnosis or after neoadjuvant chemotherapy.'),
    ScoreBand(3, 'PRETEXT III', scOrange,
        'PRETEXT III — neoadjuvant chemotherapy then re-evaluate (POST-TEXT); may need extended hepatectomy or transplant referral.'),
    ScoreBand(4, 'PRETEXT IV', scRed,
        'PRETEXT IV — all sections involved. Refer early for liver transplant evaluation alongside chemotherapy.'),
  ],
  notes: const [
    'Annotation factors modify risk: V (hepatic vein/IVC), P (portal vein), E (extrahepatic contiguous), F (multifocal), R (tumour rupture), C (caudate), N (nodes), M (distant metastases).',
    'AFP <100 ng/mL at diagnosis is an adverse prognostic feature.',
    'Source: Roebuck DJ et al. 2005 PRETEXT: a revised staging system for primary malignant liver tumours of childhood. Pediatr Radiol 2007;37:123–32.',
  ],
);

final medulloblastomaStageScore = _stage(
  title: 'Medulloblastoma / CNS Embryonal — Chang M-Stage',
  subtitle: 'Metastatic staging of medulloblastoma and other CNS embryonal tumours.',
  question: 'Metastatic status',
  options: const [
    ScoreChoice('M0 — no gross subarachnoid or haematogenous metastasis', 1),
    ScoreChoice('M1 — tumour cells found in CSF only', 2),
    ScoreChoice('M2 — gross nodular seeding in cerebellar/cerebral subarachnoid space or ventricles', 3),
    ScoreChoice('M3 — gross nodular seeding in the spinal subarachnoid space', 4),
    ScoreChoice('M4 — metastasis outside the cerebrospinal axis', 5),
  ],
  bands: const [
    ScoreBand(1, 'M0 — standard risk (if resected)', scGreen,
        'M0 with <1.5 cm² residual tumour and age ≥3 years = standard risk. Craniospinal radiotherapy plus chemotherapy.'),
    ScoreBand(2, 'M1 — high risk', scOrange,
        'M1 — positive CSF cytology places the patient in the high-risk group.'),
    ScoreBand(3, 'M2–M3 — high risk', scRed,
        'Gross nodular seeding (intracranial or spinal) — high-risk disease requiring intensified therapy.'),
    ScoreBand(5, 'M4 — high risk, extraneural', scRed,
        'M4 — extraneural metastasis; rare and carries the poorest prognosis.'),
  ],
  notes: const [
    'Risk stratification also uses extent of resection (residual <1.5 cm²), age (<3 years) and molecular subgroup (WNT, SHH, Group 3, Group 4).',
    'Source: Chang CH, Housepian EM, Herbert C. An operative staging system and a megavoltage radiotherapeutic technique for cerebellar medulloblastomas. Radiology 1969;93:1351–9.',
  ],
);

final ependymomaStageScore = _stage(
  title: 'Ependymoma — Toronto Stage',
  subtitle: 'Staged by the presence of metastatic disease.',
  question: 'Metastatic status at diagnosis',
  options: const [
    ScoreChoice('Stage I — localised, no metastases', 1),
    ScoreChoice('Stage II — metastatic disease present (CSF, spinal or extraneural)', 2),
  ],
  bands: const [
    ScoreBand(1, 'Stage I', scGreen,
        'Localised ependymoma. Extent of resection is the strongest prognostic factor — aim for gross total resection followed by focal radiotherapy.'),
    ScoreBand(2, 'Stage II', scRed,
        'Metastatic ependymoma — craniospinal radiotherapy and chemotherapy; significantly poorer prognosis.'),
  ],
);

final osteosarcomaStageScore = _stage(
  title: 'Osteosarcoma — Toronto Stage',
  subtitle: 'Staged by the presence of metastases at diagnosis.',
  question: 'Disease extent at diagnosis',
  options: const [
    ScoreChoice('Stage I — localised disease', 1),
    ScoreChoice('Stage II — metastatic disease (lung, bone or other)', 2),
  ],
  bands: const [
    ScoreBand(1, 'Stage I — localised', scGreen,
        'Localised osteosarcoma — approximately 60–70% long-term survival with neoadjuvant chemotherapy, limb-salvage surgery and adjuvant chemotherapy.'),
    ScoreBand(2, 'Stage II — metastatic', scRed,
        'Metastatic osteosarcoma — approximately 20–30% survival. Aggressive chemotherapy plus resection of all resectable metastases.'),
  ],
  notes: const [
    'Histological necrosis ≥90% after neoadjuvant chemotherapy is a favourable prognostic factor.',
  ],
);

final ewingStageScore = _stage(
  title: 'Ewing Sarcoma — Toronto Stage',
  subtitle: 'Staged by the presence of metastases at diagnosis.',
  question: 'Disease extent at diagnosis',
  options: const [
    ScoreChoice('Stage I — localised disease', 1),
    ScoreChoice('Stage II — metastatic disease', 2),
  ],
  bands: const [
    ScoreBand(1, 'Stage I — localised', scGreen,
        'Localised Ewing sarcoma — approximately 70% survival with interval-compressed chemotherapy plus local control (surgery and/or radiotherapy).'),
    ScoreBand(2, 'Stage II — metastatic', scRed,
        'Metastatic Ewing sarcoma — poorer prognosis; isolated lung metastases fare better than bone or marrow disease.'),
  ],
);

final rhabdoStageScore = _stage(
  title: 'Rhabdomyosarcoma — IRS Group',
  subtitle: 'Intergroup Rhabdomyosarcoma Study post-surgical grouping.',
  question: 'Post-surgical extent',
  options: const [
    ScoreChoice('Group I — localised, completely resected, negative margins', 1),
    ScoreChoice('Group II — grossly resected with microscopic residual and/or regional nodes', 2),
    ScoreChoice('Group III — incomplete resection with gross residual disease, or biopsy only', 3),
    ScoreChoice('Group IV — distant metastases at diagnosis', 4),
  ],
  bands: const [
    ScoreBand(1, 'Group I', scGreen,
        'Group I — completely resected. Best prognosis; chemotherapy without radiotherapy in favourable subsets.'),
    ScoreBand(2, 'Group II', scAmber,
        'Group II — microscopic residual or nodal disease. Chemotherapy plus radiotherapy.'),
    ScoreBand(3, 'Group III', scOrange,
        'Group III — gross residual disease (the largest group). Chemotherapy plus radiotherapy, with delayed surgery when feasible.'),
    ScoreBand(4, 'Group IV', scRed,
        'Group IV — metastatic disease. Poor prognosis; intensified multimodal therapy.'),
  ],
  notes: const [
    'Overall risk also depends on histology (embryonal vs alveolar / FOXO1 fusion status), site (favourable vs unfavourable) and tumour size/age.',
    'Source: Crist W et al. The Third Intergroup Rhabdomyosarcoma Study. J Clin Oncol 1995;13:610–30.',
  ],
);

final nonRhabdoStsStageScore = _stage(
  title: 'Non-Rhabdomyosarcoma Soft-Tissue Sarcoma — Toronto Stage',
  subtitle: 'Staged by resection status and metastatic disease.',
  question: 'Extent and resection status',
  options: const [
    ScoreChoice('Stage I — localised, completely resected', 1),
    ScoreChoice('Stage II — localised, incompletely resected or unresected', 2),
    ScoreChoice('Stage III — regional nodal involvement', 3),
    ScoreChoice('Stage IV — distant metastases', 4),
  ],
  bands: const [
    ScoreBand(1, 'Stage I', scGreen,
        'Completely resected localised NRSTS — surgery alone may suffice in low-grade small tumours.'),
    ScoreBand(2, 'Stage II', scAmber,
        'Localised but incompletely resected — consider re-excision, radiotherapy and chemotherapy by grade.'),
    ScoreBand(3, 'Stage III', scOrange,
        'Regional nodal disease — multimodal therapy required.'),
    ScoreBand(4, 'Stage IV', scRed,
        'Metastatic NRSTS — poor prognosis; chemotherapy sensitivity varies widely by histological subtype.'),
  ],
);

final ovarianStageScore = _stage(
  title: 'Ovarian Tumour — Toronto / FIGO Stage',
  subtitle: 'Paediatric ovarian (usually germ-cell) tumour staging.',
  question: 'Extent of disease',
  options: const [
    ScoreChoice('Stage I — limited to the ovary/ovaries, capsule intact, negative washings', 1),
    ScoreChoice('Stage II — pelvic extension or microscopic residual, positive washings', 2),
    ScoreChoice('Stage III — abdominal spread beyond the pelvis and/or retroperitoneal nodes', 3),
    ScoreChoice('Stage IV — distant metastases (including liver parenchyma or pleural effusion)', 4),
  ],
  bands: const [
    ScoreBand(1, 'Stage I', scGreen,
        'Stage I — surgery alone with surveillance is often sufficient for germ-cell tumours; excellent prognosis.'),
    ScoreBand(2, 'Stage II', scAmber,
        'Stage II — surgery plus platinum-based chemotherapy.'),
    ScoreBand(3, 'Stage III', scOrange,
        'Stage III — surgery plus chemotherapy; monitor tumour markers (AFP, β-hCG) for response.'),
    ScoreBand(4, 'Stage IV', scRed,
        'Stage IV — distant metastases. Platinum-based chemotherapy; germ-cell tumours remain highly curable even at this stage.'),
  ],
);

final testicularStageScore = _stage(
  title: 'Testicular Tumour — Toronto / COG Stage',
  subtitle: 'Paediatric testicular germ-cell tumour staging.',
  question: 'Extent of disease',
  options: const [
    ScoreChoice('Stage I — limited to testis, completely resected, markers normalise appropriately', 1),
    ScoreChoice('Stage II — microscopic residual / scrotal or high spermatic-cord involvement, or markers fail to normalise', 2),
    ScoreChoice('Stage III — retroperitoneal lymph-node involvement', 3),
    ScoreChoice('Stage IV — distant metastases (lung, liver, brain, bone)', 4),
  ],
  bands: const [
    ScoreBand(1, 'Stage I', scGreen,
        'Stage I — orchidectomy with surveillance; excellent cure rate in children.'),
    ScoreBand(2, 'Stage II', scAmber,
        'Stage II — chemotherapy after surgery; follow tumour markers closely.'),
    ScoreBand(3, 'Stage III', scOrange,
        'Stage III — retroperitoneal nodal disease requiring platinum-based chemotherapy.'),
    ScoreBand(4, 'Stage IV', scRed,
        'Stage IV — distant metastases; still highly curable with platinum-based chemotherapy and resection of residual masses.'),
  ],
  notes: const [
    'AFP has a long half-life in infants — interpret normalisation against age-appropriate reference values.',
  ],
);

final List<ScoreDef> oncologyScores = [
  chipsScore,
  allRiskScore,
  amlStageScore,
  hodgkinStageScore,
  nhlStageScore,
  wilmsStageScore,
  neuroblastomaStageScore,
  retinoblastomaStageScore,
  hepatoblastomaStageScore,
  medulloblastomaStageScore,
  ependymomaStageScore,
  osteosarcomaStageScore,
  ewingStageScore,
  rhabdoStageScore,
  nonRhabdoStsStageScore,
  ovarianStageScore,
  testicularStageScore,
];
