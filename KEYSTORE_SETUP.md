# Keystore setup — production signing for Play Store

This is a **one-time setup**. Once done, every `flutter build apk --release`
or `flutter build appbundle --release` automatically signs with your real
upload key.

If `android/key.properties` is missing the build still completes (signed
with the debug keystore) — useful for sideload-only contributors and CI.

---

## Step 1 — generate the upload keystore (30 seconds)

In **Command Prompt** (Windows). Pick a strong password and **write it
down** — losing it means losing your ability to publish updates.

```
keytool -genkey -v ^
  -keystore C:\Users\mulgu\pediaid-upload-key.jks ^
  -keyalg RSA -keysize 2048 -validity 10000 ^
  -alias pediaid-upload ^
  -storepass "<YOUR-PASSWORD>" ^
  -keypass "<YOUR-PASSWORD>" ^
  -dname "CN=Sunil Mulgund, OU=PediAid, O=PediAid, L=, S=, C=IN"
```

If `keytool` isn't on your `PATH`, the full path is:

```
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"
```

Output:

```
Generating 2,048 bit RSA key pair and self-signed certificate (SHA384withRSA) with a validity of 10,000 days
        for: CN=Sunil Mulgund, OU=PediAid, O=PediAid, C=IN
[Storing C:\Users\mulgu\pediaid-upload-key.jks]
```

---

## Step 2 — create `android/key.properties` (15 seconds)

Path: `C:\Users\mulgu\Desktop\APP\neoapp\neoapp_app\android\key.properties`

Content (replace `<YOUR-PASSWORD>`, keep the **double** backslashes in
the path):

```
storePassword=<YOUR-PASSWORD>
keyPassword=<YOUR-PASSWORD>
keyAlias=pediaid-upload
storeFile=C:\\Users\\mulgu\\pediaid-upload-key.jks
```

This file is gitignored — it will not be committed.

---

## Step 3 — back up the `.jks` (5 minutes — DO NOT SKIP)

If you lose `pediaid-upload-key.jks`, you cannot publish updates to the
same Play Store listing again. Ever. Save copies to:

1. **Google Drive** (or any cloud — encrypted preferred)
2. **A USB stick** in a drawer
3. **Password manager attachment** (Bitwarden / 1Password / Apple Keychain)

Also store the password in your password manager separately.

---

## Step 4 — verify it works (1 minute)

```
cd C:\Users\mulgu\Desktop\APP\neoapp\neoapp_app
flutter build apk --release
```

Look for `Built build\app\outputs\flutter-apk\app-release.apk`. Then check
the signature:

```
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -printcert -jarfile build\app\outputs\flutter-apk\app-release.apk
```

The `Owner: CN=Sunil Mulgund, ...` line confirms you signed with your
real key, not the debug key (`Owner: CN=Android Debug, ...`).

---

## Step 5 — extract SHA-1 and SHA-256 fingerprints

You only need these if you later add Google Sign-In, Firebase, or any
other Google service that requires app verification. For PediAid as it
stands today (custom backend on Render, no Firebase, no Google Sign-In)
you can skip this step.

```
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -keystore C:\Users\mulgu\pediaid-upload-key.jks -alias pediaid-upload
```

Look for the lines:

```
SHA1: AB:CD:EF:...
SHA256: 12:34:56:...
```

After your **first AAB upload to Play Console**, Google enrolls you in
Play App Signing automatically. They generate a separate signing key
and show its SHA-1 and SHA-256 in **Play Console → Setup → App
integrity**. Both upload-key SHAs *and* Play App Signing key SHAs need
to be added to any Google service that authenticates users.

---

## What about CI?

`android/.gitignore` already excludes `key.properties` and `*.jks`, so
they will never be committed by accident. CI builds without these files
will fall back to the debug signing config — useful for PR builds that
need to compile but don't need to publish.

---

## Disaster recovery

| Scenario | Recovery |
|---|---|
| Lost the `.jks` file | If you've already enabled Play App Signing on the first AAB upload, contact Google Play support to reset the upload key. Otherwise, you cannot ever publish updates to the same listing — you'd have to publish a new app under a new package name, losing all reviews and installs. |
| Lost the password | Same as losing the `.jks` — can be reset by Google if Play App Signing was enabled at first upload. |
| Compromised | Reset upload key via Play Console → Setup → App integrity. |
