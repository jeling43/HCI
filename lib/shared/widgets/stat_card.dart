import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Metric tile shown on the dashboard – displays a labelled numeric value
/// with a coloured glyph. Designed to echo Azure Portal metric cards.
class MetricTile extends StatelessWidget {
  final String heading;
  final String figure;
  final IconData glyph;
  final Color tint;
  final String? footnote;

  const MetricTile({
    super.key,
    required this.heading,
    required this.figure,
    required this.glyph,
    required this.tint,
    this.footnote,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tint.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(glyph, color: tint, size: 22),
                ),
                const Spacer(),
                if (footnote != null)
                  Text(footnote!, style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkMuted)),
              ],
            ),
            const SizedBox(height: 16),
            Text(figure, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: InvestigatorPalette.inkDark)),
            const SizedBox(height: 4),
            Text(heading, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
          ],
        ),
      ),
    );
  }
}
