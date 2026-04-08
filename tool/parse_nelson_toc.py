"""Parse Nelson Textbook TOC PDF extract into Dart data file."""
import re
import json

SRC = r'C:\Users\mulgu\Downloads\nelson_toc.txt'
OUT = r'C:\Users\mulgu\Desktop\APP\neoapp\neoapp_app\lib\academics\data\nelson_chapters.dart'

with open(SRC, encoding='utf-8') as f:
    raw = f.read()

raw = re.sub(r'=== PAGE \d+ ===', '\n', raw)
lines = raw.split('\n')


def norm(s: str) -> str:
    s = s.replace('\ufeff', ' ')
    s = s.replace('\u00a0', ' ')
    s = re.sub(r'\s+', ' ', s)
    return s.strip()


def is_skip(line: str) -> bool:
    if not line:
        return True
    if re.fullmatch(r'[ivxl]+', line, re.I):
        return True
    if re.fullmatch(r'Contents', line):
        return True
    if re.fullmatch(r'Contents\s+[ivxl]+', line, re.I):
        return True
    if re.fullmatch(r'[ivxl]+\s+Contents', line, re.I):
        return True
    if line.startswith('VOLUME'):
        return True
    return False


# Parse into sequential tokens
tokens = []  # list of (type, value)
buffer = ''
await_part_title = False

for raw_line in lines:
    line = norm(raw_line)
    if is_skip(line):
        continue

    m_part = re.match(r'^PART\s+([IVXL]+)$', line)
    if m_part:
        if buffer:
            tokens.append(('ENTRY', buffer))
            buffer = ''
        tokens.append(('PART', m_part.group(1), None))
        await_part_title = True
        continue

    if await_part_title:
        tokens.append(('PART_TITLE', line))
        await_part_title = False
        continue

    m_sec = re.match(r'^Section\s+(\d+)\s+(.+)$', line)
    if m_sec:
        if buffer:
            tokens.append(('ENTRY', buffer))
            buffer = ''
        tokens.append(('SECTION', m_sec.group(1), m_sec.group(2)))
        continue

    if not buffer:
        if re.match(r'^\d+(\.\d+)?\s', line):
            buffer = line
        else:
            # author line or stray — skip
            continue
    else:
        # could be continuation OR an author line stuck mid-buffer.
        # If it looks like an author (no digits or very short),
        # assume continuation since title continuations can also be short.
        buffer += ' ' + line

    if re.search(r',\s*\d+\s*$', buffer):
        tokens.append(('ENTRY', buffer))
        buffer = ''

# Strip trailing page numbers and leading numbers from entries,
# then bucket into parts / chapters / subchapters
structure = []  # list of parts
current_part = None
current_chapter = None
pending_section = None

for tok in tokens:
    if tok[0] == 'PART':
        current_part = {
            'roman': tok[1],
            'title': '',
            'chapters': [],
        }
        structure.append(current_part)
        current_chapter = None
        pending_section = None
    elif tok[0] == 'PART_TITLE':
        if current_part is not None:
            current_part['title'] = tok[1]
    elif tok[0] == 'SECTION':
        pending_section = f"Section {tok[1]}: {tok[2].title()}"
    elif tok[0] == 'ENTRY':
        text = tok[1]
        # strip trailing ", <pagenum>"
        text = re.sub(r'\s*,\s*\d+\s*$', '', text)
        text = text.strip()
        m = re.match(r'^(\d+)(?:\.(\d+))?\s+(.+)$', text)
        if not m:
            continue
        num = m.group(1)
        sub = m.group(2)
        title = m.group(3).strip().rstrip(',').strip()
        # Clean extra spaces in title
        title = re.sub(r'\s+', ' ', title)
        # Convert ALL-CAPS chapter titles to Title Case
        def smart_title(s: str) -> str:
            if s.isupper() or (sum(1 for c in s if c.isalpha() and c.isupper()) /
                               max(1, sum(1 for c in s if c.isalpha())) > 0.7):
                # Title case but preserve common acronyms
                words = s.split(' ')
                out = []
                acronyms = {'HIV', 'AIDS', 'DNA', 'RNA', 'CNS', 'GI', 'UTI',
                            'CPR', 'NK', 'IQ', 'ADHD', 'PTSD', 'OCD', 'EEG',
                            'ECG', 'EKG', 'MRI', 'CT', 'US', 'WHO', 'HPV',
                            'HSV', 'CMV', 'EBV', 'TB', 'PID', 'STD', 'STI',
                            'IV', 'IM', 'BP', 'HR', 'RR', 'GU', 'ENT',
                            'IgA', 'IgE', 'IgG', 'IgM'}
                for w in words:
                    if w.upper() in acronyms:
                        out.append(w.upper())
                    elif len(w) <= 3 and w.upper() == w and w.isalpha():
                        out.append(w.capitalize())
                    else:
                        out.append(w.capitalize())
                return ' '.join(out)
            return s

        if sub is None:
            # chapter
            chapter = {
                'number': num,
                'title': smart_title(title),
                'subchapters': [],
            }
            if pending_section:
                chapter['section'] = pending_section
                pending_section = None
            if current_part is None:
                current_part = {'roman': '?', 'title': '', 'chapters': []}
                structure.append(current_part)
            current_part['chapters'].append(chapter)
            current_chapter = chapter
        else:
            # subchapter
            if current_chapter is None:
                continue
            current_chapter['subchapters'].append({
                'number': f'{num}.{sub}',
                'title': title,
            })

# ---- Emit Dart file ----
def dart_str(s: str) -> str:
    return "'" + s.replace('\\', '\\\\').replace("'", "\\'") + "'"


def roman_to_int(r: str) -> int:
    vals = {'I': 1, 'V': 5, 'X': 10, 'L': 50, 'C': 100, 'D': 500, 'M': 1000}
    total = 0
    prev = 0
    for c in reversed(r):
        v = vals.get(c, 0)
        if v < prev:
            total -= v
        else:
            total += v
            prev = v
    return total


out = []
out.append('// GENERATED FILE — Nelson Textbook of Pediatrics (21st ed) TOC')
out.append('// Do not edit by hand. Regenerated by tool/parse_nelson_toc.py')
out.append('')
out.append('class NelsonSubchapter {')
out.append('  final String number;')
out.append('  final String title;')
out.append('  const NelsonSubchapter({required this.number, required this.title});')
out.append('}')
out.append('')
out.append('class NelsonChapter {')
out.append('  final String number;')
out.append('  final String title;')
out.append('  final String? section;')
out.append('  final List<NelsonSubchapter> subchapters;')
out.append('  const NelsonChapter({')
out.append('    required this.number,')
out.append('    required this.title,')
out.append('    this.section,')
out.append('    this.subchapters = const [],')
out.append('  });')
out.append('}')
out.append('')
out.append('class NelsonPart {')
out.append('  final String roman;')
out.append('  final int number;')
out.append('  final String title;')
out.append('  final List<NelsonChapter> chapters;')
out.append('  const NelsonPart({')
out.append('    required this.roman,')
out.append('    required this.number,')
out.append('    required this.title,')
out.append('    required this.chapters,')
out.append('  });')
out.append('}')
out.append('')
out.append('const List<NelsonPart> kNelsonParts = [')

for part in structure:
    roman = part['roman']
    num = roman_to_int(roman) if roman != '?' else 0
    out.append('  NelsonPart(')
    out.append(f'    roman: {dart_str(roman)},')
    out.append(f'    number: {num},')
    out.append(f'    title: {dart_str(part["title"])},')
    out.append('    chapters: [')
    for ch in part['chapters']:
        out.append('      NelsonChapter(')
        out.append(f'        number: {dart_str(ch["number"])},')
        out.append(f'        title: {dart_str(ch["title"])},')
        if 'section' in ch:
            out.append(f'        section: {dart_str(ch["section"])},')
        if ch['subchapters']:
            out.append('        subchapters: [')
            for sc in ch['subchapters']:
                out.append(
                    f'          NelsonSubchapter(number: {dart_str(sc["number"])}, '
                    f'title: {dart_str(sc["title"])}),'
                )
            out.append('        ],')
        out.append('      ),')
    out.append('    ],')
    out.append('  ),')

out.append('];')
out.append('')

import os
os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, 'w', encoding='utf-8') as f:
    f.write('\n'.join(out))

print(f'Parts: {len(structure)}')
total_ch = sum(len(p["chapters"]) for p in structure)
total_sc = sum(len(c["subchapters"]) for p in structure for c in p["chapters"])
print(f'Chapters: {total_ch}')
print(f'Subchapters: {total_sc}')
print(f'Wrote {OUT}')
