import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Placeholder shown when a list is empty.
class HollowPlaceholder extends StatelessWidget {
  final IconData glyph;
  final String headline;
  final String? subline;
  final String? buttonLabel;
  final VoidCallback? onButton;

  const HollowPlaceholder({super.key, required this.glyph, required this.headline, this.subline, this.buttonLabel, this.onButton});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: InvestigatorPalette.badgeNavy.withOpacity(0.05), shape: BoxShape.circle),
              child: Icon(glyph, size: 48, color: InvestigatorPalette.badgeNavy.withOpacity(0.3)),
            ),
            const SizedBox(height: 20),
            Text(headline, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark), textAlign: TextAlign.center),
            if (subline != null) ...[
              const SizedBox(height: 8),
              Text(subline!, style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted), textAlign: TextAlign.center),
            ],
            if (buttonLabel != null && onButton != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(onPressed: onButton, child: Text(buttonLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
