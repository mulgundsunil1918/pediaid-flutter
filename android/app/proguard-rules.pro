# =============================================================================
# PediAid release ProGuard rules
#
# These keep rules let R8 minify + shrink the release build (AAB / APK)
# without breaking the plugins we use that do native-side reflection. Tested
# manually against the syncfusion PDF viewer and flutter_inappwebview which
# are the two most common breakers.
#
# When adding a new plugin: build a release APK with --no-shrink first, sideload
# and test the screen the plugin powers, then re-enable shrinking with the
# matching `-keep class <plugin.package>.** { *; }` line.
# =============================================================================

# ─── Flutter framework ───────────────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# ─── Play Core / Play Asset Delivery ─────────────────────────────────────────
# Flutter references these for deferred components even when we don't ship
# any. Stripping them causes a NoClassDefFoundError at boot on some devices.
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# ─── syncfusion_flutter_pdfviewer ────────────────────────────────────────────
# The PDF viewer uses reflection for shape annotations + custom fonts.
-keep class com.syncfusion.** { *; }
-keep interface com.syncfusion.** { *; }
-dontwarn com.syncfusion.**

# ─── flutter_inappwebview (NRP / PALS / IAP chart embedded webviews) ────────
-keep class com.pichillilorenzo.** { *; }
-keep interface com.pichillilorenzo.** { *; }
-dontwarn com.pichillilorenzo.**

# ─── flutter_secure_storage (auth token persistence) ────────────────────────
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-dontwarn com.it_nomads.**

# ─── share_plus / in_app_review / package_info_plus / url_launcher ──────────
-keep class dev.fluttercommunity.plus.** { *; }
-keep class io.flutter.plugins.urllauncher.** { *; }
-dontwarn dev.fluttercommunity.plus.**

# ─── pdf + printing packages (used by reports / Lab Reference exports) ──────
-keep class net.nfet.flutter.printing.** { *; }
-dontwarn net.nfet.flutter.printing.**

# ─── shared_preferences / path_provider — handle their own, but be safe ─────
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }

# ─── Kotlin reflection / metadata ────────────────────────────────────────────
-keep class kotlin.Metadata { *; }
-keep class kotlin.reflect.** { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**

# ─── Generic — keep annotations + signatures so reflection still works ───────
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keepattributes SourceFile,LineNumberTable

# ─── Remove parameter names + line numbers in production for tiny extra
#     savings, but rename source file for crash report readability ──────────
-renamesourcefileattribute SourceFile

# ─── Common third-party libraries that ship dontwarn-worthy references ──────
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
-dontwarn org.codehaus.mojo.**

# ─── Suppress warning about missing javax classes (common on Android) ───────
-dontwarn javax.lang.model.**
