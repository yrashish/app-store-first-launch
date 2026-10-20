# Extra checks by app type

Read the sections that match the app profile from SKILL.md, Step 1. Most apps match more than one.
Guideline numbers refer to Apple's App Review Guidelines. Check the current text when a decision
depends on one, because Apple revises them several times a year.

## Contents

- Apps with accounts or a backend
- Apps that sell things
- Apps with ads or analytics
- Apps for children
- Apps with user-generated content or chat
- Apps with AI features
- Games
- Regulated fields: health, finance, gambling, VPN, and similar
- Web wrappers and thin apps
- Business, internal and unlisted apps
- Apps that use location, background modes or sensors
- Mac apps
- Selling in specific countries

## Apps with accounts or a backend

- Account deletion inside the app, not only by email or on a website (5.1.1(v)). Deletion must
  remove the account and its data, or say clearly what is kept and why.
- Offering Google, Facebook or another third-party sign-in usually means Sign in with Apple, or
  another login that meets 4.8's privacy conditions, must also be offered.
- Don't force sign-up before the app shows anything useful, unless the app's core function needs
  an account (5.1.1(v)).
- Give the reviewer a demo account with sample data in the review notes. Make sure it works from
  the reviewer's country and doesn't need two-factor codes sent to your phone.
- App Privacy can't say "Data Not Collected". Declare each type that leaves the device (email,
  user ID, user content, usage data) with its purpose and whether it's linked to the user.
- The privacy policy must name the backend provider (Firebase, Supabase, AWS) and say how to delete
  data.

## Apps that sell things

- Create the in-app purchases or subscriptions in App Store Connect, with review screenshots,
  before submitting. The first ones must be submitted with an app version.
- Show price, billing period and what the user gets before the purchase button. Free trials must
  say what happens when the trial ends.
- Restore Purchases must be reachable without buying anything again.
- Link to the terms of use (Apple's standard EULA is fine) and privacy policy from the paywall and
  from the store description.
- Test purchases with a sandbox account through TestFlight before submitting.
- The reviewer must be able to reach paid features. Explain in the review notes how, for example
  that sandbox purchases are free.

## Apps with ads or analytics

- Declare the data the SDKs collect in App Privacy. Ad SDKs usually collect device identifiers
  and usage data, and often count as tracking.
- Tracking across other companies' apps or websites needs the App Tracking Transparency prompt
  first, with `NSUserTrackingUsageDescription`.
- Use recent SDK versions that include privacy manifests.
- Apps for children: see the next section. Third-party ads and analytics are effectively ruled
  out in the Kids category.

## Apps for children

This applies whether or not the app joins the Kids category.

- A parental gate in front of settings, purchases, links out of the app and any data requests. The
  gate must be something a young child can't pass, such as a multiplication question or a number
  written out in words that has to be typed as digits.
- No third-party ads or analytics that send data off the device, if the app is in the Kids
  category. Outside the category, children's privacy law (COPPA in the US, GDPR-K in the EU, the UK
  Age Appropriate Design Code) still applies to an app aimed at children.
- Made for Kids is permanent. See the table in SKILL.md before choosing it. The age band must be
  one of 5 and under, 6–8 or 9–11.
- Metadata may say "for kids" only if the app is in the Kids category (2.3.8).
- A way for the parent to delete a child's data in the app, behind the gate, that works for every
  profile including the last one. Test it with one profile and with several. App Review may ask
  how data is deleted.
- A Kids submission can come back "Rejected" under 2.1 with questions about guideline 1.3
  (analytics, ads, data sharing, other collection). It is a request for answers. See
  `app-review.md`, section 3.
- Ages shown in the app, screenshots and description must agree with the Kids age band. Leaving
  the number out is simplest.

## Apps with user-generated content or chat

Guideline 1.2 requires all of these:

- A way to filter objectionable content.
- A way to report content, with a timely response.
- A way to block abusive users.
- Contact information published in the app.

The age rating questionnaire must answer Yes to user-generated content or messaging, which usually
raises the rating. Apps whose main purpose is anonymous chat or random video chat face extra
scrutiny.

## Apps with AI features

- Generated text or images shown to users are treated much like user-generated content. Filter
  harmful output, offer a way to report it, and answer the age rating questions to match what the
  model can produce.
- If personal data is sent to a third-party AI service, say so clearly and get the user's
  permission first (5.1.2). Declare it in App Privacy and name the provider in the privacy policy.
- Don't claim the app does things the model can't reliably do (2.3.1).
- Keep API keys out of the app bundle. Call the model through your own backend.

## Games

- Answer the age rating questions on violence, horror, simulated gambling, contests and loot boxes
  truthfully. Cartoon violence counts.
- Loot boxes and other random paid items must show the odds before purchase (3.1.1).
- Game Center is optional. If used, enable the capability and set up leaderboards and achievements
  before submitting.
- Games distributed in Vietnam need a licence entered under App Information. Games in mainland
  China need a government licence (an ISBN number) as well as an ICP filing.
- The Games category has subcategories. Pick up to two.

## Regulated fields: health, finance, gambling, VPN, and similar

- Apps in highly regulated fields (banking, payments, investing, crypto exchanges, health care,
  medical, gambling, air travel, cannabis, VPN and similar) must be submitted by an organisation
  account belonging to the business that offers the service, not by an individual (5.1.1(ix)).
- Real-money gambling needs the licences for every country where it's available, and geo-restriction
  elsewhere.
- Health and medical apps: declare whether the app is a regulated medical device (App Information →
  Regulated Medical Devices) if it's in Medical or Health & Fitness, or answers "frequent" to medical
  information. Don't make unproven diagnostic claims (1.4.1).
- HealthKit data can't be used for advertising or shared with third parties for it, and must not be
  stored in iCloud.
- VPN apps must use the NEVPNManager API and be offered by an organisation.

## Web wrappers and thin apps

- An app that only shows a website is rejected under 4.2 (minimum functionality). It needs native
  features that make it worth installing: offline use, notifications, device features or native
  navigation.
- Apps generated from templates or app-building services are rejected under 4.2.6 unless the
  service submits them under the client's own account.
- Several near-identical apps are rejected as spam (4.3). Combine them into one app.

## Business, internal and unlisted apps

- Employee-only apps can be distributed privately to one business as Custom Apps through Apple
  Business Manager. They still go through App Review.
- An app for a known group (event attendees, a club, a clinic's patients) can request unlisted
  distribution. It doesn't appear in search and can be opened only by direct link.
- If the app needs a login the reviewer can't create, the demo account is essential.

## Apps that use location, background modes or sensors

- Ask for permission at the moment the feature is used, and explain why in the usage description.
- Background location, audio or VoIP modes need a feature that clearly uses them. Explain it in
  the review notes.
- Don't ask for more access than the feature needs. For example, ask for "while using" location
  rather than "always" where possible.

## Mac apps

- The Mac App Store requires the App Sandbox. Every outside resource (network, files, camera,
  microphone, USB) needs its entitlement. Test the sandboxed build itself, because file access
  that works unsandboxed may fail.
- Mac apps can't install kernel extensions, ask for root, or download and run code outside the
  bundle.
- Apps that render with WKWebView (Tauri, Capacitor-style shells, native apps with a web view)
  need `com.apple.security.network.client` in the sandbox, or the web view's network process
  crashes and the window stays black, even for apps that make no requests.
- Moving a sandboxed app to the Trash leaves its data in
  `~/Library/Containers/<bundle ID>`. If the app or privacy policy says deleting the app deletes
  the data, that is true on iOS but not on macOS; say how to delete the container folder.
- TestFlight on a Mac asks for a redeem code when the Mac App Store is signed in with an Apple ID
  that isn't a tester. Add that Apple ID as a tester, or sign in with the tester's.
- If the Mac App Store is too limiting, Developer ID signing with notarisation and distribution from
  your own website is the alternative. That's outside this skill's scope.

## Selling in specific countries

- EU: trader status under the Digital Services Act. Without it, the app is removed from EU
  storefronts.
- Mainland China: an ICP filing number in App Information. Without it, the app can't be available
  there.
- South Korea, Vietnam, Brazil and some other countries add their own age rating labels or
  licences. The age rating summary in App Information shows the regional results.
- Untick countries where the app can't legally operate, for example because of gambling or
  finance licences.
