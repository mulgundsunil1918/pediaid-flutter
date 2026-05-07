"""tools/play_assets.py — Play Store asset pack for PediAid.

Usage:
    PYTHONIOENCODING=utf-8 python tools/play_assets.py

Produces ./play-assets/ with:
    icon-512.png                     (sourced from assets/icon/app_icon.png)
    feature-graphic-1024x500.png
    phone-1-intro.png  … phone-7-guides.png          1080×1920
    tablet-7-1.png     … tablet-7-7.png              1200×1920
    tablet-10-1.png    … tablet-10-7.png             1800×2880
    short_description.txt
    full_description.txt
… and zips it to ./play-assets.zip.
"""
from __future__ import annotations

import math
import os
import shutil
import sys
import zipfile
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

# ──────────────────────────────────────────────────────────────────────
# Brand constants
# ──────────────────────────────────────────────────────────────────────
APP_NAME       = "PediAid"
WORDMARK       = "PEDIAID"
INITIAL        = "P"
TAGLINE        = "Paediatrics. Bedside-ready."
ONE_LINE_PITCH = "Calculators, drug formulary, growth charts and emergency protocols — paediatrics & neonatology in one app."

PRIMARY        = (21, 101, 192)     # #1565C0 — clinical blue
PRIMARY_DARK   = (13, 71, 161)      # #0D47A1
ACCENT         = (255, 179, 0)      # #FFB300 — amber for warnings / CTAs
ACCENT_DARK    = (255, 143, 0)      # #FF8F00
NAVY           = (13, 27, 42)       # #0D1B2A
NAVY_HEADER    = (18, 35, 56)
NAVY_LIGHTER   = (28, 48, 72)
DANGER         = (183, 28, 28)      # #B71C1C — emergency red
SUCCESS        = (46, 125, 50)
WARNING_AMBER  = (249, 168, 37)
GRAY_DARK      = (92, 102, 120)
GRAY_LIGHT     = (210, 215, 225)
WHITE          = (255, 255, 255)
DARK_TEXT      = (26, 31, 54)
EYEBROW_PILL   = (255, 235, 196)    # warm amber pill bg (per trap #10)

DOMAIN         = "mulgundsunil1918.github.io/pediaid-flutter"
SUPPORT_EMAIL  = "mulgundsunil@gmail.com"

ROOT          = Path(__file__).resolve().parents[1]
APP_ICON_SRC  = ROOT / "assets" / "icon" / "app_icon.png"
OUT_DIR       = ROOT / "play-assets"
ZIP_PATH      = ROOT / "play-assets.zip"

# ──────────────────────────────────────────────────────────────────────
# Cross-platform font loader
# ──────────────────────────────────────────────────────────────────────
WIN_FONTS = Path("C:/Windows/Fonts")
MAC_FONTS = Path("/System/Library/Fonts")
LIN_FONTS = Path("/usr/share/fonts/truetype/dejavu")


def _first_existing(*candidates):
    for p in candidates:
        if Path(p).exists():
            return Path(p)
    return None


_BLACK = _first_existing(
    WIN_FONTS / "seguibl.ttf",
    WIN_FONTS / "ariblk.ttf",
    MAC_FONTS / "Helvetica.ttc",
    LIN_FONTS / "DejaVuSans-Bold.ttf",
)
_BOLD = _first_existing(
    WIN_FONTS / "seguisb.ttf",
    WIN_FONTS / "arialbd.ttf",
    MAC_FONTS / "Helvetica.ttc",
    LIN_FONTS / "DejaVuSans-Bold.ttf",
)
_REG = _first_existing(
    WIN_FONTS / "segoeui.ttf",
    WIN_FONTS / "arial.ttf",
    MAC_FONTS / "Helvetica.ttc",
    LIN_FONTS / "DejaVuSans.ttf",
)

# Colour emoji font + its native bitmap size.
# Per trap #9: colour glyphs only render with embedded_color=True at the
# font's native size, so we always rasterise at native and LANCZOS-downscale.
_EMOJI = _first_existing(
    WIN_FONTS / "seguiemj.ttf",
    MAC_FONTS / "Apple Color Emoji.ttc",
    Path("/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf"),
)
_EMOJI_NATIVE = 109  # Segoe UI Emoji native bitmap size; Apple uses 137.
_emoji_cache: dict = {}


def render_emoji(char: str, size: int) -> Image.Image:
    """Rasterise a single-codepoint emoji at `size`×`size` pixels (RGBA).

    Returns a transparent square if the OS has no colour-emoji font.
    Cached, since the same emojis recur across slide variants.
    """
    if (char, size) in _emoji_cache:
        return _emoji_cache[(char, size)]
    if _EMOJI is None:
        out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    else:
        fnt = ImageFont.truetype(str(_EMOJI), _EMOJI_NATIVE)
        canvas = Image.new(
            "RGBA", (_EMOJI_NATIVE, _EMOJI_NATIVE), (0, 0, 0, 0)
        )
        d = ImageDraw.Draw(canvas)
        try:
            d.text(
                (_EMOJI_NATIVE / 2, _EMOJI_NATIVE / 2),
                char,
                font=fnt,
                embedded_color=True,
                anchor="mm",
            )
        except Exception:
            d.text(
                (_EMOJI_NATIVE / 2, _EMOJI_NATIVE / 2),
                char,
                font=fnt,
                anchor="mm",
            )
        out = canvas.resize((size, size), Image.LANCZOS)
    _emoji_cache[(char, size)] = out
    return out


def paste_emoji(img: Image.Image, char: str, xy, size: int):
    """Paste an emoji centred inside the box (xy, size, size) on `img`."""
    glyph = render_emoji(char, size)
    img.paste(glyph, (int(xy[0]), int(xy[1])), glyph)


def F(weight: str, size: int) -> ImageFont.FreeTypeFont:
    """Resolve a font for one of: 'black' / 'bold' / 'regular'."""
    chosen = {"black": _BLACK, "bold": _BOLD, "regular": _REG}[weight]
    if chosen is None:
        return ImageFont.load_default()
    return ImageFont.truetype(str(chosen), size)


# ──────────────────────────────────────────────────────────────────────
# Helpers — the trap-avoidance utilities the prompt insisted on
# ──────────────────────────────────────────────────────────────────────
def tint(rgb, alpha: int):
    """Pre-mix `rgb` with white at the given alpha (0–255). RGB-mode safe.

    Pillow's RGB mode silently drops alpha from fill tuples — this helper
    converts an "I want a 30-alpha tint" intent into the equivalent solid
    blended RGB.
    """
    return tuple(
        int(c + (255 - c) * (1 - alpha / 255))
        for c in rgb
    )


def text_centered(d: ImageDraw.ImageDraw, xy, w: int, h: int,
                  text: str, fnt, fill):
    """Draw `text` visually centred in the box (xy, w, h)."""
    cx = xy[0] + w / 2
    cy = xy[1] + h / 2
    d.text((cx, cy), text, font=fnt, fill=fill, anchor="mm")


def fit_font(text: str, max_w: int, weight: str,
             start: int, min_size: int = 24):
    """Auto-shrink font until `text` fits in `max_w`."""
    sz = start
    while sz >= min_size:
        f = F(weight, sz)
        l, t, r, b = f.getbbox(text)
        if (r - l) <= max_w:
            return f
        sz -= 4
    return F(weight, min_size)


def wrap_text(text: str, fnt, max_w: int) -> list[str]:
    """Greedy word-wrap a single-line `text` into lines that each fit
    within `max_w` pixels at the given font. Returns list of lines."""
    words = text.split()
    if not words:
        return [""]
    lines = []
    cur = words[0]
    for word in words[1:]:
        candidate = cur + " " + word
        l, t, r, b = fnt.getbbox(candidate)
        if (r - l) <= max_w:
            cur = candidate
        else:
            lines.append(cur)
            cur = word
    lines.append(cur)
    return lines


def draw_wrapped(d: ImageDraw.ImageDraw, xy, text: str, fnt, fill,
                 max_w: int, line_gap_factor: float = 0.30) -> int:
    """Draw `text` word-wrapped to fit `max_w`. Returns total height drawn."""
    lines = wrap_text(text, fnt, max_w)
    asc, desc = fnt.getmetrics()
    line_h = asc + desc
    gap = int(line_h * line_gap_factor)
    x, y = xy
    for i, line in enumerate(lines):
        d.text((x, y + i * (line_h + gap)),
               line, font=fnt, fill=fill, anchor="lt")
    return len(lines) * line_h + (len(lines) - 1) * gap


def rounded(d, xy, radius, **kw):
    d.rounded_rectangle(xy, radius=radius, **kw)


def shadow_under(canvas: Image.Image, xy, radius: int, blur: int = 30,
                 alpha: int = 90, dy: int = 14):
    """Soft drop-shadow under a rounded rect, used for the phone frame."""
    x0, y0, x1, y1 = xy
    pad = blur * 2
    layer = Image.new("RGBA", (x1 - x0 + pad * 2, y1 - y0 + pad * 2),
                      (0, 0, 0, 0))
    sd = ImageDraw.Draw(layer)
    sd.rounded_rectangle(
        [pad, pad + dy, pad + (x1 - x0), pad + (y1 - y0) + dy],
        radius=radius, fill=(0, 0, 0, alpha),
    )
    layer = layer.filter(ImageFilter.GaussianBlur(blur))
    canvas.alpha_composite(layer, (x0 - pad, y0 - pad))


# ──────────────────────────────────────────────────────────────────────
# Existing app icon — load + resize on demand
# ──────────────────────────────────────────────────────────────────────
_app_icon_full: Image.Image | None = None


def _icon_full() -> Image.Image:
    global _app_icon_full
    if _app_icon_full is None:
        if not APP_ICON_SRC.exists():
            sys.exit(f"App icon source missing: {APP_ICON_SRC}")
        _app_icon_full = Image.open(APP_ICON_SRC).convert("RGBA")
    return _app_icon_full


def app_icon(size: int) -> Image.Image:
    return _icon_full().resize((size, size), Image.LANCZOS)


# ──────────────────────────────────────────────────────────────────────
# (a) Icon — copy + resize the existing app icon
# ──────────────────────────────────────────────────────────────────────
def make_icon():
    icon = app_icon(512).convert("RGB")
    icon.save(OUT_DIR / "icon-512.png", "PNG", optimize=True)


# ──────────────────────────────────────────────────────────────────────
# (b) Feature graphic 1024×500
# ──────────────────────────────────────────────────────────────────────
def make_feature_graphic():
    W, H = 1024, 500
    img = Image.new("RGB", (W, H), PRIMARY_DARK)

    # Subtle radial light from the top-left corner (atmosphere, not banner)
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    for r in range(900, 0, -30):
        a = int(60 * (1 - r / 900))
        gd.ellipse([-200 - r, -200 - r, 380 + r, 380 + r],
                   fill=(255, 255, 255, a))
    img.paste(glow.filter(ImageFilter.GaussianBlur(70)),
              (0, 0), glow.filter(ImageFilter.GaussianBlur(70)))

    d = ImageDraw.Draw(img, "RGBA")

    # ─── LEFT HALF — brand block ─────────────────────────────────────
    icon_size = 132
    icon_x, icon_y = 64, 90
    img.paste(app_icon(icon_size), (icon_x, icon_y), app_icon(icon_size))

    wm_x = icon_x + icon_size + 28
    fwm = F("black", 64)
    d.text((wm_x, icon_y + 4), APP_NAME, font=fwm, fill=WHITE, anchor="lt")
    ftag = F("bold", 22)
    d.text((wm_x, icon_y + 80), TAGLINE.upper(),
           font=ftag, fill=tint(WHITE, 200), anchor="lt")

    # Bottom-left value prop + sub
    d.text((64, H - 116),
           "Calculators, drug doses & growth charts — bedside-ready.",
           font=F("black", 28), fill=WHITE, anchor="lt")
    d.text((64, H - 70),
           "Neonatology + Paediatrics. Offline. No accounts.",
           font=F("regular", 19), fill=tint(WHITE, 200), anchor="lt")

    # ─── RIGHT HALF — three stacked clinical cards ───────────────────
    card_w, card_h = 320, 84
    card_x = W - 60 - card_w
    base_y = 60
    items = [
        ("C", "GIR calculator",   "Calculators",  ACCENT),
        ("D", "Adrenaline · 12kg", "Drugs",       DANGER),
        ("G", "WHO weight-z",      "Charts",      SUCCESS),
    ]

    # Soft shadow blob behind card stack
    sh = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    sd = ImageDraw.Draw(sh)
    for i in range(len(items)):
        cy = base_y + i * (card_h + 18)
        sd.rounded_rectangle(
            [card_x + 6, cy + 14, card_x + card_w + 6, cy + card_h + 14],
            radius=18, fill=(0, 0, 0, 80),
        )
    img.paste(sh.filter(ImageFilter.GaussianBlur(16)),
              (0, 0), sh.filter(ImageFilter.GaussianBlur(16)))

    d = ImageDraw.Draw(img, "RGBA")
    for i, (letter, name, cat, accent) in enumerate(items):
        cy = base_y + i * (card_h + 18)
        rounded(d, [card_x, cy, card_x + card_w, cy + card_h],
                18, fill=WHITE)
        rounded(d, [card_x, cy, card_x + 8, cy + card_h], 0, fill=accent)

        tile_size = 50
        tx, ty = card_x + 22, cy + (card_h - tile_size) // 2
        rounded(d, [tx, ty, tx + tile_size, ty + tile_size],
                12, fill=tint(accent, 70))
        text_centered(d, (tx, ty), tile_size, tile_size,
                      letter, F("black", 26), accent if accent != tint(WHITE, 230) else PRIMARY)

        d.text((tx + tile_size + 18, cy + 16), name,
               font=F("bold", 22), fill=DARK_TEXT, anchor="lt")
        d.text((tx + tile_size + 18, cy + 46), cat,
               font=F("regular", 16), fill=GRAY_DARK, anchor="lt")

    img.save(OUT_DIR / "feature-graphic-1024x500.png", "PNG", optimize=True)


# ──────────────────────────────────────────────────────────────────────
# Slide canvas (deep navy + vignette + corner glow)
# ──────────────────────────────────────────────────────────────────────
def slide_canvas(W: int, H: int) -> Image.Image:
    # Vertical gradient: top brighter to bottom darker (~18% delta)
    img = Image.new("RGB", (W, H), NAVY)
    grad = Image.new("RGB", (1, H), NAVY)
    gd = ImageDraw.Draw(grad)
    for y in range(H):
        t = y / H
        c = tuple(int(NAVY_HEADER[i] * (1 - t) + NAVY[i] * t) for i in range(3))
        gd.point((0, y), fill=c)
    img.paste(grad.resize((W, H), Image.NEAREST), (0, 0))

    # Soft brand-primary glow in upper-right corner
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    rad = max(W, H) // 2
    for r in range(rad, 0, -20):
        a = int(70 * (1 - r / rad))
        gd.ellipse([W - rad, -rad, W + rad - r, rad - r],
                   fill=(*PRIMARY, a))
    img.paste(glow.filter(ImageFilter.GaussianBlur(80)),
              (0, 0), glow.filter(ImageFilter.GaussianBlur(80)))
    return img


def draw_brand_header(d: ImageDraw.ImageDraw, canvas: Image.Image,
                      W: int, H: int):
    pad = max(32, W // 36)
    header_h = max(70, H // 24)
    # Logo tile
    tile_size = header_h
    canvas.paste(app_icon(tile_size), (pad, pad), app_icon(tile_size))
    # Wordmark
    fwm = F("black", int(tile_size * 0.5))
    spacing_px = int(tile_size * 0.10)
    text = WORDMARK
    spaced = text  # rendered once with letterspacing trick below
    x = pad + tile_size + 16
    y = pad + tile_size // 2
    # Manual letter-spacing for the wordmark so it reads "PEDIAID" big
    cur_x = x
    for ch in text:
        d.text((cur_x, y), ch, font=fwm, fill=WHITE, anchor="lm")
        cw = fwm.getbbox(ch)[2] - fwm.getbbox(ch)[0]
        cur_x += cw + spacing_px
    # Divider line
    div_y = pad + tile_size + 12
    d.line([(pad, div_y), (W - pad, div_y)],
           fill=tint(PRIMARY, 90), width=2)


# ──────────────────────────────────────────────────────────────────────
# Slide 1 — Intro
# ──────────────────────────────────────────────────────────────────────
def slide_intro(W: int, H: int) -> Image.Image:
    img = slide_canvas(W, H)
    d = ImageDraw.Draw(img, "RGBA")

    # Big logo block centered
    icon_size = int(W * 0.34)
    ix = (W - icon_size) // 2
    iy = int(H * 0.22)
    img.paste(app_icon(icon_size), (ix, iy), app_icon(icon_size))

    # Wordmark below icon
    wm_size = int(W * 0.10)
    fwm = F("black", wm_size)
    text_centered(d, (0, iy + icon_size + int(H * 0.04)),
                  W, wm_size + 20, APP_NAME, fwm, WHITE)

    # Tagline
    tag_y = iy + icon_size + int(H * 0.04) + wm_size + 24
    ftag = F("bold", int(W * 0.038))
    text_centered(d, (0, tag_y), W, int(W * 0.050),
                  TAGLINE, ftag, ACCENT)

    # One-line pitch — render at a fixed readable size, wrap to ≤3
    # lines centred. Single-line fit_font was overflowing the canvas
    # at small font sizes.
    sub_y = tag_y + int(W * 0.075)
    fsub = F("regular", int(W * 0.030))
    sub_max_w = int(W * 0.84)
    sub_lines = wrap_text(ONE_LINE_PITCH, fsub, sub_max_w)
    asc_s, desc_s = fsub.getmetrics()
    line_h_s = asc_s + desc_s
    gap_s = int(line_h_s * 0.18)
    for i, ln in enumerate(sub_lines):
        ly = sub_y + i * (line_h_s + gap_s)
        l, t, r, b = fsub.getbbox(ln)
        lw = r - l
        d.text(((W - lw) // 2, ly),
               ln, font=fsub, fill=tint(WHITE, 230), anchor="lt")

    # Three feature pills — bigger so they read at thumbnail size
    pills = ["OFFLINE", "FREE", "EVIDENCE-BASED"]
    pill_y = int(H * 0.86)
    fp = F("black", int(W * 0.026))
    pad_x = int(W * 0.034)
    pad_y = int(W * 0.014)
    gaps = int(W * 0.022)

    pill_dims = []
    total_w = 0
    for p in pills:
        bbox = fp.getbbox(p)
        text_w = bbox[2] - bbox[0]
        text_h = bbox[3] - bbox[1]
        pw = text_w + pad_x * 2
        ph = max(int(W * 0.036), text_h + pad_y * 2)
        pill_dims.append((p, pw, ph, text_w, text_h))
        total_w += pw
    total_w += gaps * (len(pills) - 1)
    cur_x = (W - total_w) // 2
    for p, pw, ph, _, _ in pill_dims:
        rounded(d, [cur_x, pill_y, cur_x + pw, pill_y + ph],
                ph // 2, fill=PRIMARY)
        text_centered(d, (cur_x, pill_y), pw, ph, p, fp, WHITE)
        cur_x += pw + gaps

    return img


# ──────────────────────────────────────────────────────────────────────
# Slide 2 — Problem statement (5 numbered pain cards)
# ──────────────────────────────────────────────────────────────────────
PAIN_CARDS = [
    ("01", "Doses by mental math",
     "Adrenaline 0.01 mg/kg for a 12 kg child. At 3 a.m. With a sick baby in front of you."),
    ("02", "Books that won't open fast",
     "Neofax, Harriet Lane, Nelson — flipping pages wastes the minutes you don't have."),
    ("03", "Charts in a different drawer",
     "WHO, IAP, Fenton — separate apps, separate hassles, every single round."),
    ("04", "Five apps for one round",
     "Calc · drug doses · growth charts · bilirubin · BP — switch fatigue is real."),
]


def slide_problem(W: int, H: int) -> Image.Image:
    img = slide_canvas(W, H)
    d = ImageDraw.Draw(img, "RGBA")
    draw_brand_header(d, img, W, H)

    # Eyebrow pill — "THE PROBLEM" in warm amber on light pill
    eb_text = "THE PROBLEM"
    eb_font = F("black", int(W * 0.026))   # was 0.020 — bigger so it reads at thumbnail
    bbox = eb_font.getbbox(eb_text)
    eb_tw, eb_th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    pad_x, pad_y = int(W * 0.030), int(W * 0.014)
    eb_w = eb_tw + pad_x * 2
    eb_h = eb_th + pad_y * 2
    eb_x = (W - eb_w) // 2
    eb_y = int(H * 0.085)
    rounded(d, [eb_x, eb_y, eb_x + eb_w, eb_y + eb_h],
            eb_h // 2, fill=EYEBROW_PILL)
    text_centered(d, (eb_x, eb_y), eb_w, eb_h,
                  eb_text, eb_font, ACCENT_DARK)

    # Headline + sub
    headline = "You already know the medicine."
    sub = "You shouldn't be doing the maths at the cot side."
    h_y = eb_y + eb_h + int(H * 0.020)
    fh = fit_font(headline, int(W * 0.90), "black",
                  int(W * 0.060), min_size=32)
    text_centered(d, (0, h_y), W, int(W * 0.08), headline, fh, WHITE)
    fs = F("regular", int(W * 0.038))      # was 0.030 — bigger subtitle
    text_centered(d, (0, h_y + int(W * 0.085)),
                  W, int(W * 0.05), sub, fs, tint(WHITE, 215))

    # 4 numbered cards (was 5 — fewer cards, more breathing room each)
    margin = int(W * 0.05)
    card_x0 = margin
    card_x1 = W - margin
    list_y = h_y + int(W * 0.165)
    gap = int(W * 0.020)
    card_h = (H - list_y - int(H * 0.095)) // len(PAIN_CARDS) - gap
    if card_h < 80:
        card_h = 80

    for i, (num, title, body) in enumerate(PAIN_CARDS):
        cy = list_y + i * (card_h + gap)
        # White card
        rounded(d, [card_x0, cy, card_x1, cy + card_h],
                int(card_h * 0.16), fill=WHITE)
        # Left amber stripe (a bit thicker for visual weight)
        rounded(d, [card_x0, cy, card_x0 + 12, cy + card_h], 0, fill=ACCENT)
        # Number tile
        tile_size = int(card_h * 0.58)
        tx = card_x0 + int(W * 0.028)
        ty = cy + (card_h - tile_size) // 2
        rounded(d, [tx, ty, tx + tile_size, ty + tile_size],
                int(tile_size * 0.22), fill=ACCENT)
        text_centered(d, (tx, ty), tile_size, tile_size,
                      num, F("black", int(tile_size * 0.50)), WHITE)
        # Title + body — body now WORD-WRAPS to 2 lines instead of shrinking
        # to a tiny single line, so it stays legible at thumbnail size.
        text_x = tx + tile_size + int(W * 0.028)
        right_pad = int(W * 0.035)
        avail_w = card_x1 - text_x - right_pad
        title_font = fit_font(title, avail_w, "black",
                              int(card_h * 0.30), min_size=22)
        d.text((text_x, cy + int(card_h * 0.18)), title,
               font=title_font, fill=DARK_TEXT, anchor="lt")
        body_font = F("regular", int(W * 0.026))
        draw_wrapped(d, (text_x, cy + int(card_h * 0.58)), body,
                     body_font, GRAY_DARK, avail_w,
                     line_gap_factor=0.18)

    # Closing line in brand accent
    closing = "→ PediAid fixes that."
    cy = int(H * 0.955)
    text_centered(d, (0, cy - int(H * 0.025)), W, int(H * 0.05),
                  closing, F("black", int(W * 0.038)), ACCENT)

    return img


# ──────────────────────────────────────────────────────────────────────
# Phone frame — Android punch-hole
# ──────────────────────────────────────────────────────────────────────
def render_phone_in_frame(inner: Image.Image,
                          frame_w: int, frame_h: int) -> Image.Image:
    """Wrap `inner` (already rendered at frame inner-screen size) in an
    Android-style frame with bezel, rounded corners, punch-hole, and
    side-button slivers. Returns an RGBA image (frame_w × frame_h)."""
    bezel = max(10, int(frame_w * 0.020))
    radius = int(frame_w * 0.085)

    # Body
    body = Image.new("RGBA", (frame_w, frame_h), (0, 0, 0, 0))
    d = ImageDraw.Draw(body)
    d.rounded_rectangle([0, 0, frame_w, frame_h],
                        radius=radius, fill=(20, 25, 40, 255))

    # Inner screen well
    sx0 = bezel
    sy0 = bezel
    sx1 = frame_w - bezel
    sy1 = frame_h - bezel
    sw = sx1 - sx0
    sh = sy1 - sy0
    inner_resized = inner.resize((sw, sh), Image.LANCZOS).convert("RGBA")
    # Round screen corners
    mask = Image.new("L", (sw, sh), 0)
    md = ImageDraw.Draw(mask)
    md.rounded_rectangle([0, 0, sw, sh],
                         radius=int(radius * 0.80), fill=255)
    body.paste(inner_resized, (sx0, sy0), mask)

    # Punch-hole front camera (small dark circle, slight inner highlight)
    hole_r = max(8, int(frame_w * 0.022))
    hole_cx = frame_w // 2
    hole_cy = bezel + int(frame_w * 0.040)
    d.ellipse([hole_cx - hole_r, hole_cy - hole_r,
               hole_cx + hole_r, hole_cy + hole_r],
              fill=(8, 10, 18, 255))
    inner_r = int(hole_r * 0.55)
    d.ellipse([hole_cx - inner_r, hole_cy - inner_r,
               hole_cx + inner_r, hole_cy + inner_r],
              fill=(28, 32, 50, 255))

    # Right-edge buttons: power + 2 volume slivers
    btn_x0 = frame_w - bezel - 2
    btn_x1 = frame_w + 4
    # Power
    py0 = int(frame_h * 0.30)
    py1 = py0 + int(frame_h * 0.06)
    d.rounded_rectangle([btn_x0, py0, btn_x1, py1],
                        radius=4, fill=(28, 32, 52, 255))
    # Vol up
    vy0 = py1 + int(frame_h * 0.04)
    vy1 = vy0 + int(frame_h * 0.05)
    d.rounded_rectangle([btn_x0, vy0, btn_x1, vy1],
                        radius=4, fill=(28, 32, 52, 255))
    # Vol down
    wy0 = vy1 + int(frame_h * 0.012)
    wy1 = wy0 + int(frame_h * 0.05)
    d.rounded_rectangle([btn_x0, wy0, btn_x1, wy1],
                        radius=4, fill=(28, 32, 52, 255))

    return body


# ──────────────────────────────────────────────────────────────────────
# Inner UI mockup helpers
# ──────────────────────────────────────────────────────────────────────
def status_bar(d: ImageDraw.ImageDraw, w: int, light: bool = False):
    """Time on left, signal+battery on right."""
    bar_h = max(38, w // 22)
    fg = WHITE if not light else DARK_TEXT
    f = F("bold", int(bar_h * 0.50))
    d.text((bar_h * 0.6, bar_h / 2), "9:41", font=f, fill=fg, anchor="lm")
    # Right: signal bars + battery
    rx = w - bar_h * 0.6
    # Battery
    bw, bh = bar_h * 1.0, bar_h * 0.40
    bx0 = rx - bw
    by = bar_h / 2 - bh / 2
    d.rounded_rectangle([bx0, by, rx, by + bh], radius=4, outline=fg, width=2)
    d.rectangle([rx, by + bh * 0.25, rx + 4, by + bh * 0.75], fill=fg)
    d.rounded_rectangle([bx0 + 2, by + 2, bx0 + bw - 8, by + bh - 2],
                        radius=2, fill=fg)
    # Signal bars (4 ascending)
    sx = bx0 - 12
    sh = bar_h * 0.55
    for i in range(4):
        h = sh * (0.30 + i * 0.22)
        bw_b = bar_h * 0.15
        by0 = bar_h / 2 + sh / 2 - h
        d.rectangle([sx - (3 - i) * (bw_b + 4) - bw_b,
                     by0,
                     sx - (3 - i) * (bw_b + 4),
                     bar_h / 2 + sh / 2],
                    fill=fg)
    return bar_h


def mock_appbar(d, w: int, y: int, title: str, badge: str | None = None,
                primary_bg: bool = True):
    h = int(w * 0.13)
    bg = PRIMARY if primary_bg else WHITE
    fg = WHITE if primary_bg else DARK_TEXT
    d.rectangle([0, y, w, y + h], fill=bg)
    pad = int(w * 0.04)
    f = F("black", int(h * 0.40))
    d.text((pad, y + h / 2), title, font=f, fill=fg, anchor="lm")
    if badge:
        bf = F("black", int(h * 0.26))
        bbox = bf.getbbox(badge)
        bw = bbox[2] - bbox[0] + int(w * 0.040)
        bh = int(h * 0.45)
        bx = w - pad - bw
        by = y + (h - bh) // 2
        rounded(d, [bx, by, bx + bw, by + bh], bh // 2, fill=ACCENT)
        text_centered(d, (bx, by), bw, bh, badge, bf, DARK_TEXT)
    return h


def mock_bottom_nav(d, w: int, h: int, active_idx: int = 0):
    """5-item bottom nav. Returns the y where the nav starts."""
    nav_h = int(h * 0.085)
    ny = h - nav_h
    d.rectangle([0, ny, w, h], fill=WHITE)
    d.line([(0, ny), (w, ny)], fill=tint(GRAY_LIGHT, 230), width=1)
    items = ["Home", "Calc", "Drugs", "Charts", "Settings"]
    iw = w / len(items)
    for i, label in enumerate(items):
        cx = int(iw * (i + 0.5))
        active = i == active_idx
        # Dot icon
        rad = int(nav_h * 0.16)
        col = PRIMARY if active else GRAY_DARK
        d.ellipse([cx - rad, ny + int(nav_h * 0.18),
                   cx + rad, ny + int(nav_h * 0.18) + rad * 2],
                  fill=col)
        # Label — bigger so it reads at thumbnail
        f = F("black" if active else "regular", int(nav_h * 0.22))
        d.text((cx, ny + int(nav_h * 0.76)),
               label, font=f, fill=col, anchor="mm")
    return ny


# ─── Mock 1: Camera scanner ──────────────────────────────────────────
def screen_scan(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (12, 14, 28))
    d = ImageDraw.Draw(img, "RGBA")
    status_bar(d, w, light=False)

    # Faux viewfinder — slight gradient, document outline + corner brackets
    vf_x0 = int(w * 0.10)
    vf_y0 = int(h * 0.20)
    vf_x1 = int(w * 0.90)
    vf_y1 = int(h * 0.74)
    # Document — white-ish rectangle at slight tilt
    paper_pad = int(w * 0.04)
    rounded(d, [vf_x0 + paper_pad, vf_y0 + paper_pad,
                vf_x1 - paper_pad, vf_y1 - paper_pad],
            int(w * 0.02), fill=tint(WHITE, 240))
    # Faux text lines on the paper
    line_x0 = vf_x0 + paper_pad + int(w * 0.05)
    line_x1 = vf_x1 - paper_pad - int(w * 0.05)
    for i, frac in enumerate([0.18, 0.30, 0.42, 0.54, 0.66, 0.78]):
        ly = int(vf_y0 + (vf_y1 - vf_y0) * frac)
        line_w_factor = 1.0 if i % 3 != 2 else 0.65
        d.line([(line_x0, ly),
                (line_x0 + (line_x1 - line_x0) * line_w_factor, ly)],
               fill=tint(GRAY_DARK, 180), width=int(w * 0.008))

    # Auto-detected corner brackets in amber
    bracket = int(w * 0.06)
    bw = int(w * 0.012)
    for (cx, cy, dx, dy) in [
        (vf_x0, vf_y0, +1, +1),
        (vf_x1, vf_y0, -1, +1),
        (vf_x0, vf_y1, +1, -1),
        (vf_x1, vf_y1, -1, -1),
    ]:
        d.line([(cx, cy), (cx + dx * bracket, cy)], fill=ACCENT, width=bw)
        d.line([(cx, cy), (cx, cy + dy * bracket)], fill=ACCENT, width=bw)

    # Status pill above viewfinder
    pill_text = "Auto-detecting edges…"
    pf = F("bold", int(w * 0.028))
    bbox = pf.getbbox(pill_text)
    pw = bbox[2] - bbox[0] + int(w * 0.04)
    ph = int(w * 0.060)
    px = (w - pw) // 2
    py = vf_y0 - ph - int(w * 0.02)
    rounded(d, [px, py, px + pw, py + ph], ph // 2, fill=tint(NAVY, 220))
    text_centered(d, (px, py), pw, ph, pill_text, pf, WHITE)

    # Bottom: capture button + multi-page toggle
    cap_r = int(w * 0.10)
    cx = w // 2
    cy = int(h * 0.86)
    d.ellipse([cx - cap_r - 8, cy - cap_r - 8,
               cx + cap_r + 8, cy + cap_r + 8],
              outline=WHITE, width=int(w * 0.010))
    d.ellipse([cx - cap_r, cy - cap_r, cx + cap_r, cy + cap_r],
              fill=ACCENT)

    # Multi-page chip on left
    chip_text = "Multi-page · ON"
    cf = F("bold", int(w * 0.024))
    bbox = cf.getbbox(chip_text)
    cw_p = bbox[2] - bbox[0] + int(w * 0.04)
    ch_p = int(w * 0.052)
    cx_p = int(w * 0.06)
    cy_p = cy - ch_p // 2
    rounded(d, [cx_p, cy_p, cx_p + cw_p, cy_p + ch_p],
            ch_p // 2, fill=tint(PRIMARY, 170))
    text_centered(d, (cx_p, cy_p), cw_p, ch_p, chip_text, cf, WHITE)
    return img


# ─── Mock 2: Import sheet over Home ──────────────────────────────────
def screen_import(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (245, 247, 251))
    d = ImageDraw.Draw(img, "RGBA")
    status_bar(d, w)
    appbar_h = mock_appbar(d, w, status_bar(ImageDraw.Draw(Image.new("RGB",(w,38))), w),
                           APP_NAME)
    # We need the actual y_after_status — recompute simply
    bar_h = max(38, w // 22)
    appbar_h = int(w * 0.13)
    y = bar_h + appbar_h

    # Greeting card (indigo gradient)
    greet_h = int(h * 0.13)
    greet_y = y + int(h * 0.025)
    rounded(d, [int(w * 0.05), greet_y, int(w * 0.95),
                greet_y + greet_h], int(w * 0.04), fill=PRIMARY)
    f1 = F("black", int(w * 0.044))
    d.text((int(w * 0.07), greet_y + int(greet_h * 0.30)),
           "Good morning 👋", font=f1, fill=WHITE, anchor="lm")
    f2 = F("regular", int(w * 0.026))
    d.text((int(w * 0.07), greet_y + int(greet_h * 0.65)),
           "Tap Import to file a new document.",
           font=f2, fill=tint(WHITE, 220), anchor="lm")

    # 3 hero buttons row (Import / Scan / Find)
    hero_y = greet_y + greet_h + int(h * 0.025)
    hero_h = int(h * 0.10)
    btn_pad = int(w * 0.025)
    bx0 = int(w * 0.05)
    bx1 = int(w * 0.95)
    btn_w = (bx1 - bx0 - btn_pad * 2) // 3
    labels = [("Import", True), ("Scan", False), ("Find", False)]
    for i, (label, active) in enumerate(labels):
        bx = bx0 + i * (btn_w + btn_pad)
        bg = tint(PRIMARY, 60 if not active else 140)
        rounded(d, [bx, hero_y, bx + btn_w, hero_y + hero_h],
                int(w * 0.03), fill=bg)
        f = F("black", int(w * 0.026))
        text_centered(d, (bx, hero_y), btn_w, hero_h, label,
                      f, PRIMARY if not active else WHITE)

    # Dim overlay (sheet open)
    dim = Image.new("RGBA", (w, h), (10, 14, 30, 130))
    img.paste(dim, (0, 0), dim)
    d = ImageDraw.Draw(img, "RGBA")

    # Bottom-sheet panel
    sheet_y = int(h * 0.55)
    rounded(d, [0, sheet_y, w, h], int(w * 0.06), fill=WHITE)
    # Drag handle
    d.rounded_rectangle([w // 2 - int(w * 0.06), sheet_y + int(w * 0.020),
                         w // 2 + int(w * 0.06), sheet_y + int(w * 0.030)],
                        radius=8, fill=tint(GRAY_LIGHT, 220))

    # Sheet header
    fhd = F("black", int(w * 0.038))
    d.text((int(w * 0.06), sheet_y + int(w * 0.08)),
           "Import documents", font=fhd, fill=DARK_TEXT, anchor="lt")

    # 3 list items
    items = [
        ("📄", "Import a single file",
         "Pick one PDF, image, doc or note"),
        ("🗂", "Import multiple files",
         "Pick several at once"),
        ("📁", "Import an entire folder",
         "Recursively scan and batch-import"),
    ]
    item_y = sheet_y + int(w * 0.18)
    item_h = int(w * 0.16)
    for i, (icon_letter, title, sub) in enumerate(items):
        iy = item_y + i * (item_h + int(w * 0.020))
        # Tile
        tile_size = int(item_h * 0.82)
        tx = int(w * 0.06)
        ty = iy + (item_h - tile_size) // 2
        rounded(d, [tx, ty, tx + tile_size, ty + tile_size],
                int(tile_size * 0.22), fill=tint(PRIMARY, 60))
        text_centered(d, (tx, ty), tile_size, tile_size,
                      ["1", "N", "F"][i], F("black", int(tile_size * 0.46)),
                      PRIMARY)
        # Title + sub
        d.text((tx + tile_size + int(w * 0.04), iy + int(item_h * 0.22)),
               title, font=F("black", int(w * 0.030)),
               fill=DARK_TEXT, anchor="lt")
        d.text((tx + tile_size + int(w * 0.04), iy + int(item_h * 0.62)),
               sub, font=F("regular", int(w * 0.022)),
               fill=GRAY_DARK, anchor="lt")

    return img


# ─── Mock 3: Categories grid ─────────────────────────────────────────
CATEGORY_GRID = [
    ("Identity",   "🪪", PRIMARY,        12),
    ("Finance",    "💰", PRIMARY_DARK,   28),
    ("Work",       "💼", ACCENT_DARK,    19),
    ("Education",  "🎓", (123, 90, 220), 14),
    ("Health",     "🏥", SUCCESS,         9),
    ("Insurance",  "🛡", (90, 175, 220), 11),
    ("Property",   "🏠", (190, 100, 130),  6),
    ("Vehicle",    "🚗", (40, 140, 180),  4),
]


def screen_categories(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (245, 247, 251))
    d = ImageDraw.Draw(img, "RGBA")
    bar_h = status_bar(d, w)
    appbar_h = mock_appbar(d, w, bar_h, "My Library", primary_bg=False)
    y = bar_h + appbar_h

    # 2-column grid
    margin = int(w * 0.04)
    gap = int(w * 0.025)
    col_w = (w - margin * 2 - gap) // 2
    card_h = int(col_w * 0.85)

    for i, (name, emoji, accent, count) in enumerate(CATEGORY_GRID):
        col = i % 2
        row = i // 2
        cx = margin + col * (col_w + gap)
        cy = y + int(h * 0.025) + row * (card_h + gap)
        # Card with indigo gradient feel — solid tinted
        rounded(d, [cx, cy, cx + col_w, cy + card_h],
                int(col_w * 0.07), fill=accent)
        # Emoji in upper-left — direct paste, no white tile background.
        # (The earlier bug: tint(WHITE, 100) returned solid white, then
        # the letter was also white, so the icon looked like an empty box.)
        emoji_size = int(card_h * 0.32)
        ex = cx + int(col_w * 0.05)
        ey = cy + int(card_h * 0.07)
        paste_emoji(img, emoji, (ex, ey), emoji_size)
        # Name + count
        d.text((cx + int(col_w * 0.07), cy + int(card_h * 0.55)),
               name, font=F("black", int(col_w * 0.10)),
               fill=WHITE, anchor="lt")
        d.text((cx + int(col_w * 0.07), cy + int(card_h * 0.75)),
               f"{count} document{'s' if count != 1 else ''}",
               font=F("regular", int(col_w * 0.062)),
               fill=tint(WHITE, 220), anchor="lt")

    # Bottom nav
    mock_bottom_nav(d, w, h, active_idx=1)
    return img


# ─── Mock 4: Rich note editor ────────────────────────────────────────
def screen_notes(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (255, 251, 235))  # soft amber tint
    d = ImageDraw.Draw(img, "RGBA")
    bar_h = status_bar(d, w, light=True)
    # AppBar (white-ish on amber bg)
    abh = int(w * 0.13)
    f_ab = F("black", int(abh * 0.36))
    pad = int(w * 0.04)
    d.text((pad, bar_h + abh / 2), "Edit note", font=f_ab,
           fill=DARK_TEXT, anchor="lm")
    # Save button
    save_w, save_h = int(w * 0.18), int(abh * 0.55)
    sx = w - pad - save_w
    sy = bar_h + (abh - save_h) // 2
    rounded(d, [sx, sy, sx + save_w, sy + save_h],
            save_h // 2, fill=PRIMARY)
    text_centered(d, (sx, sy), save_w, save_h, "Save",
                  F("black", int(save_h * 0.42)), WHITE)
    y = bar_h + abh

    # Folder chip
    chip_text = "Work / Project Briefs"
    cf = F("bold", int(w * 0.026))
    bbox = cf.getbbox(chip_text)
    cw_p = bbox[2] - bbox[0] + int(w * 0.06)
    ch_p = int(w * 0.06)
    cx_p = pad
    cy_p = y + int(w * 0.03)
    rounded(d, [cx_p, cy_p, cx_p + cw_p, cy_p + ch_p],
            ch_p // 2, fill=tint(PRIMARY, 70))
    text_centered(d, (cx_p, cy_p), cw_p, ch_p, chip_text, cf, PRIMARY)

    # Title
    title_y = cy_p + ch_p + int(w * 0.03)
    d.text((pad, title_y), "Q1 review notes",
           font=F("black", int(w * 0.060)),
           fill=DARK_TEXT, anchor="lt")
    d.line([(pad, title_y + int(w * 0.085)),
            (w - pad, title_y + int(w * 0.085))],
           fill=tint(GRAY_LIGHT, 230), width=2)

    # Body — H1 + bullets, with one highlighted span
    body_y = title_y + int(w * 0.115)
    d.text((pad, body_y), "Action items",
           font=F("black", int(w * 0.044)),
           fill=DARK_TEXT, anchor="lt")
    body_y += int(w * 0.075)

    bullets = [
        ("•", "Ship", "v0.2.0 to Play Internal", " by Friday"),
        ("•", "Update", "privacy policy", " (camera disclosure)"),
        ("•", "Reach out to", "5 beta testers", " for review"),
        ("•", "Polish", "the home screen tips", " carousel"),
    ]
    fb = F("regular", int(w * 0.034))
    fbb = F("black", int(w * 0.034))
    for i, (b, prefix, mid, suffix) in enumerate(bullets):
        by_ = body_y + i * int(w * 0.062)
        d.text((pad, by_), b, font=fb, fill=DARK_TEXT, anchor="lt")
        x_cur = pad + int(w * 0.04)
        # prefix
        d.text((x_cur, by_), prefix + " ", font=fb, fill=DARK_TEXT, anchor="lt")
        x_cur += fb.getbbox(prefix + " ")[2]
        # highlighted (amber)
        bbox_m = fbb.getbbox(mid)
        mid_w, mid_h = bbox_m[2] - bbox_m[0], bbox_m[3] - bbox_m[1]
        rounded(d, [x_cur - 4, by_ + 2,
                    x_cur + mid_w + 4, by_ + mid_h + 8],
                6, fill=ACCENT)
        d.text((x_cur, by_), mid, font=fbb, fill=DARK_TEXT, anchor="lt")
        x_cur += mid_w
        # suffix
        d.text((x_cur, by_), suffix, font=fb, fill=DARK_TEXT, anchor="lt")

    # Toolbar at bottom
    tb_h = int(w * 0.13)
    tb_y = h - tb_h
    d.rectangle([0, tb_y, w, h], fill=WHITE)
    d.line([(0, tb_y), (w, tb_y)], fill=tint(GRAY_LIGHT, 230), width=1)
    icons = ["B", "I", "U", "S", "≡", "•", "1.", "H₁", "↺"]
    iw = w / len(icons)
    for i, label in enumerate(icons):
        cx = int(iw * (i + 0.5))
        d.text((cx, tb_y + tb_h / 2), label,
               font=F("black", int(tb_h * 0.32)),
               fill=DARK_TEXT, anchor="mm")
    return img


# ─── Mock 5: Expiry reminders ────────────────────────────────────────
def screen_reminders(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (245, 247, 251))
    d = ImageDraw.Draw(img, "RGBA")
    bar_h = status_bar(d, w)
    appbar_h = mock_appbar(d, w, bar_h, "Properties")
    y = bar_h + appbar_h

    # Doc card
    card_y = y + int(h * 0.025)
    card_h = int(h * 0.16)
    pad = int(w * 0.05)
    rounded(d, [pad, card_y, w - pad, card_y + card_h],
            int(w * 0.04), fill=WHITE)
    # PDF tile
    tile = int(card_h * 0.62)
    tx = pad + int(w * 0.04)
    ty = card_y + (card_h - tile) // 2
    rounded(d, [tx, ty, tx + tile, ty + tile],
            int(tile * 0.18), fill=DANGER)
    text_centered(d, (tx, ty), tile, tile, "PDF",
                  F("black", int(tile * 0.30)), WHITE)
    # Name + breadcrumb
    d.text((tx + tile + int(w * 0.04), card_y + int(card_h * 0.24)),
           "Passport.pdf", font=F("black", int(w * 0.040)),
           fill=DARK_TEXT, anchor="lt")
    d.text((tx + tile + int(w * 0.04), card_y + int(card_h * 0.60)),
           "Identity / Passport · 2.4 MB",
           font=F("regular", int(w * 0.026)),
           fill=GRAY_DARK, anchor="lt")

    # Expiry section
    sec_y = card_y + card_h + int(h * 0.030)
    rounded(d, [pad, sec_y, w - pad, sec_y + int(h * 0.30)],
            int(w * 0.04), fill=WHITE)
    sx = pad + int(w * 0.04)
    sy = sec_y + int(w * 0.04)
    d.text((sx, sy), "EXPIRY",
           font=F("black", int(w * 0.024)),
           fill=GRAY_DARK, anchor="lt")
    d.text((sx, sy + int(w * 0.05)),
           "15 March 2031",
           font=F("black", int(w * 0.052)),
           fill=DARK_TEXT, anchor="lt")
    # Days-until chip (green)
    chip_text = "in 4 years 10 months"
    cf = F("bold", int(w * 0.026))
    bbox = cf.getbbox(chip_text)
    cw_p = bbox[2] - bbox[0] + int(w * 0.04)
    ch_p = int(w * 0.058)
    cx_p = sx
    cy_p = sy + int(w * 0.13)
    rounded(d, [cx_p, cy_p, cx_p + cw_p, cy_p + ch_p],
            ch_p // 2, fill=tint(SUCCESS, 70))
    text_centered(d, (cx_p, cy_p), cw_p, ch_p, chip_text, cf, SUCCESS)

    # Reminder lead-time row
    rl_y = cy_p + ch_p + int(w * 0.04)
    d.text((sx, rl_y), "Reminder lead-time",
           font=F("regular", int(w * 0.028)),
           fill=GRAY_DARK, anchor="lt")
    d.text((sx, rl_y + int(w * 0.045)), "30 days before",
           font=F("black", int(w * 0.038)),
           fill=DARK_TEXT, anchor="lt")

    # Calendar status row (success bar) — use a drawn check tile
    # instead of the ✓ glyph (which Pillow + sans-serif font drops as a
    # tofu box per trap #9 in the prompt).
    cal_y = rl_y + int(w * 0.130)
    cal_h = int(w * 0.090)
    rounded(d, [sx, cal_y, w - pad - int(w * 0.04),
                cal_y + cal_h],
            int(w * 0.02), fill=tint(SUCCESS, 60))
    # Drawn check mark on the left
    check_size = int(cal_h * 0.55)
    cx = sx + int(cal_h * 0.20)
    cy = cal_y + (cal_h - check_size) // 2
    rounded(d, [cx, cy, cx + check_size, cy + check_size],
            check_size // 4, fill=SUCCESS)
    # Two-line check stroke
    d.line([
        (cx + check_size * 0.22, cy + check_size * 0.55),
        (cx + check_size * 0.42, cy + check_size * 0.74),
        (cx + check_size * 0.78, cy + check_size * 0.32),
    ], fill="white", width=max(3, int(check_size * 0.14)))
    f_cal = F("bold", int(w * 0.030))
    # Centre the text in the remaining space (right of the check tile)
    text_x = cx + check_size + int(w * 0.020)
    text_w = (w - pad - int(w * 0.04)) - text_x
    text_centered(d, (text_x, cal_y), text_w, cal_h,
                  "Reminder added to your phone calendar",
                  f_cal, SUCCESS)
    # Bottom nav
    mock_bottom_nav(d, w, h, active_idx=1)
    return img


# ──────────────────────────────────────────────────────────────────────
# Slide composer (feature slides)
# ──────────────────────────────────────────────────────────────────────
def slide_feature(W: int, H: int, screen_fn,
                  headline: str, subtitle: str) -> Image.Image:
    img = slide_canvas(W, H)
    d = ImageDraw.Draw(img, "RGBA")
    draw_brand_header(d, img, W, H)

    # Headline + subtitle — subtitle wraps to ≤2 lines at a fixed,
    # readable size instead of being shrunk to a single skinny line.
    h_y = int(H * 0.085)
    fh = fit_font(headline, int(W * 0.88), "black",
                  int(W * 0.062), min_size=32)
    text_centered(d, (0, h_y), W, int(W * 0.085), headline, fh, WHITE)

    # Wrap subtitle at a fixed font size, centered manually.
    fs = F("regular", int(W * 0.030))
    sub_y = h_y + int(W * 0.090)
    sub_max_w = int(W * 0.86)
    sub_lines = wrap_text(subtitle, fs, sub_max_w)
    asc, desc = fs.getmetrics()
    line_h = asc + desc
    sub_gap = int(line_h * 0.18)
    for i, ln in enumerate(sub_lines):
        ly = sub_y + i * (line_h + sub_gap)
        l, t, r, b = fs.getbbox(ln)
        lw = r - l
        d.text(((W - lw) // 2, ly), ln,
               font=fs, fill=tint(WHITE, 225), anchor="lt")
    sub_block_h = len(sub_lines) * line_h + (len(sub_lines) - 1) * sub_gap

    # Phone — width 75% of canvas, aspect ~9:18.
    # Phone-top now respects the actual subtitle block height so a 2-line
    # subtitle doesn't crash into the device frame.
    frame_w = int(W * 0.75)
    frame_h = int(frame_w * 1.96)
    available_y0 = sub_y + sub_block_h + int(W * 0.030)
    available_y1 = H - int(H * 0.04)
    if frame_h > (available_y1 - available_y0):
        frame_h = available_y1 - available_y0
        frame_w = int(frame_h / 1.96)

    # Render inner mock at frame inner size for crisp text
    bezel = max(10, int(frame_w * 0.020))
    inner_w = frame_w - bezel * 2
    inner_h = frame_h - bezel * 2
    inner = screen_fn(inner_w, inner_h)
    frame = render_phone_in_frame(inner, frame_w, frame_h)

    # Centered horizontally
    fx = (W - frame_w) // 2
    fy = available_y0 + (available_y1 - available_y0 - frame_h) // 2
    base = img.convert("RGBA")
    shadow_under(base, [fx, fy, fx + frame_w, fy + frame_h],
                 radius=int(frame_w * 0.085), blur=30,
                 alpha=110, dy=18)
    base.alpha_composite(frame, (fx, fy))
    return base.convert("RGB")


# ──────────────────────────────────────────────────────────────────────
# PediAid screen mocks (paediatric clinical UI)
# ──────────────────────────────────────────────────────────────────────

# ─── Mock A: Calculator hub ──────────────────────────────────────────
CALC_TILES = [
    ("GIR",        "mg/kg/min",       PRIMARY),
    ("Maint Fluids","Holliday-Segar", PRIMARY_DARK),
    ("Schwartz",   "eGFR",            (123, 90, 220)),
    ("BSA",        "m²",              (40, 140, 180)),
    ("Bilirubin",  "phototherapy",    ACCENT_DARK),
    ("BP %ile",    "by age + height", (190, 100, 130)),
    ("ETT depth",  "by age",          SUCCESS),
    ("Adrenaline", "code dose",       DANGER),
]


def screen_calculators(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (245, 247, 251))
    d = ImageDraw.Draw(img, "RGBA")
    bar_h = status_bar(d, w)
    appbar_h = mock_appbar(d, w, bar_h, "Calculators", badge="50+")
    y = bar_h + appbar_h

    # Search bar
    pad = int(w * 0.04)
    sb_y = y + int(h * 0.020)
    sb_h = int(w * 0.105)
    rounded(d, [pad, sb_y, w - pad, sb_y + sb_h],
            sb_h // 2, fill=WHITE)
    d.line([(pad, sb_y + sb_h),
            (w - pad, sb_y + sb_h)],
           fill=tint(GRAY_LIGHT, 220), width=1)
    # Magnifier dot
    cx = pad + int(w * 0.05)
    cy = sb_y + sb_h // 2
    d.ellipse([cx - 10, cy - 10, cx + 10, cy + 10],
              outline=GRAY_DARK, width=3)
    d.line([(cx + 7, cy + 7), (cx + 14, cy + 14)],
           fill=GRAY_DARK, width=3)
    d.text((pad + int(w * 0.13), sb_y + sb_h // 2),
           "Search calculators…",
           font=F("regular", int(w * 0.036)),
           fill=GRAY_DARK, anchor="lm")

    # 2-column grid of calculators (taller cards so subtitle has room)
    grid_y = sb_y + sb_h + int(h * 0.020)
    margin = pad
    gap = int(w * 0.030)
    col_w = (w - margin * 2 - gap) // 2
    card_h = int(col_w * 0.72)            # was 0.62 — taller card

    for i, (name, sub, accent) in enumerate(CALC_TILES):
        col = i % 2
        row = i // 2
        cx = margin + col * (col_w + gap)
        cy = grid_y + row * (card_h + gap)
        rounded(d, [cx, cy, cx + col_w, cy + card_h],
                int(col_w * 0.08), fill=WHITE)
        # Left accent stripe (thicker)
        rounded(d, [cx, cy, cx + 10, cy + card_h], 0, fill=accent)
        # Icon tile
        tile = int(card_h * 0.46)
        tx = cx + int(col_w * 0.07)
        ty = cy + (card_h - tile) // 2
        rounded(d, [tx, ty, tx + tile, ty + tile],
                int(tile * 0.22), fill=tint(accent, 70))
        text_centered(d, (tx, ty), tile, tile,
                      name[0],
                      F("black", int(tile * 0.55)), accent)
        # Name + subtitle — both bigger
        name_x = tx + tile + int(col_w * 0.06)
        avail_w = cx + col_w - name_x - int(col_w * 0.04)
        title_font = fit_font(name, avail_w, "black",
                              int(col_w * 0.092), min_size=16)
        d.text((name_x, cy + int(card_h * 0.28)), name,
               font=title_font, fill=DARK_TEXT, anchor="lt")
        sub_font = fit_font(sub, avail_w, "regular",
                            int(col_w * 0.082), min_size=14)
        d.text((name_x, cy + int(card_h * 0.62)), sub,
               font=sub_font, fill=GRAY_DARK, anchor="lt")

    # Bottom nav — Calc tab active
    mock_bottom_nav(d, w, h, active_idx=1)
    return img


# ─── Mock B: Drug formulary list ─────────────────────────────────────
FORMULARY_DRUGS = [
    ("P", "Paracetamol",
     "Analgesic · antipyretic",
     "10–15 mg/kg PO q4–6h",
     PRIMARY),
    ("A", "Amoxicillin",
     "β-lactam antibiotic",
     "25–50 mg/kg/day PO ÷ q8h",
     SUCCESS),
    ("C", "Cefotaxime",
     "3rd-gen cephalosporin",
     "50 mg/kg IV q6–8h",
     PRIMARY_DARK),
    ("A", "Adrenaline",
     "α/β agonist · code drug",
     "0.01 mg/kg IV/IO  ·  q3–5 min",
     DANGER),
]


def screen_formulary(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (245, 247, 251))
    d = ImageDraw.Draw(img, "RGBA")
    bar_h = status_bar(d, w)
    appbar_h = mock_appbar(d, w, bar_h, "Formulary", badge="2.0")
    y = bar_h + appbar_h

    # Segmented toggle: NEONATES | PAEDIATRICS
    pad = int(w * 0.04)
    seg_y = y + int(h * 0.020)
    seg_h = int(w * 0.090)
    seg_w = w - pad * 2
    rounded(d, [pad, seg_y, pad + seg_w, seg_y + seg_h],
            seg_h // 2, fill=tint(GRAY_LIGHT, 230))
    half_w = seg_w // 2
    # Active half (Paediatrics on the right)
    rounded(d, [pad + half_w, seg_y, pad + seg_w, seg_y + seg_h],
            seg_h // 2, fill=PRIMARY)
    f_seg = F("black", int(w * 0.036))
    text_centered(d, (pad, seg_y), half_w, seg_h,
                  "Neonates", f_seg, GRAY_DARK)
    text_centered(d, (pad + half_w, seg_y), half_w, seg_h,
                  "Paediatrics", f_seg, WHITE)

    # Search bar
    sb_y = seg_y + seg_h + int(h * 0.020)
    sb_h = int(w * 0.110)
    rounded(d, [pad, sb_y, w - pad, sb_y + sb_h],
            sb_h // 2, fill=WHITE)
    cx = pad + int(w * 0.05)
    cy = sb_y + sb_h // 2
    d.ellipse([cx - 11, cy - 11, cx + 11, cy + 11],
              outline=GRAY_DARK, width=3)
    d.line([(cx + 8, cy + 8), (cx + 16, cy + 16)],
           fill=GRAY_DARK, width=3)
    d.text((pad + int(w * 0.135), sb_y + sb_h // 2),
           "Search 478 paediatric drugs…",
           font=F("regular", int(w * 0.034)),
           fill=GRAY_DARK, anchor="lm")

    # Drug cards — fewer & taller so the dose line is readable
    list_y = sb_y + sb_h + int(h * 0.020)
    card_h = int(w * 0.255)             # was 0.215 — taller card
    gap = int(w * 0.028)
    for i, (letter, name, klass, dose, accent) in enumerate(FORMULARY_DRUGS):
        cy = list_y + i * (card_h + gap)
        rounded(d, [pad, cy, w - pad, cy + card_h],
                int(w * 0.04), fill=WHITE)
        # Left accent stripe (thicker)
        rounded(d, [pad, cy, pad + 10, cy + card_h], 0, fill=accent)
        # Letter tile
        tile = int(card_h * 0.50)
        tx = pad + int(w * 0.045)
        ty = cy + (card_h - tile) // 2
        rounded(d, [tx, ty, tx + tile, ty + tile],
                int(tile * 0.22), fill=tint(accent, 70))
        text_centered(d, (tx, ty), tile, tile, letter,
                      F("black", int(tile * 0.55)), accent)
        # Name + class + dose
        text_x = tx + tile + int(w * 0.045)
        avail_w = w - pad - text_x - int(w * 0.030)
        d.text((text_x, cy + int(card_h * 0.16)), name,
               font=F("black", int(w * 0.046)),     # was 0.038
               fill=DARK_TEXT, anchor="lt")
        # Class chip — bigger text + more padding
        cf = F("bold", int(w * 0.028))               # was 0.022
        bbox_c = cf.getbbox(klass)
        cw_c = bbox_c[2] - bbox_c[0] + int(w * 0.040)
        ch_c = int(w * 0.054)                        # was 0.044
        cx_c = text_x
        cy_c = cy + int(card_h * 0.44)
        rounded(d, [cx_c, cy_c, cx_c + cw_c, cy_c + ch_c],
                ch_c // 2, fill=tint(accent, 80))
        text_centered(d, (cx_c, cy_c), cw_c, ch_c, klass, cf, accent)
        # Dose line (auto-fit) — bumped up so it's the strongest body line
        dose_font = fit_font(dose, avail_w, "regular",
                             int(w * 0.032), min_size=18)
        d.text((text_x, cy + int(card_h * 0.78)), dose,
               font=dose_font, fill=GRAY_DARK, anchor="lt")

    # Bottom nav — Drugs tab active
    mock_bottom_nav(d, w, h, active_idx=2)
    return img


# ─── Mock C: WHO growth chart ────────────────────────────────────────
def screen_charts(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (245, 247, 251))
    d = ImageDraw.Draw(img, "RGBA")
    bar_h = status_bar(d, w)
    appbar_h = mock_appbar(d, w, bar_h, "Weight-for-age", badge="WHO")
    y = bar_h + appbar_h

    # Toggle row: Boys | Girls
    pad = int(w * 0.04)
    seg_y = y + int(h * 0.018)
    seg_h = int(w * 0.080)
    seg_w = w - pad * 2
    rounded(d, [pad, seg_y, pad + seg_w, seg_y + seg_h],
            seg_h // 2, fill=tint(GRAY_LIGHT, 230))
    half_w = seg_w // 2
    rounded(d, [pad, seg_y, pad + half_w, seg_y + seg_h],
            seg_h // 2, fill=PRIMARY)
    f_seg = F("black", int(w * 0.034))
    text_centered(d, (pad, seg_y), half_w, seg_h, "Boys", f_seg, WHITE)
    text_centered(d, (pad + half_w, seg_y), half_w, seg_h,
                  "Girls", f_seg, GRAY_DARK)

    # Chart card
    chart_y = seg_y + seg_h + int(h * 0.018)
    chart_h = int(h * 0.42)
    rounded(d, [pad, chart_y, w - pad, chart_y + chart_h],
            int(w * 0.04), fill=WHITE)

    # Inner plot area
    plot_x0 = pad + int(w * 0.10)
    plot_y0 = chart_y + int(w * 0.06)
    plot_x1 = w - pad - int(w * 0.04)
    plot_y1 = chart_y + chart_h - int(w * 0.10)
    plot_w = plot_x1 - plot_x0
    plot_h = plot_y1 - plot_y0

    # Axes
    d.line([(plot_x0, plot_y0), (plot_x0, plot_y1)],
           fill=GRAY_DARK, width=2)
    d.line([(plot_x0, plot_y1), (plot_x1, plot_y1)],
           fill=GRAY_DARK, width=2)
    # Grid lines
    for i in range(1, 5):
        gy = plot_y0 + plot_h * i / 5
        d.line([(plot_x0, gy), (plot_x1, gy)],
               fill=tint(GRAY_LIGHT, 230), width=1)
    for i in range(1, 6):
        gx = plot_x0 + plot_w * i / 6
        d.line([(gx, plot_y0), (gx, plot_y1)],
               fill=tint(GRAY_LIGHT, 230), width=1)

    # Three percentile curves (3rd low, 50th middle, 97th high)
    # Each curve is a slow upward arc — sampled at 24 points.
    def curve(off):
        pts = []
        for k in range(25):
            t = k / 24
            # Logarithmic-ish growth — fast early, slow later.
            yv = 1.0 - math.pow(1 - t, 0.6)  # 0..1
            yv = 0.85 - yv * 0.70 + off       # invert for screen y
            xv = t
            px = plot_x0 + plot_w * xv
            py = plot_y0 + plot_h * yv
            pts.append((px, py))
        return pts

    curves = [
        (curve(+0.18), tint(PRIMARY, 130), "3rd"),
        (curve(0.0),   PRIMARY,             "50th"),
        (curve(-0.18), tint(PRIMARY, 130), "97th"),
    ]
    for pts, col, _ in curves:
        for j in range(len(pts) - 1):
            d.line([pts[j], pts[j + 1]], fill=col, width=4)

    # Plotted point — child at age ~24mo, weight z = -0.4 (between 50th + 3rd)
    # Use median curve, then offset toward 3rd by ~30%.
    mid_pts = curves[1][0]
    low_pts = curves[0][0]
    idx = 14  # ~ age 24 months
    px = mid_pts[idx][0]
    py_mid = mid_pts[idx][1]
    py_low = low_pts[idx][1]
    py = py_mid + (py_low - py_mid) * 0.30
    # Concentric dots
    d.ellipse([px - 16, py - 16, px + 16, py + 16],
              fill=tint(ACCENT, 90))
    d.ellipse([px - 9, py - 9, px + 9, py + 9],
              fill=ACCENT)
    d.ellipse([px - 4, py - 4, px + 4, py + 4],
              fill=WHITE)

    # Callout pill above the point — bigger so the headline number reads
    callout = "9.2 kg  ·  z = -0.4"
    cf = F("black", int(w * 0.030))
    bbox = cf.getbbox(callout)
    cw_p = bbox[2] - bbox[0] + int(w * 0.05)
    ch_p = int(w * 0.070)
    cx_p = int(px - cw_p / 2)
    cy_p = int(py - ch_p - 16)
    if cx_p + cw_p > plot_x1:
        cx_p = plot_x1 - cw_p
    if cx_p < plot_x0:
        cx_p = plot_x0
    rounded(d, [cx_p, cy_p, cx_p + cw_p, cy_p + ch_p],
            ch_p // 2, fill=NAVY)
    text_centered(d, (cx_p, cy_p), cw_p, ch_p, callout, cf, WHITE)

    # Y axis label (kg)
    d.text((plot_x0 - int(w * 0.022), plot_y0 - int(w * 0.012)),
           "kg", font=F("bold", int(w * 0.028)),
           fill=GRAY_DARK, anchor="rt")
    # X axis label (months)
    d.text((plot_x1, plot_y1 + int(w * 0.020)),
           "months", font=F("bold", int(w * 0.028)),
           fill=GRAY_DARK, anchor="rt")

    # Stats card below the chart
    stats_y = chart_y + chart_h + int(h * 0.020)
    stats_h = int(h * 0.13)
    rounded(d, [pad, stats_y, w - pad, stats_y + stats_h],
            int(w * 0.04), fill=WHITE)
    cells = [
        ("AGE",    "24 mo"),
        ("WEIGHT", "9.2 kg"),
        ("Z",      "-0.4"),
        ("%ILE",   "34th"),
    ]
    cell_w = (w - pad * 2) // len(cells)
    for i, (label, value) in enumerate(cells):
        cx_s = pad + i * cell_w
        f_lab = F("black", int(w * 0.028))
        d.text((cx_s + cell_w // 2, stats_y + int(stats_h * 0.27)),
               label, font=f_lab, fill=GRAY_DARK, anchor="mm")
        f_val = F("black", int(w * 0.052))
        d.text((cx_s + cell_w // 2, stats_y + int(stats_h * 0.65)),
               value, font=f_val, fill=DARK_TEXT, anchor="mm")
        if i < len(cells) - 1:
            d.line([(cx_s + cell_w, stats_y + int(stats_h * 0.18)),
                    (cx_s + cell_w, stats_y + int(stats_h * 0.82))],
                   fill=tint(GRAY_LIGHT, 220), width=1)

    # Bottom nav — Charts tab active
    mock_bottom_nav(d, w, h, active_idx=3)
    return img


# ─── Mock D: Emergency drug card ─────────────────────────────────────
def screen_emergency_drug(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (245, 247, 251))
    d = ImageDraw.Draw(img, "RGBA")
    bar_h = status_bar(d, w)

    # Red emergency app bar
    abh = int(w * 0.13)
    d.rectangle([0, bar_h, w, bar_h + abh], fill=DANGER)
    pad = int(w * 0.04)
    f_ab = F("black", int(abh * 0.40))
    d.text((pad, bar_h + abh / 2), "Adrenaline",
           font=f_ab, fill=WHITE, anchor="lm")
    # CODE pill on right
    code_text = "CODE"
    cf = F("black", int(abh * 0.28))
    bbox = cf.getbbox(code_text)
    pw = bbox[2] - bbox[0] + int(w * 0.04)
    ph = int(abh * 0.50)
    px = w - pad - pw
    py = bar_h + (abh - ph) // 2
    rounded(d, [px, py, px + pw, py + ph], ph // 2, fill=WHITE)
    text_centered(d, (px, py), pw, ph, code_text, cf, DANGER)
    y = bar_h + abh

    # Weight pill row
    wt_y = y + int(h * 0.020)
    wt_h = int(w * 0.135)
    rounded(d, [pad, wt_y, w - pad, wt_y + wt_h],
            int(w * 0.05), fill=WHITE)
    # Left: "PATIENT WEIGHT"
    d.text((pad + int(w * 0.045), wt_y + int(wt_h * 0.30)),
           "PATIENT WEIGHT",
           font=F("black", int(w * 0.030)),
           fill=GRAY_DARK, anchor="lm")
    # Right: big "12 kg"
    d.text((pad + int(w * 0.045), wt_y + int(wt_h * 0.72)),
           "12 kg",
           font=F("black", int(w * 0.066)),
           fill=DARK_TEXT, anchor="lm")
    # − / + buttons on the right
    btn_size = int(wt_h * 0.62)
    bxr = w - pad - int(w * 0.04) - btn_size
    byr = wt_y + (wt_h - btn_size) // 2
    rounded(d, [bxr, byr, bxr + btn_size, byr + btn_size],
            btn_size // 4, fill=tint(PRIMARY, 60))
    text_centered(d, (bxr, byr), btn_size, btn_size, "+",
                  F("black", int(btn_size * 0.62)), PRIMARY)
    bxl = bxr - btn_size - int(w * 0.025)
    rounded(d, [bxl, byr, bxl + btn_size, byr + btn_size],
            btn_size // 4, fill=tint(PRIMARY, 60))
    text_centered(d, (bxl, byr), btn_size, btn_size, "−",
                  F("black", int(btn_size * 0.62)), PRIMARY)

    # Indication chip
    ind_y = wt_y + wt_h + int(h * 0.018)
    ind_text = "Cardiac arrest · pulseless"
    cf = F("bold", int(w * 0.032))
    bbox = cf.getbbox(ind_text)
    cw_p = bbox[2] - bbox[0] + int(w * 0.07)
    ch_p = int(w * 0.072)
    cx_p = pad
    rounded(d, [cx_p, ind_y, cx_p + cw_p, ind_y + ch_p],
            ch_p // 2, fill=tint(DANGER, 60))
    text_centered(d, (cx_p, ind_y), cw_p, ch_p, ind_text, cf, DANGER)

    # Big dose box (red bg)
    dose_y = ind_y + ch_p + int(h * 0.020)
    dose_h = int(h * 0.22)
    rounded(d, [pad, dose_y, w - pad, dose_y + dose_h],
            int(w * 0.04), fill=DANGER)
    # Dose label + value
    d.text((pad + int(w * 0.050), dose_y + int(dose_h * 0.14)),
           "BOLUS DOSE",
           font=F("black", int(w * 0.030)),
           fill=tint(WHITE, 200), anchor="lt")
    d.text((pad + int(w * 0.050), dose_y + int(dose_h * 0.32)),
           "0.12 mg  IV / IO",
           font=F("black", int(w * 0.072)),
           fill=WHITE, anchor="lt")
    d.text((pad + int(w * 0.050), dose_y + int(dose_h * 0.62)),
           "= 1.2 mL of 1:10,000",
           font=F("black", int(w * 0.050)),
           fill=tint(WHITE, 235), anchor="lt")
    d.text((pad + int(w * 0.050), dose_y + int(dose_h * 0.83)),
           "Repeat q3–5 min  ·  max 1 mg",
           font=F("regular", int(w * 0.032)),
           fill=tint(WHITE, 215), anchor="lt")

    # Prep steps
    steps_y = dose_y + dose_h + int(h * 0.020)
    d.text((pad, steps_y),
           "PREP",
           font=F("black", int(w * 0.030)),
           fill=GRAY_DARK, anchor="lt")
    steps = [
        "Draw 1 mL of 1:1,000 adrenaline (1 mg/mL)",
        "Dilute to 10 mL with NS → 1:10,000 (0.1 mg/mL)",
        "Push 1.2 mL IV / IO, flush with 5 mL NS",
    ]
    sy = steps_y + int(w * 0.058)
    step_h = int(w * 0.105)
    for i, s in enumerate(steps):
        ys = sy + i * (step_h + int(w * 0.014))
        # Number bubble
        nb = int(step_h * 0.62)
        nx = pad
        ny = ys + (step_h - nb) // 2
        d.ellipse([nx, ny, nx + nb, ny + nb], fill=PRIMARY)
        text_centered(d, (nx, ny), nb, nb, str(i + 1),
                      F("black", int(nb * 0.55)), WHITE)
        # Text — auto-fit so longer step lines don't truncate
        text_x = nx + nb + int(w * 0.035)
        avail = w - pad - text_x
        f_step = fit_font(s, avail, "regular",
                          int(w * 0.032), min_size=18)
        d.text((text_x, ys + step_h // 2),
               s, font=f_step, fill=DARK_TEXT, anchor="lm")

    # Bottom nav — Drugs tab active
    mock_bottom_nav(d, w, h, active_idx=2)
    return img


# ─── Mock E: Clinical guides list ────────────────────────────────────
GUIDES = [
    ("DKA",                   "Diabetic ketoacidosis",        "ICU",       DANGER),
    ("Snake bite",            "Anti-snake-venom protocol",    "URGENT",    ACCENT_DARK),
    ("Scorpion sting",        "Prazosin · pulmonary oedema",  "URGENT",    ACCENT_DARK),
    ("Status epilepticus",    "Lorazepam → phenytoin → ICU",  "ICU",       DANGER),
    ("Procedural sedation",   "Midazolam · ketamine · monitoring", "ROUTINE", SUCCESS),
]


def screen_guides(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h), (245, 247, 251))
    d = ImageDraw.Draw(img, "RGBA")
    bar_h = status_bar(d, w)
    appbar_h = mock_appbar(d, w, bar_h, "Clinical guides")
    y = bar_h + appbar_h

    pad = int(w * 0.04)
    list_y = y + int(h * 0.025)
    card_h = int(h * 0.120)              # was 0.105 — taller cards
    gap = int(w * 0.028)
    for i, (title, sub, severity, accent) in enumerate(GUIDES):
        cy = list_y + i * (card_h + gap)
        rounded(d, [pad, cy, w - pad, cy + card_h],
                int(w * 0.04), fill=WHITE)
        # Severity stripe (thicker on the left)
        rounded(d, [pad, cy, pad + 10, cy + card_h], 0, fill=accent)
        # Title + sub
        text_x = pad + int(w * 0.050)
        right_pad = int(w * 0.040)
        # Severity pill on the right — bigger text + more padding
        sf = F("black", int(w * 0.026))
        bbox = sf.getbbox(severity)
        sw_p = bbox[2] - bbox[0] + int(w * 0.044)
        sh_p = int(w * 0.058)
        sx_p = w - pad - right_pad - sw_p
        sy_p = cy + int(card_h * 0.22)
        rounded(d, [sx_p, sy_p, sx_p + sw_p, sy_p + sh_p],
                sh_p // 2, fill=tint(accent, 70))
        text_centered(d, (sx_p, sy_p), sw_p, sh_p, severity, sf, accent)
        # Title (auto-fit, leaves space for severity pill)
        title_avail = sx_p - text_x - int(w * 0.030)
        title_font = fit_font(title, title_avail, "black",
                              int(w * 0.046), min_size=22)
        d.text((text_x, cy + int(card_h * 0.26)), title,
               font=title_font, fill=DARK_TEXT, anchor="lt")
        # Subtitle
        sub_avail = w - pad - right_pad - text_x
        sub_font = fit_font(sub, sub_avail, "regular",
                            int(w * 0.032), min_size=16)
        d.text((text_x, cy + int(card_h * 0.66)), sub,
               font=sub_font, fill=GRAY_DARK, anchor="lt")

    # Footer note
    f_y = list_y + len(GUIDES) * (card_h + gap) + int(h * 0.022)
    d.text((w // 2, f_y),
           "All guides reviewed by paediatricians · updated 2026",
           font=F("regular", int(w * 0.030)),
           fill=GRAY_DARK, anchor="mt")

    # Bottom nav — Home tab active (guides accessed from Home)
    mock_bottom_nav(d, w, h, active_idx=0)
    return img


# ──────────────────────────────────────────────────────────────────────
# Slide pack emitter
# ──────────────────────────────────────────────────────────────────────
FEATURES = [
    ("phone-3-calculators",
     screen_calculators,
     "50+ paediatric calculators",
     "GIR, BSA, Schwartz eGFR, maintenance fluids, bilirubin risk, BP %ile…"),
    ("phone-4-formulary",
     screen_formulary,
     "Drug Formulary 2.0",
     "199 NICU drugs (Neofax) + 478 PICU drugs (Harriet Lane). Offline."),
    ("phone-5-charts",
     screen_charts,
     "WHO + IAP growth charts",
     "Plot weight, length, head circumference. Instant z-score + percentile."),
    ("phone-6-emergency",
     screen_emergency_drug,
     "Code drugs by weight",
     "Tap weight → bolus dose, mL to push, prep steps. NICU + PICU."),
    ("phone-7-guides",
     screen_guides,
     "Clinical guides at the bedside",
     "DKA, snake bite, scorpion sting, sedation, status epilepticus."),
]


def emit_slide_set(prefix: str, W: int, H: int):
    """Render the 7-slide pack at (W, H) and save with `prefix`."""
    slide_intro(W, H).save(OUT_DIR / f"{prefix}1-intro.png", "PNG", optimize=True)
    slide_problem(W, H).save(OUT_DIR / f"{prefix}2-problem.png", "PNG", optimize=True)
    for i, (name, fn, headline, subtitle) in enumerate(FEATURES, start=3):
        slug = name.split("-", 2)[-1]
        slide = slide_feature(W, H, fn, headline, subtitle)
        slide.save(OUT_DIR / f"{prefix}{i}-{slug}.png", "PNG", optimize=True)


def make_phone_screens():
    emit_slide_set(prefix="phone-", W=1080, H=1920)


def make_tablet_7_screens():
    # 1200×1920 — same composition, slightly wider canvas
    W, H = 1200, 1920
    slide_intro(W, H).save(OUT_DIR / "tablet-7-1.png", "PNG", optimize=True)
    slide_problem(W, H).save(OUT_DIR / "tablet-7-2.png", "PNG", optimize=True)
    for i, (name, fn, headline, subtitle) in enumerate(FEATURES, start=3):
        slide_feature(W, H, fn, headline, subtitle).save(
            OUT_DIR / f"tablet-7-{i}.png", "PNG", optimize=True
        )


def make_tablet_10_screens():
    # 1800×2880 — 10-inch tablet
    W, H = 1800, 2880
    slide_intro(W, H).save(OUT_DIR / "tablet-10-1.png", "PNG", optimize=True)
    slide_problem(W, H).save(OUT_DIR / "tablet-10-2.png", "PNG", optimize=True)
    for i, (name, fn, headline, subtitle) in enumerate(FEATURES, start=3):
        slide_feature(W, H, fn, headline, subtitle).save(
            OUT_DIR / f"tablet-10-{i}.png", "PNG", optimize=True
        )


# ──────────────────────────────────────────────────────────────────────
# Descriptions
# ──────────────────────────────────────────────────────────────────────
SHORT_DESCRIPTION = (
    "Paediatric & neonatal calculators, drug formulary, growth charts, emergency dosing — offline."
)

FULL_DESCRIPTION = """\
PediAid — paediatrics and neonatology in one offline app, built for residents, registrars, paediatricians and PG students at the cot side.

▸ THE PROBLEM
Adrenaline 0.01 mg/kg for a 12-kg child at 3 a.m. Maintenance fluids for a 18-kg toddler. WHO weight-for-age z-score for a stunted 24-month-old. The answers are in Neofax, Harriet Lane, Nelson, the WHO tables — but flipping books, switching apps and waiting on hospital Wi-Fi wastes the minutes you don't have. PediAid puts every routine paediatric calculation, dose and chart inside one offline app.

▸ 50+ PAEDIATRIC CALCULATORS
GIR (mg/kg/min), BSA, Schwartz eGFR, Holliday-Segar maintenance fluids, bilirubin phototherapy thresholds, BP percentile by age and height, ETT depth and size by age, code-drug doses by weight, oxygenation index, corrected anion gap, sodium deficit, glucose infusion rate — and growing. Every calculator shows the formula, units and cited reference, so you trust the number you put in the chart.

▸ DRUG FORMULARY 2.0 — TWO DATABASES
NEONATES (Neofax-derived): 199 drugs across NICU practice. Dosing by gestational age, postnatal age and weight bands. Loading dose, maintenance dose, route, frequency, monitoring.

PAEDIATRICS (Harriet Lane-derived): 478 drugs across general paediatrics, PICU and outpatient practice. Indications, weight-based dosing, paediatric ranges, India brand names for common oral formulations, side effects, monitoring and key cross-checks against WHO Model Formulary, Nelson and DailyMed.

The two databases stay separate by design — the dose framework you need depends on whether the patient is a neonate or a child past the neonatal period.

▸ GROWTH CHARTS — WHO + IAP + FENTON
Plot weight-for-age, length/height-for-age, head circumference, BMI on WHO charts (0–5 years), IAP charts (5–18 years) and Fenton charts (preterm). Tap a point, get z-score and percentile instantly. Switch between Boys / Girls. Save serial points to track trajectory across visits.

▸ CODE / EMERGENCY DRUGS BY WEIGHT
Enter the child's weight once. Get adrenaline, atropine, amiodarone, lidocaine, calcium gluconate, dextrose, sodium bicarb — bolus dose, infusion rate, dilution prep, mL to push, frequency and max dose. NICU + PICU. Big numbers, red highlight, designed for the moment your hands aren't steady.

▸ CLINICAL GUIDES
Quick-access guides for: diabetic ketoacidosis (DKA), snake envenomation, scorpion sting, status epilepticus, procedural sedation, RSI, neonatal resuscitation, fever in the under-3-month, dehydration assessment. Step-by-step, India-relevant, weight-aware.

▸ FULLY OFFLINE
Once installed, PediAid works without internet. No account. No login. No cloud sync of patient data. Every calculator, drug entry and growth chart lives on the device. Hospital Wi-Fi blinking out doesn't take your tools with it.

KEY FEATURES
• 50+ paediatric & neonatal calculators with formulas + references
• 199 NICU drugs (Neofax-derived) + 478 PICU/paediatric drugs (Harriet Lane-derived)
• India brand-name overlay for common oral paediatric formulations
• WHO growth charts (0–5y) + IAP charts (5–18y) + Fenton (preterm)
• Code-drug calculator: bolus dose, infusion, prep steps by weight
• Clinical guides: DKA, snake bite, scorpion sting, sedation, status epilepticus
• Material 3 design with light + dark mode
• Fully offline — no account, no cloud, no ads, no tracking
• Free
• Open-source on GitHub

▸ WHO IT'S FOR
PediAid is built for clinicians who see children:
• Paediatric residents and registrars
• Neonatology fellows and NICU sisters
• PICU registrars
• General paediatricians in OPD and ward
• Family physicians who see paediatric patients
• MBBS interns posted in paediatrics / neonatology
• Paediatric PG entrance exam candidates revising clinical material

▸ PRIVATE BY DESIGN
PediAid has no server. There is no telemetry, no analytics, no cloud sync, no in-app purchases, no ads, no accounts. Calculations and charts you enter live on your device only. Source code is open on GitHub.

▸ DISCLAIMER
PediAid is a clinical reference tool intended to support — not replace — the judgement of a qualified paediatric clinician. Every dose, formula and chart should be cross-checked against your institutional protocols and the latest manufacturer literature before administration. The app is provided as-is, with no warranty of fitness for any specific clinical decision. Use it the way you'd use Neofax or Harriet Lane — as one of several inputs to a careful decision.

▸ FREE
PediAid is free. No ads. No paywalled drugs or calculators. If you find it useful, the "Buy me a chai" tile in Settings is the only ask.

▸ FEEDBACK
Settings → Feedback. Suggest a missing drug, report a dose error, request a calculator, or rate the app. Bug reports auto-include version + platform.

USE CASES: paediatric ward rounds, NICU rounds, PICU code, OPD growth monitoring, exam revision, casualty paediatric assessment, neonatal resuscitation prep, weight-based emergency dosing, drug dose lookup, growth chart plotting

KEYWORDS: paediatric drug dose, neonatal drug dose, Neofax, Harriet Lane, NICU calculator, PICU calculator, GIR calculator, Schwartz eGFR, maintenance fluids, BSA calculator, growth chart, WHO chart, IAP chart, Fenton chart, bilirubin chart, BP percentile, paediatric formulary, neonatal formulary, paediatric reference, paediatric residents app, India paediatrics

PediAid. Paediatrics · Bedside-ready · Offline.
"""


def write_descriptions():
    (OUT_DIR / "short_description.txt").write_text(
        SHORT_DESCRIPTION.strip() + "\n", encoding="utf-8"
    )
    (OUT_DIR / "full_description.txt").write_text(
        FULL_DESCRIPTION.strip() + "\n", encoding="utf-8"
    )


# ──────────────────────────────────────────────────────────────────────
# Zip + main
# ──────────────────────────────────────────────────────────────────────
def make_zip():
    if ZIP_PATH.exists():
        ZIP_PATH.unlink()
    with zipfile.ZipFile(ZIP_PATH, "w", zipfile.ZIP_DEFLATED) as zf:
        for f in sorted(OUT_DIR.iterdir()):
            zf.write(f, f.relative_to(OUT_DIR.parent))


def main():
    if OUT_DIR.exists():
        for f in OUT_DIR.glob("*.png"):
            f.unlink()
        for f in OUT_DIR.glob("*.txt"):
            f.unlink()
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    print("Generating Play Store asset pack for PediAid …")
    make_icon()
    print("  ✓ icon-512.png")
    make_feature_graphic()
    print("  ✓ feature-graphic-1024x500.png")

    make_phone_screens()
    print("  ✓ phone-1-intro.png … phone-7-guides.png  (7 × 1080×1920)")

    make_tablet_7_screens()
    print("  ✓ tablet-7-1.png … tablet-7-7.png  (7 × 1200×1920)")

    make_tablet_10_screens()
    print("  ✓ tablet-10-1.png … tablet-10-7.png  (7 × 1800×2880)")

    write_descriptions()
    print("  ✓ short_description.txt + full_description.txt")

    make_zip()
    print(f"\n→ {ZIP_PATH}  ({ZIP_PATH.stat().st_size // 1024} KB)")
    print(f"→ {OUT_DIR}/")


if __name__ == "__main__":
    main()
