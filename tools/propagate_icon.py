"""tools/propagate_icon.py — push assets/icon/app_icon.png into every
platform icon folder (Android mipmap-*, iOS AppIcon.appiconset,
web Icon-*, macOS AppIcon.appiconset, favicon).

Run after replacing assets/icon/app_icon.png with a new master.

    PYTHONIOENCODING=utf-8 python tools/propagate_icon.py
"""
from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / "assets" / "icon" / "app_icon.png"

# Android launcher icons live in res/mipmap-{density} — Flutter doesn't use
# any "round" or "foreground" variants by default for this project, so we
# just rewrite ic_launcher.png at each density.
ANDROID_DENSITIES = {
    "mipmap-mdpi":     48,
    "mipmap-hdpi":     72,
    "mipmap-xhdpi":    96,
    "mipmap-xxhdpi":  144,
    "mipmap-xxxhdpi": 192,
}

# iOS AppIcon.appiconset filenames to sizes (Flutter's default set).
IOS_ICONS = {
    "Icon-App-20x20@1x.png":      20,
    "Icon-App-20x20@2x.png":      40,
    "Icon-App-20x20@3x.png":      60,
    "Icon-App-29x29@1x.png":      29,
    "Icon-App-29x29@2x.png":      58,
    "Icon-App-29x29@3x.png":      87,
    "Icon-App-40x40@1x.png":      40,
    "Icon-App-40x40@2x.png":      80,
    "Icon-App-40x40@3x.png":     120,
    "Icon-App-60x60@2x.png":     120,
    "Icon-App-60x60@3x.png":     180,
    "Icon-App-76x76@1x.png":      76,
    "Icon-App-76x76@2x.png":     152,
    "Icon-App-83.5x83.5@2x.png": 167,
    "Icon-App-1024x1024@1x.png":1024,
}

# macOS AppIcon.appiconset filenames to sizes (Flutter's default set).
MACOS_ICONS = {
    "app_icon_16.png":     16,
    "app_icon_32.png":     32,
    "app_icon_64.png":     64,
    "app_icon_128.png":   128,
    "app_icon_256.png":   256,
    "app_icon_512.png":   512,
    "app_icon_1024.png": 1024,
}


def load_master() -> Image.Image:
    if not MASTER.exists():
        raise SystemExit(f"Master icon missing: {MASTER}")
    img = Image.open(MASTER).convert("RGBA")
    print(f"Master: {MASTER}  ({img.size[0]}×{img.size[1]} {img.mode})")
    return img


def save_resized(master: Image.Image, dest: Path, size: int,
                 mode: str = "RGBA") -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    out = master.resize((size, size), Image.LANCZOS)
    if mode == "RGB":
        # Flatten on solid background (the PediAid blue is part of the
        # logo itself, so flattening on white is fine for places that
        # don't support alpha — e.g. iOS App Store).
        bg = Image.new("RGB", out.size, (255, 255, 255))
        bg.paste(out, mask=out.split()[3])
        out = bg
    out.save(dest, "PNG", optimize=True)
    print(f"  → {dest.relative_to(ROOT)}  ({size}×{size})")


def propagate_android(master: Image.Image) -> None:
    base = ROOT / "android" / "app" / "src" / "main" / "res"
    print("Android:")
    for folder, size in ANDROID_DENSITIES.items():
        save_resized(master, base / folder / "ic_launcher.png", size)


def propagate_ios(master: Image.Image) -> None:
    base = ROOT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    print("iOS:")
    for fn, size in IOS_ICONS.items():
        # iOS App Store rejects icons with alpha — flatten to RGB.
        save_resized(master, base / fn, size, mode="RGB")


def propagate_macos(master: Image.Image) -> None:
    base = ROOT / "macos" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    print("macOS:")
    for fn, size in MACOS_ICONS.items():
        save_resized(master, base / fn, size)


def propagate_web(master: Image.Image) -> None:
    base = ROOT / "web"
    print("Web:")
    save_resized(master, base / "favicon.png",                  64)
    save_resized(master, base / "icons" / "Icon-192.png",      192)
    save_resized(master, base / "icons" / "Icon-512.png",      512)
    save_resized(master, base / "icons" / "Icon-maskable-192.png", 192)
    save_resized(master, base / "icons" / "Icon-maskable-512.png", 512)


def propagate_windows(master: Image.Image) -> None:
    """Windows uses a single multi-size .ico file. Pillow packs the standard
    Win32 sizes (16/32/48/64/128/256) into one .ico."""
    base = ROOT / "windows" / "runner" / "resources"
    base.mkdir(parents=True, exist_ok=True)
    print("Windows:")
    sizes = [(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
    largest = master.resize((256, 256), Image.LANCZOS)
    dest = base / "app_icon.ico"
    largest.save(dest, format="ICO", sizes=sizes)
    print(f"  -> {dest.relative_to(ROOT)}  ({'/'.join(str(s[0]) for s in sizes)})")


def main() -> None:
    master = load_master()
    propagate_android(master)
    propagate_ios(master)
    propagate_macos(master)
    propagate_web(master)
    propagate_windows(master)
    print("\nDone. Re-run `flutter build` to bake the new icons in.")


if __name__ == "__main__":
    main()
