# Privacy policy: writing and hosting

Apple requires a public privacy policy URL for every app, including apps that collect nothing.
The Kids category and apps for children also need it to cover children's privacy.

## Writing it

Base it on what the app actually does. Check the code (network calls, SDKs, storage) instead of
assuming. Keep these sections:

1. **Who makes the app**: the developer's name and contact email.
2. **What we collect**: if nothing leaves the device, say so plainly. Name what's absent: no
   accounts, ads, analytics, tracking or servers.
3. **What stays on the device**: list what the app stores locally (for example settings, saved
   documents, history or cached account data) and whether any of it leaves the device.
4. **Third parties**: each SDK and outside service that receives data, including Apple services
   that send data to Apple (for example iCloud sync or server-based speech recognition).
5. **Deleting data**: how to delete data in the app, and that deleting the app deletes everything.
6. **Children's privacy** (if relevant): COPPA, GDPR-K and the UK Age Appropriate Design Code.
   If nothing is collected, say there's nothing to disclose. Only claim to follow the Kids
   category rules if the app is actually in the Kids category.
7. **Changes**: new versions get a new "Last updated" date.
8. **Contact**: the email address again.

Set "Last updated" to today's date. Don't publish a policy that still has placeholders like
`[developer name]`. Grep for `[` before publishing.

## Hosting options

Confirm with the user before publishing. A public page shows their name and email.

| Option | Cost | Notes |
|---|---|---|
| GitHub Pages on a separate public repo | Free | The quickest option if `gh` is signed in. A private repo can't use Pages on a free plan, so don't make the app's source repo public just for this. |
| An existing personal or company website | — | Use a stable path like `/appname/privacy`. |
| Notion or Google Docs public page | Free | Works, but the URLs are long and the pages look less official. |

### GitHub Pages steps

```bash
# in a scratch directory, not inside the app's repo
mkdir -p site/privacy && cd site
# write privacy/index.html (the policy) and index.html (short app page with links
# to privacy/ and a mailto: support link; this can double as the Support URL)
git init -q -b main && git add -A && git commit -q -m "Privacy policy page"
gh repo create <owner>/<app-slug> --public --description "<App>: privacy policy and support" --source . --push
gh api -X POST repos/<owner>/<app-slug>/pages -f "source[branch]=main" -f "source[path]=/"
```

The site goes live at `https://<owner>.github.io/<app-slug>/privacy/` within about 1 to 10
minutes. Check that it's live with `curl -s -o /dev/null -w '%{http_code}'` (expect 200) before
pasting the URL into App Store Connect, because Apple may check the link.

Keep the HTML simple: one column, readable on a phone. If the repo keeps its own copy of the
policy, generate the page from it and note the published URL in that file, so whoever edits it
next knows to update both.
