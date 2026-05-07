// =============================================================================
// lib/screens/guides/developmental_milestones/dev_milestones_trivandrum.dart
//
// Routing shim — keeps the historical class name used by the parent
// hub and search delegate, but now forwards straight to the full TDSC
// hub built under tdsc/.
// =============================================================================

import 'package:flutter/material.dart';
import 'tdsc/tdsc_hub.dart';

class DevTrivandrumPlaceholder extends StatelessWidget {
  const DevTrivandrumPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => const TdscHub();
}
