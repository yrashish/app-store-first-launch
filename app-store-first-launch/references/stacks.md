# Building and uploading by stack

Where each stack keeps the bundle ID, version and signing team, and how to get a build into App
Store Connect. Tool versions change, so check the project's own docs or `--help` when a command
fails.

## Native Xcode (Swift, SwiftUI, Objective-C, Mac Catalyst)

- Bundle ID, version, build number and team: the target's General and Signing & Capabilities tabs.
  These are stored as `PRODUCT_BUNDLE_IDENTIFIER`, `MARKETING_VERSION`, `CURRENT_PROJECT_VERSION`
  and `DEVELOPMENT_TEAM` in `project.pbxproj`.
- Upload: set the destination to "Any iOS Device" (or "My Mac"), then Product → Archive →
  Distribute App → App Store Connect. Automatic signing creates certificates and profiles.
- From the command line: `xcodebuild archive`, then `xcodebuild -exportArchive` with an
  `ExportOptions.plist` (method `app-store-connect`). Upload with Transporter or
  `xcrun altool --upload-app`.

## Flutter

- Bundle ID and team: `ios/Runner.xcodeproj` (open `ios/Runner.xcworkspace` in Xcode). Version and
  build: `version: 1.2.0+5` in `pubspec.yaml`, where 5 is the build number.
- Build: `flutter build ipa`, then upload the `.ipa` from `build/ios/ipa/` with Transporter, or
  open the archive in Xcode Organizer.
- macOS: `flutter build macos`. Sandbox entitlements are in `macos/Runner/*.entitlements`.

## React Native (bare) and Expo

- Bare React Native: same as native Xcode, using `ios/<App>.xcworkspace`.
- Expo: bundle ID in `app.json` or `app.config.js` under `ios.bundleIdentifier`. Version is
  `version`, and the build number is `ios.buildNumber` (or set automatically by EAS).
- Expo upload: `eas build --platform ios --profile production`, then `eas submit --platform ios`.
  EAS can create certificates and profiles if the user signs in with their Apple ID. The user has
  to enter that password themselves.

## Capacitor / Ionic

- Bundle ID: `appId` in `capacitor.config.*`, and in the Xcode project under `ios/App`.
- Build: `npx cap sync ios`, then open `ios/App/App.xcworkspace` and archive in Xcode.
- Web-only content in a native shell is the 4.2 risk. See "Web wrappers" in `app-types.md`.

## Tauri (v2)

- Bundle ID: `identifier` in `src-tauri/tauri.conf.json`. Version: `version` there. Without
  `bundle > iOS > bundleVersion`, the version is also used as the build number, so a second upload
  of the same version is rejected. Set `bundleVersion` and raise it on every upload.
- iOS team: `bundle > iOS > developmentTeam` or the `APPLE_DEVELOPMENT_TEAM` environment variable.
  Build with `npx tauri ios build`, which generates an Xcode project in `src-tauri/gen/apple`.
- Mac App Store: a separate config with sandbox entitlements and an `.app` target. Sign with Apple
  Distribution, then `productbuild --sign "3rd Party Mac Developer Installer: …" --component
  <App>.app /Applications <App>.pkg`, and upload with Transporter.

## Unity

- Bundle ID, version and build: Player Settings → iOS → Other Settings.
- Build to an Xcode project, then archive and upload from Xcode. Set the team in Unity or in the
  generated Xcode project.

## Electron (Mac App Store)

- Package with the `mas` target (electron-builder) or `@electron/osx-sign` with the MAS
  entitlements. The app must be sandboxed, and helper processes need the inherit entitlement.
- Upload the signed `.pkg` with Transporter. Electron apps often fail sandbox review because of
  file access or auto-update code. Remove the auto-updater from the MAS build.

## .NET MAUI and Kotlin Multiplatform

- MAUI: bundle ID is `ApplicationId` in the `.csproj`. Publish with
  `dotnet publish -f net*-ios -c Release`, which needs signing properties set, then upload the
  `.ipa`.
- Kotlin Multiplatform: the iOS app is an Xcode project in `iosApp/`. Treat it as native Xcode.

## Any stack: version and build numbers

- The version (`CFBundleShortVersionString`, such as 1.2.0) is what users see and must be higher
  than the live version for an update.
- The build number (`CFBundleVersion`) must be higher than every earlier upload for the same
  version. Re-uploading after a fix needs a new build number.
