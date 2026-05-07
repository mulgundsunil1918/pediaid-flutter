// =============================================================================
// lib/screens/guides/developmental_milestones/dev_milestones_trivandrum.dart
//
// Routing shim — keeps the historical class name used by the parent
// hub and search delegate, but now forwards straight to the premium
// TDSC Assistant (intelligent screening + interpretation, single page).
// =============================================================================

import 'package:flutter/material.dart';
import 'tdsc/tdsc_assistant_screen.dart';

class DevTrivandrumPlaceholder extends StatelessWidget {
  const DevTrivandrumPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => const TdscAssistantScreen();
}
