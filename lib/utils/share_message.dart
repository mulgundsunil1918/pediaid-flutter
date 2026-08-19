// =============================================================================
// utils/share_message.dart
//
// The single message sent by every "Share with Colleagues" entry point.
//
// It used to be written inline in two places (the home drawer and Settings),
// which had already drifted: the drawer carried a WRONG App Store id
// (6748139585) that sent every iOS recipient to the wrong listing, and neither
// copy mentioned the scores, resources or immunisation work. One constant so
// the two can never disagree again.
//
// Counts here are real: 62 calculators and 110 scores (14 neonatal + 96
// paediatric) are what the app ships. If those lists grow, update this text —
// it is the app's public claim about itself.
// =============================================================================

const String kAppStoreUrl =
    'https://apps.apple.com/us/app/pediaid-pediatrics-neonatology/id6777623709';
const String kPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=com.pediaid.pediaid';
const String kLandingUrl = 'https://info.pediaid.bridgr.co.in';
const String kDemoUrl = 'https://youtu.be/AuNn9sdnXvc';

const String kShareSubject =
    'PediAid — paediatric & neonatal clinical reference';

const String kShareMessage = '''
🩺 PediAid — paediatric & neonatal clinical reference, in your pocket.

🧮 62 calculators • 🧠 110 clinical scores • 📈 Growth charts (WHO · IAP · Fenton 2025 · INTERGROWTH)
💊 Drug formulary — paediatric & neonatal dosing • 🧪 Lab reference values by system
💉 Immunisation — IAP · National (NIS) · catch-up schedules
🚨 NRP 9th · PALS · BLS · emergency protocols • 🧒 Developmental milestones

🎓 Academics — trials, IAP & NNF updates • 📅 CME & webinars
⚠️ Never Again — learn from real, anonymous clinical mistakes

🔍 Search anything from the home screen • 📌 Pin your most-used tools • 🌙 Dark mode
📴 Fast • Offline-friendly • 💯 100% FREE

📚 Plus around 50 free PDF resources — question banks, viva decks, X-ray & instruments, national health programmes, case formats, growth & scoring sheets.

🌐 $kLandingUrl

🤖 Android: $kPlayStoreUrl
🍎 iOS: $kAppStoreUrl
▶️ Demo: $kDemoUrl

💚 Share PediAid with your colleagues — good knowledge deserves to be shared!''';
