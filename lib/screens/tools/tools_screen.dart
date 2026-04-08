import 'package:flutter/material.dart';
import 'paediatric_parameters_screen.dart';
import '../calculators/bp_hub_screen.dart';
import '../calculators/jaundice_hub_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  static const List<_ToolItem> _tools = [
    _ToolItem(
      title: 'Paediatric Parameters & Equipment',
      subtitle: 'Harriet Lane Reference',
      icon: Icons.medical_services_outlined,
    ),
    _ToolItem(
      title: 'Blood Pressure',
      subtitle: 'Neonatal & Paediatric BP',
      icon: Icons.favorite_outline,
    ),
    _ToolItem(
      title: 'Neonatal Jaundice',
      subtitle: 'AAP 2022 Bilirubin Tool',
      icon: Icons.wb_sunny_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Tools'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        bottom: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final cols = isWide ? 3 : 2;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: GridView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: _tools.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final item = _tools[index];
                    return _ToolCard(
                      item: item,
                      onTap: () => _navigate(context, item.title),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String title) {
    switch (title) {
      case 'Paediatric Parameters & Equipment':
        Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => const PaediatricParametersScreen()));
      case 'Blood Pressure':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BPHubScreen()));
      case 'Neonatal Jaundice':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const JaundiceHubScreen()));
    }
  }
}

class _ToolCard extends StatelessWidget {
  final _ToolItem item;
  final VoidCallback onTap;

  const _ToolCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: primary, size: 22),
              ),
              const Spacer(),
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.title,
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.65),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
