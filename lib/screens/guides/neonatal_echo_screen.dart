import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../calculators/echo_calculators_screen.dart';

// ── Window colour map ────────────────────────────────────────────────────────
const Color _subcostalColor    = Color(0xFF1565C0);
const Color _apicalColor       = Color(0xFFC62828);
const Color _parasternalColor  = Color(0xFF2E7D32);
const Color _suprasternalColor = Color(0xFF6A1B9A);

const Color _green  = Color(0xFF2E7D32);
const Color _red    = Color(0xFFB71C1C);
const Color _amber  = Color(0xFFF57F17);

// ── Data models ──────────────────────────────────────────────────────────────
class _NormalValue {
  final String label;
  final String value;
  final String note;
  final String severity; // 'normal', 'abnormal', 'note'
  const _NormalValue(
    this.label,
    this.value, {
    this.note = '',
    this.severity = 'normal',
  });
}

class _Measurement {
  final String name;
  final String window; // Subcostal, Apical, Parasternal, Suprasternal
  final String optimalView;
  final List<String> howToGet;
  final String technique;
  final String standardsLandmarks;
  final List<_NormalValue> normalValues;
  final String remarks;
  final String source;
  final List<String> functions;
  const _Measurement({
    required this.name,
    required this.window,
    required this.optimalView,
    required this.howToGet,
    required this.technique,
    required this.standardsLandmarks,
    required this.normalValues,
    required this.remarks,
    required this.source,
    required this.functions,
  });
}

// ── All 23 measurements ──────────────────────────────────────────────────────
const List<_Measurement> _measurements = [
  // 1. IVC Collapsibility
  _Measurement(
    name: 'IVC Collapsibility',
    window: 'Subcostal',
    optimalView: "12 O'clock, right tilt",
    howToGet: [
      "Place probe just below xiphoid, point toward right shoulder (12 O'clock, right tilt)",
      'Identify hepatic vein tributary entering IVC as landmark',
      'Switch to M-mode through the IVC',
      'Measure maximum IVC diameter (during expiration) and minimum (during inspiration)',
      'In mechanically ventilated infants, measure max and min over respiratory cycle',
      'Calculate: (Max − Min)/Max × 100',
    ],
    technique: 'Max diameter and min diameter (Max − Min)/Max × 100',
    standardsLandmarks: 'Hepatic vein tributary entering IVC',
    normalValues: [
      _NormalValue(
        'Spontaneously breathing — normal',
        '<50%',
        note: 'Collapsibility >50% is abnormal',
        severity: 'normal',
      ),
      _NormalValue(
        'Mechanically ventilated — use distensibility instead',
        'Use IVC distensibility formula',
        note: 'Collapsibility index less reliable in ventilated infants',
        severity: 'note',
      ),
    ],
    remarks: 'M-mode preferred than 2D. Data required for normal values. >50% is abnormal. Useful in spontaneously breathing subjects',
    source: 'Singh Y. Echocardiographic evaluation of hemodynamics in neonates and children. Front Pediatr. 2017;5:201',
    functions: ['Fluid Assessment', 'Volume Status'],
  ),

  // 2. IVC Distensibility
  _Measurement(
    name: 'IVC Distensibility',
    window: 'Subcostal',
    optimalView: 'Same as IVC collapsibility',
    howToGet: [
      'Same probe position as IVC collapsibility',
      'Measure maximum IVC diameter (during peak inspiration on ventilator)',
      'Measure minimum IVC diameter (during expiration)',
      'Calculate: (Max − Min)/Min × 100',
    ],
    technique: '(Max − Min)/Min × 100',
    standardsLandmarks: 'Same',
    normalValues: [
      _NormalValue(
        'Mechanically ventilated neonates',
        '>18% suggests fluid responsiveness',
        note: 'Values vary; trending more important than single reading',
        severity: 'normal',
      ),
    ],
    remarks: 'Useful in mechanically ventilated subjects',
    source: 'Singh Y. Echocardiographic evaluation of hemodynamics in neonates and children. Front Pediatr. 2017;5:201',
    functions: ['Fluid Assessment', 'Volume Status'],
  ),

  // 3. SVC Flow Velocity
  _Measurement(
    name: 'SVC Flow Velocity',
    window: 'Subcostal',
    optimalView: "Modified 3 O'clock, slight tilt toward right shoulder",
    howToGet: [
      "Start at subcostal 12 O'clock position",
      "Tilt probe to modified 3 O'clock, slight rightward tilt toward shoulder",
      'Identify SVC entering right atrium',
      'Add colour Doppler, choose low scale',
      'Beware of simultaneous L–R shunt through PFO — this can contaminate the signal',
      'Place PWD sample gate just inside SVC-RA junction',
      'Record at least three (ideally five) respiratory cycles',
      'Include the negative wave in VTI calculation',
      'Calculate SVC flow: VTI × π(d/2)² × HR ÷ weight(kg) in mL/kg/min',
    ],
    technique: 'PWD, sample gate just inside SVC-RA junction, at least three respiratory cycles',
    standardsLandmarks: 'Add color, choose low scale, beware of simultaneous L–R shunt through PFO',
    normalValues: [
      _NormalValue(
        'Preterm <30 wks (day 1–3)',
        '41–120 mL/kg/min',
        note: 'Low SVC flow (<41 mL/kg/min) associated with IVH risk',
        severity: 'normal',
      ),
      _NormalValue(
        'Preterm 30–36 wks',
        '50–150 mL/kg/min',
        severity: 'normal',
      ),
      _NormalValue(
        'Term ≥37 wks',
        '55–155 mL/kg/min',
        severity: 'normal',
      ),
      _NormalValue(
        'Abnormal (all GA)',
        '<41 mL/kg/min = low flow',
        note: 'Associated with poor neurodevelopmental outcomes in preterm',
        severity: 'abnormal',
      ),
    ],
    remarks: 'More than five cycles for research usage. Include the negative wave also for VTI calculation',
    source: 'Kluckow M, Evans N. Low superior vena cava flow and intraventricular haemorrhage in preterm infants. Arch Dis Child Fetal Neonatal Ed. 2000;82:F188–F194',
    functions: ['Cardiac Output', 'Hemodynamics'],
  ),

  // 4. Shunt through PFO
  _Measurement(
    name: 'Shunt through PFO',
    window: 'Subcostal',
    optimalView: "3 O'clock, head tilt",
    howToGet: [
      'Subcostal position, head tilt toward thorax',
      'Add colour Doppler at moderate scale (30–50 cm/s)',
      'Identify PFO in interatrial septum',
      'Place PWD gate at the PFO',
      'Determine direction of shunt: L→R (blue) or R→L (red)',
      'Note velocity and pattern',
    ],
    technique: 'PWD, sample gate at the PFO',
    standardsLandmarks: 'Add color, choose moderate scale (30–50), through PFO',
    normalValues: [
      _NormalValue(
        'Transitional period (first 24–72 hrs)',
        'R→L or bidirectional shunt expected',
        note: 'Purely R→L beyond 72 hrs suggests persistent pulmonary hypertension',
        severity: 'note',
      ),
      _NormalValue(
        'After transitional period',
        'Small L→R shunt or closed — normal',
        severity: 'normal',
      ),
    ],
    remarks: 'Colour scale 30–50 cm/s optimal for low-velocity shunt visualisation',
    source: 'Jain A, McNamara PJ. Persistent pulmonary hypertension of the newborn. Semin Fetal Neonatal Med. 2015;20:262–271',
    functions: ['Shunt Assessment'],
  ),

  // 5. UVC Tip
  _Measurement(
    name: 'UVC Tip',
    window: 'Subcostal',
    optimalView: "12 O'clock, right tilt",
    howToGet: [
      'Subcostal position, right tilt',
      'Identify ductus venosus (DV) — enters IVC from below',
      'Colour Doppler helps identify DV flow',
      'Watch for subtle back-and-forth movement of catheter tip during insertion',
      'UVC should enter IVC via DV — not directly',
      'Tip should be at junction of IVC and right atrium, not in RA',
      'Reduce sample gate width to 1 mm',
      'Use moderate Doppler colour scale',
      'Angle correction may be required due to acute caudal turn of both vessels',
    ],
    technique: 'Identify DV, enters IVC through DV. Visualize DV',
    standardsLandmarks: 'Vertebra should be near running anterior to the aorta, fully seen with aorta',
    normalValues: [
      _NormalValue(
        'Correct UVC tip position',
        'IVC-RA junction (T8–T9 level on X-ray)',
        note: 'On echo: tip seen at IVC–RA junction, not floating in RA',
        severity: 'normal',
      ),
      _NormalValue(
        'Malposition',
        'Tip in RA, RV, hepatic veins, or portal vein = reposition',
        note: 'UVC in portal circulation risks hepatic injury',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Can be tracked while placing UVC. Subtle back and forth movement before fixation helps to locate the tip better.',
    source: 'Jain A, Mohamed A, El-Khuffash A, et al. J Am Soc Echocardiogr. 2014',
    functions: ['Line Placement'],
  ),

  // 6. Celiac and SMA Doppler
  _Measurement(
    name: 'Celiac and SMA Doppler',
    window: 'Subcostal',
    optimalView: "12 O'clock left tilt, 3 O'clock position, slight leg tilt",
    howToGet: [
      'Subcostal position, slight left tilt to visualise abdominal aorta in long axis',
      'Vertebra should appear near, running anterior to aorta, fully seen',
      'First branch off aorta = celiac trunk; follow by SMA',
      'Reduce scale to 30–50 cm/s (moderate colour Doppler)',
      'Place PWD gate in proximal portion of vessel',
      'Trace diastolic waveform to get mean and peak diastolic velocity',
    ],
    technique: 'View abdominal aorta long axis, first branch is celiac trunk followed by SMA PWD, sample gate in proximal portion',
    standardsLandmarks: 'Vertebra near and running anterior to aorta, fully seen with aorta',
    normalValues: [
      _NormalValue(
        'Celiac trunk — peak systolic velocity',
        '60–120 cm/s',
        note: 'Diastolic forward flow present normally',
        severity: 'normal',
      ),
      _NormalValue(
        'SMA — peak systolic velocity',
        '50–100 cm/s',
        note: 'Absent or reversed diastolic flow in NEC risk',
        severity: 'normal',
      ),
      _NormalValue(
        'SMA diastolic flow absent/reversed',
        'Abnormal — risk of gut ischaemia',
        note: 'Especially concerning in context of feeding intolerance',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Moderate Doppler color scale. Angle correction important for accurate velocity',
    source: 'Murdoch EM, et al. Doppler flow velocimetry in the SMA on the first day of life. Pediatr Res. 2006',
    functions: ['Gut Perfusion'],
  ),

  // 7. Ejection Fraction (EF)
  _Measurement(
    name: 'Ejection Fraction (EF)',
    window: 'Apical',
    optimalView: "3 O'clock, below left nipple, may move lateral, may rotate to 2 O'clock",
    howToGet: [
      "Place probe below left nipple at 3 O'clock; tilt toward 2 O'clock if needed",
      'Heart should appear VERTICAL on screen — if tilted, reposition',
      'Check for moderator band in RV to confirm orientation',
      'Four-chamber view first — check for LV foreshortening',
      'Include papillary muscles in LV tracing',
      'Use ECG or MV opening/closure to time end-diastole and end-systole',
      'Biplane Simpson required: trace LV endocardium in 4-chamber AND 2-chamber',
      'Trace blood–endocardial interface until straight line connecting MV annulus is reached',
      'EF = (EDV − ESV)/EDV × 100',
      'Check for papillary muscles and trabeculae — include them in the traced area',
    ],
    technique: 'Biplane Simpson. Two planes required. Trace blood–endocardial interface till straight line connecting MV annulus is reached',
    standardsLandmarks: 'Should see vertically placed heart. Check for moderator band in RV',
    normalValues: [
      _NormalValue(
        'Normal LV EF (all neonates)',
        '55–80%',
        note: 'Hyperdynamic if >80%; Simpson biplane preferred method',
        severity: 'normal',
      ),
      _NormalValue(
        'Mild dysfunction',
        '45–54%',
        severity: 'note',
      ),
      _NormalValue(
        'Moderate dysfunction',
        '30–44%',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Severe dysfunction',
        '<30%',
        note: 'Urgent escalation required',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Shortening fraction (SF) — normal',
        '28–40%',
        note: 'Use discouraged by ASE; use EF if possible',
        severity: 'note',
      ),
    ],
    remarks: 'Identifying endocardium at apex is crucial. Check for foreshortening. Include papillary muscles.',
    source: 'Tissot C, Singh Y, Sekarski N. Front Pediatr. 2018;6:79. ASE/CSE TNE Guidelines 2024',
    functions: ['LV Systolic Function'],
  ),

  // 8. LV Output (LVO)
  _Measurement(
    name: 'LV Output (LVO)',
    window: 'Apical',
    optimalView: 'Apical plus PLAX',
    howToGet: [
      'Apical 5-chamber or PLAX view — ascending aorta must appear as a tube originating from valve',
      'This confirms no foreshortening',
      'Measure LVOT diameter at sinotubular junction (STJ) in PLAX — most accurate location',
      'Place PWD sample volume at hinge point of aortic valve in apical 5-chamber',
      'Angle of insonation must be <20° — minimise angle',
      'Trace VTI of aortic flow',
      'Average over 3–5 cardiac cycles (avoid respiratory variation)',
      'Calculate: LVO (mL/kg/min) = VTI × π(d/2)² × HR ÷ weight(kg)',
    ],
    technique: 'Diameter from PLAX. VTI × π². Multiply by HR and divide by weight (kg)',
    standardsLandmarks: 'Should view ascending aorta as a tube originating from valve for a reasonable length',
    normalValues: [
      _NormalValue(
        'Preterm <32 wks (no shunts)',
        '150–300 mL/kg/min',
        note: 'Wide range; trending more useful than single value',
        severity: 'normal',
      ),
      _NormalValue(
        'Term ≥37 wks (no shunts)',
        '150–300 mL/kg/min',
        note: 'Mean ~222 mL/kg/min in stable term infants post-ductal closure',
        severity: 'normal',
      ),
      _NormalValue(
        'Low flow threshold (all)',
        '<150 mL/kg/min',
        note: 'Suggests compromised systemic perfusion',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Stroke volume (SV) sometimes more reliable. Tachycardia and errors in weight/BSA may affect output',
    source: 'Kluckow M, Evans N. Arch Dis Child Fetal Neonatal Ed. 2000. MRI validation: Groves AM, et al. 2011;96:F86',
    functions: ['Cardiac Output', 'Hemodynamics'],
  ),

  // 9. RV Output (RVO)
  _Measurement(
    name: 'RV Output (RVO)',
    window: 'Parasternal',
    optimalView: 'PLAX or PSAX',
    howToGet: [
      'Parasternal long or short axis view',
      'Measure MPA diameter at pulmonary valve hinge points in same plane as Doppler',
      'Both VTI and annulus must be measured in the same plane',
      'Place PWD sample at pulmonary valve hinge point',
      'Angle of insonation <20°',
      'Trace VTI, average over 3–5 cycles',
      'Calculate: RVO (mL/kg/min) = VTI × π(d/2)² × HR ÷ weight(kg)',
    ],
    technique: 'MPA VTI and diameter, VTI × π². Multiply by HR and divide by weight (kg)',
    standardsLandmarks: 'View RA, TV, and RV. Measure a complete Doppler envelope',
    normalValues: [
      _NormalValue(
        'Preterm and term (no shunts)',
        '150–300 mL/kg/min',
        note: 'Similar range to LVO when no shunts present. Mean ~219 mL/kg/min',
        severity: 'normal',
      ),
      _NormalValue(
        'Low flow',
        '<150 mL/kg/min',
        note: 'Suggests RV dysfunction or raised PVR',
        severity: 'abnormal',
      ),
    ],
    remarks: 'SV should be more reliable. Tachycardia and weight/BSA errors affect output',
    source: 'Groves AM, et al. Functional cardiac MRI in preterm and term newborns. Arch Dis Child Fetal Neonatal Ed. 2011;96:F86–F91',
    functions: ['Cardiac Output', 'Hemodynamics'],
  ),

  // 10. LA/Ao Ratio
  _Measurement(
    name: 'LA/Ao Ratio',
    window: 'Parasternal',
    optimalView: "PLAX, 11 O'clock, third left intercostal space",
    howToGet: [
      "Parasternal long axis view at 11 O'clock",
      'M-mode preferred; 2D acceptable',
      'Scan line through aortic valve and LA at widest diameter',
      'In M-mode: open aortic valvelets form a parallelogram — measure LA at widest point',
      'Both LA and Ao measured at LV systole (when aortic valve is open)',
      'LA diameter = widest point posterior to aortic root',
      'Ao diameter = inner edge of anterior aortic wall to inner edge of posterior wall',
      'LA/Ao = LA diameter ÷ Ao diameter',
    ],
    technique: 'M-mode preferred, 2D acceptable. LA at LV systole when aortic valve is open',
    standardsLandmarks: 'M-mode shows open valvelets of aorta — both corresponding to LV systole (parallelogram)',
    normalValues: [
      _NormalValue(
        'Normal (all neonates)',
        '≤1.4',
        note: 'Ratio increases with significant L→R ductal shunt',
        severity: 'normal',
      ),
      _NormalValue(
        'Haemodynamically significant PDA',
        '>1.5',
        note: 'LA/Ao >1.5 suggests significant volume load from PDA',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Large PDA',
        '>1.8',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Largest and smallest aortic diameter gives SF alternatively. High interobserver variability',
    source: 'El-Khuffash AF, et al. J Pediatr. 2011',
    functions: ['PDA Assessment', 'Shunt Assessment'],
  ),

  // 11. Shortening Fraction (SF)
  _Measurement(
    name: 'Shortening Fraction (SF)',
    window: 'Parasternal',
    optimalView: "11 O'clock, third left intercostal space",
    howToGet: [
      "Parasternal long axis, 11 O'clock",
      'M-mode preferred — scan line through MV tips',
      'Check MV is open and closed in M-mode capture',
      'Measure LVED (diastole — MV open) and LVES (systole — MV closed)',
      'Use ECG to time measurements precisely',
      'SF = (LVED − LVES)/LVED × 100',
    ],
    technique: 'M-mode preferred, 2D acceptable. Scan line through MV tips',
    standardsLandmarks: 'Check for open and closed MV in M-mode capture. ECG or MV can be used for timing',
    normalValues: [
      _NormalValue(
        'Normal neonates (all GA)',
        '28–40%',
        note: 'ASE discourages exclusive use; favour EF where possible',
        severity: 'normal',
      ),
      _NormalValue(
        'Reduced',
        '<28% — impaired LV systolic function',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Hyperdynamic',
        '>40%',
        note: 'Common in sepsis, anaemia, significant PDA',
        severity: 'note',
      ),
    ],
    remarks: 'SF is unreliable in septal flattening and high PVR',
    source: 'Tissot C, Singh Y, Sekarski N. Front Pediatr. 2018;6:79. ASE Neonatal Echo Guidelines 2024',
    functions: ['LV Systolic Function'],
  ),

  // 12. MPA Doppler
  _Measurement(
    name: 'MPA Doppler',
    window: 'Parasternal',
    optimalView: "PLAX (11 O'clock) or PSAX (1 O'clock), slight tilt toward left shoulder",
    howToGet: [
      'PLAX or PSAX view',
      'CWD cursor in MPA between hinges and tips, middle of vessel',
      'Be as close to valve and as central in vessel as possible',
      'Trace waveform: get VTI and mean + peak diastolic velocity',
      'Trace diastolic waveform separately if present',
    ],
    technique: 'CWD cursor in MPA, between hinges and tips, middle of vessel',
    standardsLandmarks: 'Be as close to valve and center in vessel as possible',
    normalValues: [
      _NormalValue(
        'MPA peak systolic velocity',
        '60–110 cm/s',
        note: 'Higher velocity may suggest RVOTO or PPHN',
        severity: 'normal',
      ),
      _NormalValue(
        'Diastolic forward flow',
        'Present = normal',
        severity: 'normal',
      ),
      _NormalValue(
        'Diastolic retrograde flow in LPA',
        'Suggests significant L→R ductal shunt (PDA)',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Be as close to valve and center in vessel as possible',
    source: 'Jain A, McNamara PJ. Semin Fetal Neonatal Med. 2015;20:262–271',
    functions: ['Pulmonary Hypertension'],
  ),

  // 13. MPA Diameter
  _Measurement(
    name: 'MPA Diameter',
    window: 'Parasternal',
    optimalView: 'PLAX or PSAX, slight tilt toward left shoulder',
    howToGet: [
      'PLAX or PSAX — same position as MPA Doppler',
      '2D preferred; M-mode acceptable',
      'M-mode: scan line perpendicular to valve — hinges perpendicular to beam',
      'Measure upper hinge to lower hinge when valves fully open',
      'Use calliper function',
    ],
    technique: '2D preferred; M-mode scan valve hinges perpendicularly. Measure hinge to hinge when fully open',
    standardsLandmarks: 'Upper to lower hinge when fully open',
    normalValues: [
      _NormalValue(
        'Term neonate (≥37 wks)',
        '8–12 mm',
        note: 'Scales with weight and GA',
        severity: 'normal',
      ),
      _NormalValue(
        'Preterm 28–32 wks',
        '5–8 mm',
        severity: 'normal',
      ),
      _NormalValue(
        'MPA:Ao ratio',
        '≤1.2 normal',
        note: 'MPA > Ao suggests pulmonary hypertension',
        severity: 'note',
      ),
    ],
    remarks: 'Lower hinge not well visualised — attempt five-chamber apical view if needed',
    source: 'Mertens L, et al. Targeted neonatal echocardiography. J Am Soc Echocardiogr. 2011',
    functions: ['Pulmonary Hypertension'],
  ),

  // 14. LPA Doppler
  _Measurement(
    name: 'LPA Doppler',
    window: 'Parasternal',
    optimalView: "11 O'clock (PLAX) or 1 O'clock (PSAX), high, slight left shoulder tilt",
    howToGet: [
      'High parasternal view — tilt slightly left toward shoulder',
      'CWD cursor in LPA just after bifurcation, middle of vessel',
      'Trace diastolic waveform if present',
      'Diastolic forward flow in LPA is abnormal — suggests L→R ductal shunt',
    ],
    technique: 'CWD cursor in LPA, just after bifurcation, middle of vessel. Trace diastolic waveform',
    standardsLandmarks: 'Trace diastolic waveform to get mean and peak diastolic velocity',
    normalValues: [
      _NormalValue(
        'Normal',
        'Systolic forward flow only, no diastolic flow',
        severity: 'normal',
      ),
      _NormalValue(
        'Diastolic forward flow present',
        'Suggests significant L→R PDA shunt',
        note: 'The more diastolic flow, the larger the shunt',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Diastolic waveform in Doppler indicates left-to-right shunt, commonly due to PDA',
    source: 'El-Khuffash AF, et al. J Pediatr. 2011',
    functions: ['PDA Assessment'],
  ),

  // 15. TR Jet (PAPSp estimation)
  _Measurement(
    name: 'TR Jet (PAPSp)',
    window: 'Apical',
    optimalView: 'Apical — RV focused, slight tilt toward left shoulder. PSAX alternate',
    howToGet: [
      'Apical 4-chamber view, RV focused — tilt probe toward left shoulder',
      'Identify TR jet with colour Doppler',
      'CWD cursor on TV annulus/jet exit point',
      'Record multiple cycles to pick MAXIMUM velocity',
      'PAPSp = 4 × V² (simplified Bernoulli)',
      'Always check BOTH apical and parasternal views — measure maximum',
      'Jet velocity falsely reduced in significant RV dysfunction',
      'PLAX with right hip tilt recommended as alternate view',
    ],
    technique: 'CWD cursor on TV annulus/jet exit point. Record multiple cycles. PAPSp = 4 × V²',
    standardsLandmarks: 'Should see vertically placed heart in apical view. View RA, TV, and RV in PSAX',
    normalValues: [
      _NormalValue(
        'TR velocity — transitional period (0–72 hrs)',
        'Up to 3.0 m/s (PAPSp ~36 mmHg)',
        note: 'Transitional pulmonary hypertension is normal in first 72 hours',
        severity: 'note',
      ),
      _NormalValue(
        'TR velocity — after 72 hrs',
        '<2.8 m/s (PAPSp <31 mmHg)',
        note: 'PAPSp >35 mmHg after 72 hrs suggests PPHN',
        severity: 'normal',
      ),
      _NormalValue(
        'PAPSp normal (term)',
        '<35 mmHg after transitional period',
        severity: 'normal',
      ),
      _NormalValue(
        'Severe pulmonary hypertension',
        'PAPSp >2/3 systemic BP',
        note: 'Or flat/bowing IVS toward LV',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Always check TR jet in both apical and PSAX views. Jet velocity can be falsely reduced in significant RV dysfunction',
    source: 'Jain A, McNamara PJ. Semin Fetal Neonatal Med. 2015. ASE TNE Guidelines 2024',
    functions: ['Pulmonary Hypertension'],
  ),

  // 16. E/A Ratio
  _Measurement(
    name: 'E/A Ratio',
    window: 'Apical',
    optimalView: 'Same as EF; LV focused, slight tilt toward right shoulder',
    howToGet: [
      'Apical 4-chamber view, LV focused',
      'Add colour Doppler to visualise mitral inflow',
      'PWD gate between MV annulus and tips — just inside LV',
      'Freeze a short clip, move frame by frame in diastole',
      'Confirm gate is NOT above or below annulus and tips',
      'PWD gate should be more toward interventricular septal wall',
      'Measure E wave (passive filling) and A wave (atrial contraction)',
      'E/A = E peak velocity ÷ A peak velocity',
    ],
    technique: 'PWD in four-chamber. Sample gate between MV annulus and tips, just inside LV',
    standardsLandmarks: 'Gate not above or below annulus and tips. Move frame by frame to confirm',
    normalValues: [
      _NormalValue(
        'Term neonate (≥37 wks)',
        'E/A < 1 (A > E is normal)',
        note: 'Neonates rely heavily on atrial kick — A wave dominant is normal',
        severity: 'normal',
      ),
      _NormalValue(
        'Preterm neonate (<37 wks)',
        'E/A < 1 typically, but waves often fused',
        note: 'E and A waves merged at high heart rates — ratio unreliable',
        severity: 'note',
      ),
      _NormalValue(
        'E/A ≥ 1 in neonate',
        'Abnormal — suggests diastolic dysfunction or volume overload',
        severity: 'abnormal',
      ),
    ],
    remarks: 'E and A waves often merged in sick neonates due to high heart rate. Avoid measuring if waves fused',
    source: 'Mertens L, Friedberg MK. Nat Rev Cardiol. 2010;7:551–563. Tissot et al. Front Pediatr. 2018',
    functions: ['Diastolic Function'],
  ),

  // 17. IVRT
  _Measurement(
    name: 'IVRT',
    window: 'Apical',
    optimalView: 'Same as E/A ratio',
    howToGet: [
      'Apical 4-chamber view',
      'Make a 5-chamber view by tilting slightly anterior',
      'Add colour Doppler to visualise both inflow AND outflow jets simultaneously',
      'Place PWD gate inside LV at intersection of both jets',
      'Gate more toward interventricular septal wall',
      'IVRT = time from aortic valve closure to mitral valve opening',
      'Measure from end of ejection signal to start of E wave',
    ],
    technique: 'Make five-chamber view. Place PWD gate inside LV at intersection of both jets',
    standardsLandmarks: 'PWD placement point more toward interventricular septal wall',
    normalValues: [
      _NormalValue(
        'Term neonate',
        '35–65 ms',
        note: 'Prolonged IVRT suggests impaired relaxation',
        severity: 'normal',
      ),
      _NormalValue(
        'Preterm neonate',
        '30–60 ms',
        note: 'Values vary with heart rate',
        severity: 'normal',
      ),
      _NormalValue(
        'Prolonged IVRT',
        '>70 ms — diastolic dysfunction',
        severity: 'abnormal',
      ),
    ],
    remarks: 'See text for more description on 5-chamber technique',
    source: 'Mertens L, Friedberg MK. Nat Rev Cardiol. 2010;7:551–563',
    functions: ['Diastolic Function'],
  ),

  // 18. Septal Deviation
  _Measurement(
    name: 'Septal Deviation',
    window: 'Apical',
    optimalView: 'Four-chamber',
    howToGet: [
      'Apical 4-chamber view',
      'Freeze a frame with at least 5 cardiac cycles',
      'Watch for septal movement toward LV during end-systole',
      'In normal physiology: septum bows toward RV (LV pressure dominant)',
      'In pulmonary hypertension: septum flattens (D-shape LV) or bows toward LV',
      'End-systole push of septum toward LV = earliest indicator of septal deviation',
      'Confirm in parasternal short axis — D-sign = flattened LV cross-section',
    ],
    technique: 'Freeze frame with at least 5 cardiac cycles. Watch for septal movement',
    standardsLandmarks: '',
    normalValues: [
      _NormalValue(
        'Normal',
        'Septum bows toward RV — LV circular in cross-section',
        severity: 'normal',
      ),
      _NormalValue(
        'Diastolic septal flattening',
        'RV volume overload (e.g. large L→R shunt)',
        severity: 'note',
      ),
      _NormalValue(
        'Systolic septal flattening (D-sign)',
        'RV pressure overload — pulmonary hypertension',
        note: 'Eccentricity index >1.3 at end-systole confirms',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Septal bowing into LV',
        'Severe PPHN — RV pressure exceeds LV',
        severity: 'abnormal',
      ),
    ],
    remarks: 'End-systole push of septum toward LV is earliest indicator',
    source: 'Jain A, McNamara PJ. Semin Fetal Neonatal Med. 2015',
    functions: ['Pulmonary Hypertension'],
  ),

  // 19. Eccentricity Index
  _Measurement(
    name: 'Eccentricity Index',
    window: 'Parasternal',
    optimalView: "1 O'clock, PSAX, apical tilt, papillary muscle cut",
    howToGet: [
      'Parasternal short axis view at papillary muscle level',
      "1 O'clock, apical tilt",
      'LV should appear as a circle in cross-section normally',
      'Identify IVS position and shape',
      'Measure D2 (vertical diameter — through IVS midpoint and LV posterior free wall)',
      'Measure D1 (horizontal diameter — perpendicular to D2)',
      'Eccentricity Index = D1/D2',
    ],
    technique: 'Check IVS position. D2 through IVS midpoint and LV posterior free wall. D1 perpendicular to D2',
    standardsLandmarks: 'D2 through IVS midpoint. D1 perpendicular to D2',
    normalValues: [
      _NormalValue(
        'Normal',
        'D1/D2 = 1.0 (circular LV)',
        severity: 'normal',
      ),
      _NormalValue(
        'RV pressure overload',
        'D1/D2 > 1.3 at end-systole',
        note: 'Higher PAP causes IVS to flatten',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Severe',
        'D1/D2 > 1.5',
        note: 'IVS curves into LV — LV crescent shaped',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Newer measure, not much is known about this index as of now',
    source: 'Ryan T, et al. J Am Coll Cardiol. 1996',
    functions: ['Pulmonary Hypertension'],
  ),

  // 20. Pulmonary Artery Acceleration Time (PAAT)
  _Measurement(
    name: 'Pulmonary Artery Acceleration Time (PAAT)',
    window: 'Parasternal',
    optimalView: "1 O'clock, PSAX, slight tilt toward left shoulder",
    howToGet: [
      'PSAX view, 1 O\'clock',
      'CWD cursor in MPA between hinges and tips, middle of vessel',
      'Display RV systole waveform',
      'Calculate RVET: from start to end of the trace waveform',
      'Calculate time to peak velocity: from start of trace to peak',
      'PAAT = time from start of RV ejection to peak pulmonary velocity',
      'IMPORTANT: measure from start to EARLIEST peak, NOT mid-peak',
      'Waveform is more rounded and not wedge-shaped in high PAP',
    ],
    technique: 'CWD cursor in MPA. Display RV systole. PAAT from start to earliest peak',
    standardsLandmarks: 'Display RV systole. Calculate RVET from start to end',
    normalValues: [
      _NormalValue(
        'Normal PAAT (term)',
        '>65 ms (or PAATi >0.31)',
        note: 'Shorter PAAT = higher PVR',
        severity: 'normal',
      ),
      _NormalValue(
        'Pulmonary hypertension',
        'PAAT <55 ms (or PAATi <0.29)',
        note: 'PAAT/RVET <0.30 strongly suggests elevated PAP',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Severe PPHN',
        'PAAT <45 ms',
        note: 'Notching of waveform mid-systole also suggests elevated PVR',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Measure from start to EARLIEST peak. Important when waveform is rounded',
    source: 'Nair J, Lakshminrusimha S. Update on PPHN. Semin Perinatol. 2014',
    functions: ['Pulmonary Hypertension'],
  ),

  // 21. Ductal Assessment
  _Measurement(
    name: 'Ductal Assessment',
    window: 'Suprasternal',
    optimalView: "12–1 O'clock, slight tilt toward left shoulder",
    howToGet: [
      "Suprasternal position, 12–1 O'clock, tilt toward left shoulder",
      'Find three-legged stool: RPA, LPA, DA all visible',
      'More commonly you find two-legs (LPA and DA parallelly positioned)',
      'If two parallel vessels and not joining at an angle = LPA + DA',
      'TDD — measure at narrowest part in 2D (usually narrowest pulmonary end)',
      'Colour Doppler to identify direction and pattern',
      'Use CWD if velocity >2 m/s',
      'PWD sample gate at pulmonary end, distal to narrowest diameter',
      'Trace waveform for VTI and peak systolic velocity',
      'Classify ductal Doppler pattern: growing, closing, pulsatile, pulmonary hypertension',
    ],
    technique: 'Three-legged stool (RPA, LPA, DA). TDD in 2D at narrowest part. PWD at pulmonary end',
    standardsLandmarks: '',
    normalValues: [
      _NormalValue(
        'TDD — haemodynamically significant PDA',
        '>1.5 mm in preterm',
        note: 'Combined with clinical and other echo criteria',
        severity: 'abnormal',
      ),
      _NormalValue(
        'LA/Ao >1.5 + TDD >1.5 mm',
        'Suggests haemodynamically significant PDA',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Ductal flow pattern — closing',
        'Pulsatile, predominantly L→R, peak velocity rising >1.5 m/s',
        severity: 'normal',
      ),
      _NormalValue(
        'Ductal flow — pulmonary hypertension',
        'R→L or bidirectional flow',
        note: 'Indicates PVR ≥ SVR',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Ductal flow — growing',
        'Low velocity, laminar, L→R throughout',
        note: 'Suggests haemodynamic significance',
        severity: 'note',
      ),
    ],
    remarks: 'More commonly two-legs. Use CWD if velocity >2 m/s. Classify pattern',
    source: 'El-Khuffash AF, Weisz DE, McNamara PJ. Semin Fetal Neonatal Med. 2018',
    functions: ['PDA Assessment', 'Shunt Assessment'],
  ),

  // 22. Aortic Arch (DTA) Doppler
  _Measurement(
    name: 'Aortic Arch (DTA) Doppler',
    window: 'Suprasternal',
    optimalView: "Suprasternal/high parasternal 12 O'clock, slight left shoulder tilt",
    howToGet: [
      "Suprasternal position, 12 O'clock, slight left shoulder tilt",
      'Identify descending thoracic aorta (DTA) in colour Doppler',
      'Set colour scale at 50–70 cm/s',
      'Use PWD at diaphragm level',
      'Modify settings to allow visualisation of low-velocity flows',
      'Trace diastolic waveform if present',
      'Diastolic forward flow = systemic steal from PDA',
    ],
    technique: 'Color Doppler of DTA; set scale 50–70 cm/s; PWD at diaphragm level',
    standardsLandmarks: '',
    normalValues: [
      _NormalValue(
        'Normal',
        'Systolic forward flow only, no diastolic flow',
        severity: 'normal',
      ),
      _NormalValue(
        'DTA diastolic forward flow',
        'Indicates systemic steal — haemodynamically significant PDA',
        note: 'Flow going to lungs during diastole steals from systemic circulation',
        severity: 'abnormal',
      ),
      _NormalValue(
        'Absent or reversed diastolic flow in DTA',
        'Significant systemic hypoperfusion risk',
        note: 'Associated with NEC and IVH risk in preterm',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Modify settings to allow low-velocity flow visualisation',
    source: 'El-Khuffash AF, et al. J Pediatr. 2011. Kluckow M, Evans N. 2000',
    functions: ['PDA Assessment', 'Gut Perfusion'],
  ),

  // 23. Crab's View (Pulmonary Veins)
  _Measurement(
    name: "Crab's View (Pulmonary Veins)",
    window: 'Suprasternal',
    optimalView: "Suprasternal cross sectional, 2–3 O'clock",
    howToGet: [
      "Suprasternal cross-sectional view, 2–3 O'clock",
      'LA appears at back, with four pulmonary veins draining into it (crab shape)',
      'Right upper PV is usually best aligned with scan line',
      'Colour Doppler to identify all four veins',
      'PWD gate in each vein, confirm forward flow into LA',
      'In TAPVR: veins drain elsewhere — not into LA',
    ],
    technique: 'LA from back with four veins draining',
    standardsLandmarks: '',
    normalValues: [
      _NormalValue(
        'Normal',
        'All four pulmonary veins drain into LA',
        note: 'Confirm L+R upper and lower PV flow',
        severity: 'normal',
      ),
      _NormalValue(
        'TAPVR',
        'Veins absent from LA — drain to systemic circulation',
        note: 'Infradiaphragmatic TAPVR diagnosed from subcostal view',
        severity: 'abnormal',
      ),
    ],
    remarks: 'Usually right upper PV best aligns with scan line for measurement',
    source: 'NICE CG98 and standard TNE protocols',
    functions: ['Structural'],
  ),
];

// ── Function categories ──────────────────────────────────────────────────────
class _FunctionCategory {
  final String name;
  final IconData icon;
  final List<String> measurementNames;
  const _FunctionCategory(this.name, this.icon, this.measurementNames);
}

const List<_FunctionCategory> _functionCategories = [
  _FunctionCategory(
    'Fluid Assessment',
    Icons.water_drop,
    ['IVC Collapsibility', 'IVC Distensibility'],
  ),
  _FunctionCategory(
    'Cardiac Output',
    Icons.monitor_heart,
    ['SVC Flow Velocity', 'LV Output (LVO)', 'RV Output (RVO)'],
  ),
  _FunctionCategory(
    'LV Systolic Function',
    Icons.favorite,
    ['Ejection Fraction (EF)', 'Shortening Fraction (SF)'],
  ),
  _FunctionCategory(
    'Diastolic Function',
    Icons.graphic_eq,
    ['E/A Ratio', 'IVRT'],
  ),
  _FunctionCategory(
    'Pulmonary Hypertension',
    Icons.air,
    [
      'TR Jet (PAPSp)',
      'MPA Doppler',
      'MPA Diameter',
      'Eccentricity Index',
      'Pulmonary Artery Acceleration Time (PAAT)',
      'Septal Deviation',
    ],
  ),
  _FunctionCategory(
    'PDA Assessment',
    Icons.compare_arrows,
    [
      'LA/Ao Ratio',
      'LPA Doppler',
      'Ductal Assessment',
      'Aortic Arch (DTA) Doppler',
    ],
  ),
  _FunctionCategory(
    'Shunt Assessment',
    Icons.swap_horiz,
    ['Shunt through PFO', 'Ductal Assessment'],
  ),
  _FunctionCategory(
    'Gut Perfusion & Lines',
    Icons.restaurant,
    [
      'Celiac and SMA Doppler',
      'UVC Tip',
      "Crab's View (Pulmonary Veins)",
    ],
  ),
];

// ── Quick Ref data ───────────────────────────────────────────────────────────
const List<List<String>> _probePositions = [
  ['Subcostal', 'Below xiphoid, point to right shoulder (12 O\'clock)', 'IVC, SVC, UVC, Celiac/SMA, PFO'],
  ['Apical', 'Below left nipple, 3 O\'clock, tilt 2 O\'clock if needed', 'EF, LVO, TR Jet, E/A, IVRT, Septal deviation'],
  ['Parasternal', '11 O\'clock (PLAX) or 1 O\'clock (PSAX), 3rd L ICS', 'RVO, LA/Ao, SF, MPA, LPA, Eccentricity, PAAT'],
  ['Suprasternal', 'Above sternum, 12–1 O\'clock, tilt left shoulder', 'PDA, DTA, Pulmonary veins (Crab\'s)'],
];

const List<List<String>> _keyFormulae = [
  ['EF (Simpson Biplane)', '(EDV − ESV) / EDV × 100'],
  ['Cardiac Output', 'VTI × π(d/2)² × HR ÷ weight (kg) = mL/kg/min'],
  ['Simplified Bernoulli', 'Pressure gradient = 4 × V² (mmHg)'],
  ['Shortening Fraction', '(LVED − LVES) / LVED × 100'],
  ['PAAT', 'Time from start of RV ejection to peak pulmonary velocity (ms)'],
  ['LA/Ao', 'LA diameter ÷ Ao diameter (at LV systole)'],
  ['Eccentricity Index', 'D1 / D2 (D1 ⊥ to D2 through IVS)'],
  ['IVC Collapsibility', '(Max − Min) / Max × 100'],
  ['IVC Distensibility', '(Max − Min) / Min × 100'],
];

const List<List<String>> _abbreviations = [
  ['LVOT', 'Left ventricular outflow tract'],
  ['MPA', 'Main pulmonary artery'],
  ['LPA', 'Left pulmonary artery'],
  ['RPA', 'Right pulmonary artery'],
  ['PWD', 'Pulsed wave Doppler'],
  ['CWD', 'Continuous wave Doppler'],
  ['VTI', 'Velocity–time integral'],
  ['STJ', 'Sinotubular junction'],
  ['RVET', 'Right ventricular ejection time'],
  ['PAAT', 'Pulmonary artery acceleration time'],
  ['PAPSp', 'Pulmonary artery systolic pressure'],
  ['TDD', 'Transductal diameter'],
  ['IVRT', 'Isovolumic relaxation time'],
  ['IVS', 'Interventricular septum'],
  ['DTA', 'Descending thoracic aorta'],
  ['DV', 'Ductus venosus'],
  ['SVC', 'Superior vena cava'],
  ['IVC', 'Inferior vena cava'],
  ['PFO', 'Patent foramen ovale'],
  ['TAPVR', 'Total anomalous pulmonary venous return'],
  ['PPHN', 'Persistent pulmonary hypertension of the newborn'],
  ['PVR', 'Pulmonary vascular resistance'],
  ['SVR', 'Systemic vascular resistance'],
  ['GA', 'Gestational age'],
  ['PLAX', 'Parasternal long axis'],
  ['PSAX', 'Parasternal short axis'],
];

// ── Main screen ──────────────────────────────────────────────────────────────
class NeonatalEchoScreen extends StatefulWidget {
  const NeonatalEchoScreen({super.key});

  @override
  State<NeonatalEchoScreen> createState() => _NeonatalEchoScreenState();
}

class _NeonatalEchoScreenState extends State<NeonatalEchoScreen> {
  int _modeIndex = 0; // 0=By Window, 1=By Function, 2=Quick Ref

  Color _windowColor(String window) {
    switch (window) {
      case 'Subcostal':    return _subcostalColor;
      case 'Apical':       return _apicalColor;
      case 'Parasternal':  return _parasternalColor;
      case 'Suprasternal': return _suprasternalColor;
      default:             return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Neonatal 2D Echo',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            Text(
              'Point-of-Care Guide · Neonates',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        toolbarHeight: 64,
      ),
      body: Column(
        children: [
          // ── Mode selector ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                _modeChip(0, 'By Window', Icons.layers_outlined),
                const SizedBox(width: 8),
                _modeChip(1, 'By Function', Icons.category_outlined),
                const SizedBox(width: 8),
                _modeChip(2, 'Quick Ref', Icons.list_alt_outlined),
              ],
            ),
          ),
          const Divider(height: 1),
          // ── Content ────────────────────────────────────────────────────
          Expanded(
            child: _modeIndex == 0
                ? _buildByWindowMode(cs, cardColor)
                : _modeIndex == 1
                    ? _buildByFunctionMode(cs, cardColor)
                    : _buildQuickRefMode(cs, cardColor),
          ),
        ],
      ),
    );
  }

  Widget _modeChip(int idx, String label, IconData icon) {
    final selected = _modeIndex == idx;
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _modeIndex = idx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? cs.primary.withValues(alpha: 0.15)
                : cs.onSurface.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? cs.primary.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? cs.primary : cs.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? cs.primary : cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── MODE 1: By Window ────────────────────────────────────────────────────
  Widget _buildByWindowMode(ColorScheme cs, Color cardColor) {
    const windows = ['Subcostal', 'Apical', 'Parasternal', 'Suprasternal'];
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      children: [
        ...windows.map((window) {
          final windowMeasurements =
              _measurements.where((m) => m.window == window).toList();
          final color = _windowColor(window);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _WindowSection(
              window: window,
              color: color,
              measurements: windowMeasurements,
              cardColor: cardColor,
              cs: cs,
            ),
          );
        }),
        _echoCalculatorsButton(cs),
        const SizedBox(height: 10),
        _openWebsiteButton(cs),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── MODE 2: By Function ──────────────────────────────────────────────────
  Widget _buildByFunctionMode(ColorScheme cs, Color cardColor) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _functionCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, i) {
            final cat = _functionCategories[i];
            return _FunctionCategoryCard(
              category: cat,
              cardColor: cardColor,
              cs: cs,
              onTap: () => _showFunctionBottomSheet(cat, cs, cardColor),
            );
          },
        ),
        const SizedBox(height: 16),
        _echoCalculatorsButton(cs),
        const SizedBox(height: 10),
        _openWebsiteButton(cs),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showFunctionBottomSheet(
      _FunctionCategory cat, ColorScheme cs, Color cardColor) {
    final catMeasurements = cat.measurementNames
        .map((name) => _measurements.where((m) => m.name == name).firstOrNull)
        .whereType<_Measurement>()
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Icon(cat.icon, color: cs.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cat.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '${catMeasurements.length} measurement${catMeasurements.length != 1 ? 's' : ''}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                children: catMeasurements
                    .map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _MeasurementCard(
                            measurement: m,
                            cardColor: cardColor,
                            cs: cs,
                            windowColor: _windowColor(m.window),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── MODE 3: Quick Ref ────────────────────────────────────────────────────
  Widget _buildQuickRefMode(ColorScheme cs, Color cardColor) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      children: [
        // Probe Positions
        _sectionHeader('Probe Positions', Icons.explore_outlined, cs),
        const SizedBox(height: 8),
        _quickRefCard(
          cardColor: cardColor,
          cs: cs,
          child: Column(
            children: [
              _tableHeader(['Window', 'Position', 'Key Views'], cs),
              ..._probePositions.map((row) => _tableRow(row, cs)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Key Formulae
        _sectionHeader('Key Formulae', Icons.calculate_outlined, cs),
        const SizedBox(height: 8),
        _quickRefCard(
          cardColor: cardColor,
          cs: cs,
          child: Column(
            children: _keyFormulae.map((row) => _formulaRow(row, cs)).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Abbreviations
        _sectionHeader('Abbreviations', Icons.sort_by_alpha_outlined, cs),
        const SizedBox(height: 8),
        _quickRefCard(
          cardColor: cardColor,
          cs: cs,
          child: Wrap(
            spacing: 0,
            runSpacing: 0,
            children: _abbreviations
                .map((row) => _abbrRow(row, cs))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        _echoCalculatorsButton(cs),
        const SizedBox(height: 10),
        _openWebsiteButton(cs),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon, ColorScheme cs) {
    return Row(
      children: [
        Icon(icon, size: 18, color: cs.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _quickRefCard({
    required Color cardColor,
    required ColorScheme cs,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }

  Widget _tableHeader(List<String> cols, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: cols
            .map((c) => Expanded(
                  child: Text(
                    c,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _tableRow(List<String> cols, ColorScheme cs) {
    final windowColor = _windowColor(cols[0]);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.onSurface.withValues(alpha: 0.06))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: windowColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    cols[0],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: windowColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              cols[1],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              cols[2],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formulaRow(List<String> row, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.onSurface.withValues(alpha: 0.06))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              row[0],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              row[1],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: cs.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _abbrRow(List<String> row, ColorScheme cs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.onSurface.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              row[0],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              row[1],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _openWebsiteButton(ColorScheme cs) {
    return OutlinedButton.icon(
      onPressed: () async {
        final uri = Uri.parse(
            'https://www.neocardiolab.com/tnecho-and-neonatal-hemodynamics');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      icon: const Icon(Icons.open_in_new, size: 16),
      label: Text(
        'Full Reference — Open Website',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.primary,
        side: BorderSide(color: cs.primary.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// "Echo Calculators" CTA — jumps to the interactive calculator screen
  /// where the same echo formulas can be computed with live input.
  Widget _echoCalculatorsButton(ColorScheme cs) {
    return FilledButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EchoCalculatorsScreen(),
          ),
        );
      },
      icon: const Icon(Icons.calculate_outlined, size: 18),
      label: Text(
        'Useful Echo Calculators',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ── Window section widget ─────────────────────────────────────────────────────
class _WindowSection extends StatelessWidget {
  final String window;
  final Color color;
  final List<_Measurement> measurements;
  final Color cardColor;
  final ColorScheme cs;

  const _WindowSection({
    required this.window,
    required this.color,
    required this.measurements,
    required this.cardColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_windowIcon(window), color: color, size: 18),
          ),
          title: Text(
            window,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          subtitle: Text(
            '${measurements.length} measurement${measurements.length != 1 ? 's' : ''}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
          children: measurements
              .map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _MeasurementCard(
                      measurement: m,
                      cardColor: Theme.of(context).scaffoldBackgroundColor,
                      cs: cs,
                      windowColor: color,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  IconData _windowIcon(String window) {
    switch (window) {
      case 'Subcostal':    return Icons.vertical_align_bottom;
      case 'Apical':       return Icons.place;
      case 'Parasternal':  return Icons.linear_scale;
      case 'Suprasternal': return Icons.vertical_align_top;
      default:             return Icons.circle;
    }
  }
}

// ── Measurement card widget ───────────────────────────────────────────────────
class _MeasurementCard extends StatelessWidget {
  final _Measurement measurement;
  final Color cardColor;
  final ColorScheme cs;
  final Color windowColor;

  const _MeasurementCard({
    required this.measurement,
    required this.cardColor,
    required this.cs,
    required this.windowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: Container(
            width: 6,
            height: 32,
            decoration: BoxDecoration(
              color: windowColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          title: Text(
            measurement.name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          subtitle: Text(
            measurement.optimalView,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
          children: [
            const SizedBox(height: 4),
            // HOW TO GET
            _DetailSection(
              icon: Icons.videocam_outlined,
              title: 'HOW TO GET THIS VIEW',
              color: const Color(0xFF1565C0),
              bgColor: const Color(0xFF1565C0).withValues(alpha: 0.06),
              cs: cs,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: measurement.howToGet
                    .asMap()
                    .entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1565C0).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${e.key + 1}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                e.value,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: cs.onSurface.withValues(alpha: 0.82),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),

            // TECHNIQUE
            _DetailSection(
              icon: Icons.calculate_outlined,
              title: 'TECHNIQUE',
              color: cs.primary,
              cs: cs,
              child: Text(
                measurement.technique,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.82),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // STANDARDS / LANDMARKS
            if (measurement.standardsLandmarks.isNotEmpty) ...[
              _DetailSection(
                icon: Icons.place_outlined,
                title: 'STANDARDS / LANDMARKS',
                color: cs.primary,
                cs: cs,
                child: Text(
                  measurement.standardsLandmarks,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.82),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // NORMAL VALUES
            _DetailSection(
              icon: Icons.bar_chart,
              title: 'NORMAL VALUES',
              color: _green,
              cs: cs,
              child: Column(
                children: measurement.normalValues
                    .map((nv) => _NormalValueRow(nv: nv, cs: cs))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),

            // REMARKS
            if (measurement.remarks.isNotEmpty) ...[
              _DetailSection(
                icon: Icons.info_outline,
                title: 'REMARKS',
                color: cs.primary,
                cs: cs,
                child: Text(
                  measurement.remarks,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: cs.onSurface.withValues(alpha: 0.75),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // SOURCE
            _DetailSection(
              icon: Icons.book_outlined,
              title: 'SOURCE',
              color: cs.onSurface.withValues(alpha: 0.4),
              cs: cs,
              child: Text(
                measurement.source,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: cs.onSurface.withValues(alpha: 0.5),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Detail section widget ─────────────────────────────────────────────────────
class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color? bgColor;
  final ColorScheme cs;
  final Widget child;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.color,
    required this.cs,
    required this.child,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor ?? cs.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          child,
        ],
      ),
    );
  }
}

// ── Normal value row ──────────────────────────────────────────────────────────
class _NormalValueRow extends StatelessWidget {
  final _NormalValue nv;
  final ColorScheme cs;

  const _NormalValueRow({required this.nv, required this.cs});

  @override
  Widget build(BuildContext context) {
    final borderColor = nv.severity == 'normal'
        ? _green
        : nv.severity == 'abnormal'
            ? _red
            : _amber;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border(left: BorderSide(color: borderColor, width: 3)),
          color: borderColor.withValues(alpha: 0.06),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    nv.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.7),
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  nv.value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: borderColor,
                  ),
                ),
              ],
            ),
            if (nv.note.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                nv.note,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: cs.onSurface.withValues(alpha: 0.55),
                  height: 1.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Function category card widget ─────────────────────────────────────────────
class _FunctionCategoryCard extends StatelessWidget {
  final _FunctionCategory category;
  final Color cardColor;
  final ColorScheme cs;
  final VoidCallback onTap;

  const _FunctionCategoryCard({
    required this.category,
    required this.cardColor,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(category.icon, color: cs.primary, size: 18),
            ),
            const Spacer(),
            Text(
              category.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${category.measurementNames.length} measurements',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
