---
name: app-store-first-launch
description: Guide a developer, especially a first-timer, through getting an app onto Apple's App Store and TestFlight with App Store Connect. Covers checking launch readiness, registering the bundle ID, creating the app record, name and subtitle limits, category, the age rating questionnaire and the Made for Kids decision, App Privacy labels, writing and hosting a privacy policy, signing, uploading a build, and when to start charging. Use this whenever someone asks "where are we with the App Store launch", wants to publish, submit or ship an iOS, iPadOS or macOS app, mentions App Store Connect, TestFlight, a bundle ID, provisioning, an age rating, privacy nutrition labels or the Kids category, or is filling in App Store forms in a browser, even if they never say "first time". Not for fastlane or CI upload automation, crash debugging, StoreKit or other feature code, replying to a rejection, or Google Play.
---

# First App Store launch

This skill walks someone through publishing an app to Apple's App Store. Many people doing this
for the first time get lost because Apple splits the work across three websites and a build tool,
and some choices can't be undone. Your job is to know the order, check what is already done, and
explain each choice before the user makes it.

## How to work with the user

- **Check the current state first, then report.** Run `scripts/check_readiness.sh` from this
  skill's folder in the project root. Read any launch notes in the repo (`docs/app-store.md`,
  `PRIVACY.md`, `README`). Report what is done, what is blocked, and who has to do each step.
- **Explain in plain words.** Define terms like bundle ID, provisioning profile and SKU the first
  time they come up. Say which website a step happens on.
- **Stop before anything irreversible.** Before such a step, explain what gets locked in and ask
  for a clear yes. The list is in the next section. Clicking Save or Create in Apple's forms counts
  as submitting a form, so confirm the values first.
- **Some steps only the user can do.** These are enrolling in the Developer Program, accepting
  Apple's agreements, entering bank and tax details, and anything that needs their Apple ID
  password. Tell them exactly where to click and wait.
- **Recommend one option and give the reason.** First-timers usually want a recommendation, not a
  list of choices.
- **Check limits before you type.** The name and subtitle are 30 characters each. Count before
  entering. If the user's text is too long, offer a version that fits.

## Choices that are hard or impossible to undo

| Choice | Where | Why it matters |
|---|---|---|
| Bundle ID | developer.apple.com → Identifiers | Permanent for the app. Use one ID for iOS and macOS if you want Universal Purchase. It doesn't have to match the display name. |
| SKU | New App form | Internal only. It can't be changed later. Any short slug works. |
| Made for Kids | Age rating questionnaire, step 7 | Apple's dialog says it can't be changed later. Once approved, every update must follow the Kids rules: no third-party ads or analytics, and links out and purchases behind a parental gate. The only way out is a new app record. Recommend "Not Applicable" unless the user has decided to commit, because you can opt in later but can't opt out. |
| Kids age band | Same place | Only one band: 5 and under, 6–8, or 9–11. "5–11" is not an option. |
| App name | New App form | Creating the record reserves the name. Names must be unique across the App Store. |
| Primary language | New App form | Can be changed later, but it sets the default listing. |
| Free → paid upfront | Pricing | Turning a free app into a paid one annoys existing users. Adding subscriptions or in-app purchases to a free app is normal. |
| Publishing App Privacy | App Privacy → Publish | Becomes the public "nutrition label". Make sure the answers match what the app actually does. |
| Public privacy policy page | GitHub Pages or other hosting | Publishes the developer's name and email. Confirm before creating a public repo or page. |

## The launch order

Each phase lists what to check, what to do, and the usual mistakes. For field-by-field details of
the App Store Connect screens, read `references/app-store-connect.md` when you reach phase 3.

### Phase 0: Is the app ready for review?

Check the code before any forms. Apple rejects apps for these more often than for paperwork:

- No debug or developer features in the store build. That means test endpoints, API keys, log
  uploads and "record samples" tools.
- The app makes no network calls the privacy answers don't declare. Look for web fonts
  (Google Fonts), analytics SDKs and crash reporters.
- Usage descriptions (`NS...UsageDescription`) for every permission the app asks for.
- `ITSAppUsesNonExemptEncryption = false` in Info.plist if the app only uses Apple's built-in
  encryption. This skips the export-compliance question on every upload.
- A privacy manifest (`PrivacyInfo.xcprivacy`) that declares required-reason APIs.
- For a children's app, a parental gate in front of settings, purchases and links out.
- If users can create an account, they must also be able to delete it from inside the app
  (guideline 5.1.1(v)). This is a very common rejection.
- If the app offers Google, Facebook or another third-party sign-in, it usually also needs Sign in
  with Apple (guideline 4.8).
- If the app has a login, prepare a demo account with sample data for the review notes.
- If data leaves the device (a backend, Firebase, analytics), the App Privacy answers must list
  each data type and its purpose. "Data Not Collected" is only for apps where nothing leaves the
  device.

### Phase 1: Apple Developer account (user only)

- Enrolment costs USD 99 a year. Individual accounts show the person's name as the seller.
  Organisation accounts need a D-U-N-S number.
- In App Store Connect, look for banners. An updated licence agreement that hasn't been accepted
  blocks new submissions, and only the Account Holder can accept it. The EU Digital Services Act
  trader status is needed to sell in the EU.
- The team ID is shown at the top right of developer.apple.com/account/resources. It's 10
  characters and needed for signing.

### Phase 2: Register the bundle ID

developer.apple.com → Certificates, Identifiers & Profiles → Identifiers → (+) → App IDs → App.

- Choose Explicit. Paste the bundle ID from the project config. Look in `tauri.conf.json`
  `identifier`, the Xcode target, `app.json` (Expo), or the Flutter iOS project.
- The description can be the display name. It can't contain special characters.
- Only enable capabilities the app uses. Most can be added later.
- The New App form's Bundle ID dropdown stays empty until this is done.

### Phase 3: Create the app record and fill in the listing

appstoreconnect.apple.com → Apps → (+) New App. Then:

1. New App form: platforms, name (30 characters), primary language, bundle ID, SKU, user access
   (Full Access is fine for a solo developer).
2. App Information: subtitle (30 characters), primary category (and an optional secondary),
   content rights, age rating questionnaire.
3. App Privacy: Data Collection questions, then the privacy policy URL, then Publish.
4. Pricing and Availability: price tier and countries.
5. Version page (1.0 Prepare for Submission): description, keywords (100 characters,
   comma-separated, no spaces needed), support URL, marketing URL, screenshots, review notes,
   contact details, and the build.

`references/app-store-connect.md` has the questionnaire walkthrough and the form quirks.

### Phase 4: Privacy policy

Every app needs a public privacy policy URL, including apps that collect nothing. Read
`references/privacy-policy.md` for a template and three hosting options. The quickest free option
is a separate public GitHub repo with GitHub Pages. Pages doesn't work on a private repo with a
free account.

### Phase 5: Signing and upload

- Set the team ID in the project. Tauri uses `bundle > iOS > developmentTeam` or the
  `APPLE_DEVELOPMENT_TEAM` environment variable. Native Xcode uses Signing & Capabilities → Team.
- iOS: in Xcode, Product → Archive, then Distribute App → App Store Connect. Or upload with
  Transporter or `xcrun altool`.
- Mac App Store: use an Apple Distribution certificate, a Mac App Store provisioning profile and
  the App Sandbox entitlement. Build a signed `.pkg` with
  `productbuild --sign "3rd Party Mac Developer Installer: …"`, then upload with Transporter.
- After upload, the build takes 5 to 30 minutes to process before it appears in TestFlight.
- TestFlight internal testers (up to 100 people on the team) need no review. External testers
  need a short beta review.
- `security find-identity -v -p codesigning` reporting "0 valid identities" means signing hasn't
  been set up on this Mac.

### Phase 6: Submit

- Test the exact store build on a real device first. Check permissions, first launch with no
  network, and anything sandboxed on macOS.
- Review notes should explain anything a reviewer might get stuck on, such as a parental gate,
  a login (give a demo account), or hardware the app needs.
- Review usually takes 1 to 3 days. The most common rejections are crashes, placeholder content,
  broken links, missing purchase restore, metadata that doesn't match the app, and privacy answers
  that don't match the app's behaviour.

## Monetisation questions

First-timers often ask whether to charge from day one. Usual advice:

- Ship 1.0 free to get reviews and real usage, then add a subscription or in-app purchase in an
  update. Charging needs the Paid Apps agreement, bank and tax details, and StoreKit code, and each
  of these can delay the first release.
- Subscriptions need a Restore Purchases button and clear terms (guideline 3.1.2).
- The Kids category allows purchases behind a parental gate. It rules out third-party ads and
  analytics.
- Don't release free and later switch to a paid upfront price.

## Keep a record

At the end of each session, write down what was done so the next session doesn't have to work it
out again. Record the app's Apple ID, team ID, bundle ID, SKU, the Made for Kids decision, the
privacy policy URL, and which phase each platform has reached. Write it in the repo's launch notes,
or in memory if the user keeps project memory.
