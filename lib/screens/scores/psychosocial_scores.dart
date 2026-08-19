// =============================================================================
// scores/psychosocial_scores.dart
//
// DSM-5 diagnostic-criteria screens (18). Each is a criteria checklist: tick
// what is present, and the scaffold reports how many criteria are met against
// the DSM-5 threshold for that disorder.
//
// These are SCREENING AIDS that mirror the published criteria — a DSM-5
// diagnosis additionally requires clinically significant distress/impairment,
// a minimum duration, and exclusion of substances/another condition, and must
// be made by a qualified clinician. Each screen states its own threshold.
// =============================================================================

import 'package:flutter/material.dart';
import 'score_scaffold.dart';

const _psy = Color(0xFF5B3E96);

/// Criteria-count screen: N of M criteria + duration/impairment reminder.
ScoreDef _criteria({
  required String title,
  required String subtitle,
  required List<String> criteria,
  required int threshold,
  required String metAdvice,
  required String notMetAdvice,
  List<String> notes = const [],
}) =>
    ScoreDef(
      title: title,
      subtitle: subtitle,
      system: 'Psychosocial',
      accent: _psy,
      totalLabel: 'criteria met',
      questions: [for (final c in criteria) ScoreQ.yesNo(c)],
      bands: [
        ScoreBand(0, 'Below threshold', scGreen, notMetAdvice),
        ScoreBand(threshold, 'Threshold met', scOrange, metAdvice),
      ],
      notes: [
        'DSM-5 threshold: $threshold or more of the ${criteria.length} criteria listed.',
        'A diagnosis also requires clinically significant distress or impairment, the '
            'required duration, and exclusion of substance use or another condition. '
            'Screening aid only — not a diagnosis.',
        ...notes,
      ],
    );

// ── Neurodevelopmental / disruptive ──────────────────────────────────────────

final adhdInattentiveScore = _criteria(
  title: 'ADHD — DSM-5 Criteria',
  subtitle:
      'Attention-deficit/hyperactivity disorder. Score the inattention list, then repeat for hyperactivity-impulsivity.',
  criteria: const [
    'Fails to give close attention to details / careless mistakes',
    'Difficulty sustaining attention in tasks or play',
    'Does not seem to listen when spoken to directly',
    'Does not follow through on instructions; fails to finish work',
    'Difficulty organising tasks and activities',
    'Avoids or dislikes tasks requiring sustained mental effort',
    'Loses things necessary for tasks or activities',
    'Easily distracted by extraneous stimuli',
    'Forgetful in daily activities',
    'Fidgets, taps hands/feet, squirms in seat',
    'Leaves seat when remaining seated is expected',
    'Runs about or climbs where inappropriate (or feels restless)',
    'Unable to play or engage in activities quietly',
    'On the go / acts as if driven by a motor',
    'Talks excessively',
    'Blurts out answers before questions are completed',
    'Difficulty waiting their turn',
    'Interrupts or intrudes on others',
  ],
  threshold: 6,
  metAdvice:
      '≥6 criteria in EITHER domain (inattention OR hyperactivity-impulsivity) supports ADHD, if present ≥6 months, in ≥2 settings, with onset before age 12. Refer for full assessment.',
  notMetAdvice:
      'Fewer than 6 in a single domain. Note: the count must reach 6 WITHIN one domain (first 9 = inattention, last 9 = hyperactivity-impulsivity), not across both.',
  notes: const [
    'Criteria 1–9 = inattention; criteria 10–18 = hyperactivity-impulsivity.',
    'Age ≥17 y and adults: threshold drops to 5 in a domain.',
    'Requires onset of several symptoms before age 12 and impairment in ≥2 settings.',
  ],
);

final oddScore = _criteria(
  title: 'Oppositional Defiant Disorder',
  subtitle: 'DSM-5 criteria — angry/irritable mood, argumentative behaviour, vindictiveness.',
  criteria: const [
    'Often loses temper',
    'Often touchy or easily annoyed',
    'Often angry and resentful',
    'Often argues with authority figures / adults',
    'Often actively defies or refuses to comply with rules or requests',
    'Often deliberately annoys others',
    'Often blames others for their mistakes or misbehaviour',
    'Spiteful or vindictive at least twice in the past 6 months',
  ],
  threshold: 4,
  metAdvice:
      '≥4 symptoms for ≥6 months, during interaction with at least one non-sibling, supports ODD. Assess severity by number of settings involved.',
  notMetAdvice: 'Fewer than 4 symptoms — threshold not met.',
  notes: const [
    'Children <5 y: behaviour should occur on most days for ≥6 months. Age ≥5 y: at least weekly.',
  ],
);

final conductDisorderScore = _criteria(
  title: 'Conduct Disorder',
  subtitle: 'DSM-5 criteria — repetitive violation of others’ rights or major age-appropriate norms.',
  criteria: const [
    'Bullies, threatens or intimidates others',
    'Initiates physical fights',
    'Used a weapon that can cause serious harm',
    'Physically cruel to people',
    'Physically cruel to animals',
    'Stolen while confronting a victim (mugging, extortion)',
    'Forced someone into sexual activity',
    'Deliberately engaged in fire-setting with intent to cause damage',
    'Deliberately destroyed others’ property (other than fire)',
    'Broken into someone’s house, building or car',
    'Lies to obtain goods/favours or to avoid obligations ("cons")',
    'Stolen items of nontrivial value without confronting a victim',
    'Stays out at night despite parental prohibition (before age 13)',
    'Run away from home overnight ≥2 times (or once, lengthy)',
    'Often truant from school, beginning before age 13',
  ],
  threshold: 3,
  metAdvice:
      '≥3 criteria in the past 12 months, with ≥1 in the past 6 months, supports conduct disorder. Specify childhood-onset (<10 y) or adolescent-onset.',
  notMetAdvice: 'Fewer than 3 criteria in the past 12 months.',
);

final dmddScore = _criteria(
  title: 'Disruptive Mood Dysregulation Disorder (DMDD)',
  subtitle: 'DSM-5 criteria — chronic severe irritability with temper outbursts.',
  criteria: const [
    'Severe recurrent temper outbursts (verbal and/or behavioural), grossly out of proportion',
    'Outbursts inconsistent with developmental level',
    'Outbursts occur ≥3 times per week on average',
    'Mood between outbursts is persistently irritable/angry most of the day, nearly every day',
    'Symptoms present ≥12 months, without a symptom-free period ≥3 months',
    'Symptoms present in ≥2 settings (home, school, with peers) and severe in at least one',
    'Age at diagnosis 6–18 years, with onset before age 10',
    'No distinct period >1 day meeting full manic/hypomanic criteria',
  ],
  threshold: 8,
  metAdvice:
      'All criteria met — consistent with DMDD. Cannot coexist with ODD, intermittent explosive disorder or bipolar disorder (DMDD takes precedence over ODD).',
  notMetAdvice: 'Not all required criteria are met — DMDD requires ALL of them.',
);

final scdScore = _criteria(
  title: 'Social (Pragmatic) Communication Disorder',
  subtitle: 'DSM-5 criteria — persistent difficulty with social use of verbal and nonverbal communication.',
  criteria: const [
    'Deficits using communication for social purposes (greeting, sharing information)',
    'Impaired ability to change communication to match context or listener',
    'Difficulty following rules for conversation and storytelling (turn-taking, rephrasing)',
    'Difficulty understanding what is not explicitly stated (inference, idioms, humour, ambiguity)',
    'Deficits cause functional limitations in communication or social participation',
    'Onset in the early developmental period',
    'Not attributable to another medical/neurological condition or low structural language ability',
    'Autism spectrum disorder has been ruled out (no restricted/repetitive behaviours)',
  ],
  threshold: 8,
  metAdvice:
      'All criteria met — consistent with social (pragmatic) communication disorder. ASD must be excluded before this diagnosis is used.',
  notMetAdvice: 'Not all criteria met — all are required for the diagnosis.',
);

// ── Mood ─────────────────────────────────────────────────────────────────────

final majorDepressiveScore = _criteria(
  title: 'Major Depressive Episode',
  subtitle: 'DSM-5 criteria — symptoms in the same 2-week period, a change from previous function.',
  criteria: const [
    'Depressed mood most of the day, nearly every day (children/adolescents: can be irritable mood)',
    'Markedly diminished interest or pleasure in almost all activities',
    'Significant weight change or appetite change (children: failure to make expected weight gain)',
    'Insomnia or hypersomnia nearly every day',
    'Psychomotor agitation or retardation observable by others',
    'Fatigue or loss of energy nearly every day',
    'Feelings of worthlessness or excessive/inappropriate guilt',
    'Diminished ability to think or concentrate; indecisiveness',
    'Recurrent thoughts of death, suicidal ideation, or a suicide attempt/plan',
  ],
  threshold: 5,
  metAdvice:
      '≥5 symptoms over the same 2 weeks — and at least ONE must be depressed mood or loss of interest. Assess suicide risk now and arrange mental-health review.',
  notMetAdvice: 'Fewer than 5 symptoms in the same 2-week period.',
  notes: const [
    'At least one of the first two criteria (depressed mood / anhedonia) must be present.',
    'Always ask directly about suicidal ideation and safety, regardless of total.',
  ],
);

final dysthymiaScore = _criteria(
  title: 'Persistent Depressive Disorder (Dysthymia)',
  subtitle: 'DSM-5 criteria — depressed mood for most of the day, more days than not, ≥1 year in children.',
  criteria: const [
    'Poor appetite or overeating',
    'Insomnia or hypersomnia',
    'Low energy or fatigue',
    'Low self-esteem',
    'Poor concentration or difficulty making decisions',
    'Feelings of hopelessness',
  ],
  threshold: 2,
  metAdvice:
      '≥2 symptoms alongside depressed/irritable mood for ≥1 year (children & adolescents; ≥2 years in adults), never symptom-free >2 months.',
  notMetAdvice: 'Fewer than 2 accompanying symptoms.',
);

final manicEpisodeScore = _criteria(
  title: 'Manic Episode',
  subtitle: 'DSM-5 criteria — distinct period of abnormally elevated/irritable mood and increased energy.',
  criteria: const [
    'Inflated self-esteem or grandiosity',
    'Decreased need for sleep (rested after 3 hours)',
    'More talkative than usual or pressure to keep talking',
    'Flight of ideas or racing thoughts',
    'Distractibility',
    'Increase in goal-directed activity or psychomotor agitation',
    'Excessive involvement in activities with high risk of painful consequences',
  ],
  threshold: 3,
  metAdvice:
      '≥3 symptoms (≥4 if mood is only irritable) during ≥1 week of elevated mood and increased energy — manic episode. Urgent psychiatric referral.',
  notMetAdvice: 'Fewer than 3 symptoms in the mood period.',
  notes: const [
    'Mania: ≥1 week (or any duration if hospitalisation needed). Hypomania: ≥4 consecutive days without marked impairment or psychosis.',
    'If mood is irritable rather than elevated, 4 symptoms are required.',
  ],
);

// ── Anxiety ──────────────────────────────────────────────────────────────────

final gadScore = _criteria(
  title: 'Generalized Anxiety Disorder',
  subtitle: 'DSM-5 criteria — excessive anxiety and worry, more days than not, ≥6 months.',
  criteria: const [
    'Restlessness or feeling keyed up / on edge',
    'Being easily fatigued',
    'Difficulty concentrating or mind going blank',
    'Irritability',
    'Muscle tension',
    'Sleep disturbance (difficulty falling/staying asleep, restless sleep)',
  ],
  threshold: 1,
  metAdvice:
      'CHILDREN need only 1 of these 6 symptoms (adults need 3), with excessive worry that is difficult to control on more days than not for ≥6 months.',
  notMetAdvice: 'No associated symptom endorsed.',
  notes: const [
    'Threshold shown is the paediatric one (1 symptom). Adults require ≥3.',
  ],
);

final separationAnxietyScore = _criteria(
  title: 'Separation Anxiety Disorder',
  subtitle: 'DSM-5 criteria — developmentally inappropriate fear of separation from attachment figures.',
  criteria: const [
    'Recurrent excessive distress when anticipating or experiencing separation from home/attachment figures',
    'Persistent excessive worry about losing major attachment figures or harm to them',
    'Persistent excessive worry about an event causing separation (getting lost, kidnapped, ill)',
    'Persistent reluctance or refusal to go out, to school or elsewhere because of separation fear',
    'Persistent excessive fear of being alone or without attachment figures',
    'Persistent reluctance or refusal to sleep away from home or without an attachment figure nearby',
    'Repeated nightmares involving the theme of separation',
    'Repeated physical complaints (headache, stomach ache, nausea) when separation occurs or is anticipated',
  ],
  threshold: 3,
  metAdvice:
      '≥3 criteria, lasting ≥4 weeks in children/adolescents, with significant distress or impairment.',
  notMetAdvice: 'Fewer than 3 criteria endorsed.',
);

final socialPhobiaScore = _criteria(
  title: 'Social Anxiety Disorder (Social Phobia)',
  subtitle: 'DSM-5 criteria — marked fear of social situations with possible scrutiny.',
  criteria: const [
    'Marked fear/anxiety about ≥1 social situation involving possible scrutiny by others',
    'Fears acting in a way, or showing anxiety, that will be negatively evaluated',
    'Social situations almost always provoke fear or anxiety (children: crying, tantrums, freezing, clinging, failing to speak)',
    'Social situations are avoided or endured with intense fear',
    'Fear is out of proportion to the actual threat posed',
    'Persistent, typically lasting ≥6 months',
    'Causes clinically significant distress or impairment',
    'Occurs in peer settings, not just with adults (required in children)',
  ],
  threshold: 8,
  metAdvice:
      'All criteria met — consistent with social anxiety disorder. In children the anxiety must occur in peer settings, not only during interactions with adults.',
  notMetAdvice: 'Not all criteria met — DSM-5 requires all of them.',
);

final panicAgoraphobiaScore = _criteria(
  title: 'Panic Disorder / Agoraphobia',
  subtitle: 'DSM-5 panic-attack symptom list — abrupt surge of intense fear peaking within minutes.',
  criteria: const [
    'Palpitations, pounding heart or accelerated heart rate',
    'Sweating',
    'Trembling or shaking',
    'Sensations of shortness of breath or smothering',
    'Feelings of choking',
    'Chest pain or discomfort',
    'Nausea or abdominal distress',
    'Feeling dizzy, unsteady, light-headed or faint',
    'Chills or heat sensations',
    'Paraesthesias (numbness or tingling)',
    'Derealisation or depersonalisation',
    'Fear of losing control or going crazy',
    'Fear of dying',
  ],
  threshold: 4,
  metAdvice:
      '≥4 symptoms peaking within minutes = a panic attack. Panic DISORDER additionally requires recurrent unexpected attacks plus ≥1 month of persistent worry about further attacks or maladaptive behaviour change.',
  notMetAdvice: 'Fewer than 4 symptoms — a limited-symptom attack rather than a full panic attack.',
  notes: const [
    'Agoraphobia: marked fear in ≥2 of — public transport, open spaces, enclosed places, queues/crowds, being outside the home alone.',
  ],
);

final ptsdYoungChildScore = _criteria(
  title: 'PTSD — Children 6 Years and Younger',
  subtitle: 'DSM-5 preschool subtype criteria after exposure to actual/threatened death, serious injury or sexual violence.',
  criteria: const [
    'Recurrent involuntary intrusive distressing memories (may be expressed in play)',
    'Recurrent distressing dreams related to the event',
    'Dissociative reactions / flashbacks (may be trauma-specific re-enactment in play)',
    'Intense or prolonged distress at exposure to reminders',
    'Marked physiological reactions to reminders',
    'Avoidance of activities, places or physical reminders',
    'Avoidance of people, conversations or interpersonal situations that are reminders',
    'Substantially increased frequency of negative emotional states (fear, guilt, sadness, shame, confusion)',
    'Markedly diminished interest or participation in significant activities, including play',
    'Socially withdrawn behaviour',
    'Persistent reduction in expression of positive emotions',
    'Irritable behaviour and angry outbursts (including extreme tantrums)',
    'Hypervigilance',
    'Exaggerated startle response',
    'Problems with concentration',
    'Sleep disturbance',
  ],
  threshold: 3,
  metAdvice:
      'Preschool PTSD needs ≥1 intrusion symptom (items 1–5), ≥1 avoidance OR negative-mood symptom (items 6–11), and ≥2 arousal symptoms (items 12–16), lasting >1 month.',
  notMetAdvice: 'Threshold not yet met — check the per-cluster minimums, not just the total.',
  notes: const [
    'Clusters: intrusion (1–5) ≥1 · avoidance/negative mood (6–11) ≥1 · arousal (12–16) ≥2.',
  ],
);

// ── Feeding & eating ─────────────────────────────────────────────────────────

final anorexiaScore = _criteria(
  title: 'Anorexia Nervosa',
  subtitle: 'DSM-5 criteria — restriction of energy intake with fear of weight gain.',
  criteria: const [
    'Restriction of energy intake leading to significantly low body weight for age, sex and health',
    'Intense fear of gaining weight or becoming fat, or persistent behaviour that interferes with weight gain',
    'Disturbance in the way body weight/shape is experienced, undue influence on self-evaluation, or lack of recognition of the seriousness of low weight',
  ],
  threshold: 3,
  metAdvice:
      'All 3 criteria met — consistent with anorexia nervosa. Specify restricting vs binge-eating/purging type. Assess medical stability (bradycardia, orthostasis, electrolytes) urgently.',
  notMetAdvice: 'Not all 3 criteria met.',
  notes: const [
    'In children, "significantly low weight" includes failure to make expected weight gain along the growth trajectory.',
  ],
);

final bulimiaScore = _criteria(
  title: 'Bulimia Nervosa',
  subtitle: 'DSM-5 criteria — recurrent binge eating with compensatory behaviours.',
  criteria: const [
    'Recurrent episodes of binge eating (large amount in a discrete period + sense of lack of control)',
    'Recurrent inappropriate compensatory behaviour (vomiting, laxatives, fasting, excessive exercise)',
    'Binges and compensatory behaviours both occur ≥1×/week for 3 months',
    'Self-evaluation unduly influenced by body shape and weight',
    'Does not occur exclusively during episodes of anorexia nervosa',
  ],
  threshold: 5,
  metAdvice:
      'All criteria met — consistent with bulimia nervosa. Check electrolytes, dental erosion and cardiac status.',
  notMetAdvice: 'Not all criteria met.',
);

final bingeEatingScore = _criteria(
  title: 'Binge Eating Disorder',
  subtitle: 'DSM-5 criteria — recurrent binge eating without regular compensatory behaviour.',
  criteria: const [
    'Eating much more rapidly than normal',
    'Eating until feeling uncomfortably full',
    'Eating large amounts when not physically hungry',
    'Eating alone because of embarrassment about how much one is eating',
    'Feeling disgusted, depressed or very guilty afterwards',
  ],
  threshold: 3,
  metAdvice:
      '≥3 features, with binge episodes ≥1×/week for 3 months, marked distress, and NO regular compensatory behaviour — consistent with binge eating disorder.',
  notMetAdvice: 'Fewer than 3 features endorsed.',
);

final arfidScore = _criteria(
  title: 'Avoidant/Restrictive Food Intake Disorder (ARFID)',
  subtitle: 'DSM-5 criteria — eating disturbance without body-image disturbance.',
  criteria: const [
    'Significant weight loss or failure to achieve expected weight gain / faltering growth',
    'Significant nutritional deficiency',
    'Dependence on enteral feeding or oral nutritional supplements',
    'Marked interference with psychosocial functioning',
  ],
  threshold: 1,
  metAdvice:
      '≥1 consequence present with an eating/feeding disturbance — consistent with ARFID, provided there is no body-image disturbance and no lack of available food or culturally sanctioned practice.',
  notMetAdvice: 'No listed consequence — ARFID requires at least one.',
  notes: const [
    'Must NOT be explained by anorexia/bulimia (no disturbance in body weight or shape experience).',
  ],
);

final bodyDysmorphicScore = _criteria(
  title: 'Body Dysmorphic Disorder',
  subtitle: 'DSM-5 criteria — preoccupation with perceived defects in physical appearance.',
  criteria: const [
    'Preoccupation with ≥1 perceived defect in appearance not observable or slight to others',
    'Repetitive behaviours (mirror checking, grooming, skin picking, reassurance seeking) or mental acts (comparing) in response',
    'Preoccupation causes clinically significant distress or impairment',
    'Preoccupation is not better explained by concerns with body fat/weight in an eating disorder',
  ],
  threshold: 4,
  metAdvice:
      'All criteria met — consistent with body dysmorphic disorder. Specify muscle dysmorphia and degree of insight; screen for depression and suicidality.',
  notMetAdvice: 'Not all criteria met.',
);

/// Every DSM-5 screen, in hub display order.
final List<ScoreDef> psychosocialScores = [
  adhdInattentiveScore,
  oddScore,
  conductDisorderScore,
  dmddScore,
  scdScore,
  majorDepressiveScore,
  dysthymiaScore,
  manicEpisodeScore,
  gadScore,
  separationAnxietyScore,
  socialPhobiaScore,
  panicAgoraphobiaScore,
  ptsdYoungChildScore,
  anorexiaScore,
  bulimiaScore,
  bingeEatingScore,
  arfidScore,
  bodyDysmorphicScore,
];
