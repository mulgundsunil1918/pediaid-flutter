import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'blood_gas_analyser.dart';
import 'double_volume_exchange.dart';
import 'ventilator_parameters.dart';
import 'ponderal_index_calculator.dart';
import 'bsa_calculator.dart';
import 'nutritional_audit_calculator.dart';
import 'tpn_calculator.dart';
import 'cga_pma_calculator.dart';
import 'gir_calculator.dart';
import 'schwartz_egfr_calculator.dart';
import 'gestational_age_calculator.dart';
import 'bp_hub_screen.dart';
import 'jaundice_hub_screen.dart';
import 'maintenance_fluid_calculator.dart';
import 'parkland_calculator_screen.dart';
import 'lund_browder_screen.dart';
import 'burn_mortality_calculator.dart';
import 'pet_calculator_screen.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  static const List<_CalculatorItem> _calculators = [
    _CalculatorItem(
      title: 'Gestational Age & EDD',
      subtitle: 'EDD, GA & Antenatal Dates',
      icon: Icons.pregnant_woman_outlined,
    ),
    _CalculatorItem(
      title: 'Ponderal Index',
      subtitle: 'IUGR & nutritional status',
      icon: Icons.child_care,
    ),
    _CalculatorItem(
      title: 'Body Surface Area',
      subtitle: 'Mosteller formula',
      icon: Icons.person_outlined,
    ),
    _CalculatorItem(
      title: 'Nutritional Audit',
      subtitle: 'ESPGHAN 2022',
      icon: Icons.local_dining,
    ),
    _CalculatorItem(
      title: 'TPN Calculator',
      subtitle: 'Stock & multi-line TPN',
      icon: Icons.medical_services,
    ),
    _CalculatorItem(
      title: 'CGA / PMA Calculator',
      subtitle: 'Age correction',
      icon: Icons.calendar_month,
    ),
    _CalculatorItem(
      title: 'GIR Calculator',
      subtitle: 'Glucose infusion rate',
      icon: Icons.water_drop,
    ),
    _CalculatorItem(
      title: 'Schwartz eGFR',
      subtitle: 'Creatinine clearance',
      icon: Icons.monitor_heart,
    ),
    _CalculatorItem(
      title: 'Blood Gas Analyser',
      subtitle: '7-step interpretation',
      icon: Icons.air,
    ),
    _CalculatorItem(
      title: 'DVET Calculator',
      subtitle: 'Exchange transfusion',
      icon: Icons.water_drop,
    ),
    _CalculatorItem(
      title: 'Ventilator Parameters',
      subtitle: 'OI, OSI, MAP, HFOV',
      icon: Icons.monitor_heart,
    ),
    _CalculatorItem(
      title: 'BPD Estimator',
      subtitle: 'Bronchopulmonary Dysplasia — NICHD Neonatal Research Network',
      icon: Icons.air,
    ),
    _CalculatorItem(
      title: 'Blood Pressure',
      subtitle: 'Neonatal & Paediatric BP',
      icon: Icons.favorite_rounded,
    ),
    _CalculatorItem(
      title: 'Neonatal Jaundice',
      subtitle: 'AAP 2022 Bilirubin Tool',
      icon: Icons.opacity_rounded,
    ),
    _CalculatorItem(
      title: 'Maintenance Fluids',
      subtitle: 'Neonatal & Paediatric Fluid Calculator',
      icon: Icons.local_drink_outlined,
    ),
    _CalculatorItem(
      title: 'Parkland Formula',
      subtitle: 'Burns Fluid Resuscitation',
      icon: Icons.local_fire_department_outlined,
    ),
    _CalculatorItem(
      title: 'Lund & Browder Chart',
      subtitle: 'Burn Surface Area Estimation',
      icon: Icons.person_outlined,
    ),
    _CalculatorItem(
      title: 'Burn Mortality',
      subtitle: 'Revised Baux Score',
      icon: Icons.monitor_heart_rounded,
    ),
    _CalculatorItem(
      title: 'PET Calculator',
      subtitle: 'Partial Exchange Transfusion — Polycythemia',
      icon: Icons.bloodtype_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Calculators & Tools'),
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
                itemCount: _calculators.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final item = _calculators[index];
                  return _CalculatorCard(
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
      case 'Gestational Age & EDD':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const GestationalAgeCalculator()));
      case 'Ponderal Index':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PonderalIndexCalculator()));
      case 'Body Surface Area':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BSACalculator()));
      case 'Nutritional Audit':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const NutritionalAuditCalculator()));
      case 'TPN Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const TpnCalculator()));
      case 'CGA / PMA Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CGAPMACalculator()));
      case 'GIR Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const GIRCalculator()));
      case 'Schwartz eGFR':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SchwartzEGFRCalculator()));
      case 'Blood Gas Analyser':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BloodGasAnalyser()));
      case 'DVET Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const DoubleVolumeExchange()));
      case 'Ventilator Parameters':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const VentilatorParameters()));
      case 'BPD Estimator':
        launchUrl(
          Uri.parse('https://neonatal.rti.org/index.cfm?fuseaction=BPD_Calculator2.start'),
          mode: LaunchMode.externalApplication,
        );
      case 'Blood Pressure':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BPHubScreen()));
      case 'Neonatal Jaundice':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const JaundiceHubScreen()));
      case 'Maintenance Fluids':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const MaintenanceFluidCalculator()));
      case 'Parkland Formula':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ParklandCalculatorScreen()));
      case 'Lund & Browder Chart':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const LundBrowderScreen()));
      case 'Burn Mortality':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BurnMortalityCalculator()));
      case 'PET Calculator':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PETCalculatorScreen()));
    }
  }
}

class _CalculatorCard extends StatelessWidget {
  final _CalculatorItem item;
  final VoidCallback onTap;

  const _CalculatorCard({required this.item, required this.onTap});

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
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
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

class _CalculatorItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _CalculatorItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
