import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Full-width strip rendered above every workspace pane.
class WorkspaceBanner extends StatelessWidget {
  final String title;
  final String? caption;
  final List<Widget>? controls;

  const WorkspaceBanner({super.key, required this.title, this.caption, this.controls});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 16),
      decoration: const BoxDecoration(
        color: InvestigatorPalette.cardWhite,
        border: Border(bottom: BorderSide(color: InvestigatorPalette.ruleLine)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: InvestigatorPalette.inkDark)),
              if (caption != null) ...[
                const SizedBox(height: 4),
                Text(caption!, style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
              ],
            ],
          ),
          const Spacer(),
          if (controls != null) ...controls!,
        ],
      ),
    );
  }
}
