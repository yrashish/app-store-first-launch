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
echo "== Stack, bundle ID, version and team =="
stack=""
[ -f src-tauri/tauri.conf.json ] && stack="$stack tauri"
[ -f pubspec.yaml ] && stack="$stack flutter"
{ [ -f app.json ] || [ -f app.config.js ] || [ -f app.config.ts ]; } && grep -qs '"expo"' package.json && stack="$stack expo"
ls capacitor.config.* >/dev/null 2>&1 && stack="$stack capacitor"
[ -f ProjectSettings/ProjectSettings.asset ] && stack="$stack unity"
grep -qs '"electron"' package.json && stack="$stack electron"
ls ./*.csproj >/dev/null 2>&1 && grep -qs 'ApplicationId' ./*.csproj && stack="$stack maui"
[ -d ios ] && [ -z "$stack" ] && grep -qs '"react-native"' package.json && stack="$stack react-native"
echo "Detected:${stack:- native Xcode or unknown}"
for f in src-tauri/tauri*.conf.json app.json; do
  [ -f "$f" ] && grep -nE '"(identifier|bundleIdentifier|buildNumber|bundleVersion|developmentTeam|version|productName)"' "$f" | sed "s|^|$f:|"
done
[ -f pubspec.yaml ] && grep -nE '^version:' pubspec.yaml | sed 's|^|pubspec.yaml:|'
for f in capacitor.config.json capacitor.config.ts; do
  [ -f "$f" ] && grep -nE 'appId' "$f" | sed "s|^|$f:|"
done
[ -f ProjectSettings/ProjectSettings.asset ] && grep -nE '(bundleVersion|iPhone: )' ProjectSettings/ProjectSettings.asset | head -4 | sed 's|^|ProjectSettings.asset:|'
for f in ./*.csproj; do [ -f "$f" ] && grep -nE '<(ApplicationId|ApplicationDisplayVersion|ApplicationVersion)>' "$f" | sed "s|^|$f:|"; done
find . -name project.pbxproj -not -path '*/node_modules/*' -not -path '*/Pods/*' 2>/dev/null | head -3 | while read -r p; do
  grep -hoE '(PRODUCT_BUNDLE_IDENTIFIER|DEVELOPMENT_TEAM|MARKETING_VERSION|CURRENT_PROJECT_VERSION) = [^;]+' "$p" | sort -u | sed "s|^|$p: |"
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
echo "== SDKs and calls that need App Privacy declarations =="
grep -noiE '(firebase|crashlytics|google-mobile-ads|admob|facebook|fbsdk|amplitude|mixpanel|segment|sentry|appsflyer|adjust|onesignal|revenuecat|posthog|datadog|bugsnag|branch)[a-z_./-]*' \
  package.json pubspec.yaml Podfile Package.resolved ios/Podfile src-tauri/Cargo.toml build.gradle 2>/dev/null | sort -u | head -15
grep -rnoE 'https?://(fonts\.googleapis|fonts\.gstatic|www\.google-analytics|api\.mixpanel|[a-z0-9.-]*sentry\.io|[a-z0-9.-]*firebase[a-z0-9.-]*)[^"'"'"' )]*' \
  --include='*.html' --include='*.ts' --include='*.tsx' --include='*.js' --include='*.css' --include='*.swift' --include='*.rs' --include='*.dart' --include='*.kt' \
  --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=target --exclude-dir=Pods \
  --exclude-dir=.next --exclude-dir=gen --exclude-dir=DerivedData --exclude-dir=.git . 2>/dev/null | head -10
echo "(empty above = none of the usual suspects found; a backend of your own still counts)"

echo
echo "== Features that add review rules (hints; confirm they ship in the store build) =="
hits() { grep -rlsiE "$1" --include='*.swift' --include='*.ts' --include='*.tsx' --include='*.js' --include='*.dart' --include='*.kt' --include='*.rs' --include='*.cs' \
  --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=target --exclude-dir=Pods \
  --exclude-dir=.next --exclude-dir=gen --exclude-dir=DerivedData --exclude-dir=.git . 2>/dev/null | head -1; }
f=$(hits 'GoogleSignIn|signInWithGoogle|FacebookLogin|signInWithPopup|OAuthProvider'); [ -n "$f" ] && echo "third-party sign-in ($f): needs Sign in with Apple check and account deletion"
f=$(hits 'ASAuthorizationAppleID|SignInWithApple|appleAuth'); [ -n "$f" ] && echo "Sign in with Apple found ($f)"
f=$(hits 'createUserWithEmail|createUser\(|auth\.signUp|signUpWith'); [ -n "$f" ] && echo "account creation ($f): needs in-app account deletion and a demo account"
f=$(hits 'StoreKit|SKProduct|Product\.products|purchases_flutter|react-native-iap|in_app_purchase|RevenueCat'); [ -n "$f" ] && echo "in-app purchases ($f): needs restore, terms links, products set up in ASC"
f=$(hits 'ATTrackingManager|requestTrackingAuthorization|GADMobileAds|MobileAds\.'); [ -n "$f" ] && echo "ads or tracking ($f): ATT prompt and App Privacy tracking answers"
f=$(hits 'openai|anthropic|generativelanguage|gemini|ollama|bedrock'); [ -n "$f" ] && echo "AI service calls ($f): disclose, get consent, filter output"
f=$(hits 'WKWebView|webview_flutter|react-native-webview'); [ -n "$f" ] && echo "web views ($f): check 4.2 minimum functionality and web-access age rating"

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
