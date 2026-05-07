# Play Store Listing — PediAid

Drafts ready to paste into Play Console. Update bracketed `[…]` placeholders before submission.

---

## App identity

| Field | Value |
|---|---|
| **App name** | PediAid — Paediatric & Neonatal Reference |
| **Default language** | English (United States) |
| **App or game** | App |
| **Free or paid** | Free |
| **Application ID** | `org.pediaid.app` (locked — do not change) |
| **Category** | Medical |
| **Tags** | Reference, Medical professionals, Pediatrics, Neonatal |

---

## Short description (≤ 80 chars)

```
Paediatric & neonatal calculators, growth charts, drug formulary, NICE & AAP.
```

(78 chars)

## Full description (≤ 4000 chars)

```
PediAid is a paediatric & neonatal clinical reference app for paediatricians, neonatologists, registrars, nurses and medical students. One fast, offline-friendly app instead of juggling 8 references at the bedside.

WHAT'S INSIDE

CLINICAL CALCULATORS (18+)
• GIR (Glucose Infusion Rate) — required dextrose %, two-stock mixing, central-line safety bands
• Maintenance fluids (Holliday-Segar)
• Body Surface Area (Mosteller, DuBois)
• BP percentile (AAP 2017 by age, sex, height)
• Neonatal BP percentile by gestational age
• Schwartz eGFR
• Blood gas analyser (acid-base interpretation)
• Ventilator parameters (TV, MAP, OI / OSI)
• Burn mortality (Lund-Browder, Parkland)
• Corrected Gestational Age / PMA
• TPN, double-volume exchange, ponderal index, gestational age, nutritional audit and more

GROWTH CHARTS
• WHO 2006/2007 (0–5 yr) percentiles & z-scores
• IAP 2015 (5–18 yr) Indian growth references
• Fenton 2013 preterm growth curves

JAUNDICE / BILIRUBIN
• AAP 2022 hour-specific TSB thresholds for ≥35 weeks
• NICE CG98 graphical thresholds for 23–38+ weeks preterm
• Bilirubin:Albumin ratio
• Phototherapy + exchange transfusion guidance with neurotoxicity risk factors

DRUG FORMULARY
• Searchable Neofax (neonatal) and Harriet Lane (paediatric)
• Indications, dosing, intervals, key safety notes

REFERENCE LIBRARY
• Age-banded lab normals
• NICU scores: Apgar, SNAPPE-II, CRIB, Downe, Silverman-Anderson
• Vaccine schedules, NRP, PALS algorithms
• IAP STG 2022, IAP Action Plan 2026, NNF CPG 2021 standard treatment guidelines

WHY IT'S TRUSTED
Every threshold is digitised from the source publication (AAP, NICE, WHO, IAP, NNF, Neofax, Harriet Lane) with the reference shown on every screen. Formulas are visible — you can verify before you act.

PRIVACY YOU CAN COUNT ON
Patient inputs you type into a calculator (weights, gestational ages, lab values) are NEVER sent to our servers. They're forgotten the moment you close the screen. Only your account email and authentication token are stored on our backend.

CROSS-PLATFORM
Web, Android, iOS, Windows, Linux and macOS from a single Flutter codebase. Same answers, every device.

OPEN SOURCE
PediAid is built openly on GitHub. Source, issues and clinical feedback are public — github.com/mulgundsunil1918

DISCLAIMER
PediAid is a clinical decision support tool intended for use by qualified healthcare professionals only. All calculations and reference data must be verified against current clinical guidelines and the patient's clinical context before any treatment decision. The developers accept no liability for clinical decisions made based on this app.

---

Privacy: https://mulgundsunil1918.github.io/pediaid-landing/privacy.html
Web: https://mulgundsunil1918.github.io/pediaid-flutter/
Support: mulgundsunil@gmail.com
```

(approx 2,700 chars — comfortable headroom)

---

## Data safety form (matches the privacy policy)

This form must match the policy at https://mulgundsunil1918.github.io/pediaid-landing/privacy.html, otherwise Google reviewers reject.

### Data collection summary

| Data type | Collected? | Shared with third parties? | Optional? | Why |
|---|---|---|---|---|
| **Email address** | ✅ Yes | ❌ No | ❌ No (only if signing in) | Authentication, support replies |
| **Name** | ✅ Yes (optional display name) | ❌ No | ✅ Yes | Personalisation |
| **App activity (in-app actions)** | ❌ No | — | — | We don't track which calculators you open |
| **Device or other IDs** | ❌ No | — | — | No advertising IDs |
| **Health & fitness data** | ❌ No | — | — | We do not collect any patient data — all calculator inputs stay on-device and are forgotten on screen close |
| **Photos / videos** | ❌ No | — | — | |
| **Location** | ❌ No | — | — | |
| **Contacts** | ❌ No | — | — | |
| **Files / docs** | ❌ No | — | — | |
| **Calendar / messages / call logs** | ❌ No | — | — | |
| **Audio** | ❌ No | — | — | |
| **Crash logs / diagnostics** | ✅ Optional | ❌ No | ✅ Yes | Only included when you tap "Report a bug" — manual, not background |

### Security practices

- ✅ Data is encrypted in transit (HTTPS / TLS 1.2+)
- ✅ You can request your data be deleted (Settings → Delete account, or email)
- ✅ This app collects zero data from users under the age of 13
- ✅ Independent security review: not yet (open-source code on GitHub)

### Account deletion

- ✅ Yes, users can request account and data deletion **directly inside the app** at Settings → Danger zone → Delete account
- ✅ Deletion is immediate, hard-delete (no soft-delete or grace period)
- Web URL for deletion (Play Store also requires this): https://mulgundsunil1918.github.io/pediaid-landing/privacy.html#contact

---

## Content rating questionnaire (IARC) — answers

| Question | Answer |
|---|---|
| Cartoon, fantasy, realistic violence | None |
| Sex / nudity | None |
| Profanity | None |
| Drug, alcohol, tobacco | Educational reference only (paediatric drug dosing) — answer **No** to "depicts use" |
| Simulated gambling | None |
| User-generated content | None |
| Shares user location | No |
| Allows users to interact | No |
| Digital purchases | No |

Expected rating: **Everyone**.

---

## Target audience and content

- **Target age**: 18 and over (medical professionals)
- **Appeals to children?**: No
- **Has Family Designation?**: No

---

## Pre-launch checklist

Before clicking "Send for review":

- [ ] Real upload keystore generated and `key.properties` exists (see `KEYSTORE_SETUP.md`)
- [ ] versionCode bumped (currently 2 in pubspec.yaml — bump again if you re-uploaded already)
- [ ] AAB built with `flutter build appbundle --release`
- [ ] Application ID `org.pediaid.app` locked (NEVER change after first upload)
- [ ] App icon 512×512 uploaded
- [ ] Feature graphic 1024×500 uploaded
- [ ] At least 2 phone screenshots (1080×1920 or similar 16:9 portrait)
- [ ] Privacy policy URL set to https://mulgundsunil1918.github.io/pediaid-landing/privacy.html
- [ ] Data safety form filled to match the policy
- [ ] Content rating questionnaire completed
- [ ] App content declarations: Ads = No, In-app purchases = No, COPPA = No
- [ ] Target audience: 18+
- [ ] Country availability: pick (default: India + worldwide)
- [ ] Email + phone for developer profile public on Play store ✅
