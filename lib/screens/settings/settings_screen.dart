import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';
import '../intro/intro_screen.dart';
import '../shared/suggest_feature_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = Theme.of(context).colorScheme.tertiary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.15,
                  color: mutedColor,
                )),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dark Mode',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              )),
                          Text(
                            isDark ? 'Dark theme active' : 'Light theme active',
                            style: TextStyle(fontSize: 12, color: mutedColor),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isDark,
                      onChanged: (val) => themeProvider.setDarkMode(val),
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('About',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.15,
                  color: mutedColor,
                )),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary),
                    title: Text('Version', style: TextStyle(color: textColor)),
                    trailing: Text('v1.0', style: TextStyle(color: mutedColor)),
                  ),
                  ListTile(
                    leading: Icon(Icons.description_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    title: Text('Medical Disclaimer', style: TextStyle(color: textColor)),
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Medical Disclaimer'),
                        content: const Text(
                          'PediAid is a clinical decision support tool intended for use by qualified healthcare professionals only. All calculators, charts and references must be verified against current clinical guidelines before use. The developers accept no liability for clinical decisions made based on this app.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('I Understand'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Help',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.15,
                  color: mutedColor,
                )),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.tour_outlined,
                    color: Theme.of(context).colorScheme.primary),
                title: Text('Show app tour again',
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
                subtitle: Text(
                    "Replay the 5-page tutorial you saw on first launch",
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                        fontSize: 12)),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.35)),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => IntroScreen(
                      onDone: () => Navigator.of(context).pop(),
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Feedback',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.15,
                  color: mutedColor,
                )),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.lightbulb_outline_rounded,
                    color: Theme.of(context).colorScheme.primary),
                title: Text('Suggest a Feature',
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
                subtitle: Text(
                    'Request a calculator, guide, chart, or feature',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                        fontSize: 12)),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.35)),
                onTap: () => showSuggestSheet(context),
              ),
            ),
            const SizedBox(height: 24),
            Text('Account',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.15,
                  color: Theme.of(context).colorScheme.outline,
                )),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red.shade400),
                title: Text('Logout',
                    style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
                subtitle: Text('Sign out of PediAid',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 12)),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out successfully')),
                          );
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
