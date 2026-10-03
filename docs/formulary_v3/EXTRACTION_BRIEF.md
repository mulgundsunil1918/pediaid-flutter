# PediAid Drug Formulary 3.0 — extraction brief

You are extracting the full drug formulary from `source/harriet-lane-24th-ed.pdf`
(the Harriet Lane Handbook, 24th edition — 474 pages, drug monographs run
pages 31–474) into structured Dart data files, one `DrugEntryV3` constant per
drug, matching the exact schema in `reference/drug_entry_v3.dart`.

This file exists because a prior session (local, not cloud) did this by hand
for one drug — Acetaminophen, `reference/drug_entry_v3.dart` — and found real
failure modes along the way. Read this whole document before starting; it is
shorter than redoing that discovery.

## The one rule everything else serves

**Word-for-word. Nothing added, nothing dropped, nothing paraphrased.**

This is a clinical dosing reference. A rounded number, a "simplified" sentence,
or a summarised caution is not an improvement — it is a wrong answer someone
may act on. If a sentence is ambiguous or you cannot read a scan clearly, copy
it exactly as printed and flag it (see Verification below) rather than
resolving the ambiguity yourself.

## What "done" looks like

For each drug, a `DrugEntryV3` constant (see `reference/drug_entry_v3.dart`
for the full shape) with:

- `name`, `brandNames`, `drugClass`
- `iconRow` — printed exactly as it appears (e.g. `"B/C · 1 · Yes · Yes · No"`).
  **Do not expand or interpret these icons.** The legend is on a different
  page (p. 814) and was not in scope for the reference entry either — keep
  that precedent. If you do look up the legend and are confident, you may add
  a *separate* `iconMeaning` style field, but never silently replace the raw
  printed row with your interpretation of it.
- `formulations` — every formulation/strength line, verbatim
- `doseSections` — each heading from the book as its own `DoseSection`, with
  `DoseLine`s for prose and a `DoseTable` wherever the book has a real table
  (see Tables below). Sub-headings inside a section (e.g. "Neonate and
  infant:", "Adolescent (≥13 yr) and adult:") are `DoseLine(isHeading: true)`,
  matching the reference file.
- `remarks` — cautions / interactions / pharmacokinetics paragraphs, in the
  order the book prints them
- `pregnancyNote`, `sourcePages`

## Tables: reconstruct them, never flatten them

A naive PDF text pull turns a table into a flat run of numbers in reading
order. That is not acceptable output. Every table in the book must become a
real `DoseTable` with `headers` and `rows` — look at the actual page (render
it, don't trust text extraction alone; see Verification) and copy the grid
cell by cell, including blank cells that represent "same as the row above"
(the reference Acetaminophen table has none, but you will hit these — e.g. a
"Postconceptional age" column with a blank cell under `30–34` meaning it
continues from the row above it. Copy the blank as printed; do not fill it in
with the value from the row above).

## Footnotes and captions are real content

In the reference extraction, a table's footnotes (the "ᵃ Or significant
asphyxia..." / "ᵇ Use Q36 hr interval..." lines under a table) and the small
icon-row caption were both easy to miss on a first pass — they don't sit in
the main reading flow, they're attached to the table/header as a separate
element. If you are parsing via a structured intermediate (docling or
similar) rather than reading pages directly, explicitly check for a
`footnotes` or `captions` field on anything table-shaped — don't rely on the
main body-text stream alone.

## What to exclude (and how to tell)

Running headers/footers repeat verbatim across pages and are not drug
content:
- `Chapter 31 <letter> <page number>` (e.g. "Chapter 31 A 853")
- `FORMULARY`
- `For explanation of icons, see p. 814`
- `Continued` / `"<DRUG NAME> continued"` page headers

Strip these. Everything else on the page, including footnotes, is content.

## A specific, confirmed failure mode: dash normalization

An earlier (non-docling, ChatGPT-based) extraction attempt at this same book
silently converted every en dash (–, U+2013) in dose ranges to a plain hyphen
(-, U+002D) — "10–15 mg/kg/dose" became "10-15 mg/kg/dose". It didn't change
any number, but it is a literal character change from the source, and it was
*systematic* — every range in the book, not a one-off. Preserve the real en
dash character. If your extraction path normalizes Unicode punctuation at any
stage, that is the kind of silent change to watch for specifically.

## Verification — do this for every drug, not a sample

Two checks, because they catch different things:

1. **Completeness (word-level, order-independent).** Compare the set of words
   you extracted against an independent plain-text pull of the same page
   range (e.g. via `pypdf`). Use a **multiset/count comparison**
   (`collections.Counter` in Python), not a positional diff
   (`difflib.SequenceMatcher`). A positional diff produces false positives
   when real content legitimately moves — a table pulled out of the reading
   flow, a footnote attached to a table rather than inline — and chasing
   those false positives wastes far more time than it saves. A multiset diff
   sidesteps that entirely: it only flags words that are actually missing or
   actually added, regardless of where they end up.

2. **Positional correctness, for anything table-shaped (word-count diffing
   cannot do this).** A word-multiset match does not prove a table is
   correct — if two cell values got swapped, the word set is identical and
   the count-diff passes while the table is wrong. For every drug with a
   table, render the actual PDF page as an image (e.g. `pymupdf`,
   `page.get_pixmap(dpi=200)`) and read it directly, checking the
   reconstructed table against the image cell by cell, row by row. This is
   not optional for table-bearing drugs — it is the only check in this list
   that catches a transposition.

When something is genuinely unclear from the scan (a smudge, an ambiguous
character), do not guess silently. Write the line as best you can read it and
add a one-line note in `progress/flagged.md` naming the drug and what's
uncertain, so a human can check the one page instead of re-verifying
everything.

## Output organisation

Write to `output/`, grouped by first letter of the drug name matching the
book's own section breaks (`output/a.dart`, `output/b.dart`, ...), each file
a `List<DrugEntryV3>` or a sequence of top-level `const` entries — whichever
reads more naturally as a growing file; either is fine as long as it's
consistent across all 26.

Keep a running checklist in `progress/checklist.md` — one line per drug,
checked off as you finish it — so the work is resumable across sessions and
so progress is visible without reading every output file.

## Reference files in this repo

- `reference/drug_entry_v3.dart` — the proven-correct target schema
  (Acetaminophen), verified word-for-word against the source PDF by both
  methods above.
- `reference/drug_detail_v3_screen.dart` — the Flutter UI that renders a
  `DrugEntryV3`. You do not need to touch this; it's here so you can see what
  the data is actually for, and so field names make sense in context (e.g.
  why `iconRow` is a raw string rather than structured — the UI shows it
  as-printed with a note, not as interpreted icons).

## Scope

This repo is extraction only. Nothing here gets built, signed, or deployed —
that happens back in the main PediAid app repo once the output is reviewed.
Work through the alphabet in whatever batch size is practical; commit and
push regularly so progress isn't lost.
