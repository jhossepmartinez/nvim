#!/usr/bin/env python3
# ponytail: add 1px vertical-separator glyphs to BlexMono Nerd Font (non-Mono)
# widths 30/40/50 units; at ▏=75units=2px on user's term, ~40u≈1px
# Output family: "BlexMono Nerd Font Sep" (keeps big icons, adds U+E00B/C/D)
# Self-contained: reads IBMPlexMono.zip from this dir, writes BlexMonoNF-Sep.zip
# Usage: python3 add_sep_glyphs.py
import os, sys, zipfile, tempfile
from fontTools.ttLib import TTFont
from fontTools.pens.ttGlyphPen import TTGlyphPen

HERE = os.path.dirname(os.path.abspath(__file__))
SRC_ZIP = os.path.join(HERE, "IBMPlexMono.zip")    # original Nerd Font zip
OUT_ZIP = os.path.join(HERE, "BlexMonoNF-Sep.zip")  # patched output zip
SRC_PREFIX = "BlexMonoNerdFont-"                    # non-Mono variant (bigger icons)

FAMILY = "BlexMono Nerd Font Sep"
PS_PREFIX = "BlexMonoNF-Sep"

# (codepoint, glyph_name, width_in_font_units)
GLYPHS = [
    (0xE00B, "sep30", 30),
    (0xE00C, "sep40", 40),
    (0xE00D, "sep50", 50),
]
ADV, YMIN, YMAX = 600, -350, 950   # match ▏ (U+258F) advance + vertical extent

# filename suffix -> (weightName, isItalic, isBold)
WEIGHTS = {
    "Regular":            ("Regular",           False, False),
    "Italic":             ("Italic",            True,  False),
    "Bold":               ("Bold",              False, True),
    "BoldItalic":         ("Bold Italic",       True,  True),
    "ExtraLight":         ("ExtraLight",        False, False),
    "ExtraLightItalic":   ("ExtraLight Italic", True,  False),
    "Light":              ("Light",             False, False),
    "LightItalic":        ("Light Italic",      True,  False),
    "Medium":             ("Medium",            False, False),
    "MediumItalic":       ("Medium Italic",     True,  False),
    "SemiBold":           ("SemiBold",          False, False),
    "SemiBoldItalic":     ("SemiBold Italic",   True,  False),
    "Text":               ("Text",              False, False),
    "TextItalic":         ("Text Italic",       True,  False),
    "Thin":               ("Thin",              False, False),
    "ThinItalic":         ("Thin Italic",       True,  False),
}

def add_sep(f, name, width):
    glyf = f["glyf"]
    if name in glyf:
        del glyf[name]
    pen = TTGlyphPen(f.getGlyphSet())
    pen.moveTo((0, YMIN)); pen.lineTo((width, YMIN))
    pen.lineTo((width, YMAX)); pen.lineTo((0, YMAX)); pen.closePath()
    glyf[name] = pen.glyph()
    f["hmtx"][name] = (ADV, 0)

def set_name(f, nid, val):
    for plat in ((3,1,0x409),(1,0,0)):
        for rec in f["name"].names:
            if rec.nameID==nid and rec.platformID==plat[0] and rec.platEncID==plat[1] and rec.langID==plat[2]:
                rec.string = val; break
        else:
            f["name"].setName(val, nid, *plat)

def rename(f, weightName, isItalic, isBold):
    # 16/17: Typographic family (group) + unique subfamily — Windows 10+ uses these
    set_name(f, 16, FAMILY)
    set_name(f, 17, weightName)
    # 1/2: legacy 4-style linking. Non-canonical weights get unique family(1) + Regular/Italic(2)
    subfam = ("Bold Italic" if isBold and isItalic else "Bold" if isBold else "Italic" if isItalic else "Regular")
    canonical = weightName in ("Regular","Italic","Bold","Bold Italic")
    set_name(f, 1, FAMILY if canonical else f"{FAMILY} {weightName}")
    set_name(f, 2, subfam)
    set_name(f, 4, f"{FAMILY} {weightName}")
    set_name(f, 6, f"{PS_PREFIX}-{weightName.replace(' ','')}")

def process(f, suffix):
    cmap = f.getBestCmap()
    for cp, name, w in GLYPHS:
        add_sep(f, name, w); cmap[cp] = name
    wn, ital, bold = WEIGHTS[suffix]
    rename(f, wn, ital, bold)
    return f

if __name__ == "__main__":
    tmp = tempfile.mkdtemp()
    with zipfile.ZipFile(SRC_ZIP) as z:
        names = [n for n in z.namelist() if n.startswith(SRC_PREFIX) and n.endswith(".ttf")]
        z.extractall(tmp, names)
    out_dir = tempfile.mkdtemp()
    for fn in sorted(os.listdir(tmp)):
        if fn.startswith(SRC_PREFIX) and fn.endswith(".ttf"):
            suffix = fn[len(SRC_PREFIX):-4]
            if suffix in WEIGHTS:
                f = process(TTFont(os.path.join(tmp, fn)), suffix)
                f.save(os.path.join(out_dir, f"BlexMonoNerdFont-Sep-{suffix}.ttf"))
    with zipfile.ZipFile(OUT_ZIP, "w", zipfile.ZIP_DEFLATED) as z:
        for fn in sorted(os.listdir(out_dir)):
            z.write(os.path.join(out_dir, fn), f"BlexMonoNF-Sep/{fn}")
    print(f"wrote {OUT_ZIP}")
