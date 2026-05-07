"""tools/restructure_hl.py — turn the cluttered Harriet Lane v2 drug data
into structured per-population dose blocks with markdown-formatted
prose, ready to render as bullets / bold / sections in the Flutter
DrugDetailScreen.

Reads:  assets/data/formulary/formulary_v2/harrietlane_full.json
Writes: assets/data/formulary/formulary_v2/harrietlane_v3.json

Design
------
The source `comments` blob for each drug is a partially-cleaned PDF dump
that follows recognisable patterns:

    Indication-A:
    Route-1:
      Neonate:    <dose narrative>
      Child:      <dose narrative>
    Route-2:
      Adolescent: <dose narrative>
    Indication-B:
      Loading dose:    <dose narrative>
      Maintenance dose: <dose narrative>

Plus PDF-wrap noise (mid-sentence linebreaks, soft-hyphen artefacts, NBSPs)
and occasional formulation-strip noise at the very top.

We don't try to parse every drug perfectly; we extract what we can and
fall back to preformatted markdown if a drug doesn't fit the patterns.
The Flutter renderer accepts both. Numbers, units and routes are bolded
via simple regex so the bedside reader sees the dose first.

    PYTHONIOENCODING=utf-8 python tools/restructure_hl.py
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC  = ROOT / "assets" / "data" / "formulary" / "formulary_v2" / "harrietlane_full.json"
DEST = ROOT / "assets" / "data" / "formulary" / "formulary_v2" / "harrietlane_v3.json"

# ──────────────────────────────────────────────────────────────────────
# Vocabularies
# ──────────────────────────────────────────────────────────────────────

# Population labels (case-insensitive prefix match on a line). The order
# matters slightly because `Infant and child` must be tested before `Infant`.
POP_PATTERNS = [
    (re.compile(r"^\s*Preterm\s+neonate\s*:", re.I),         "Preterm neonate"),
    (re.compile(r"^\s*Term\s+neonate\s*:", re.I),            "Term neonate"),
    (re.compile(r"^\s*Neonate\s*\([^)]*\)\s*:", re.I),       "Neonate"),
    (re.compile(r"^\s*Neonate(?:s)?\s*:", re.I),             "Neonate"),
    (re.compile(r"^\s*Infant\s+and\s+child(?:ren)?\s*:", re.I), "Infant & child"),
    (re.compile(r"^\s*Infants?\s*:", re.I),                  "Infant"),
    (re.compile(r"^\s*Child(?:ren)?\s*\([^)]*\)\s*:", re.I), "Child"),
    (re.compile(r"^\s*Child(?:ren)?\s*:", re.I),             "Child"),
    (re.compile(r"^\s*Pediatric\s*:", re.I),                 "Paediatric"),
    (re.compile(r"^\s*Adolescent\s+and\s+adults?\s*≥\s*\d+\s*kg\s*:", re.I),
        "Adolescent / adult ≥50 kg"),
    (re.compile(r"^\s*Adolescents?\s*:", re.I),              "Adolescent"),
    (re.compile(r"^\s*Adults?\s*:", re.I),                   "Adult"),
    # Age-range markers — handle <, >, ≤, ≥ and trailing "and adult" / "and adolescent".
    # Examples: "1–5 yr:", "<1 yr:", "≤6 yr:", ">12 yr and adult:", "≥2 yr and adult:".
    (re.compile(
        r"^\s*([<>≤≥]?\s*\d+(?:\.\d+)?\s*[–\-]\s*[<>≤≥]?\s*\d+(?:\.\d+)?\s*"
        r"(?:yr|year|month|mo|wk|week)s?(?:\s+and\s+(?:adult|adolescent)s?)?)"
        r"\s*:", re.I),
        None),
    (re.compile(
        r"^\s*([<>≤≥]\s*\d+(?:\.\d+)?\s*"
        r"(?:yr|year|month|mo|wk|week)s?(?:\s+and\s+(?:adult|adolescent)s?)?)"
        r"\s*:", re.I),
        None),
    (re.compile(r"^\s*Loading\s+dose\s*:", re.I),            "Loading dose"),
    (re.compile(r"^\s*Maintenance(?:\s+dose)?\s*:", re.I),   "Maintenance dose"),
    (re.compile(r"^\s*Initial\s+dose\s*:", re.I),            "Initial dose"),
    (re.compile(r"^\s*Subsequent\s+dose(?:s)?\s*:", re.I),   "Subsequent dose"),
]

# Route markers (line is just a route, ending in `:`, becomes a sub-heading
# inside the indication block).
ROUTE_LINE = re.compile(
    r"^\s*("
    r"IV|IM|IM/IV|IV/IM|PO|PR|SC|IO|ETT|NG|SL|"
    r"PO/PR|IM, IV|IV/PO|PO/IV|IV \(see remarks\)|"
    r"Nebuli[sz]ation|Inhalation|Inhaled|Oral|Topical|Intranasal|Nasal|"
    r"Subcutaneous|Sublingual|Buccal|Intrathecal|Intra-articular|Ophthalmic|Otic|"
    r"Continuous infusion|Continuous IV infusion|Bolus|Loading|Maintenance|"
    r"Aerosol"
    r")\s*:\s*$",
    re.I,
)

# A "table placeholder" the parser should preserve as a callout:
TABLE_PLACEHOLDER = re.compile(
    r"\[\s*Weight[\s\-]*band\s*/\s*age[\s\-]*banded\s+dosing\s+table[^\]]*\]",
    re.I,
)

# Bold-target patterns (applied to dose narrative). Order matters — apply
# the most specific first so we don't double-bold inside an already-bold span.
BOLD_PATTERNS: list[tuple[re.Pattern[str], str]] = [
    # Doses with units: "0.05 mg/kg", "12 mg", "10–15 mg/kg/dose", "20 mcg/kg/min"
    (re.compile(r"\b(\d+(?:\.\d+)?(?:[–\-]\d+(?:\.\d+)?)?\s*"
                r"(?:mg|mcg|µg|g|kg|mL|L|U|IU|mEq|mmol|mol|ng)"
                r"(?:/kg)?(?:/dose|/day|/24\s*hr|/hr|/min|/h)?)\b"),
        r"**\1**"),
    # Routes used inline: "IV", "IM", "PO", "PR", "SC", "IO", "ETT"
    (re.compile(r"(?<![A-Za-z])(IV|IM|PO|PR|SC|IO|ETT|NG|SL)(?![A-Za-z])"),
        r"**\1**"),
    # Frequencies: "Q6 hr", "Q6–8 hr", "every 6 hours", "BID", "TID", "QID", "OD"
    (re.compile(r"(?<![A-Za-z])(Q\d+(?:[–\-]\d+)?\s*(?:hr|hour|h|min)|"
                r"every\s+\d+\s*(?:hr|hours?|min|minutes?)|"
                r"BID|TID|QID|OD|QD|QHS|PRN)(?![A-Za-z])", re.I),
        r"**\1**"),
    # "Max. dose: 12 mg" / "Maximum: 4 g/24 hr"
    (re.compile(r"\b(Max\.?(?:\s+(?:single|daily|subsequent)?\s*dose)?\s*:)", re.I),
        r"**\1**"),
]

# Garbage drug detection
GARBAGE_ID_RE = re.compile(r"^hl-[a-z]/[a-z]$", re.I)  # hl-a/c, hl-a/x ...
SEE_OTHER_RE  = re.compile(r"^\s*See\s+[A-Z][\w\s\-,]+\.?\s*$")
USELESS_CATEGORY_RE = re.compile(
    r"^\s*(US RDA|See Chapter|Dosing  ·)", re.I,
)

# ──────────────────────────────────────────────────────────────────────
# Text cleanup
# ──────────────────────────────────────────────────────────────────────

def clean_text(s: str) -> str:
    """Normalise whitespace, fix common PDF artefacts."""
    if not s:
        return ""
    # Replace narrow no-break space + non-breaking space with regular space.
    s = s.replace(" ", " ").replace(" ", " ")
    # Fix soft-hyphen + space at line break: "treat-\nment" -> "treatment"
    s = re.sub(r"-\s*\n\s*(?=[a-z])", "", s)
    # Collapse runs of spaces / tabs.
    s = re.sub(r"[ \t]+", " ", s)
    # Trim space before newlines.
    s = re.sub(r" +\n", "\n", s)
    # Collapse 3+ blank lines.
    s = re.sub(r"\n{3,}", "\n\n", s)
    return s.strip()


def join_wrapped_lines(s: str) -> str:
    """Join lines that look like PDF mid-sentence wrap. A line wraps if it
    ends without a sentence-terminator and the next line begins lowercase
    or a continuation token."""
    out_lines: list[str] = []
    lines = s.split("\n")
    i = 0
    while i < len(lines):
        cur = lines[i].rstrip()
        # Look ahead and merge while the next line is a wrap continuation.
        while i + 1 < len(lines):
            nxt = lines[i + 1].lstrip()
            if not nxt:
                break
            if cur.endswith((".", ":", ";", "?", "!")):
                break
            # If next line starts with a recognised section/population/route
            # header, don't merge.
            if any(p.search(nxt) for p, _ in POP_PATTERNS):
                break
            if ROUTE_LINE.match(nxt):
                break
            # If next line starts uppercase AND looks like a new heading
            # (short, ends with `:`), don't merge.
            if re.match(r"^[A-Z][\w\s\-/,]{1,40}:\s*$", nxt):
                break
            # Otherwise merge.
            cur = cur + " " + nxt
            i += 1
        out_lines.append(cur)
        i += 1
    return "\n".join(out_lines)


def bold_dose_terms(s: str) -> str:
    for pat, repl in BOLD_PATTERNS:
        s = pat.sub(repl, s)
    return s


# ──────────────────────────────────────────────────────────────────────
# Block extraction
# ──────────────────────────────────────────────────────────────────────

def detect_population(line: str) -> str | None:
    """Return the canonical population label if `line` opens a population
    block, else None. Strips the colon header from the line in-place via
    the caller (we just classify here)."""
    for pat, label in POP_PATTERNS:
        m = pat.match(line)
        if m:
            if label is not None:
                return label
            # Capture group form (age range)
            return m.group(1).strip()
    return None


def is_indication_header(line: str) -> bool:
    """An indication is a line that ends with `:`, isn't a route header,
    isn't a population header, and looks like prose (multi-word)."""
    t = line.strip()
    if not t.endswith(":"):
        return False
    if ROUTE_LINE.match(t):
        return False
    if detect_population(t):
        return False
    # Don't confuse "Loading dose:" style with indications.
    return len(t.split()) >= 1 and len(t) < 120


def split_indications(text: str) -> list[tuple[str, str]]:
    """Return [(indication_title, body_text), ...]. The first chunk gets
    title = '' if the text doesn't start with an indication header."""
    lines = text.split("\n")
    sections: list[tuple[str, list[str]]] = [("", [])]
    for ln in lines:
        if is_indication_header(ln):
            title = ln.rstrip(": \t").strip()
            sections.append((title, []))
        else:
            sections[-1][1].append(ln)
    out = []
    for title, buf in sections:
        body = "\n".join(buf).strip()
        if not body and not title:
            continue
        out.append((title, body))
    return out


def split_populations(text: str) -> list[dict[str, str]]:
    """Within an indication body, group lines under their population
    headers. If no population markers are found, return one entry with
    label = '' and the whole body."""
    lines = text.split("\n")
    cur_label: str | None = None
    cur_route: str | None = None
    buckets: list[dict[str, list[str] | str]] = []

    def flush(label: str | None, route: str | None, buf: list[str]) -> None:
        body = "\n".join(buf).strip()
        if not body and not label:
            return
        buckets.append({
            "label": label or "",
            "route_hint": route or "",
            "lines": body,
        })

    cur_buf: list[str] = []
    for ln in lines:
        # Population header?
        pop = detect_population(ln)
        if pop is not None:
            flush(cur_label, cur_route, cur_buf)
            # Strip the `Label:` prefix and keep the rest of the line as
            # body for this population.
            after_colon = ln.split(":", 1)[1].strip() if ":" in ln else ""
            cur_buf = [after_colon] if after_colon else []
            cur_label = pop
            continue
        # Route header?
        m = ROUTE_LINE.match(ln)
        if m:
            flush(cur_label, cur_route, cur_buf)
            cur_route = m.group(1).strip().upper()
            cur_label = None
            cur_buf = []
            continue
        cur_buf.append(ln)
    flush(cur_label, cur_route, cur_buf)

    # Convert lines back to strings.
    return [{"label": b["label"], "route_hint": b["route_hint"], "body": b["lines"]}  # type: ignore[index]
            for b in buckets if b["lines"]]


# ──────────────────────────────────────────────────────────────────────
# Per-drug structuring
# ──────────────────────────────────────────────────────────────────────

def is_garbage(d: dict) -> bool:
    """A drug entry is garbage when its name looks like a parser artefact
    AND its doses don't carry useful info."""
    name = (d.get("drug") or "").strip()
    did  = (d.get("id")   or "").strip()
    if GARBAGE_ID_RE.match(did):
        return True
    if len(name) <= 2 and not d.get("alt_names"):
        return True
    # Drug is essentially just "See X"
    comments = " ".join(dose.get("comments", "") for dose in d.get("doses", []))
    if SEE_OTHER_RE.match(comments.strip()):
        # Keep it but mark hidden so search can still cross-reference.
        return True
    if not comments.strip() and not (d.get("contraindications") or d.get("monitoring")):
        return True
    return False


def clean_category(raw: str) -> str:
    """Drop USELESS_CATEGORY_RE matches; return '' if useless."""
    if not raw:
        return ""
    if USELESS_CATEGORY_RE.match(raw):
        return ""
    return clean_text(raw).rstrip(".")


def extract_callouts(text: str) -> tuple[str, list[str]]:
    """Pull [Weight-band ... ] notices out into a callouts list, return
    cleaned text + the callouts list."""
    callouts: list[str] = []
    def repl(m: re.Match[str]) -> str:
        callouts.append(m.group(0).strip("[]").strip())
        return ""  # remove from inline text
    cleaned = TABLE_PLACEHOLDER.sub(repl, text)
    return cleaned, callouts


def restructure_drug(d: dict) -> dict:
    out: dict = {
        "id": d.get("id"),
        "drug": clean_text(d.get("drug") or ""),
        "alt_names": [clean_text(x) for x in (d.get("alt_names") or []) if x],
        "category": clean_category(d.get("category") or ""),
        "page": (d.get("sources") or {}).get("primary_harriet_lane_page", 0),
        "hidden": is_garbage(d),
        "callouts": [],
        "dose_blocks": [],
        "raw_dose_md": "",
        "cautions_md": "",
        "monitoring_md": "",
        "adverse_effects_md": "",
        "pharmacokinetics_md": "",
        "pearls_md": "",
        "review_status": (d.get("review") or {}).get("status", ""),
    }

    # ── Comments: build dose blocks ──────────────────────────────────
    comments_raw = " \n".join(
        dose.get("comments", "") for dose in (d.get("doses") or []) if dose.get("comments")
    )
    text = clean_text(comments_raw)
    text, callouts = extract_callouts(text)
    text = join_wrapped_lines(text)
    out["callouts"].extend(callouts)

    indications = split_indications(text)
    if not indications or (len(indications) == 1 and not indications[0][0]):
        # No indication headers at all — treat the whole thing as one
        # block titled "Dosing".
        body = indications[0][1] if indications else text
        pops = split_populations(body)
        if pops:
            out["dose_blocks"].append({
                "indication": "Dosing",
                "populations": [
                    {
                        "label": p["label"],
                        "route_hint": p["route_hint"],
                        "dose_md": bold_dose_terms(p["body"]).strip(),
                    } for p in pops
                ],
            })
        else:
            out["raw_dose_md"] = bold_dose_terms(body).strip()
    else:
        for title, body in indications:
            pops = split_populations(body)
            block: dict = {"indication": title or "Dosing", "populations": []}
            if pops:
                block["populations"] = [
                    {
                        "label": p["label"],
                        "route_hint": p["route_hint"],
                        "dose_md": bold_dose_terms(p["body"]).strip(),
                    } for p in pops
                ]
            else:
                # No structured population — one fallback population with
                # empty label (will render as a single block under the
                # indication heading).
                block["populations"] = [{
                    "label": "",
                    "route_hint": "",
                    "dose_md": bold_dose_terms(body).strip(),
                }]
            out["dose_blocks"].append(block)

    # Drop empty blocks (all populations empty)
    out["dose_blocks"] = [
        b for b in out["dose_blocks"]
        if any(p.get("dose_md") for p in b["populations"])
    ]

    # ── Other prose fields ──────────────────────────────────────────
    def md_field(raw: str) -> str:
        if not raw:
            return ""
        return bold_dose_terms(clean_text(raw)).strip()

    out["cautions_md"]         = md_field(d.get("contraindications") or "")
    out["monitoring_md"]       = md_field(d.get("monitoring") or "")
    out["adverse_effects_md"]  = md_field(d.get("adverse_effects") or "")
    out["pharmacokinetics_md"] = md_field(d.get("pharmacokinetics") or "")
    out["pearls_md"]           = md_field(d.get("pearl") or "")

    return out


# ──────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────

def main() -> None:
    if not SRC.exists():
        sys.exit(f"missing source: {SRC}")
    src = json.loads(SRC.read_text(encoding="utf-8"))
    drugs = src.get("drugs", [])
    cleaned = [restructure_drug(d) for d in drugs]

    # Stats
    total = len(cleaned)
    hidden = sum(1 for d in cleaned if d["hidden"])
    structured = sum(1 for d in cleaned if d["dose_blocks"] and not d["hidden"])
    fallback = sum(1 for d in cleaned if not d["dose_blocks"] and d.get("raw_dose_md") and not d["hidden"])

    payload = {
        "schema_version": "v3.0-hl-restructured",
        "section_label": "PediAid v3 Paediatrics — Harriet Lane (restructured)",
        "last_updated": "2026-05-07",
        "stats": {
            "total": total,
            "hidden_garbage": hidden,
            "structured_dose_blocks": structured,
            "fallback_raw_md": fallback,
        },
        "drugs": cleaned,
    }
    DEST.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Wrote {DEST.relative_to(ROOT)}")
    print(f"  total drugs: {total}")
    print(f"  hidden as garbage: {hidden}")
    print(f"  with structured dose_blocks: {structured}")
    print(f"  fallback raw_dose_md: {fallback}")


if __name__ == "__main__":
    main()
