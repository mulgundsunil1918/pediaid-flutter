// =============================================================================
// services/qualifications_catalogue.dart
//
// The qualifications a PediAid user can hold.
//
// A picked list rather than a text field, because free text gives you "MBBS",
// "M.B.B.S.", "mbbs" and "MBBS " as four different values and nothing can be
// counted. Everything here is multi-select: a paediatrician typically holds
// MBBS *and* MD *and* often a superspecialty, and forcing one answer would
// make most people pick the wrong one.
//
// Scope is paediatrics and the disciplines that read paediatric references —
// neonatal nurses use the scores in this app, pharmacists use the formulary.
// Trainees are included deliberately: a large share of users are residents,
// and leaving them to pick "Other" would lose the single most interesting
// segment.
//
// `kQualificationOther` must always be offered so nothing is unrepresentable,
// but it is the fallback, not the escape hatch for a list that is too short.
// If it starts showing up often, the list is wrong and should be extended.
// =============================================================================

/// One selectable qualification.
class Qualification {
  const Qualification(this.id, this.label, {this.note});

  /// Stable key. **Persisted to Firestore — never change one.** A renamed id
  /// silently orphans every profile that selected it.
  final String id;

  /// What the user sees.
  final String label;

  /// Disambiguation shown under the label, where the abbreviation alone is
  /// ambiguous across countries.
  final String? note;
}

/// A titled block in the picker.
class QualificationGroup {
  const QualificationGroup(this.title, this.items);
  final String title;
  final List<Qualification> items;
}

/// The id stored when someone picks "Other".
const String kQualificationOther = 'other';

const List<QualificationGroup> kQualificationGroups = [
  QualificationGroup('Basic medical degree', [
    Qualification('mbbs', 'MBBS', note: 'India, UK and Commonwealth'),
    Qualification(
      'md_us',
      'MD',
      note: 'US / Europe entry-level medical degree',
    ),
    Qualification('do_us', 'DO', note: 'Doctor of Osteopathic Medicine, US'),
    Qualification('bds', 'BDS / DDS', note: 'Dental'),
  ]),

  QualificationGroup('Postgraduate — paediatrics', [
    Qualification('md_paed', 'MD (Paediatrics)'),
    Qualification('dnb_paed', 'DNB (Paediatrics)'),
    Qualification('dch', 'DCH', note: 'Diploma in Child Health'),
    Qualification('mrcpch', 'MRCPCH', note: 'Royal College of Paediatrics, UK'),
    Qualification('frcpch', 'FRCPCH', note: 'Fellow, RCPCH'),
    Qualification(
      'faap',
      'FAAP',
      note: 'Fellow, American Academy of Pediatrics',
    ),
    Qualification(
      'abp',
      'ABP Board Certified',
      note: 'American Board of Pediatrics',
    ),
    Qualification(
      'fcps_paed',
      'FCPS (Paediatrics)',
      note: 'Pakistan, Bangladesh, Sri Lanka',
    ),
    Qualification(
      'mmed_paed',
      'MMed (Paediatrics)',
      note: 'Africa, South-East Asia',
    ),
    Qualification('ms_paed', 'MS (Paediatrics)'),
  ]),

  QualificationGroup('Postgraduate — other specialties', [
    Qualification('md_med', 'MD (General Medicine)'),
    Qualification('dnb_med', 'DNB (General Medicine)'),
    Qualification('md_obg', 'MD / DNB (Obstetrics & Gynaecology)'),
    Qualification('md_anaes', 'MD / DNB (Anaesthesiology)'),
    Qualification('md_path', 'MD / DNB (Pathology)'),
    Qualification('md_radio', 'MD / DNB (Radiodiagnosis)'),
    Qualification('md_commed', 'MD (Community Medicine)'),
    Qualification('mrcp', 'MRCP', note: 'Royal College of Physicians, UK'),
    Qualification('ms_surg', 'MS (General Surgery)'),
  ]),

  QualificationGroup('Superspecialty — DM / DrNB / FNB', [
    Qualification('dm_neonat', 'Neonatology', note: 'DM / DrNB / FNB'),
    Qualification(
      'dm_picu',
      'Paediatric Critical Care',
      note: 'DM / DrNB / FNB',
    ),
    Qualification('dm_cardio', 'Paediatric Cardiology', note: 'DM / DrNB'),
    Qualification('dm_neuro', 'Paediatric Neurology', note: 'DM / DrNB'),
    Qualification('dm_nephro', 'Paediatric Nephrology', note: 'DM / DrNB'),
    Qualification(
      'dm_gastro',
      'Paediatric Gastroenterology',
      note: 'DM / DrNB',
    ),
    Qualification(
      'dm_hemonc',
      'Paediatric Haematology & Oncology',
      note: 'DM / DrNB',
    ),
    Qualification('dm_endo', 'Paediatric Endocrinology', note: 'DM / DrNB'),
    Qualification(
      'dm_pulmo',
      'Paediatric Pulmonology',
      note: 'DM / DrNB / FNB',
    ),
    Qualification('dm_id', 'Paediatric Infectious Diseases', note: 'DM / FNB'),
    Qualification('dm_rheum', 'Paediatric Rheumatology', note: 'DM / FNB'),
    Qualification('dm_genetics', 'Medical Genetics', note: 'DM / DrNB'),
    Qualification(
      'dm_emerg',
      'Paediatric Emergency Medicine',
      note: 'FNB / Fellowship',
    ),
    Qualification(
      'dm_devpaed',
      'Developmental Paediatrics',
      note: 'Fellowship',
    ),
    Qualification(
      'dm_hepato',
      'Paediatric Hepatology',
      note: 'DM / Fellowship',
    ),
  ]),

  QualificationGroup('Paediatric surgery', [
    Qualification('mch_paedsurg', 'MCh (Paediatric Surgery)'),
    Qualification('drnb_paedsurg', 'DrNB (Paediatric Surgery)'),
    Qualification('mch_paedcardsurg', 'MCh (Paediatric Cardiac Surgery)'),
    Qualification('mch_neurosurg', 'MCh (Neurosurgery)'),
  ]),

  QualificationGroup('Fellowships & diplomas', [
    Qualification(
      'iap_fellowship',
      'IAP Fellowship',
      note: 'Indian Academy of Paediatrics',
    ),
    Qualification(
      'nnf_fellowship',
      'NNF Fellowship',
      note: 'National Neonatology Forum',
    ),
    Qualification(
      'fiap',
      'FIAP',
      note: 'Fellow, Indian Academy of Paediatrics',
    ),
    Qualification('pgdip', 'Postgraduate Diploma', note: 'PGDip / PGCert'),
    Qualification('phd', 'PhD'),
  ]),

  QualificationGroup('Nursing & allied health', [
    Qualification('bsc_nursing', 'BSc Nursing'),
    Qualification('post_basic_bsc', 'Post Basic BSc Nursing'),
    Qualification('msc_nursing', 'MSc Nursing'),
    Qualification('gnm', 'GNM', note: 'General Nursing & Midwifery'),
    Qualification('nnp', 'Neonatal Nurse Practitioner'),
    Qualification('pharm_d', 'Pharm D'),
    Qualification('bpharm', 'B Pharm / M Pharm'),
    Qualification('rt', 'Respiratory Therapist'),
    Qualification('dietitian', 'Dietitian / Nutritionist'),
  ]),

  QualificationGroup('In training', [
    Qualification('student', 'Medical student'),
    Qualification('intern', 'Intern'),
    Qualification('jr', 'Junior Resident / PG trainee'),
    Qualification('sr', 'Senior Resident'),
    Qualification('fellow_training', 'Fellow in training'),
    Qualification('nursing_student', 'Nursing student'),
  ]),

  QualificationGroup('Not listed', [
    Qualification(kQualificationOther, 'Other'),
  ]),
];

/// Every qualification, flattened — for lookup and validation.
final Map<String, Qualification> kQualificationsById = {
  for (final g in kQualificationGroups)
    for (final q in g.items) q.id: q,
};

/// Renders stored ids back to labels, skipping any the catalogue no longer
/// knows. Unknown ids are dropped rather than shown raw: an id is a storage
/// key, and showing "dm_hemonc" to a user would be worse than showing nothing.
List<String> labelsFor(Iterable<String> ids) => ids
    .map((id) => kQualificationsById[id]?.label)
    .whereType<String>()
    .toList();
