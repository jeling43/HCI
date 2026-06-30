import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Labelled divider used before card groups.
class ZoneLabel extends StatelessWidget {
  final String text;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;
  final IconData? trailingGlyph;

  const ZoneLabel({super.key, required this.text, this.trailingLabel, this.onTrailingTap, this.trailingGlyph});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
          const Spacer(),
          if (trailingLabel != null)
            TextButton.icon(
              onPressed: onTrailingTap,
              icon: Icon(trailingGlyph ?? Icons.arrow_forward, size: 16),
              label: Text(trailingLabel!),
              style: TextButton.styleFrom(foregroundColor: InvestigatorPalette.evidenceBlue),
            ),
        ],
      ),
    );
  }
}
