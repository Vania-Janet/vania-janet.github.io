#!/usr/bin/env bash
# Run from the ROOT of the vania-janet.github.io repository, BEFORE pasting the new
# index.html and styles.css. Safe to re-run. Needs: git, ImageMagick (magick or convert),
# curl, python3.  Optional: ./prepare-site.sh path/to/better-headshot.jpg
set -euo pipefail
IM=$(command -v magick || command -v convert || true)
[ -n "$IM" ] || { echo "Install ImageMagick first (brew install imagemagick / apt install imagemagick)"; exit 1; }

echo "== 1/5  Backups (nothing is lost; everything is in git history too)"
git tag -f backup-2026-10-19
git branch -f backup/pre-redesign
mkdir -p backup/2026-10-19
cp -n index.html styles.css README.md backup/2026-10-19/ 2>/dev/null || true

echo "== 2/5  Clean, stable file names for documents"
mkdir -p assets/docs assets/img
mvf() { if [ -e "$1" ]; then git mv "$1" "$2"; else echo "   skip (not found): $1"; fi; }
mvf "assets/Confirmation Letter Selene - Vania (1).pdf"          assets/docs/uzh-visit-confirmation.pdf
mvf "assets/UGRIP Vania Janet Raya Rios.pdf"                      assets/docs/mbzuai-ugrip-certificate.pdf
mvf "assets/Vania_Raya_PagaTodo_Recognition_EN_ES.pdf"            assets/docs/pagatodo-recognition-en-es.pdf
mvf "assets/Tesis___Vania_Raya (4).pdf"                           assets/docs/thesis-es.pdf
mvf "assets/Vania_Raya_UNAM_Academic_History_EN_ES.pdf"           assets/docs/unam-academic-history-en-es.pdf
mvf "assets/Vania_Raya_UNAM_Computing_Diploma_EN_ES.pdf"          assets/docs/unam-computing-diploma-en-es.pdf
mvf "assets/Samsung_Essay_Original_Spanish.pdf"                   assets/docs/samsung-essay-es.pdf
mvf "assets/Samsung_Essay_English.pdf"                            assets/docs/samsung-essay-en.pdf
mvf "assets/Vania_Raya_Samsung_Recognition_EN_ES.pdf"             assets/docs/samsung-recognition-en-es.pdf
mvf "assets/Vania_Raya_UNAM_Recognition_EN_ES.pdf"                assets/docs/unam-recognition-en-es.pdf
mvf "assets/Gmail - ACL 2026 Confirmation of Volunteer Work.pdf"  assets/docs/acl2026-volunteer-confirmation.pdf
mvf "assets/Vania_Raya_Morelos_Soy_Mujer_y_Hago_Ciencia_EN_ES.pdf" assets/docs/morelos-soy-mujer-certificate-en-es.pdf
mvf "assets/SemEval 8.png"                                        assets/docs/cert-semeval.png
mvf "assets/Reconocimiento Samsung.jpeg"                          assets/docs/cert-samsung.jpeg
mvf "assets/Reconocimiento UNAM.jpeg"                             assets/docs/cert-unam.jpeg
mvf "assets/img/semeval-architecture.png"                         assets/docs/semeval-architecture-original.png
echo "   NOTE: assets/What_Does_a_Risk_Guarante.pdf is NOT moved. It is still public on GitHub Pages."
echo "         If the manuscript is under anonymous review, remove it from the public repo (see chat)."

echo "== 3/5  Optimised images (WebP, metadata stripped)"
SRC="${1:-}"
if [ -z "$SRC" ]; then
  SRC=/tmp/profile-src.jpg
  curl -fsSL "https://avatars.githubusercontent.com/u/111891293?s=800&v=4" -o "$SRC"
fi
$IM "$SRC" -auto-orient -strip -resize 640x800^ -gravity north -extent 640x800 -quality 82 assets/img/profile.webp
$IM assets/docs/semeval-architecture-original.png -strip -resize 1600x -quality 85 assets/img/semeval-architecture.webp
$IM assets/docs/cert-semeval.png  -auto-orient -strip -resize 640x640 -quality 80 assets/img/cert-semeval.webp
$IM assets/docs/cert-samsung.jpeg -auto-orient -strip -resize 640x640 -quality 80 assets/img/cert-samsung.webp
$IM assets/docs/cert-unam.jpeg    -auto-orient -strip -resize 640x640 -quality 80 assets/img/cert-unam.webp
# Full-size certificates: strip EXIF (can contain GPS/device data) and cap the size.
for f in assets/docs/cert-samsung.jpeg assets/docs/cert-unam.jpeg; do
  $IM "$f" -auto-orient -strip -resize '2200x2200>' -quality 88 "$f"
done

echo "== 4/5  Fonts: WOFF2 versions (about 30% smaller)"
python3 -m pip install --quiet fonttools brotli
for f in assets/fonts/*.woff; do
  python3 -m fontTools.ttLib.woff2 compress -o "${f%.woff}.woff2" "$f"
  python3 - "$f" << 'PY'
import sys
from fontTools.ttLib import TTFont
f = TTFont(sys.argv[1])
print("  ", sys.argv[1], "->", "variable font" if "fvar" in f else "STATIC font (one weight only)")
PY
done
ls -la assets/fonts

echo "== 5/5  Result"
du -sh assets/img assets/docs assets/fonts
echo "Now paste the new index.html and styles.css, add the files from site/assets/img, then:"
echo "  git add -A && git commit -m 'Redesign: typography, layout, optimised images' && git push"
echo "  git push origin backup-2026-10-19 backup/pre-redesign"
