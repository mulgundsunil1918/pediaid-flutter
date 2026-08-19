# PediAid live content updates (OTA) — plan

**Status:** proposal, nothing built.
**Goal:** change clinical data, navigation and text without a store release.
**Not a goal:** replacing tests or store review for code changes.

---

## 1. What this can and cannot fix

Measured against the nine real defects found on 2026-08-19, five would have been
fixable over the air and four would not. That ratio is the honest case for this
work — it is a large reduction in release pressure, not a cure-all.

| Change | OTA? | Why |
|---|---|---|
| Add / edit / remove a **score** | Yes | `ScoreDef` is pure data (questions, weights, bands, citations) |
| **Vaccine rule** values — intervals, dose counts, age limits | Yes | `VaccineRule`/`DoseBand` are pure data |
| **Resources** — add a PDF, retitle, recategorise | Yes | title / filename / driveId / category |
| **Lab reference** values | Yes | already JSON assets |
| **Which cards appear, where, titles, badges, order** | Yes | *once the navigation catalogue is data* |
| Any **text** — notes, references, disclaimers | Yes | strings |
| **Kill switch** — hide a broken tool now | Yes | a flag |
| Calculator **labels, units, ranges, bands, references** | Yes | data around the maths |
| Calculator **formula** | Only with §7 | needs an expression evaluator |
| **New** calculator | Only with §7, and only simple shapes | must fit numeric-in → formula → band |
| **Engine logic** (e.g. the missing 28-day live-vaccine rule) | No | Dart code |
| **New screen types, chart rendering, interactions** | No | Dart code |

### The bug that motivated this
`Paediatric Scores` vanished from the Guides list while `PaediatricScoresHub`
was still compiled into the binary. Only the *entry pointing at it* was lost.
With a data-driven navigation catalogue that is a config push. This is why §4
is in scope and not a "nice to have".

---

## 2. Hard constraint: Apple guideline 2.5.2

Apps may not download and execute code. **Data is fine.** Everything above sits
on the data side of that line, including §7's expression strings — evaluating a
formula string is interpreting data, the same thing a spreadsheet does, not
executing downloaded code.

Explicitly **out of scope**: Shorebird and any Dart code-patching. Android would
be fine; iOS is an unresolved grey area against 2.5.2 and is not worth risking
the listing for.

---

## 3. Payload and hosting

| | Size |
|---|---|
| Scores, vaccine rules, resources as JSON | ~129 KB |
| Lab refs, NICU scores, vaccine schedules (already JSON) | ~108 KB |
| **Update bundle total** | **~240 KB raw, ~70 KB gzipped** |
| WHO tables + formulary — **stays bundled, never changes** | 16.6 MB |

**Host it as static files on the existing `gh-pages` branch.** Not on Render,
not behind Neon.

Reason beyond cost: Neon has suspended before (it is on the status page as a
known issue). If the clinical-data path runs through the backend, a sleeping
database means blocking on startup or silently stale data. Static files have no
cold start, no pool, no spin-down.

Cost at 1,000 users: ~6 MB/month of manifest checks, ~70 MB per published
update. Free. At 100,000 users it is ~7 GB per update — still free on GitHub
Pages for a few pushes a month, and free on Cloudflare Pages past that.

---

## 4. Layout

```
gh-pages/content/
  manifest.json              # tiny; the only file fetched every launch
  bundles/
    scores-<version>.json
    vaccine-rules-<version>.json
    resources-<version>.json
    lab-reference-<version>.json
    navigation-<version>.json
```

`manifest.json`:

```jsonc
{
  "schemaVersion": 1,           // app refuses a schemaVersion it does not know
  "minAppBuild": 34,            // bundles needing newer code are ignored by old apps
  "publishedAt": "2026-08-19T12:00:00Z",
  "channel": "stable",          // or "staging"
  "bundles": {
    "scores":        { "version": 12, "url": "bundles/scores-12.json",
                       "sha256": "…", "bytes": 131072 },
    "vaccine-rules": { "version": 4,  "url": "bundles/vaccine-rules-4.json",
                       "sha256": "…", "bytes": 13000 }
  }
}
```

`minAppBuild` is the safety valve for the §1 "partly" cases: if a new vaccine
rule needs an engine field that only build 36 has, set `minAppBuild: 36` and
older installs keep their bundled copy instead of misreading the new shape.

---

## 5. Update flow in the app

1. On launch, fetch `manifest.json` with a short timeout (3 s). **Never block
   the UI on it** — the app is usable offline with bundled data.
2. Reject the manifest unless `schemaVersion` is known and `minAppBuild <=` this
   build.
3. For each bundle whose `version` exceeds the cached one, download it.
4. **Verify sha256**, then **validate against the schema** (required fields,
   types, sane ranges — e.g. a dose interval must be 0–3650 days).
5. Write to a *staging* cache directory. Only on full success, atomically swap
   it in and bump the stored version.
6. Any failure at any step: keep what is already there. Log, do not surface.

Loading order at read time, first hit wins:
**downloaded cache → bundled asset**. The bundled asset always exists, so a
fresh install with no network is fully functional.

### The "Updating clinical data…" screen
Only shown when a bundle is being applied *and* the user is on a screen that
depends on it. Everyday launches with no update show nothing.

---

## 6. Safety — the part that matters

Store review currently sits between a bad value and every user. Removing it
means the guardrails move here.

- **Schema validation** on publish *and* on device. Both, not either.
- **Staging channel.** `channel: "staging"` is only fetched by builds with a
  debug flag or by a device whose id is on a list. Publish to staging, check on
  a real phone, then promote the identical file to stable.
- **sha256 per bundle** in the manifest.
- **Rollback = republish the previous version number.** Because bundles are
  content-addressed by version, rollback is a manifest edit, not a rebuild.
  Target: under five minutes.
- **Never delete the bundled fallback.** Shipping assets stay in the binary
  forever; they are the floor.
- **A bundle can only ever be data.** No URLs that become code paths, no
  arbitrary deep links; the navigation catalogue references *screen ids the
  binary already knows*, never a route string it will blindly push.
- **Test the bundles in CI** the same way the app does — a `flutter test` that
  loads each published bundle through the real parser and asserts it produces
  the expected screen/score/rule counts.

---

## 7. Optional later: calculator formulas as data

Store the maths as an expression string plus declared inputs:

```json
{
  "id": "gir",
  "inputs": [{"key": "rate", "unit": "mL/h"}, {"key": "dex", "unit": "%"},
             {"key": "wt", "unit": "kg"}],
  "formula": "(rate * dex * 1000) / (wt * 6000)",
  "bands": [{"min": 0, "label": "Low"}, {"min": 4, "label": "Typical"}]
}
```

Needs a bundled expression parser and a migration of the 62 calculators into
declarative form. **Do this only after §1–6 has proven itself in production**,
and migrate in small batches with the existing `new_calculators_test.dart`
asserting identical output before and after each batch. A formula migration that
silently changes a dose is worse than no OTA at all.

---

## 8. Phasing

| Phase | Content | Effort | Risk |
|---|---|---|---|
| **1** | Pipeline + **resources** only | ~1 day | Low — worst case is a wrong PDF link |
| **2** | **Scores** + **lab references** | ~1 day | Low — read-only reference data |
| **3** | **Navigation catalogue** | ~1 day | Medium — fixes the class of bug that started this |
| **4** | **Vaccine rules** | ~1 day | **Highest — dose-affecting.** Only after 1–3 are proven |
| **5** | Admin-dashboard publishing (optional) | ~2 days | Adds a backend dependency at publish time only |
| **6** | Calculator formulas (§7) | Large | High — do not start without a reason |

Phase 4 last, deliberately: the vaccine rules are the most valuable thing to fix
quickly *and* the most dangerous thing to get wrong. It should ride a pipeline
that has already survived three lower-stakes phases.

---

## 8b. Performance — measured, not assumed

Concern: does parsing content at runtime slow the app?

Benchmarked a 285 KB bundle shaped like a real 110-score set (questions,
choices, bands, citations), full `jsonDecode` plus a walk of every nested list:

```
BUNDLE  285 KB
PARSE   5.43 ms per full decode+walk   (dev machine)
BUDGET  16.7 ms = one 60fps frame
```

That is a third of one frame on a dev machine. On a low-end Android phone
expect roughly 3–5x that — **~15–30 ms** — and it is paid **once**, lazily, the
first time a module is opened, then held in memory. Not on launch, not per
screen.

Three things keep it invisible:

1. **Startup is untouched.** The manifest fetch is async with a 3 s timeout and
   never blocks first paint. Offline, nothing happens at all.
2. **Lazy + cached**, exactly like the existing `FormularyService` and
   `WhoDataService`, which already parse runtime assets and cache in memory.
3. **Precedent already exists.** The app parses `nicu_scores.json`,
   `lab_reference`, the vaccine schedules and WHO `.xlsx` at runtime today.
   This is not a new pattern, only more of one that already performs acceptably.

**Memory:** ~240 KB of JSON becomes roughly 1–2 MB of Dart objects. Negligible.

**The honest cost:** `const` Dart data is genuinely faster than parsed JSON —
it is laid out at compile time and costs nothing to "load". Moving scores out of
`const` gives up that optimisation. The measurement above is what it is worth:
single-digit milliseconds, once. Worth trading for the ability to fix a dose
band in an hour.

**The real UX risk is not speed** — it is the "Updating clinical data…" screen
appearing too often. It must only show when a bundle is actually being applied
*and* the user is heading into a screen that needs it. An ordinary launch with
no update pending shows nothing at all.

---

## 9. What this does not solve

Worth stating plainly so it is not oversold.

- It does not prevent regressions. The Paediatric Scores bug was caught by a
  human looking at the app, not by tooling. Tests remain the defence.
- It does not remove the need for builds — engine changes, new screens and
  anything in §1's "No" rows still need a release.
- It adds a new failure mode: a bad push reaches everyone in minutes. §6 exists
  entirely to bound that.
