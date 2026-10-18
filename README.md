# app-store-first-launch

A Claude skill that guides a developer through publishing an app to Apple's App Store, from a
first-ever launch to a new app from an experienced team, and through later updates. It covers iOS,
iPadOS and macOS, through App Store Connect and TestFlight.

It came out of shipping a children's maths app, Junior Tutor. Apple splits the work across
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
- "We're shipping 2.3 with a chat feature. What changes in App Store Connect?"

Steps that only you can do are left to you. These are enrolment, accepting Apple's agreements,
bank and tax details, and anything that needs your Apple ID password.

## Layout

```
app-store-first-launch/
├── SKILL.md                      launch order, irreversible choices, how to guide a first-timer
├── references/
│   ├── app-store-connect.md      field-by-field notes and browser quirks
│   ├── app-types.md              extra review rules by app type
│   ├── stacks.md                 bundle ID, signing and upload per stack
│   └── privacy-policy.md         policy outline and GitHub Pages hosting
└── scripts/
    └── check_readiness.sh        read-only readiness check, run from the project root
evals/
└── trigger-evals.json            requests used to test when the skill loads
```

## Trigger tests

`evals/trigger-evals.json` has 24 sample requests: 14 that should load the skill (first launches,
updates, games, AI apps, several stacks) and 10 near-misses (Google Play, StoreKit code, fastlane,
crash logs, rejection replies, screenshot design) that should not. With Claude Opus 5.5 in Claude
Code, three runs per request, the current description loads the skill for all 14 positives and none
of the 10 negatives.

## Caveats

Apple changes App Store Connect screens and rules over time. The skill tells Claude to trust what
is on screen over its notes. Pull requests with corrections are welcome.

## Licence

MIT
