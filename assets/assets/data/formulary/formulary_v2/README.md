# PediAid Formulary v2 — Curated NICU Drug Database

This folder contains the in-house, copyright-safe drug formulary that
replaces the bundled Neofax/Harriet-Lane PDFs.

## Schema

Each entry is a single JSON object inside `drugs[]`:

```jsonc
{
  "id": "neo-paracetamol",                    // stable kebab-case ID
  "drug": "Paracetamol (Acetaminophen)",      // display name
  "alt_names": ["Acetaminophen", "APAP"],     // for search
  "category": "Analgesic / Antipyretic",
  "atc_code": "N02BE01",                       // WHO ATC where known

  "india_formulations": [                      // INDIAN brands + strengths
    {
      "form": "IV solution",
      "strength": "10 mg/mL (100 mL vial = 1000 mg)",
      "brands_india": ["Perfalgan", "Pacimol IV"],
      "notes": "Single-use; discard 6 h after opening"
    }
  ],

  "doses": [                                   // structured dose table
    {
      "indication": "Fever",
      "route": "IV",                           // IV | IM | IO | PO | PR | ETT | SC | NEB | TOPICAL
      "ga_band": "≥ 32 weeks gestation",       // GA band specific
      "pma_band": null,                        // postmenstrual age band
      "postnatal_age_band": null,              // postnatal age band
      "loading_dose_per_kg": null,             // mg/kg (load) — if any
      "dose_per_kg_per_dose": "12.5 mg/kg",    // amount + unit
      "frequency": "every 6 hours",
      "max_per_dose": "50 mg/kg/day total",
      "max_per_day_all_routes": "50 mg/kg/day",
      "infusion_rate": "Over 15 min",
      "comments": ""
    }
  ],

  "monitoring": "Liver function; pain score; temperature.",
  "adverse_effects": "Hepatotoxicity (rare at therapeutic dose); ...",
  "contraindications": "Severe hepatic impairment.",
  "renal_adjustment": "...",
  "hepatic_adjustment": "Avoid in severe hepatic impairment.",
  "incompatibilities": "...",
  "reconstitution": "...",

  "sources": {
    "primary_neofax_page": 8,                   // Neofax monograph page (this PDF)
    "cross_checks": [                           // Independent confirmations
      { "source": "WHO WMFc 2024", "agreement": "agrees" },
      { "source": "NNF CPG 2020", "agreement": "agrees" },
      { "source": "DailyMed (Ofirmev label)", "agreement": "agrees" }
    ],
    "indian_guidelines": ["IAP Drug Formulary 2024"]
  },

  "review": {
    "status": "draft_pending_user_review",      // draft | reviewed | published
    "reviewer": null,
    "review_date": null,
    "notes": ""
  }
}
```

## Unit discipline (critical)

| What | Notation |
|---|---|
| milligrams | `mg` (lowercase) |
| micrograms | `mcg` (NEVER `μg` or `ug`) |
| grams | `g` |
| millilitres | `mL` (capital L) |
| units (insulin/heparin) | `U` |
| milliequivalents | `mEq` |
| Per kg, per dose | `mg/kg/dose` |
| Per kg, per minute | `mcg/kg/min` |
| Per kg, per day | `mg/kg/day` |

All doses preserve route + frequency + max per dose + max per day separately
to avoid ambiguity at the bedside.

## Legal stance

This database is original prose synthesised from multiple sources. Numerical
dose facts (which are not copyrightable) are taken from Neofax then
independently confirmed against at least one of: WHO WMFc, NNF CPG,
DailyMed (FDA label), IAP Drug Formulary. Selection, structure, and
narrative wording are PediAid's own.

## Files

- `neofax_pilot.json` — pilot batch (5 drugs) for review.
- Future: `nicu_formulary.json` — full Neofax-coverage equivalent (~200 drugs).
- Future: `picu_formulary.json` — full Harriet Lane equivalent (~500 drugs).
