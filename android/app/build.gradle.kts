import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load release signing config from android/key.properties (gitignored).
// The file is absent in CI / on dev machines without the upload key — fall
// back to debug signing so `flutter build apk` and analysis still work.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKey = keystorePropertiesFile.exists()
if (hasReleaseKey) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.pediaid.pediaid"
    // Pin compileSdk one ahead of targetSdk per Play 2026 guidance.
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.pediaid.pediaid"
        // minSdk 23 — required floor for flutter_secure_storage and the
        // current Material 3 widgets we use; covers >99% of devices.
        minSdk = flutter.minSdkVersion
        // Play Store 2026 deadline: targetSdk 35.
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    lint {
        // FullBackupContent: with android:allowBackup="false" the backup XML
        // is runtime-moot, but our checklist requires the files exist for
        // belt-and-braces against Smart Switch. The lint check refuses any
        // file that combines wildcard <include> + <exclude>; suppressing it
        // here lets the build succeed without weakening the actual backup
        // behaviour (which is already off via allowBackup=false).
        disable.add("FullBackupContent")
    }

    buildTypes {
        release {
            // Use the upload-keystore signing config when key.properties
            // is present; fall back to debug signing in CI / dev so the
            // project still compiles without the secret.
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
