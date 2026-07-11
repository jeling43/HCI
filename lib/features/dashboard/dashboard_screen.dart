import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/case_model.dart';
import '../../core/navigation/navigation_provider.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/page_header.dart';

/// Landing pane – the first thing an investigator sees.
/// Combines active case cards, quick stats, and a prominent
/// New Complaint button for the demo workflow.
class InvestigatorDashboard extends StatelessWidget {
  const InvestigatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final registry = SyntheticRecords.dossiers;
    final activeCases = registry.where((d) => d.status != DossierStatus.archived).toList();
    final missingEvidence = registry.where((d) => d.artifactCompleteness < 1.0 && d.status != DossierStatus.archived).length;

    return Column(
      children: [
        WorkspaceBanner(
          title: 'Dashboard',
          caption: 'Welcome back, Det. John Doe',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Metric row ──────────────────────────────────────
                Row(children: [
                  Expanded(child: MetricTile(heading: 'Active Cases', figure: '${activeCases.length}', glyph: Icons.folder_open, tint: InvestigatorPalette.badgeNavy)),
                  const SizedBox(width: 16),
                  Expanded(child: MetricTile(heading: 'Missing Evidence', figure: '$missingEvidence', glyph: Icons.warning_amber_rounded, tint: InvestigatorPalette.cautionAmber)),
                  const SizedBox(width: 16),
                  Expanded(child: MetricTile(heading: "Today's Activity", figure: '${registry.length}', glyph: Icons.today, tint: InvestigatorPalette.evidenceBlue)),
                ]),
                const SizedBox(height: 32),

                // ── New Complaint button ────────────────────────────
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => context.read<WorkspaceIndexNotifier>().jumpTo(1),
                      icon: const Icon(Icons.add, size: 24),
                      label: const Text('+ New Complaint', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: InvestigatorPalette.badgeNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Active Cases ────────────────────────────────────
                const ZoneLabel(text: 'Active Cases'),
                Card(child: Column(
                  children: activeCases.map((d) => _CaseCard(dossier: d)).toList(),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A single case row in the dashboard list.
class _CaseCard extends StatelessWidget {
  final ComplaintDossier dossier;
  const _CaseCard({required this.dossier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: InvestigatorPalette.separatorWash))),
      child: Row(children: [
        // Case icon
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: InvestigatorPalette.evidenceBlue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.folder_outlined, color: InvestigatorPalette.evidenceBlue, size: 24),
        ),
        const SizedBox(width: 16),
        // Case details
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Case ${dossier.fileNumber}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: InvestigatorPalette.inkDark)),
          const SizedBox(height: 4),
          Text(dossier.offense.label, style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
        ])),
        // Status note
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _statusColor(dossier.status).withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _statusColor(dossier.status).withOpacity(0.3)),
          ),
          child: Text(
            dossier.statusNote ?? dossier.status.label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _statusColor(dossier.status)),
          ),
        ),
      ]),
    );
  }

  Color _statusColor(DossierStatus status) {
    switch (status) {
      case DossierStatus.open:
        return InvestigatorPalette.evidenceBlue;
      case DossierStatus.underInvestigation:
        return InvestigatorPalette.cautionAmber;
      case DossierStatus.awaitingReview:
        return InvestigatorPalette.resolvedGreen;
      case DossierStatus.archived:
        return InvestigatorPalette.inkMuted;
    }
  }
}
