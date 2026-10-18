---
name: app-store-first-launch
description: Guide a developer through getting any app onto Apple's App Store or TestFlight with App Store Connect, from a first-ever launch to a new app or platform from an experienced team, and through later version updates. Works out which rules apply to the app (accounts and backends, subscriptions, games, children, user-generated content, AI features, regulated fields like health or finance) and to the stack (Xcode, Flutter, React Native/Expo, Capacitor, Tauri, Unity, Electron). Covers readiness checks, bundle ID, the app record, listing limits, age rating and Made for Kids, App Privacy labels, privacy policy hosting, signing, upload, review, phased release and when to charge. Use it whenever someone wants to publish, submit, ship or update an iOS, iPadOS or macOS app, asks where their App Store launch stands, or is filling in App Store Connect. Not for fastlane or CI automation, crash debugging, StoreKit or feature code, replying to a rejection, or Google Play.
---

# App Store launch

This skill takes someone from "the app runs" to "the app is on the App Store", and through later
updates. The work is spread across developer.apple.com, App Store Connect, a privacy policy host
and the build tools. Which rules apply depends on what the app does and how it's built, and some
choices can't be undone. Your job is to know the order, find out what applies to this app, check
what is already done, and explain each choice before the user makes it.

## How to work with the user

- **Check the current state first, then report.** Run `scripts/check_readiness.sh` from this
  skill's folder with the project root as the working directory. Read any launch notes in the repo
  (`docs/app-store*.md`, `PRIVACY.md`, `README`). Report what is done, what is blocked, and who has
  to do each step.
- **Match the user's experience.** A first-timer needs terms defined (bundle ID, provisioning
  profile, SKU) and the website named for each step. Someone who has shipped before only needs the
  parts that differ for this app. Ask if you can't tell.
- **Stop before anything irreversible.** Before such a step, explain what gets locked in and ask
  for a clear yes. The list is in "Choices that are hard or impossible to undo". Clicking Save or
  Create in Apple's forms counts as submitting a form, so confirm the values first.
- **Some steps only the user can do.** These are enrolling in the Developer Program, accepting
  Apple's agreements, entering bank and tax details, and anything that needs their Apple ID
  password. Tell them exactly where to click and wait.
- **Recommend one option and give the reason.** Most people want a recommendation, not a list.
- **Check limits before you type.** The name and subtitle are 30 characters each, keywords are
  100, and promotional text is 170. Count before entering. If the text is too long, offer a version
  that fits.
- **Trust the screen over these notes.** Apple changes forms and guidelines. Prices, limits,
  screenshot sizes and guideline numbers here were checked in October 2026. If a page or a current
  guideline disagrees with this skill, follow Apple and tell the user.

## Step 1: Profile the app

Before giving advice, work out the following. Infer what you can from the repo and the
conversation, and ask only about what's left.

| Question | Why it matters |
|---|---|
| Platforms: iOS, iPadOS, macOS, or several? | Changes signing, screenshots and sandboxing. One record and bundle ID can cover iOS and macOS. |
| Stack | Changes where the bundle ID and team are set, and how to build and upload. See `references/stacks.md`. |
| First app on this account, first release of this app, or an update? | An update skips most of the setup (see "Releasing an update"). |
| Individual or organisation account? | The seller name shown on the store. Apps in regulated fields need an organisation account. |
| How will it be distributed? | Public App Store (the default), unlisted, private to one business (Custom Apps through Apple Business Manager), or TestFlight only. |
| What the app does | Accounts or a backend, payments, ads or analytics, children as the audience, user-generated content, AI features, a game, a health, finance, gambling or VPN app, or a thin wrapper around a website. Each adds rules, listed in `references/app-types.md`. |

Then read the matching sections of `references/app-types.md` before Phase 0.

## Choices that are hard or impossible to undo

| Choice | Where | Why it matters |
|---|---|---|
| Bundle ID | developer.apple.com → Identifiers | Permanent for the app. Use one ID for iOS and macOS if you want Universal Purchase. It doesn't have to match the display name. |
| SKU | New App form | Internal and can't be changed later. Any short slug works. |
| Account type for the seller name | Developer Program enrolment | Moving an app from an individual to an organisation account later means an app transfer. |
| Made for Kids | Age rating questionnaire, last step | Apple's dialog says it can't be changed later. Once approved, every update must follow the Kids rules: no third-party ads or analytics, and links out and purchases behind a parental gate. The only way out is a new app record. Recommend "Not Applicable" unless the user has decided to commit: you can opt in later but can't opt out. |
| Kids age band | Same place | Only one band: 5 and under, 6–8, or 9–11. |
| App name | New App form | Creating the record reserves the name. Names must be unique on the App Store. |
| Free → paid upfront | Pricing | Turning a free app into a paid download annoys existing users. Adding subscriptions or in-app purchases to a free app is normal. |
| Publishing App Privacy | App Privacy → Publish | Becomes the public "nutrition label". The answers must match what the app actually does. |
| Public privacy policy page | GitHub Pages or other hosting | Publishes the developer's name and email. Confirm before creating a public repo or page. |
| Releasing a version | Version page → Release | Users download it right away (or over 7 days with phased release). You can't take a version back, only ship a new one. |

## The launch order

Each phase lists what to check and do. For field-by-field notes on App Store Connect, read
`references/app-store-connect.md` when you reach phase 3.

### Phase 0: Is the app ready for review?

Check the code before any forms. Apple rejects apps for these more often than for paperwork.

These apply to every app:

- No debug or developer features in the store build: test endpoints, hard-coded keys, debug menus,
  log uploads.
- No placeholder content, broken links or "coming soon" screens.
- Every network call the app makes is either declared in the privacy answers or doesn't collect
  data. Look for analytics SDKs, crash reporters, ad SDKs and web fonts.
- A usage description (`NS...UsageDescription`) for every permission the app requests, saying why.
- `ITSAppUsesNonExemptEncryption = false` in Info.plist if the app only uses standard encryption
  such as HTTPS or Apple's APIs. This skips the export-compliance question on every upload.
- A privacy manifest (`PrivacyInfo.xcprivacy`) that declares required-reason APIs. Third-party
  SDKs need their own manifests, which recent versions ship.
- The app works on the devices it claims to support, including iPad if iPad is enabled. An
  iPhone-only layout running on iPad is a common rejection.

Then add the checks from `references/app-types.md` for each type that applies, for example account
deletion and Sign in with Apple for apps with logins, or report and block for apps with
user-generated content.

### Phase 1: Apple Developer account (user only)

- Enrolment costs USD 99 a year (free for some non-profits and schools). Individual accounts show
  the person's name as the seller. Organisation accounts show the company name and need a D-U-N-S
  number.
- In App Store Connect, look for banners. An updated licence agreement that hasn't been accepted
  blocks new submissions, and only the Account Holder can accept it. EU Digital Services Act trader
  status is needed to distribute in the EU.
- Selling anything needs the Paid Apps agreement, plus bank and tax details, under Business.
- The team ID is shown at the top right of developer.apple.com/account/resources. It's 10
  characters and needed for signing.

### Phase 2: Register the bundle ID

developer.apple.com → Certificates, Identifiers & Profiles → Identifiers → (+) → App IDs → App.

- Choose Explicit and paste the bundle ID from the project. `references/stacks.md` says where each
  stack keeps it.
- The description can be the display name. It can't contain special characters.
- Enable the capabilities the app uses, such as Sign in with Apple, Push Notifications, iCloud,
  App Groups or HealthKit. More can be added later, but provisioning profiles must be regenerated.
- Xcode's automatic signing can register the ID for you. Registering it by hand first avoids
  surprises with the name Xcode picks.
- The New App form's Bundle ID dropdown stays empty until this is done.

### Phase 3: Create the app record and fill in the listing

appstoreconnect.apple.com → Apps → (+) New App. Then:

1. New App form: platforms, name, primary language, bundle ID, SKU, user access.
2. App Information: subtitle, primary and optional secondary category, content rights, age rating
   questionnaire.
3. App Privacy: data collection answers, privacy policy URL, then Publish.
4. Pricing and Availability: price, countries, and distribution method (public or unlisted).
5. In-app purchases and subscriptions, if any. Create the products before submitting, and attach
   them to the first version that uses them.
6. Version page: screenshots, description, keywords, support URL, review notes, contact details,
   and the build.

### Phase 4: Privacy policy

Every app needs a public privacy policy URL, including apps that collect nothing. Read
`references/privacy-policy.md` for what it must cover and how to host it.

### Phase 5: Signing and upload

The details depend on the stack (see `references/stacks.md`). Common to all:

- iOS needs an Apple Distribution certificate and an App Store provisioning profile. Xcode's
  automatic signing creates both. Running `security find-identity -v -p codesigning` and getting
  "0 valid identities" means nothing is set up on this Mac yet.
- The Mac App Store needs the App Sandbox entitlement, a Mac App Store provisioning profile, and a
  `.pkg` signed with a "3rd Party Mac Developer Installer" (Mac Installer Distribution) certificate.
- Each upload needs a higher build number than the last one for that version.
- After upload, the build takes 5 to 30 minutes to process before it appears in TestFlight.
- TestFlight internal testers (up to 100 people on the team) need no review. External testers (up
  to 10,000, by email or public link) need a short beta review of the first build, and the
  TestFlight Test Information page filled in first: a beta app description, a feedback email, and
  "What to Test" notes. Answer the export compliance question if the build asks.

### Phase 6: Submit and release

- Test the exact store build from TestFlight on a real device. Check permissions, first launch
  with no network and an empty account, purchases in the sandbox, and anything sandboxed on macOS.
- Review notes should explain anything a reviewer might get stuck on: a demo account, a parental
  gate, hardware or a location the app needs, or features behind a paywall.
- Choose how to release: manual, automatic on approval, or scheduled. Phased release spreads an
  automatic update over 7 days and can be paused.
- Review usually takes 1 to 3 days. The most common rejections are crashes, incomplete content,
  missing account deletion, missing purchase restore, misleading metadata, and privacy answers that
  don't match the app. If a rejection comes in, help the user fix the cause. Writing the reply
  itself is outside this skill.

## Releasing an update

For an app that's already live:

1. Bump the version (`CFBundleShortVersionString`) and the build number.
2. In App Store Connect, add a new version (+ next to the platform name), fill in "What's New in
   This Version", and update screenshots if the UI changed.
3. Re-check App Privacy and the age rating if the update adds SDKs, accounts, ads, chat, web
   content or AI features. These don't update themselves.
4. Upload, attach the build, submit, and choose a release option. Use phased release for large
   changes.
5. Promotional text can be changed at any time without a new version. The description, keywords
   and screenshots need one.

## Monetisation

People often ask whether to charge from day one. Unless the user has a reason to charge now:

- A free 1.0 gets reviews and real usage data sooner. A subscription or in-app purchase can be
  added in an update. Charging needs the Paid Apps agreement, bank and tax details, product setup
  and StoreKit code, and each of these can delay the first release.
- Digital goods and features unlocked inside the app must use Apple's in-app purchase. Physical
  goods and real-world services use other payment methods. The rules for linking to outside
  payment differ by country and change often, so check the current guideline 3.1 before
  advising on them.
- Subscriptions need a Restore Purchases button, clear price and terms on the paywall, and links
  to the terms of use and privacy policy (guideline 3.1.2).
- The Small Business Program lowers Apple's commission to 15% for developers under USD 1 million a
  year. Enrol under Business in App Store Connect.
- Don't release free and later switch to a paid upfront price.

## Keep a record

At the end of each session, write down what was done so the next session doesn't have to work it
out again. Record the app's Apple ID, team ID, bundle ID, SKU, the Made for Kids decision, the
privacy policy URL, the current version, and which phase each platform has reached. Write it in the
repo's launch notes, or in memory if the user keeps project memory.
