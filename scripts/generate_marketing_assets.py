#!/usr/bin/env python3
"""
generate_marketing_assets.py — Programmatic Play Store asset generator.

Run with:
    pip install pillow
    python scripts/generate_marketing_assets.py

Produces, in build/marketing_assets/:

    icon-512x512.png            — Play Store launcher icon
    feature-graphic-1024x500.png — Play Store feature graphic
    screenshot-01-1080x1920.png … screenshot-05-1080x1920.png
                                — phone screenshots wrapped in
                                  brand background + headlines
    tablet-7in-1200x1920.png    — 7-inch tablet
    tablet-10in-1600x2560.png   — 10-inch tablet

The script is intentionally self-contained — no external image inputs
needed. All visuals are drawn programmatically so they regenerate
consistently whenever you tweak the colours or copy.

Replace the SCREENSHOTS list below with real phone screenshots once
you've captured them; for now the script renders mock UI cards.
"""

from __future__ import annotations
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

# ── Brand palette ──────────────────────────────────────────────────────────
NAVY = (30, 58, 95)         # #1e3a5f
NAVY_2 = (44, 82, 130)      # #2c5282
ACCENT = (49, 130, 206)     # #3182ce
ACCENT_2 = (79, 168, 224)   # #4fa8e0
GREEN = (56, 161, 105)      # #38a169
WARNING = (214, 158, 46)    # #d69e2e
WHITE = (255, 255, 255)
INK = (45, 55, 72)          # #2d3748
INK_MUTED = (113, 128, 150) # #718096
BG = (247, 250, 252)        # #f7fafc

OUT_DIR = Path(__file__).resolve().parent.parent / 'build' / 'marketing_assets'
OUT_DIR.mkdir(parents=True, exist_ok=True)


# ── Font loader (best-effort — falls back to default if Inter not on host) ─
def load_font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    candidates = []
    if bold:
        candidates += [
            'C:/Windows/Fonts/segoeuib.ttf',
            'C:/Windows/Fonts/arialbd.ttf',
            '/System/Library/Fonts/SFNS.ttf',
            '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
        ]
    else:
        candidates += [
            'C:/Windows/Fonts/segoeui.ttf',
            'C:/Windows/Fonts/arial.ttf',
            '/System/Library/Fonts/SFNS.ttf',
            '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
        ]
    for path in candidates:
        if Path(path).exists():
            try:
                return ImageFont.truetype(path, size=size)
            except OSError:
                pass
    return ImageFont.load_default()


# ── Rounded rectangle helper ───────────────────────────────────────────────
def rounded_rect(img: Image.Image, xy, radius: int, fill, outline=None):
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline,
                           width=2 if outline else 0)


# ── Linear-gradient helper (vertical or diagonal) ──────────────────────────
def gradient_image(width: int, height: int, c1, c2, diagonal: bool = True):
    """Cheap manual gradient — fast enough for our sizes."""
    base = Image.new('RGB', (width, height), c1)
    top = Image.new('RGB', (width, height), c2)
    mask = Image.new('L', (width, height))
    md = mask.load()
    if diagonal:
        for y in range(height):
            for x in range(width):
                md[x, y] = int(255 * ((x + y) / (width + height)))
    else:
        for y in range(height):
            v = int(255 * (y / height))
            for x in range(width):
                md[x, y] = v
    base.paste(top, (0, 0), mask)
    return base


# ── 512x512 launcher icon ──────────────────────────────────────────────────
def build_icon():
    print('  building icon-512x512.png …')
    size = 512
    img = gradient_image(size, size, NAVY, ACCENT)
    draw = ImageDraw.Draw(img)
    # Soft circle highlight (top-left)
    overlay = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    od = ImageDraw.Draw(overlay)
    od.ellipse([-100, -100, 320, 320], fill=(255, 255, 255, 35))
    img.paste(overlay, (0, 0), overlay)
    # Big "P" or stethoscope-ish glyph — text-only for brand consistency.
    font = load_font(290, bold=True)
    text = 'P'
    # Centre roughly
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    draw.text(((size - tw) // 2 - bbox[0], (size - th) // 2 - bbox[1] - 30),
              text, font=font, fill=WHITE)
    # Subtle bottom label
    f2 = load_font(38, bold=True)
    label = 'PediAid'
    bbox2 = draw.textbbox((0, 0), label, font=f2)
    tw2 = bbox2[2] - bbox2[0]
    draw.text(((size - tw2) // 2 - bbox2[0], 410 - bbox2[1]),
              label, font=f2, fill=(255, 255, 255, 230))
    img.save(OUT_DIR / 'icon-512x512.png', optimize=True)


# ── 1024x500 feature graphic ───────────────────────────────────────────────
def build_feature():
    print('  building feature-graphic-1024x500.png …')
    img = gradient_image(1024, 500, NAVY, ACCENT)
    draw = ImageDraw.Draw(img)
    # Soft blob highlights
    overlay = Image.new('RGBA', (1024, 500), (0, 0, 0, 0))
    od = ImageDraw.Draw(overlay)
    od.ellipse([-200, -200, 600, 600], fill=(255, 255, 255, 25))
    od.ellipse([700, 280, 1300, 880], fill=(255, 255, 255, 18))
    img.paste(overlay, (0, 0), overlay)
    # Big headline + tagline
    f_big = load_font(78, bold=True)
    f_med = load_font(28, bold=False)
    f_eyebrow = load_font(16, bold=True)
    draw.text((60, 80), 'PEDIATRICS · NEONATOLOGY',
              font=f_eyebrow, fill=(255, 255, 255, 200))
    draw.multiline_text((58, 115), 'PediAid', font=f_big, fill=WHITE,
                        spacing=6)
    draw.multiline_text((60, 230),
                        'Calculators, growth charts, drug formulary,\n'
                        'NICE & AAP bilirubin, IAP STG, NNF CPG.',
                        font=f_med, fill=(255, 255, 255, 230), spacing=8)
    draw.text((60, 380), 'Bedside-ready.  Offline.  One app.',
              font=f_med, fill=(255, 255, 255, 200))
    img.save(OUT_DIR / 'feature-graphic-1024x500.png', optimize=True)


# ── Phone screenshots: 1080x1920 mock UI ───────────────────────────────────
SCREENSHOTS = [
    {
        'eyebrow': '18+ CALCULATORS',
        'headline': 'GIR, fluids,\nBP, eGFR, more.',
        'tagline': 'Every formula visible. Every safety band built in.',
        'bg': (NAVY, ACCENT),
    },
    {
        'eyebrow': 'GROWTH CHARTS',
        'headline': 'WHO, IAP, Fenton.\nPercentiles + z-scores.',
        'tagline': 'Plot once, switch view, no scrolling between books.',
        'bg': (GREEN, NAVY),
    },
    {
        'eyebrow': 'BILIRUBIN PATHWAYS',
        'headline': 'AAP 2022.\nNICE CG98.',
        'tagline': 'Hour-specific TSB thresholds. From 23 to 38+ weeks.',
        'bg': (WARNING, NAVY),
    },
    {
        'eyebrow': 'DRUG FORMULARY',
        'headline': 'Neofax.\nHarriet Lane.',
        'tagline': 'Search by drug, indication, or brand. Offline-ready.',
        'bg': (NAVY_2, ACCENT_2),
    },
    {
        'eyebrow': 'STANDARD GUIDELINES',
        'headline': 'IAP STG. NNF CPG.\nIAP Action Plan 2026.',
        'tagline': '237 chapters indexed. Tap, search, read.',
        'bg': (NAVY, GREEN),
    },
]


def build_screenshot(spec, out_name, w=1080, h=1920):
    bg = gradient_image(w, h, spec['bg'][0], spec['bg'][1])
    draw = ImageDraw.Draw(bg)

    # Eyebrow
    f_eyebrow = load_font(28, bold=True)
    f_headline = load_font(78, bold=True)
    f_tagline = load_font(34, bold=False)

    margin_x = 70
    y = 180

    draw.text((margin_x, y), spec['eyebrow'],
              font=f_eyebrow, fill=(255, 255, 255, 220))
    y += 75
    draw.multiline_text((margin_x, y), spec['headline'],
                        font=f_headline, fill=WHITE, spacing=14)
    # Estimate height for headline
    head_lines = spec['headline'].count('\n') + 1
    y += head_lines * 92
    draw.multiline_text((margin_x, y), spec['tagline'],
                        font=f_tagline, fill=(255, 255, 255, 230), spacing=8)

    # Mock device card
    card_top = h - 1100
    card_bottom = h - 120
    card_left = 90
    card_right = w - 90
    rounded_rect(bg, [card_left, card_top, card_right, card_bottom],
                 radius=40, fill=WHITE)

    # Mock card content
    cdraw = ImageDraw.Draw(bg)
    f_card_label = load_font(22, bold=True)
    f_card_value = load_font(64, bold=True)
    f_card_sub = load_font(22, bold=False)

    cdraw.text((card_left + 60, card_top + 80),
               'PEDIAID', font=f_card_label, fill=NAVY)
    cdraw.text((card_left + 60, card_top + 130),
               spec['headline'].split('\n')[0], font=f_card_value, fill=NAVY)
    cdraw.text((card_left + 60, card_top + 230),
               spec['tagline'].split('.')[0] + '.',
               font=f_card_sub, fill=INK_MUTED)

    # Mini "buttons" row
    btn_y = card_bottom - 220
    for i, (label, color) in enumerate([
        ('Open', ACCENT),
        ('Save', GREEN),
        ('Share', WARNING),
    ]):
        bx1 = card_left + 60 + i * 240
        bx2 = bx1 + 200
        rounded_rect(bg, [bx1, btn_y, bx2, btn_y + 70],
                     radius=14, fill=color)
        f_btn = load_font(22, bold=True)
        bbox = cdraw.textbbox((0, 0), label, font=f_btn)
        tw = bbox[2] - bbox[0]
        cdraw.text((bx1 + (200 - tw) // 2 - bbox[0],
                    btn_y + 22 - bbox[1]),
                   label, font=f_btn, fill=WHITE)

    bg.save(OUT_DIR / out_name, optimize=True)
    print(f'  built {out_name}')


def build_screenshots():
    for i, spec in enumerate(SCREENSHOTS, start=1):
        build_screenshot(spec, f'screenshot-{i:02d}-1080x1920.png')


# ── Tablet variants (re-render at tablet sizes) ────────────────────────────
def build_tablets():
    print('  building tablet variants …')
    build_screenshot(SCREENSHOTS[0], 'tablet-7in-1200x1920.png',
                     w=1200, h=1920)
    build_screenshot(SCREENSHOTS[0], 'tablet-10in-1600x2560.png',
                     w=1600, h=2560)


def main():
    print(f'Output: {OUT_DIR}')
    build_icon()
    build_feature()
    build_screenshots()
    build_tablets()
    print('\nDone. Upload these to Play Console.')


if __name__ == '__main__':
    main()
