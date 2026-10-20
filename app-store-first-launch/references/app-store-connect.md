# App Store Connect: field-by-field

Apple changes these screens from time to time. Read the page (accessibility tree or page text)
before you click, and trust what is on screen over this file.

## Contents

1. Working in the browser
2. New App form
3. App Information page
4. Age rating questionnaire
5. App Privacy
6. Version page

## 1. Working in the browser

- App Store Connect and developer.apple.com use the user's existing Apple sign-in. If a sign-in or
  two-factor prompt appears, the user has to complete it.
- **Dropdowns are native `<select>` elements in a React app.** Setting the value from script
  (form_input or `select.value = …`) changes what's displayed, but the app doesn't register it,
  and the field later shows "This field is required". Click the select, type the first letters of
  the option, and press Return instead.
- Radio buttons respond to a normal click, and to `.click()` from script.
- Pages often render blank for 2 to 5 seconds after navigating. Wait, then screenshot.
- Banners at the top of the Apps page show account blockers: an unaccepted licence agreement, DSA
  trader status, and new required questions. Mention them to the user.

## 2. New App form

Apps → (+) or "Add Apps".

| Field | Notes |
|---|---|
| Platforms | Tick each platform the record should cover (iOS, macOS, tvOS, visionOS). Other platforms can be added later with "Add Platform". |
| Name | 30 characters. Must be unique on the store. "Name: Short description" style is common and helps search. |
| Primary Language | The language the listing is written in, for the main market. Other localisations can be added later. |
| Bundle ID | Empty until the App ID is registered on developer.apple.com. |
| SKU | Internal, permanent and never shown publicly. Use a slug like `appname`. |
| User Access | Full Access for a solo developer. Limited Access hides the app from some team members. |

Clicking Create reserves the name and opens the app's Distribution page. The URL contains the
app's Apple ID (`/apps/<10 digits>/`). Record it.

## 3. App Information page

`/apps/<id>/distribution/info`

- **Subtitle**: 30 characters. It's indexed for search, so put the main search term for what the
  app does here, such as "budget planner", "habit tracker" or "language flashcards".
- **Category**: primary is required, secondary is optional. Games and Stickers have subcategories.
- **Content Rights**: asks whether the app shows third-party content. Set it up before submitting.
- **Age Ratings**: "Set Up Age Ratings" opens the 7-step questionnaire (next section).
- The Save button at the top right turns into "Saved" when the save works.

## 4. Age rating questionnaire

Seven steps. An app with no web views, chat, user content, ads or mature themes usually answers
No or None throughout, and the result is 4+.

1. **Features**: In-App Controls (Parental Controls, Age Assurance) and Capabilities
   (Unrestricted Web Access, User-Generated Content, Social Media, Messaging and Chat,
   Advertising). Yes/No. A parental gate in front of settings is not "Parental Controls" in
   Apple's sense, which means tools that let parents monitor or restrict content.
2. **Mature Themes**: profanity, horror, alcohol, tobacco and drugs. None, Infrequent or Frequent.
3. **Medical or Wellness**.
4. **Sexuality or Nudity**.
5. **Violence**: cartoon and fantasy violence count, including mild slapstick in a game.
6. **Chance-Based Activities**: gambling, simulated gambling, contests, loot boxes.
7. **Additional Information**: shows the calculated rating, then Age Categories and Override:
   - Not Applicable: the usual choice.
   - Made for Kids: needs an age band and is permanent (see the table in SKILL.md). Choosing it
     shows a warning banner. Stop and confirm with the user before saving.
   - Override to Higher Age Rating: use this if the app has an EULA with a minimum age.
   - Age Suitability URL is optional.

When answering many radios, read each step's question names before answering. Don't blindly
answer No to everything: if the app does have ads, a web view or chat, answer truthfully. Apple
checks the questionnaire against the app.

## 5. App Privacy

`/apps/<id>/distribution/privacy`

1. Get Started → "Do you or your third-party partners collect data from this app?"
   - "Collect" means data leaves the device and is kept longer than it takes to serve a request.
     On-device storage is not collection.
   - Third-party SDKs count. Analytics, crash reporting (Crashlytics, Sentry), ad networks and
     some font or CDN loads may count.
   - If nothing leaves the device, answer No. The label then reads "Data Not Collected".
2. Privacy Policy → Edit → enter the public URL. The User Privacy Choices URL is optional.
3. **Publish** at the top right. This makes the label live on the product page. If no policy URL
   is set, Publish may refuse or warn.

## 6. Version page

`/apps/<id>/distribution/ios/version/inflight` (or `macos`).

- **Screenshots**: required sizes change. As of October 2026 that means the 6.9" iPhone, 13" iPad
  (if the app supports iPad), and a Mac size for macOS. The default iPhone slot ("Dynamic Island
  medium display") takes 1206×2622 and rejects 1320×2868 files, so scale them for it. Screenshot
  changes save without the Save button. Order, captions, checks and upload steps are in
  `screenshots.md`.
- **Promotional text** (170 characters) can be changed without a new version.
- **Description** (4000 characters) and **Keywords** (100 characters, comma-separated) need a new
  version to change.
- **Support URL** is required. **Marketing URL** is optional.
- **Build**: shows up after an upload finishes processing. To swap builds, hover the build row
  and click the − at its right end, then "Add Build", pick the new one, Done, and Save.
- **App Review Information**: contact name, phone and email, a demo account if the app has a
  login, and notes. Edits to the notes don't save until the contact fields are filled in; the
  contact is the user's personal data, so leave it to them.
- **Version Release**: manual, automatic after approval, or scheduled for a date. Phased release
  (for updates) is set here too.
