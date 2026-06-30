import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/case_model.dart';

/// Compact pill that renders a status or urgency label with semantic colour.
class ConditionPill extends StatelessWidget {
  final String label;
  final Color hue;

  const ConditionPill({super.key, required this.label, required this.hue});

  factory ConditionPill.forStatus(DossierStatus s) {
    final c = switch (s) {
      DossierStatus.open => InvestigatorPalette.evidenceBlue,
      DossierStatus.underInvestigation => InvestigatorPalette.cautionAmber,
      DossierStatus.awaitingReview => InvestigatorPalette.infoSky,
      DossierStatus.archived => InvestigatorPalette.resolvedGreen,
    };
    return ConditionPill(label: s.label, hue: c);
  }

  factory ConditionPill.forUrgency(UrgencyTier u) {
    final c = switch (u) {
      UrgencyTier.routine => InvestigatorPalette.resolvedGreen,
      UrgencyTier.elevated => InvestigatorPalette.cautionAmber,
      UrgencyTier.urgent => InvestigatorPalette.alertRed,
      UrgencyTier.critical => const Color(0xFF7C2D12),
    };
    return ConditionPill(label: u.label, hue: c);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: hue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: hue.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: hue)),
    );
  }
}
