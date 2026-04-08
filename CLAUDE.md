# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**PediAid** — a paediatric & neonatal clinical reference Flutter app with calculators, growth charts, and drug formulary. Targets web, Android, iOS, Windows, Linux, and macOS.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run (web, port 8080)
flutter run -d web-server --web-port=8080

# Build (web)
flutter build web

# Build (Android release)
flutter build apk --release
flutter build appbundle --release

# Run tests
flutter test

# Lint / static analysis
flutter analyze

# Clean build artifacts
flutter clean
```

VS Code launch config already configured for web on Edge at port 8080 (`.vscode/launch.json`).

## Architecture

### Entry Point & Bootstrap
`lib/main.dart` — initializes edge-to-edge system UI, sets up `ThemeProvider` via `Provider`, and routes to `HomeScreen`.

### State Management
`Provider` (ChangeNotifier pattern) is used only for theme state (`lib/theme/theme_provider.dart`). No BLoC, Riverpod, or Redux.

### Theme System
`lib/theme/app_theme.dart` defines full Material 3 light and dark themes. `ThemeProvider` exposes `isDarkMode` toggle consumed throughout the app.

### Service Layer (Singletons)
- `lib/services/formulary_service.dart` — loads and caches drug data from `assets/data/formulary/formulary_index_accurate.json`; supports Neofax and Harriet Lane databases.
- `lib/services/who_data_service.dart` — loads and caches WHO growth chart data from `.xlsx` files in `assets/data/who/`.

Both services use the singleton pattern (`static final _instance`) and in-memory caching to avoid repeated asset reads.

### Screens
All screens live under `lib/screens/`:
- `home/home_screen.dart` — main navigation hub with drawer and quick-access buttons
- `calculators/` (flat in screens/) — 18 calculator files plus hub screens (`calculators_screen.dart`, `bp_hub_screen.dart`, `jaundice_hub_screen.dart`)
- `charts_screen.dart`, `who_chart_screen.dart`, `who_chart_selection_screen.dart`, `iap_chart_screen.dart`, `growth_charts_screen.dart` — growth chart views
- `formulary_screen.dart`, `drug_detail_screen.dart`, `drug_pdf_viewer_screen.dart` — drug reference views
- `settings/settings_screen.dart`

### Platform-Specific Code
- `html_download_web.dart` / `html_download_stub.dart` — conditional import pattern for web-only file download functionality.

### Assets
```
assets/data/
  formulary/   — drug index JSON
  who/         — WHO growth chart Excel files (percentile & z-score tables)
  bilirubin/   — bilirubin curve JSON
assets/        — iap_growth_chart_2015_edited.html (embedded IAP chart)
```

## Key Constraints
- Dart SDK: `^3.11.1`
- Flutter stable channel
- Android NDK: `27.0.12077973`, Java target: `VERSION_17`
- Package name: `com.example.neoapp_app`
