# PediAid — Upload Keystore Setup

## You need this before submitting the AAB to Play Console.

The release `signingConfig` in `android/app/build.gradle.kts` looks for
`android/key.properties` and `android/app/upload-keystore.jks`. If both
files are present, release builds are signed with your upload key.
If either is missing, the build falls back to debug signing (which is
NOT acceptable for Play Store).

Both files are gitignored — they MUST NOT be committed.

## Step 1: Generate the upload keystore (one time)

From the project root, run:

```bash
keytool -genkey -v ^
  -keystore android/app/upload-keystore.jks ^
  -keyalg RSA -keysize 2048 -validity 10000 ^
  -alias upload
```

You'll be prompted for a store password and a key password. Use **the
same password for both** to keep things simple. Pick something strong —
anything you record in a password manager.

Answer the next set of prompts:

| Prompt | Answer |
|---|---|
| Your first and last name | Sunil Mulgund |
| Organisational unit | PediAid |
| Organisation | PediAid |
| City | (your city) |
| State | (your state) |
| Country code (XX) | IN |

When it asks "Is this correct?" — type `yes`.

A `upload-keystore.jks` file appears at `android/app/upload-keystore.jks`.

## Step 2: Create `android/key.properties`

Create the file `android/key.properties` (it's already gitignored):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

Use the passwords you set in Step 1. `storeFile` is RELATIVE to
`android/app/`.

## Step 3: BACK UP THE KEYSTORE

Right now, before you do anything else:

1. Copy `android/app/upload-keystore.jks` to **somewhere outside this repo** —
   a personal cloud drive, an external SSD, your password-manager file
   vault. Anywhere safe and durable.
2. Save the passwords in a password manager.
3. Confirm you can find both the keystore file AND the passwords from
   a fresh laptop. Test this NOW, not when you're trying to ship a hotfix.

If you lose the keystore, you cannot publish updates to your Play
listing ever again. You'd have to publish a brand new app, losing every
existing install + all reviews.

## Step 4: Recommend Play App Signing

In Play Console under **Release → Setup → App integrity**, enable
"Play App Signing". This means:

- Google holds the actual app-signing key (the one your users' devices
  trust).
- Your `upload-keystore.jks` becomes a "rotatable upload key" — if you
  ever lose or compromise it, Google can issue you a new one.
- Without Play App Signing, losing your upload key means losing the app.

## Step 5: Build a release AAB

```bash
flutter build appbundle --release
```

The AAB lands at `build/app/outputs/bundle/release/app-release.aab`.
Upload that to Play Console.

## Sanity-check that signing worked

```bash
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
```

If the output mentions your alias (`upload`) and your DN (CN=Sunil Mulgund...),
the AAB is signed with your upload key. ✅

If it says "AndroidDebugKey", `key.properties` wasn't found at build time —
double-check the path and password values.

## When versionCode collides

Play Console PERMANENTLY consumes a versionCode every time it sees one
(even rejected uploads). If Play rejects your AAB with "version code N
already used", bump the `+N` suffix in `pubspec.yaml`:

```yaml
version: 1.2.0+5    # <- bump the number after the +
```

Then rebuild the AAB.
