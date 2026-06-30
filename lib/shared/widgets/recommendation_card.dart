import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/case_model.dart';

/// Card surfaced by the Smart Assistant panel (Prototype 3 concept).
class InsightBubble extends StatelessWidget {
  final InsightCard insight;

  const InsightBubble({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final (glyph, tint) = switch (insight.severity) {
      InsightSeverity.gapAlert   => (Icons.warning_amber_rounded, InvestigatorPalette.cautionAmber),
      InsightSeverity.followUp   => (Icons.help_outline,          InvestigatorPalette.evidenceBlue),
      InsightSeverity.tip        => (Icons.lightbulb_outline,     InvestigatorPalette.infoSky),
      InsightSeverity.urgentFlag => (Icons.error_outline,         InvestigatorPalette.alertRed),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: tint.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(glyph, color: tint, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(insight.heading, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
                  const SizedBox(height: 4),
                  Text(insight.detail, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
                ],
              ),
            ),
            IconButton(icon: const Icon(Icons.close, size: 16), onPressed: () {}, tooltip: 'Dismiss', splashRadius: 16, color: InvestigatorPalette.inkFaint),
          ],
        ),
      ),
    );
  }
}
