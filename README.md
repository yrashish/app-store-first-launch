# app-store-first-launch

A Claude skill that guides a developer through publishing an app to Apple's App Store, from a
first-ever launch to a new app from an experienced team, through App Review, and through later
updates. It covers iOS, iPadOS and macOS, through App Store Connect and TestFlight.

It came out of shipping a children's app on iPhone, iPad and Mac. Apple splits the work across
developer.apple.com, App Store Connect, a privacy policy host and Xcode, and several of the
choices can't be undone. The skill gives Claude the order to work in, the limits for each field,
and the decisions to stop and explain before the user clicks Save.

## What it does

- Checks where you are first. `scripts/check_readiness.sh` reports signing identities and
  provisioning profiles, the bundle ID and team ID in your config, Info.plist and
  privacy-manifest keys, web calls that would contradict a "Data Not Collected" label, and
  placeholders left in your privacy policy.
- Walks through the launch in order: review readiness, the developer account, the bundle ID, the
  app record and listing, the privacy policy, signing and upload, TestFlight (including the test
  information external testers need), then submission.
- Stops before choices that are hard or impossible to undo and explains them. These include the
  bundle ID, the SKU, Made for Kids, the app name, switching from free to paid upfront, and
  publishing the privacy label.
- Explains the age rating questionnaire step by step, including when "Made for Kids" is a
  mistake.
- Plans and checks screenshots: which screens go in the three slots search results show,
  captions that read at that size, sizes per device, no alpha channel, content Apple rejects.
  `scripts/check_screenshots.py` checks a folder of screenshots and a captions file.
- Handles App Review: what each status means, questions that arrive as rejections (such as the
  Kids Category guideline 1.3 questions), drafting replies whose claims are tested on the build
  first, swapping the build in a rejected version, and resubmitting.
- Uploads Mac apps built outside Xcode (Tauri, Electron, Flutter) without a local installer
  certificate, by wrapping the `.app` in an `.xcarchive` and letting `xcodebuild -exportArchive`
  sign it in the cloud.
- Writes a privacy policy and hosts it free with GitHub Pages.
- Answers "should I charge from day one?" with the usual trade-offs.
- Works out which extra rules apply to the app: accounts and backends, in-app purchases and
  subscriptions, ads and analytics, apps for children, user-generated content, AI features, games,
  regulated fields (health, finance, gambling, VPN), web wrappers, business apps and Mac apps.
- Covers each stack's build and upload: Xcode, Flutter, React Native/Expo, Capacitor, Tauri,
  Unity, Electron, .NET MAUI and Kotlin Multiplatform.
- Handles version updates: version and build numbers, What's New, re-checking privacy and age
  rating answers, and phased release.

## Install

**Claude Code** (all projects):

```bash
git clone https://github.com/yrashish/app-store-first-launch.git
```

```bash
cp -r app-store-first-launch/app-store-first-launch ~/.claude/skills/
```

**Claude.ai / Claude desktop:** download `app-store-first-launch.skill` from the
[latest release](https://github.com/yrashish/app-store-first-launch/releases/latest) and open it,
or upload it under Settings → Capabilities → Skills.

## Use

Ask in plain words. The skill loads when the request is about publishing to the App Store:

- "Where are we with the App Store launch?"
- "App Store Connect is open in Chrome. Fill in the New App form for me."
- "I'm on step 7 of the age rating. Should I pick Made for Kids?"
- "I need a privacy policy URL. The app doesn't collect anything."
- "Should I charge for my first app from day one?"
- "Apple rejected my Kids app under 2.1 and asked about analytics and ads. What do I reply?"
- "Which screenshots should go first, and are these the right sizes?"
- "We're shipping 2.3 with a chat feature. What changes in App Store Connect?"

Steps that only you can do are left to you. These are enrolment, accepting Apple's agreements,
bank and tax details, and anything that needs your Apple ID password. Sending a reply to App
Review and submitting or resubmitting are also left to you, or done only after you say yes.

## Layout

```
app-store-first-launch/
├── SKILL.md                      launch order, irreversible choices, how to guide a first-timer
├── references/
│   ├── app-store-connect.md      field-by-field notes and browser quirks
│   ├── app-review.md             statuses, questions, rejections, replies, resubmitting
│   ├── screenshots.md            order, captions, sizes, checks, upload, app previews
│   ├── app-types.md              extra review rules by app type
│   ├── stacks.md                 bundle ID, signing and upload per stack
│   └── privacy-policy.md         policy outline and GitHub Pages hosting
└── scripts/
    ├── check_readiness.sh        read-only readiness check, run from the project root
    └── check_screenshots.py      sizes, alpha, count and caption rules for screenshots
evals/
└── trigger-evals.json            requests used to test when the skill loads
```

## Trigger tests

`evals/trigger-evals.json` has 30 sample requests: 19 that should load the skill (first launches,
updates, games, AI apps, several stacks, screenshots, App Review rejections and questions,
resubmitting, a Mac sandbox problem) and 11 near-misses (Google Play, StoreKit code, fastlane,
build errors, crash logs, keyword research, a website privacy policy, launch posts, a promo video,
icon design) that should not. With Claude Opus 5.5 in Claude Code, three runs per request, the
current description loads the skill for all 19 positives and none of the 11 negatives. Test by
running `claude -p "<request>" --output-format stream-json --verbose` and looking for a `Skill`
tool call naming `app-store-first-launch`; the init event lists every installed skill, so a plain
text search of the output always matches.

## Caveats

Apple changes App Store Connect screens and rules over time. The skill tells Claude to trust what
is on screen over its notes. Pull requests with corrections are welcome.

## Licence

MIT
