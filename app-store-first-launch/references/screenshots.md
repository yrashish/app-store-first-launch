# Screenshots and app previews

How to plan, make, check and upload product-page screenshots. Sources: Apple's asset best
practices, the screenshot and app preview specifications, and guideline 2.3. Sizes and slots
were checked in October 2026; the upload page in App Store Connect lists the current ones.

## Contents

1. What the store shows
2. Order and captions
3. Sizes and file rules
4. Per-device framing
5. Content rules
6. Making them
7. Checking them
8. Uploading them
9. App previews
10. Auditing an existing set

## 1. What the store shows

- Search results show the first 3 portrait screenshots (or the first landscape one, or an app
  preview) at about 115×249 points each on iPhone. Most people decide there, without opening the
  product page.
- The product page shows all of them, up to 10 per device size.
- An app preview, if present, plays before the screenshots and can replace them in search.

So the first three slots carry most of the weight. Treat them as one strip that has to be read at
thumbnail size.

## 2. Order and captions

- Lead with the app's best feature in use, not onboarding, a welcome screen, settings or a menu.
  Welcome screens and menus are the most common weak first slots.
- Use three different screens in the first three slots. Two shots of the same screen before and
  after one tap waste a search slot.
- Add a short caption to each: a title of about 28 characters or fewer, so it reads at search size,
  and an optional subtitle. Apple asks for "a short phrase that enhances your visual rather than
  describes it": say what the user gets ("Plan your week in a minute"), not what the screen is
  ("Planner screen").
- Every claim in a caption must be true of the build under review. Captions, the description, the
  age band and the app's own text must agree. For example, an age range on a welcome screen that
  differs from the Kids age band is a visible contradiction.
- Keep the caption order and text in a data file (JSON) next to the capture scripts, so a reorder
  or wording change is one edit and all device sets stay in step.

## 3. Sizes and file rules

| Device | Size to make | Notes |
|---|---|---|
| iPhone 6.9" | 1320×2868 portrait | The largest required iPhone size. In the 2026 App Store Connect layout the default iPhone slot is "iPhone with Dynamic Island (medium display)", which takes 1206×2622 and rejects 1320×2868. Scale the 6.9" files to 1206×2622 for that slot (`sips -z 2622 1206 in.png --out out.png`), or open the larger slot in Media Manager. |
| iPad 13" | 2064×2752 portrait (2048×2732 also accepted) | Needed if the app runs on iPad. |
| Mac | 2880×1800 (also 2560×1600, 1440×900, 1280×800) | 16:10. |
| iPhone Duo | 1398×2034 outer, 2007×2853 inner | Required from April 2027 for apps built with the iOS 27.1 SDK or later. |

- PNG or JPEG, RGB, **no alpha channel**, even if every pixel is opaque. Browsers and simulators
  often write RGBA; convert (`sips -s format jpeg`, or Pillow `im.convert('RGB')`).
- 1 to 10 per device size.
- Smaller devices scale down from the largest size you upload unless you add sets for them.

## 4. Per-device framing

- **iPad**: an iPhone-shaped layout centred on a 13-inch canvas uses about a quarter of the image,
  and the focal point is too small to read. Capture iPad in landscape or at its real layout, or
  crop to the part that matters and place an enlarged copy (a callout) over it. If the app keeps a
  fixed-width panel on iPad, let the device frame run off the bottom of the image rather than
  shrinking everything to fit.
- **Mac**: show the app in a window with its title bar, at the window size users will see.
  Background and caption above, as on iPhone.
- **Status bar**: 9:41, full battery and signal, no silent-mode or recording indicators. In the
  simulator: `xcrun simctl status_bar booted override --time 9:41 --batteryLevel 100
  --cellularBars 4`.

## 5. Content rules

Apple rejects screenshots (guideline 2.3) that show:

- prices, discounts or "free" claims;
- URLs, other platforms or stores (Android, Google Play, Windows);
- awards, rankings or Apple endorsements ("App of the Day", "#1") the app hasn't received;
- copyright symbols or legal text;
- anything other than the app in use: marketing art alone is not enough;
- content above the app's age rating.

## 6. Making them

Capture real screens from the store build's UI with example data, then add captions in a separate
compose step. Keep the scripts in the repo so the set can be regenerated after a UI change.

- **Seed the state.** Use example data (a fictional user name, realistic progress) rather than
  empty first-run screens. Write it into the app's storage before capture, or drive the app to it.
- **Native apps**: simulator plus `xcrun simctl io booted screenshot`, or UI tests that call
  `XCUIScreen.main.screenshot()` (fastlane snapshot does the same).
- **Web-view apps** (Tauri, Capacitor, Electron, React Native Web): serve the store build's web
  UI and capture it with Playwright at each device's viewport and pixel ratio (iPhone 440×956 at
  3×, iPad 1032×1376 at 2×, Mac window size at 2×). Run one device at a time if runs hang on exit.
- **Compose**: render background, caption and the framed capture as an HTML page and screenshot
  it at the target size, or composite with Pillow. Write RGB output.
- Record per-shot layout boxes (for example the bounding box of the focal element) in a JSON file
  next to each capture, so the compose step can crop or place a callout without guessing.

## 7. Checking them

`scripts/check_screenshots.py` (in this skill) checks a folder per device kind for accepted sizes,
alpha, count, and caption text against the content rules:

```bash
python3 <skill>/scripts/check_screenshots.py iphone path/to/iphone ipad path/to/ipad --captions captions.json
```

Then look at the first three at search size, side by side, on light and dark backgrounds. If the
captions can't be read at that size, shorten them or make the type larger.

## 8. Uploading them

On the version page (`/distribution/ios/version/inflight`, or `macos`):

- To replace a set: "Remove All" under the device's screenshots, confirm, then upload the new
  files. Files upload in the order selected, so name them `01-…`, `02-…`.
- In a browser session driven by tools, find the hidden file input next to "Upload" and set its
  files directly; clicking "Upload" opens a native file picker that can't be driven.
- The first Mac upload may show a notice about using the set for all Mac sizes; dismiss it.
- Screenshot changes save on their own; the Save button stays disabled.
- Screenshots can change only while the version is editable: "Prepare for Submission", or
  "Rejected"/"Developer Rejected". While a version is "Waiting for Review" they are locked, and the
  change goes with the next version.

## 9. App previews

- 15 to 30 seconds, H.264 or ProRes, at most 30 fps. Portrait sizes: 886×1920 for iPhone,
  1200×1600 for iPad; 1920×1080 for Mac. Check with `ffprobe` before upload.
- Real UI captured from the app, with on-screen text for anything spoken, because previews
  autoplay muted. No quick cuts; it should loop cleanly. The poster frame defaults to 5 seconds.
- Up to 3 per device size. A preview takes the first search slot.
- Don't record a child's voice without the parent's consent; an adult voice or on-screen text is
  simpler.

## 10. Auditing an existing set

Before redoing screenshots, write down what is wrong with the current set and why, ranked by how
much it affects downloads:

1. List every set (device, count, size, alpha, captions) with `sips -g pixelWidth -g pixelHeight
   -g hasAlpha *.png`.
2. Render the first three of each set at search size next to the top competitors. The iTunes
   Search API returns their screenshot URLs:
   `curl 'https://itunes.apple.com/search?term=<words>&country=us&entity=software&limit=5'`
   (`screenshotUrls`, `ipadScreenshotUrls`). Keep competitor images out of the repo.
3. Check each claim in the screenshots and captions against the app and the listing.
4. Render the icon at 40 to 180 px on light and dark backgrounds.

The audit can't tell whether a change raises downloads. After release, App Analytics shows
impressions, product page views and conversion, and Product Page Optimization can test a new
first screenshot against the old one.
