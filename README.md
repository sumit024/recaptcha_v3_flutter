# recaptcha_v3_flutter

Add **reCAPTCHA v3** verification to your Flutter apps — simple client token fetching + server-side verification.


---

## Table of contents

* [What is this](#what-is-this)
* [Features](#features)
* [Install](#install)
* [Android / iOS setup](#android--ios-setup)
* [Get Google recaptcha v3 API key](#get-google-recaptcha-v3-api-key)
* [Usage (example)](#usage-example)
* [Important client-side notes](#important-client-side-notes)
* [Server-side verification](#server-side-verification)
* [Contributing](#contributing)
* [License & changelog](#license--changelog)

---

## What is this

`recaptcha_v3_flutter` is a tiny Flutter package that lets your app get a reCAPTCHA v3 token from the client and then you can send it to your backend to verify it. The goal: keep user experience frictionless while protecting endpoints (signups, logins, forms) from bots.

> **Note:** reCAPTCHA v3 is invisible to users — it returns a score (0.0–1.0) instead of a challenge.

## Features

* Fetch a reCAPTCHA v3 token for a given `action` from the client.
* Minimal API surface so you can integrate quickly.
* Example flow + server verification guidance included.

## Install

Add the package to your `pubspec.yaml`.

If the package is not published to pub.dev yet, use the Git dependency:

```yaml
dependencies:
  recaptcha_v3_flutter:
    git:
      url: https://github.com/sumit024/recaptcha_v3_flutter.git
      ref: main
```

Then run:

```bash
flutter pub get
```

## Android / iOS setup

These are general guidelines — adapt to your project.

### Android

1. Ensure your app has internet permission in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

2. If your integration uses a WebView or relies on external domains, make sure network settings allow requests to Google domains during development.

3. (If needed) configure proguard rules and AndroidX compatibility as with any Flutter plugin.

### iOS

1. No special keys are required by default for reCAPTCHA v3, but if you need to allow non-HTTPS requests during development, adjust `Info.plist` App Transport Security settings. Prefer enabling domain access only for `google.com` if you must loosen ATS.

2. Make sure your app targets a modern iOS SDK and is compatible with Flutter plugin embedding.

### Get Google recaptcha v3 API key
* Go to the recaptcha admin console at https://www.google.com/recaptcha/admin

* Sign in using your Google account credentials Add Label name (eg: app name) Selected recaptcha type as Challenge(V3),

* Add Domains: click on the “+ Add” button to register a website,

* For Testing purposes, we need to add a domain name as localhost In production, we can later add another real domain name (example.com)

* GOOGLE CLOUD PLATFORM: Add an app name and it will create a project to enable the required APIS

* Click Save and Submit

You will get two keys:
* site key : This is a public key used to show the captcha verification widget on your site. Store it in you .env file.
* secret key: This key is kept in your backend and is used for authentication communication between the application & recaptcha server to verify the user’s response

## Usage (example)

> The snippet below is a **clear, generic example** showing the expected flow. Replace the class/method names with the actual API if they differ in the library.

```dart
import 'package:flutter/material.dart';
import 'package:recaptcha_v3_flutter/recaptcha_v3_flutter.dart';

// in your main() method
AppRecaptchaHandler.instance.setupSiteKey(dataSiteKey: 'YOUR_SITE_KEY');

// some where in your widget tree
AppRecaptchaWidget(
onTokenReceived: (token){},
onError: (error) {
// display a toast message
},
onLoading: () {
// show a loading indicator
},
),

ElevatedButton(
onPressed: () {
/// Execute the Recaptcha V3  using this method call
AppRecaptchaHandler.executeV3(action: 'login');
},
child: const Text('submit'),
),
```

### Important client-side notes
* Tokens are short-lived (usually valid for ~2 minutes). Fetch a fresh token when needed.
* Use the `action` argument to label what the token is for. Check out https://cloud.google.com/recaptcha/docs/actions-website for different actions.

## Server-side verification
Using the secret key, the token obtained using this package is verified using this Google API https://www.google.com/recaptcha/api/siteverify.


## Contributing

PRs and issues welcome. A suggested workflow:

1. Fork the repo
2. Create a feature branch
3. Add tests (if applicable)
4. Open a PR with a clear description

## License & changelog

See `LICENSE` and `CHANGELOG.md` in the repo for license details and release notes.

---
