#!/usr/bin/env bash
# Report App Store launch readiness for the project in the current directory.
# Read-only: checks signing on this Mac and common config/policy gaps. Run from the project root.

echo "== Signing on this Mac =="
if command -v security >/dev/null; then
  security find-identity -v -p codesigning 2>/dev/null | tail -n 5
else
  echo "security tool not found (not macOS?)"
fi
prof_dir="$HOME/Library/MobileDevice/Provisioning Profiles"
alt_dir="$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles"
n=0
for d in "$prof_dir" "$alt_dir"; do
  [ -d "$d" ] && n=$((n + $(ls "$d" 2>/dev/null | wc -l)))
done
echo "Provisioning profiles: $n"
xcode-select -p 2>/dev/null | sed 's/^/Xcode developer dir: /'

echo
echo "== Bundle ID and team in project config =="
for f in src-tauri/tauri.conf.json src-tauri/tauri.appstore.conf.json app.json app.config.json; do
  [ -f "$f" ] && grep -nE '"(identifier|bundleIdentifier|developmentTeam|version|productName)"' "$f" | sed "s|^|$f:|"
done
find . -name project.pbxproj -not -path '*/node_modules/*' -not -path '*/Pods/*' 2>/dev/null | head -3 | while read -r p; do
  grep -hoE '(PRODUCT_BUNDLE_IDENTIFIER|DEVELOPMENT_TEAM|MARKETING_VERSION) = [^;]+' "$p" | sort -u | sed "s|^|$p: |"
done
[ -n "$APPLE_DEVELOPMENT_TEAM" ] && echo "APPLE_DEVELOPMENT_TEAM=$APPLE_DEVELOPMENT_TEAM"

echo
echo "== Info.plist / privacy manifest =="
find . \( -name 'Info.plist' -o -name '*.xcprivacy' \) -not -path '*/node_modules/*' -not -path '*/build/*' -not -path '*/target/*' 2>/dev/null | head -10 | while read -r f; do
  printf '%s' "$f"
  grep -q ITSAppUsesNonExemptEncryption "$f" 2>/dev/null && printf ' [encryption key set]'
  echo
done

echo
echo "== Network calls a 'Data Not Collected' label would contradict =="
grep -rnoE 'https?://(fonts\.googleapis|fonts\.gstatic|www\.google-analytics|api\.mixpanel|sentry\.io|[a-z0-9.-]*firebase[a-z0-9.-]*)[^"'"'"' )]*' \
  --include='*.html' --include='*.ts' --include='*.tsx' --include='*.js' --include='*.css' --include='*.swift' --include='*.rs' \
  . 2>/dev/null | grep -v node_modules | head -10
echo "(empty above = none of the usual suspects found)"

echo
echo "== Privacy policy =="
for f in PRIVACY.md privacy.md docs/privacy.md; do
  if [ -f "$f" ]; then
    echo "$f found"
    grep -nE '\[[a-z ]+\]' "$f" | head -5 | sed 's/^/  placeholder: /'
    grep -noE 'https?://[^ )]+' "$f" | head -3 | sed 's/^/  url: /'
    break  # macOS is case-insensitive: PRIVACY.md and privacy.md are the same file
  fi
done

echo
echo "== Launch notes =="
notes=$(ls docs/app-store*.md docs/*launch*.md 2>/dev/null)
echo "${notes:-none}"
