# App Review: statuses, questions, rejections and resubmitting

What to do between "Submit for Review" and release. App Store Connect's review screens changed in
2025–2026; read the page before clicking and trust it over this file.

## Contents

1. Where review lives
2. Statuses
3. Information requests that look like rejections
4. Writing the reply
5. Fixing and resubmitting
6. Disagreeing with a decision
7. Two platforms on one record

## 1. Where review lives

- Distribution → **App Review** (left sidebar; a red dot means something needs attention) lists
  submissions. Each submission page has the items submitted, their review status, a **Messages**
  thread with Apple, "Reply to App Review", and "Resubmit to App Review".
- The version page (Distribution → iOS App or macOS App → the version) shows a red "This item
  requires your attention" banner with a link to the submission.
- Apple also emails the account holder, but the email only says the status changed. The detail
  is in the Messages thread.

## 2. Statuses

| Status | Meaning |
|---|---|
| Waiting for Review | In the queue. Metadata, screenshots and the build are locked. You can withdraw it ("Developer Rejected") to make changes. |
| In Review | Being reviewed. Usually hours. |
| Rejected | See the message. The version becomes editable again. |
| Metadata Rejected | Only the listing needs a change; no new build needed. |
| Pending Developer Release | Approved, waiting for you (manual release). |
| Ready for Distribution | Approved and released, or about to be with automatic release. |

## 3. Information requests that look like rejections

Some "rejections" are questions. A common one: an app in the **Kids Category** gets "Rejected" with
"Guideline 2.1 – Performance – App Completeness" (shown as 2.1.0) and a message asking about
guideline 1.3: whether the app includes third-party analytics, third-party advertising, shares
data with third parties, or collects any other user or device data. It can come with an automated
first message and is not a defect report. The reviewer is waiting for a reply.

Other common questions: how to reach a feature, a demo account that doesn't work, what a
permission is used for, whether the app needs specific hardware.

## 4. Writing the reply

- **Answer every question, numbered as Apple numbered them.** Yes or no first, then one or two
  sentences of fact.
- **Every statement must be true of the build that will be reviewed.** Test each claim on that
  build before sending. A claim like "parents can delete a child's data in Settings" is easy to
  write and easy to have wrong: check it with one profile, with several, and with the last one.
  If a claim is not true yet, fix the app, upload a new build, and send the reply when that build
  is attached.
- **Match the App Privacy label and the privacy policy.** If the label says "Data Not Collected",
  say why: no SDKs that send data, no network requests, or only requests that keep nothing.
- **Distinguish on-device storage from collection.** Data the app keeps only on the device (a
  child's first name, progress, settings) is not "collected" in Apple's sense, but list it so the
  reviewer sees you thought about it, and say how a parent deletes it.
- For a Kids app, say where links out, purchases and support contact sit (behind a parental gate)
  and how the gate works.
- No marketing language, no promises about future versions.
- **Sending the reply is the user's action.** Draft the text; let the user paste and send it, or
  get an explicit yes before sending it from a browser session.

A skeleton for the Kids Category 1.3 request, to be filled in from the actual app:

```
Thank you for reviewing <App>. Answers to the four questions:

1. Third-party analytics: <No. The app contains no analytics or crash-reporting SDK.>
2. Third-party advertising: <No. The app shows no ads and contains no advertising SDK.>
3. Data shared with third parties: <No. ...what leaves the device, if anything, and to whom.>
4. Other collection of user or device data: <No. The developer does not collect any data.
   Kept only on the device, to make the app work: ...list each item and why.>
<Permissions and what they are used for, for example on-device speech recognition.>

<How a parent deletes the data.> <Where links out and contact details are, behind a parental
gate.> The App Privacy section says "<label>", and the privacy policy is at <URL>.
```

## 5. Fixing and resubmitting

A rejected version can be edited in place: same version number, new build if the code changed.

1. Fix the cause. Upload a new build with a higher build number (the version number stays).
2. Wait for it to finish processing (TestFlight shows "Ready to Submit").
3. On the version page, remove the old build (the − icon appears when you hover the build row)
   and add the new one. Change screenshots or text if needed. Save.
4. Test the new build from TestFlight on a real device before resubmitting.
5. On the submission page, reply in Messages if Apple asked anything.
6. Resubmit: "Resubmit to App Review" on the submission page. If it is greyed out after the
   version was edited, open the version page: it shows an **Update Review** button at the top
   right, which is the route to try (seen in October 2026; not confirmed to be the only cause).
   Resubmitting is the user's action; get an explicit yes.

The banner "Your app version was rejected and no other items submitted can be accepted or
approved" means nothing else in that submission (in-app purchases, other items) can be approved
until the rejected item is resubmitted and accepted. It does not mean you must wait for Apple.

Replying without resubmitting leaves the version rejected. Resubmitting without replying to a
question usually gets the same rejection back.

## 6. Disagreeing with a decision

- First reply in Messages with facts: where the feature is, what the reviewer may have missed,
  a video of the flow if it is hard to reach.
- If the reviewer stands by it and you still believe the app complies, appeal to the App Review
  Board through Apple's App Review contact form (developer.apple.com/contact/app-store, topic
  "appeal"). Appeals take longer than a fix; fix it if the fix is small.
- Guideline 4.3 (spam or copycat) and 4.2 (minimum functionality) rejections rarely change by
  argument. Show what is specific to the app, or change it.

## 7. Two platforms on one record

- iOS and macOS on one record have separate versions, builds, screenshots, review notes and
  submissions, each reviewed on its own.
- Fixes in shared code usually belong in both: when one platform gets a new build after a review
  issue, check whether the other platform's attached build has the same problem, and bump its
  build number separately (each platform keeps its own build numbers).
- The answers you gave for one platform should hold for the other. If they differ (for example
  how to delete data on macOS, where the sandbox container survives moving the app to the Trash),
  say so in that platform's review notes.
