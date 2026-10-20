#!/usr/bin/env python3
"""Check App Store screenshots and their captions before upload. Read-only. Needs Pillow.

Usage:
  python3 check_screenshots.py <kind> <dir> [<kind> <dir> ...] [--captions file.json] [--kids]

  kind      iphone, ipad, mac or duo
  dir       folder of .png/.jpg files for that device, in upload order
  captions  JSON list of {"title": "...", "sub": "..."} (sub optional), one per slide
  --kids    also flag age numbers in captions; the product page already shows the age band

Sizes and rules: Apple's screenshot specifications and guideline 2.3, as of October 2026.
"""
import json
import re
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    sys.exit('needs Pillow: python3 -m pip install pillow')

SIZES = {
    'iphone': {(1320, 2868), (1290, 2796), (1260, 2736), (1206, 2622), (1179, 2556),
               (1284, 2778), (1242, 2688), (1242, 2208)},
    'ipad': {(2064, 2752), (2048, 2732), (1668, 2388), (1640, 2360)},
    'mac': {(1280, 800), (1440, 900), (2560, 1600), (2880, 1800)},
    'duo': {(1398, 2034), (2007, 2853)},
}
MAX_SHOTS = 10
MAX_TITLE = 28  # a short phrase still reads at search-result size

BANNED = {
    'price or discount': r'[$€£₹¥]\s?\d|\bfree\b|%\s*off|\bsale\b',
    'URL': r'https?://|www\.|\.(com|org|net|app|io)\b',
    'copyright or legal symbol': r'©|®|™|\(c\)',
    'other platform or store': r'\b(android|google play|play store|windows|app store)\b',
    'award or ranking': r"\b(award|editor'?s choice|app of the day|#1|number one|best)\b",
}
AGE = r'\bages?\s*\d|\d+\s*(to|-|–)\s*\d+\s*(years|year-olds|yrs)|\b\d+\+'


def check_images(kind, folder):
    errors = []
    files = sorted(p for p in Path(folder).iterdir() if p.suffix.lower() in ('.png', '.jpg', '.jpeg'))
    if not 1 <= len(files) <= MAX_SHOTS:
        errors.append(f'{kind}: {len(files)} screenshots, need 1 to {MAX_SHOTS}')
    for f in files:
        with Image.open(f) as im:
            size, mode, info = im.size, im.mode, im.info
        rot = (size[1], size[0])
        if size not in SIZES[kind] and rot not in SIZES[kind]:
            errors.append(f'{f}: {size[0]}x{size[1]} is not an accepted {kind} size')
        if mode in ('RGBA', 'LA', 'PA') or 'transparency' in info:
            errors.append(f'{f}: has an alpha channel ({mode}); Apple accepts none')
    return files, errors


def check_captions(path, kids):
    errors = []
    banned = dict(BANNED, **({'age number': AGE} if kids else {}))
    for s in json.loads(Path(path).read_text(encoding='utf-8')):
        text = f"{s.get('title', '')} {s.get('sub', '')}"
        for what, pattern in banned.items():
            if re.search(pattern, text, re.I):
                errors.append(f"caption '{s.get('title')}': {what}")
        if len(s.get('title', '')) > MAX_TITLE:
            errors.append(f"caption '{s['title']}': title is {len(s['title'])} characters, keep to {MAX_TITLE}")
    return errors


def main(argv):
    kids = '--kids' in argv
    argv = [a for a in argv if a != '--kids']
    captions = None
    if '--captions' in argv:
        i = argv.index('--captions')
        captions = argv[i + 1]
        del argv[i:i + 2]
    if not argv or len(argv) % 2:
        sys.exit(__doc__)
    errors = check_captions(captions, kids) if captions else []
    for kind, folder in zip(argv[::2], argv[1::2]):
        if kind not in SIZES:
            sys.exit(f'unknown kind {kind}; use one of {", ".join(SIZES)}')
        files, errs = check_images(kind, folder)
        errors += errs
        print(f'{kind:7} {len(files)} screenshots in {folder}')
    for e in errors:
        print('FAIL', e)
    print('OK' if not errors else f'{len(errors)} problems')
    return 1 if errors else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
