import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════
// NHBPEP 4th Report 2004 — Boys BP Reference
// age → bp_percentile → 'sbp'/'dbp' → [ht5,ht10,ht25,ht50,ht75,ht90,ht95]
// ══════════════════════════════════════════════════════════════
const Map<int, Map<String, Map<String, List<int>>>> _bpBoys = {
  1: {
    '50th': {'sbp': [80,81,83,85,87,88,89],  'dbp': [34,35,36,37,38,39,39]},
    '90th': {'sbp': [94,95,97,99,100,102,103],'dbp': [49,50,51,52,53,53,54]},
    '95th': {'sbp': [98,99,101,103,104,106,106],'dbp':[54,54,55,56,57,58,58]},
    '99th': {'sbp': [105,106,108,110,112,113,114],'dbp':[61,62,63,64,65,66,66]},
  },
  2: {
    '50th': {'sbp': [84,85,87,88,90,92,92],  'dbp': [39,40,41,42,43,44,44]},
    '90th': {'sbp': [97,99,100,102,104,105,106],'dbp':[54,55,56,57,58,58,59]},
    '95th': {'sbp': [101,102,104,106,108,109,110],'dbp':[59,59,60,61,62,63,63]},
    '99th': {'sbp': [109,110,111,113,115,117,117],'dbp':[66,67,68,69,70,71,71]},
  },
  3: {
    '50th': {'sbp': [86,87,89,91,93,94,95],  'dbp': [44,44,45,46,47,48,48]},
    '90th': {'sbp': [100,101,103,105,107,108,109],'dbp':[59,59,60,61,62,63,63]},
    '95th': {'sbp': [104,105,107,109,110,112,113],'dbp':[63,63,64,65,66,67,67]},
    '99th': {'sbp': [111,112,114,116,118,119,120],'dbp':[71,71,72,73,74,75,75]},
  },
  4: {
    '50th': {'sbp': [88,89,91,93,95,96,97],  'dbp': [47,48,49,50,51,51,52]},
    '90th': {'sbp': [102,103,105,107,109,110,111],'dbp':[62,63,64,65,66,66,67]},
    '95th': {'sbp': [106,107,109,111,112,114,115],'dbp':[66,67,68,69,70,71,71]},
    '99th': {'sbp': [113,114,116,118,120,121,122],'dbp':[74,75,76,77,78,78,79]},
  },
  5: {
    '50th': {'sbp': [90,91,93,95,96,98,98],  'dbp': [50,51,52,53,54,55,55]},
    '90th': {'sbp': [104,105,106,108,110,111,112],'dbp':[65,66,67,68,69,69,70]},
    '95th': {'sbp': [108,109,110,112,114,115,116],'dbp':[69,70,71,72,73,74,74]},
    '99th': {'sbp': [115,116,118,120,121,123,123],'dbp':[77,78,79,80,81,81,82]},
  },
  6: {
    '50th': {'sbp': [91,92,94,96,98,99,100], 'dbp': [53,53,54,55,56,57,57]},
    '90th': {'sbp': [105,106,108,110,111,113,113],'dbp':[68,68,69,70,71,72,72]},
    '95th': {'sbp': [109,110,112,114,115,117,117],'dbp':[72,72,73,74,75,76,76]},
    '99th': {'sbp': [116,117,119,121,123,124,125],'dbp':[80,80,81,82,83,84,84]},
  },
  7: {
    '50th': {'sbp': [92,94,95,97,99,100,101], 'dbp': [55,55,56,57,58,59,59]},
    '90th': {'sbp': [106,107,109,111,113,114,115],'dbp':[70,70,71,72,73,74,74]},
    '95th': {'sbp': [110,111,113,115,117,118,119],'dbp':[74,74,75,76,77,78,78]},
    '99th': {'sbp': [117,118,120,122,124,125,126],'dbp':[82,82,83,84,85,86,86]},
  },
  8: {
    '50th': {'sbp': [94,95,97,99,100,102,102], 'dbp': [56,57,58,59,60,60,61]},
    '90th': {'sbp': [107,109,110,112,114,115,116],'dbp':[71,72,72,73,74,75,76]},
    '95th': {'sbp': [111,112,114,116,118,119,120],'dbp':[75,76,77,78,79,79,80]},
    '99th': {'sbp': [119,120,122,123,125,127,127],'dbp':[83,84,85,86,87,87,88]},
  },
  9: {
    '50th': {'sbp': [95,96,98,100,102,103,104], 'dbp': [57,58,59,60,61,61,62]},
    '90th': {'sbp': [109,110,112,114,115,117,118],'dbp':[72,73,74,75,76,76,77]},
    '95th': {'sbp': [113,114,116,118,119,121,121],'dbp':[76,77,78,79,80,81,81]},
    '99th': {'sbp': [120,121,123,125,127,128,129],'dbp':[84,85,86,87,88,88,89]},
  },
  10: {
    '50th': {'sbp': [97,98,100,102,103,105,106], 'dbp': [58,59,60,61,61,62,63]},
    '90th': {'sbp': [111,112,114,115,117,119,119],'dbp':[73,73,74,75,76,77,78]},
    '95th': {'sbp': [115,116,117,119,121,122,123],'dbp':[77,78,79,80,81,81,82]},
    '99th': {'sbp': [122,123,125,127,128,130,130],'dbp':[85,86,86,88,88,89,90]},
  },
  11: {
    '50th': {'sbp': [99,100,102,104,105,107,107], 'dbp': [59,59,60,61,62,63,63]},
    '90th': {'sbp': [113,114,115,117,119,120,121],'dbp':[74,74,75,76,77,78,78]},
    '95th': {'sbp': [117,118,119,121,123,124,125],'dbp':[78,78,79,80,81,82,82]},
    '99th': {'sbp': [124,125,127,129,130,132,132],'dbp':[86,86,87,88,89,90,90]},
  },
  12: {
    '50th': {'sbp': [101,102,104,106,108,109,110], 'dbp': [59,60,61,62,63,63,64]},
    '90th': {'sbp': [115,116,118,120,121,123,123],'dbp':[74,75,75,76,77,78,79]},
    '95th': {'sbp': [119,120,122,123,125,127,127],'dbp':[78,79,80,81,82,82,83]},
    '99th': {'sbp': [126,127,129,131,133,134,135],'dbp':[86,87,88,89,90,90,91]},
  },
  13: {
    '50th': {'sbp': [104,105,106,108,110,111,112], 'dbp': [60,60,61,62,63,64,64]},
    '90th': {'sbp': [117,118,120,122,124,125,126],'dbp':[75,75,76,77,78,79,79]},
    '95th': {'sbp': [121,122,124,126,128,129,130],'dbp':[79,79,80,81,82,83,83]},
    '99th': {'sbp': [128,130,131,133,135,136,137],'dbp':[87,87,88,89,90,91,91]},
  },
  14: {
    '50th': {'sbp': [106,107,109,111,113,114,115], 'dbp': [60,61,62,63,64,65,65]},
    '90th': {'sbp': [120,121,123,125,126,128,128],'dbp':[75,76,77,78,79,79,80]},
    '95th': {'sbp': [124,125,127,128,130,132,132],'dbp':[80,80,81,82,83,84,84]},
    '99th': {'sbp': [131,132,134,136,138,139,140],'dbp':[87,88,89,90,91,92,92]},
  },
  15: {
    '50th': {'sbp': [109,110,112,113,115,117,117], 'dbp': [61,62,63,64,65,66,66]},
    '90th': {'sbp': [122,124,125,127,129,130,131],'dbp':[76,77,78,79,80,80,81]},
    '95th': {'sbp': [126,127,129,131,133,134,135],'dbp':[81,81,82,83,84,85,85]},
    '99th': {'sbp': [134,135,136,138,140,142,142],'dbp':[88,89,90,91,92,93,93]},
  },
  16: {
    '50th': {'sbp': [111,112,114,116,118,119,120], 'dbp': [63,63,64,65,66,67,67]},
    '90th': {'sbp': [125,126,128,130,131,133,134],'dbp':[78,78,79,80,81,82,82]},
    '95th': {'sbp': [129,130,132,134,135,137,137],'dbp':[82,83,83,84,85,86,87]},
    '99th': {'sbp': [136,137,139,141,143,144,145],'dbp':[90,90,91,92,93,94,94]},
  },
  17: {
    '50th': {'sbp': [114,115,116,118,120,121,122], 'dbp': [65,66,66,67,68,69,70]},
    '90th': {'sbp': [127,128,130,132,134,135,136],'dbp':[80,80,81,82,83,84,84]},
    '95th': {'sbp': [131,132,134,136,138,139,140],'dbp':[84,85,86,87,87,88,89]},
    '99th': {'sbp': [139,140,141,143,145,146,147],'dbp':[92,93,93,94,95,96,97]},
  },
};

// ══════════════════════════════════════════════════════════════
// NHBPEP 4th Report 2004 — Girls BP Reference
// ══════════════════════════════════════════════════════════════
const Map<int, Map<String, Map<String, List<int>>>> _bpGirls = {
  1: {
    '50th': {'sbp': [83,84,85,86,88,89,90],  'dbp': [38,39,39,40,41,41,42]},
    '90th': {'sbp': [97,97,98,100,101,102,103],'dbp':[52,53,53,54,55,55,56]},
    '95th': {'sbp': [100,101,102,104,105,106,107],'dbp':[56,57,57,58,59,59,60]},
    '99th': {'sbp': [108,108,109,111,112,113,114],'dbp':[64,64,65,65,66,67,67]},
  },
  2: {
    '50th': {'sbp': [85,85,87,88,89,91,91],  'dbp': [43,44,44,45,46,46,47]},
    '90th': {'sbp': [98,99,100,101,103,104,105],'dbp':[57,58,58,59,60,61,61]},
    '95th': {'sbp': [102,103,104,105,107,108,109],'dbp':[61,62,62,63,64,65,65]},
    '99th': {'sbp': [109,110,111,112,114,115,116],'dbp':[69,69,70,70,71,72,72]},
  },
  3: {
    '50th': {'sbp': [86,87,88,89,91,92,93],  'dbp': [47,48,48,49,50,50,51]},
    '90th': {'sbp': [100,100,102,103,104,106,106],'dbp':[61,62,62,63,64,64,65]},
    '95th': {'sbp': [104,104,105,107,108,109,110],'dbp':[65,66,66,67,68,68,69]},
    '99th': {'sbp': [111,111,113,114,115,116,117],'dbp':[73,73,74,74,75,76,76]},
  },
  4: {
    '50th': {'sbp': [88,88,90,91,92,94,94],  'dbp': [50,50,51,52,52,53,54]},
    '90th': {'sbp': [101,102,103,104,106,107,108],'dbp':[64,64,65,66,67,67,68]},
    '95th': {'sbp': [105,106,107,108,110,111,112],'dbp':[68,68,69,70,71,71,72]},
    '99th': {'sbp': [112,113,114,115,117,118,119],'dbp':[76,76,76,77,78,79,79]},
  },
  5: {
    '50th': {'sbp': [89,90,91,93,94,95,96],  'dbp': [52,53,53,54,55,55,56]},
    '90th': {'sbp': [103,103,105,106,107,109,109],'dbp':[66,67,67,68,69,69,70]},
    '95th': {'sbp': [107,107,108,110,111,112,113],'dbp':[70,71,71,72,73,73,74]},
    '99th': {'sbp': [114,114,116,117,118,120,120],'dbp':[78,78,79,79,80,81,81]},
  },
  6: {
    '50th': {'sbp': [91,92,93,94,96,97,98],  'dbp': [54,54,55,56,56,57,58]},
    '90th': {'sbp': [104,105,106,108,109,110,111],'dbp':[68,68,69,70,70,71,72]},
    '95th': {'sbp': [108,109,110,111,113,114,115],'dbp':[72,72,73,74,74,75,76]},
    '99th': {'sbp': [115,116,117,119,120,121,122],'dbp':[80,80,80,81,82,83,83]},
  },
  7: {
    '50th': {'sbp': [93,93,95,96,97,99,99],  'dbp': [55,56,56,57,58,58,59]},
    '90th': {'sbp': [106,107,108,109,111,112,113],'dbp':[69,70,70,71,72,72,73]},
    '95th': {'sbp': [110,111,112,113,115,116,116],'dbp':[73,74,74,75,76,76,77]},
    '99th': {'sbp': [117,118,119,120,122,123,124],'dbp':[81,81,82,82,83,84,84]},
  },
  8: {
    '50th': {'sbp': [95,95,96,98,99,100,101], 'dbp': [57,57,57,58,59,60,60]},
    '90th': {'sbp': [108,109,110,111,113,114,114],'dbp':[71,71,71,72,73,74,74]},
    '95th': {'sbp': [112,112,114,115,116,118,118],'dbp':[75,75,75,76,77,78,78]},
    '99th': {'sbp': [119,120,121,122,123,125,125],'dbp':[82,82,83,83,84,85,86]},
  },
  9: {
    '50th': {'sbp': [96,97,98,100,101,102,103], 'dbp': [58,58,58,59,60,61,61]},
    '90th': {'sbp': [110,110,112,113,114,116,116],'dbp':[72,72,72,73,74,75,75]},
    '95th': {'sbp': [114,114,115,117,118,119,120],'dbp':[76,76,76,77,78,79,79]},
    '99th': {'sbp': [121,121,123,124,125,127,127],'dbp':[83,83,84,84,85,86,87]},
  },
  10: {
    '50th': {'sbp': [98,99,100,102,103,104,105], 'dbp': [59,59,59,60,61,62,62]},
    '90th': {'sbp': [112,112,114,115,116,118,118],'dbp':[73,73,73,74,75,76,76]},
    '95th': {'sbp': [116,116,117,119,120,121,122],'dbp':[77,77,77,78,79,80,80]},
    '99th': {'sbp': [123,123,125,126,127,129,129],'dbp':[84,84,85,86,86,87,88]},
  },
  11: {
    '50th': {'sbp': [100,101,102,103,105,106,107], 'dbp': [60,60,60,61,62,63,63]},
    '90th': {'sbp': [114,114,116,117,118,119,120],'dbp':[74,74,74,75,76,77,77]},
    '95th': {'sbp': [118,118,119,121,122,123,124],'dbp':[78,78,78,79,80,81,81]},
    '99th': {'sbp': [125,125,126,128,129,130,131],'dbp':[85,85,86,87,87,88,89]},
  },
  12: {
    '50th': {'sbp': [102,103,104,105,107,108,109], 'dbp': [61,61,61,62,63,64,64]},
    '90th': {'sbp': [116,116,117,119,120,121,122],'dbp':[75,75,75,76,77,78,78]},
    '95th': {'sbp': [119,120,121,123,124,125,126],'dbp':[79,79,79,80,81,82,82]},
    '99th': {'sbp': [127,127,128,130,131,132,133],'dbp':[86,86,87,88,88,89,90]},
  },
  13: {
    '50th': {'sbp': [104,105,106,107,109,110,110], 'dbp': [62,62,62,63,64,65,65]},
    '90th': {'sbp': [117,118,119,121,122,123,124],'dbp':[76,76,76,77,78,79,79]},
    '95th': {'sbp': [121,122,123,124,126,127,128],'dbp':[80,80,80,81,82,83,83]},
    '99th': {'sbp': [128,129,130,132,133,134,135],'dbp':[87,87,88,89,89,90,91]},
  },
  14: {
    '50th': {'sbp': [106,106,107,109,110,111,112], 'dbp': [63,63,63,64,65,66,66]},
    '90th': {'sbp': [119,120,121,122,124,125,125],'dbp':[77,77,77,78,79,80,80]},
    '95th': {'sbp': [123,123,125,126,127,129,129],'dbp':[81,81,81,82,83,84,84]},
    '99th': {'sbp': [130,131,132,133,135,136,136],'dbp':[88,88,89,90,90,91,92]},
  },
  15: {
    '50th': {'sbp': [107,108,109,110,111,113,113], 'dbp': [64,64,64,65,66,67,67]},
    '90th': {'sbp': [120,121,122,123,125,126,127],'dbp':[78,78,78,79,80,81,81]},
    '95th': {'sbp': [124,125,126,127,129,130,131],'dbp':[82,82,82,83,84,85,85]},
    '99th': {'sbp': [131,132,133,134,136,137,138],'dbp':[89,89,90,91,91,92,93]},
  },
  16: {
    '50th': {'sbp': [108,108,110,111,112,114,114], 'dbp': [64,64,65,66,66,67,68]},
    '90th': {'sbp': [121,122,123,124,126,127,128],'dbp':[78,78,79,80,81,81,82]},
    '95th': {'sbp': [125,126,127,128,130,131,132],'dbp':[82,82,83,84,85,85,86]},
    '99th': {'sbp': [132,133,134,135,137,138,139],'dbp':[90,90,90,91,92,93,93]},
  },
  17: {
    '50th': {'sbp': [108,109,110,111,113,114,115], 'dbp': [64,65,65,66,67,67,68]},
    '90th': {'sbp': [122,122,123,125,126,127,128],'dbp':[78,79,79,80,81,81,82]},
    '95th': {'sbp': [125,126,127,129,130,131,132],'dbp':[82,83,83,84,85,85,86]},
    '99th': {'sbp': [133,133,134,136,137,138,139],'dbp':[90,90,91,91,92,93,93]},
  },
};

// ══════════════════════════════════════════════════════════════
// BP CHARTS HUB SCREEN
// ══════════════════════════════════════════════════════════════

class BPChartsScreen extends StatelessWidget {
  const BPChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Blood Pressure Charts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              'Select Age Group',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Age-specific BP norms using validated reference tables',
              style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 16),
            _BPHubCard(
              icon: Icons.child_care,
              title: 'Infants',
              subtitle: 'Zubrow et al. reference\nNeonates & infants < 2 years',
              color: const Color(0xFF4F8FC0),
              comingSoon: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _BPHubCard(
              icon: Icons.monitor_heart,
              title: 'Children & Adolescents',
              subtitle: 'NHBPEP 4th Report 2004 · AAP 2017\nAges 1–17 years',
              color: const Color(0xFF26648E),
              comingSoon: false,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BPCalculator())),
            ),
          ],
        ),
      ),
    );
  }
}

class _BPHubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool comingSoon;
  final VoidCallback onTap;

  const _BPHubCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.comingSoon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: comingSoon ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: comingSoon
                      ? Colors.grey.withValues(alpha: 0.1)
                      : color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon,
                    color: comingSoon ? Colors.grey : color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: comingSoon
                                ? Colors.grey
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        if (comingSoon) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Coming Soon',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: comingSoon
                            ? Colors.grey.withValues(alpha: 0.6)
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (!comingSoon)
                Icon(Icons.chevron_right,
                    color: color.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// BP CALCULATOR — Children (AAP 2017 / NHBPEP 2004)
// ══════════════════════════════════════════════════════════════

class BPCalculator extends StatefulWidget {
  const BPCalculator({super.key});

  @override
  State<BPCalculator> createState() => _BPCalculatorState();
}

class _BPCalculatorState extends State<BPCalculator> {
  // ── Inputs ──
  bool _isBoy = true;
  int _age = 8;
  int _sbp = 100;
  int _dbp = 65;
  double _heightCm = 120.0;

  // ── Controllers ──
  final _ageCtrl = TextEditingController(text: '8');
  final _sbpCtrl = TextEditingController(text: '100');
  final _dbpCtrl = TextEditingController(text: '65');
  final _heightCtrl = TextEditingController(text: '120');

  @override
  void dispose() {
    _ageCtrl.dispose();
    _sbpCtrl.dispose();
    _dbpCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  // ── Height percentile conversion ──
  static const Map<int, double> _heightP50Boys = {1:75.7,2:87.8,3:96.1,4:102.9,5:109.2,6:115.1,7:120.6,8:125.9,9:130.9,10:135.7,11:140.4,12:145.3,13:151.8,14:158.7,15:164.9,16:168.5,17:170.6};
  static const Map<int, double> _heightP50Girls = {1:74.0,2:86.4,3:94.4,4:101.2,5:107.2,6:113.0,7:118.5,8:123.8,9:128.7,10:133.3,11:138.3,12:144.8,13:152.2,14:154.6,15:156.2,16:157.4,17:158.1};
  static const Map<int, double> _heightSDBoys = {1:2.6,2:3.1,3:3.4,4:3.7,5:4.0,6:4.3,7:4.7,8:5.1,9:5.5,10:5.9,11:6.3,12:7.3,13:8.4,14:8.5,15:7.5,16:6.5,17:6.0};
  static const Map<int, double> _heightSDGirls = {1:2.6,2:3.2,3:3.5,4:3.8,5:4.1,6:4.5,7:4.9,8:5.3,9:5.7,10:6.1,11:6.6,12:7.0,13:6.8,14:6.0,15:5.7,16:5.4,17:5.4};

  int _cmToHeightPercentileIndex(double heightCm, int age, String gender) {
    final p50 = gender == 'boy' ? (_heightP50Boys[age] ?? 120.0) : (_heightP50Girls[age] ?? 120.0);
    final sd = gender == 'boy' ? (_heightSDBoys[age] ?? 5.0) : (_heightSDGirls[age] ?? 5.0);
    final z = (heightCm - p50) / sd;
    if (z <= -1.645) return 0; // 5th
    if (z <= -1.28) return 1;  // 10th
    if (z <= -0.68) return 2;  // 25th
    if (z <= 0) return 3;      // 50th
    if (z <= 0.68) return 4;   // 75th
    if (z <= 1.28) return 5;   // 90th
    return 6;                   // 95th
  }

  String _heightPercentileLabel(int idx) {
    const labels = ['5th','10th','25th','50th','75th','90th','95th'];
    return labels[idx];
  }

  // ── Results ──
  bool _calculated = false;
  int _enteredSBP = 0;
  int _enteredDBP = 0;
  void _calculate() {
    setState(() {
      _calculated = true;
      _enteredSBP = _sbp;
      _enteredDBP = _dbp;
    });
  }

  // ── Bedside hypotension ──
  int bedsideMinSBP(int ageYears) {
    if (ageYears < 1) return 60;
    return (2 * ageYears) + 70;
  }

  bool isHypotensive(int sbp, int ageYears) => sbp < bedsideMinSBP(ageYears);

  // ── Stepper widget ──
  Widget _stepper({
    required String label,
    required int value,
    required int min,
    required int max,
    required String hint,
    required ValueChanged<int> onChanged,
    TextEditingController? controller,
  }) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface)),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: value > min ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
                onPressed: value > min ? () {
                  final newVal = value - 1;
                  onChanged(newVal);
                  controller?.text = newVal.toString();
                } : null,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: hint, isDense: true),
                  onChanged: (v) {
                    final parsed = int.tryParse(v);
                    if (parsed != null && parsed >= min && parsed <= max) {
                      onChanged(parsed);
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: value < max ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
                onPressed: value < max ? () {
                  final newVal = value + 1;
                  onChanged(newVal);
                  controller?.text = newVal.toString();
                } : null,
              ),
            ],
          ),
        ],
      );
    });
  }

  // ── Section label helper ──
  Widget _sectionLabel(String text) {
    return Builder(builder: (context) => Text(text,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface)));
  }

  // ── Build ──
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BP Calculator',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Children · AAP BP Guidelines 2017',
                style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputCard(),
            if (_calculated) ...[
              const SizedBox(height: 16),
              _buildBPResultCards(),
              const SizedBox(height: 12),
              _buildCentileStatement(),
              const SizedBox(height: 12),
              _buildHypotensionInfo(),
              const SizedBox(height: 12),
              _buildHeightPercentileInfo(),
              const SizedBox(height: 12),
              _buildReference(),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Input card ──
  Widget _buildInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) => Text('Blood Pressure Assessment',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary))),
            const SizedBox(height: 16),

            // Gender toggle
            Builder(builder: (context) => Text('Gender',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface))),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _genderBtn('👦  Boy', true)),
                Expanded(child: _genderBtn('👧  Girl', false)),
              ],
            ),
            const SizedBox(height: 16),

            _stepper(
              label: 'Age (years)',
              value: _age,
              min: 1,
              max: 17,
              hint: '1–17 years',
              controller: _ageCtrl,
              onChanged: (v) => setState(() => _age = v),
            ),
            const SizedBox(height: 16),

            _sectionLabel('Height (cm)'),
            const SizedBox(height: 6),
            Builder(builder: (context) {
              final cs = Theme.of(context).colorScheme;
              return Row(children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _heightCm > 50 ? () => setState(() {
                    _heightCm = (_heightCm - 1).clamp(50.0, 200.0);
                    _heightCtrl.text = _heightCm.toStringAsFixed(0);
                  }) : null,
                  color: _heightCm > 50 ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _heightCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Height (cm)', suffixText: 'cm', isDense: true),
                    onChanged: (v) => setState(() {
                      _heightCm = (double.tryParse(v) ?? _heightCm).clamp(50.0, 200.0);
                    }),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _heightCm < 200 ? () => setState(() {
                    _heightCm = (_heightCm + 1).clamp(50.0, 200.0);
                    _heightCtrl.text = _heightCm.toStringAsFixed(0);
                  }) : null,
                  color: _heightCm < 200 ? cs.primary : cs.onSurface.withValues(alpha: 0.3),
                ),
              ]);
            }),
            const SizedBox(height: 4),
            Builder(builder: (context) => Text(
              'Height percentile used: ${_heightPercentileLabel(_cmToHeightPercentileIndex(_heightCm, _age, _isBoy ? 'boy' : 'girl'))} for age $_age yrs',
              style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary),
            )),
            const SizedBox(height: 16),

            _stepper(
              label: 'Systolic BP (mmHg)',
              value: _sbp,
              min: 50,
              max: 200,
              hint: 'e.g. 118',
              controller: _sbpCtrl,
              onChanged: (v) => setState(() => _sbp = v),
            ),
            const SizedBox(height: 16),

            _stepper(
              label: 'Diastolic BP (mmHg)',
              value: _dbp,
              min: 30,
              max: 130,
              hint: 'e.g. 72',
              controller: _dbpCtrl,
              onChanged: (v) => setState(() => _dbp = v),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                child: const Text('Assess Blood Pressure',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderBtn(String label, bool isBoy) {
    final active = _isBoy == isBoy;
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return GestureDetector(
        onTap: () => setState(() => _isBoy = isBoy),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? cs.primary : Colors.transparent,
            border: Border.all(color: cs.primary),
            borderRadius: BorderRadius.horizontal(
              left: isBoy ? const Radius.circular(10) : Radius.zero,
              right: isBoy ? Radius.zero : const Radius.circular(10),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : cs.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      );
    });
  }

  // ── New results: two BP result boxes side by side ──────────────────────────
  Widget _buildBPResultCards() {
    final htIdx = _cmToHeightPercentileIndex(_heightCm, _age, _isBoy ? 'boy' : 'girl');
    final data = _isBoy ? _bpBoys : _bpGirls;
    final ageData = data[_age]!;
    final r90sbp = ageData['90th']!['sbp']![htIdx];
    final r95sbp = ageData['95th']!['sbp']![htIdx];
    final r99sbp = ageData['99th']!['sbp']![htIdx];
    final r90dbp = ageData['90th']!['dbp']![htIdx];
    final r95dbp = ageData['95th']!['dbp']![htIdx];
    final r99dbp = ageData['99th']!['dbp']![htIdx];

    final sbpCentile = _getCentileText(_enteredSBP, r90sbp, r95sbp, r99sbp);
    final dbpCentile = _getCentileText(_enteredDBP, r90dbp, r95dbp, r99dbp);

    return Row(
      children: [
        Expanded(child: _bpResultBox('Systolic BP', '$_enteredSBP mmHg', sbpCentile, _getBPBoxColor(sbpCentile))),
        const SizedBox(width: 12),
        Expanded(child: _bpResultBox('Diastolic BP', '$_enteredDBP mmHg', dbpCentile, _getBPBoxColor(dbpCentile))),
      ],
    );
  }

  String _getCentileText(int val, int p90, int p95, int p99) {
    if (val >= p99) return '≥99th centile';
    if (val >= p95) return '95th–99th centile';
    if (val >= p90) return '90th–95th centile';
    return '<90th centile';
  }

  Color _getBPBoxColor(String centile) {
    if (centile.contains('≥99th')) return const Color(0xFFE53935);
    if (centile.contains('95th–99th')) return const Color(0xFFF97316);
    if (centile.contains('90th–95th')) return const Color(0xFFD4820A);
    return const Color(0xFF2DBD8C);
  }

  Widget _bpResultBox(String label, String value, String centile, Color color) {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border(left: BorderSide(color: color, width: 4)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: cs.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(centile, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    });
  }

  Widget _buildCentileStatement() {
    final htIdx = _cmToHeightPercentileIndex(_heightCm, _age, _isBoy ? 'boy' : 'girl');
    final data = _isBoy ? _bpBoys : _bpGirls;
    final ageData = data[_age]!;
    final r90sbp = ageData['90th']!['sbp']![htIdx];
    final r95sbp = ageData['95th']!['sbp']![htIdx];
    final r99sbp = ageData['99th']!['sbp']![htIdx];
    final r90dbp = ageData['90th']!['dbp']![htIdx];
    final r95dbp = ageData['95th']!['dbp']![htIdx];
    final r99dbp = ageData['99th']!['dbp']![htIdx];

    final sbpCentile = _getCentileText(_enteredSBP, r90sbp, r95sbp, r99sbp);
    final dbpCentile = _getCentileText(_enteredDBP, r90dbp, r95dbp, r99dbp);

    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Centile Position', style: TextStyle(color: cs.onSurface, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('SBP is $sbpCentile', style: TextStyle(color: cs.onSurface, fontSize: 13)),
            const SizedBox(height: 4),
            Text('DBP is $dbpCentile', style: TextStyle(color: cs.onSurface, fontSize: 13)),
          ],
        ),
      );
    });
  }

  Widget _buildHypotensionInfo() {
    final htIdx = _cmToHeightPercentileIndex(_heightCm, _age, _isBoy ? 'boy' : 'girl');
    final data = _isBoy ? _bpBoys : _bpGirls;
    final ageData = data[_age]!;
    final fifth5thSBP = ageData['50th']!['sbp']![htIdx] - 15; // approximate 5th centile
    final clinicalMin = 70 + (2 * _age);
    final isHypo = _enteredSBP < fifth5thSBP || _enteredSBP < clinicalMin;

    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      const amber = Color(0xFFD4820A);
      const red = Color(0xFFE53935);
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: amber.withValues(alpha: 0.08),
              border: Border.all(color: amber.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hypotension Reference', style: TextStyle(color: amber, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Approx. 5th centile SBP (age $_age, ${_isBoy ? 'boy' : 'girl'}, ${_heightCm.toStringAsFixed(0)} cm): ~$fifth5thSBP mmHg',
                    style: TextStyle(color: cs.onSurface, fontSize: 12)),
                const SizedBox(height: 4),
                Text('Clinical minimum (70 + 2×age): $clinicalMin mmHg',
                    style: TextStyle(color: cs.onSurface, fontSize: 12)),
              ],
            ),
          ),
          if (isHypo) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: red.withValues(alpha: 0.1),
                border: Border.all(color: red.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_rounded, color: red, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('SBP below 5th centile — assess for hypotension',
                      style: TextStyle(color: red, fontSize: 13, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildHeightPercentileInfo() {
    final htIdx = _cmToHeightPercentileIndex(_heightCm, _age, _isBoy ? 'boy' : 'girl');
    final htLabel = _heightPercentileLabel(htIdx);
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Text(
        'Height ${_heightCm.toStringAsFixed(0)} cm → ~$htLabel height centile used for lookup',
        style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5), fontSize: 11),
      );
    });
  }

  Widget _buildReference() {
    return Builder(builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Flynn JT et al. AAP Clinical Practice Guideline.\nPediatrics. 2017;140(3):e20171904.\nData: NHBPEP 4th Report. Pediatrics. 2004;114(2 Suppl):555-576.',
          style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 11, height: 1.5),
        ),
      );
    });
  }
}
