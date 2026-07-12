import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/case_model.dart';
import '../../core/navigation/navigation_provider.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/page_header.dart';

/// Landing pane – the first thing an investigator sees.
/// Combines active case cards, quick stats, and a prominent
/// New Complaint button for the demo workflow.
class InvestigatorDashboard extends StatefulWidget {
  const InvestigatorDashboard({super.key});

  @override
  State<InvestigatorDashboard> createState() => _InvestigatorDashboardState();
}

class _InvestigatorDashboardState extends State<InvestigatorDashboard> {
  @override
  Widget build(BuildContext context) {
    final registry = SyntheticRecords.dossiers;
    final activeCases = registry.where((d) => d.status != DossierStatus.archived).toList();
    final missingEvidence = registry.where((d) => d.artifactCompleteness < 1.0 && d.status != DossierStatus.archived).length;

    return Column(
      children: [
        WorkspaceBanner(
          title: 'Investigator Dashboard',
          caption: 'Complaint Intake Overview · Det. John Doe',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Metric row ──────────────────────────────────────
                Row(children: [
                  Expanded(child: MetricTile(heading: 'Active Complaints', figure: '${activeCases.length}', glyph: Icons.folder_open, tint: InvestigatorPalette.badgeNavy)),
                  const SizedBox(width: 16),
                  Expanded(child: MetricTile(heading: 'Missing Evidence', figure: '$missingEvidence', glyph: Icons.warning_amber_rounded, tint: InvestigatorPalette.cautionAmber)),
                  const SizedBox(width: 16),
                  Expanded(child: MetricTile(heading: 'Total Complaints', figure: '${registry.length}', glyph: Icons.assignment, tint: InvestigatorPalette.evidenceBlue)),
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

                // ── Active Cases table ────────────────────────────
                const ZoneLabel(text: 'Complaint Registry'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(120),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(1.2),
                        3: FixedColumnWidth(100),
                        4: FixedColumnWidth(110),
                        5: FixedColumnWidth(100),
                        6: FixedColumnWidth(110),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: InvestigatorPalette.cardOffWhite),
                          children: const [
                            _TableHeader('Complaint #'),
                            _TableHeader('Complainant'),
                            _TableHeader('Crime Type'),
                            _TableHeader('Date'),
                            _TableHeader('Status'),
                            _TableHeader('Evidence'),
                            _TableHeader('Missing Info'),
                          ],
                        ),
                        ...activeCases.map((d) => TableRow(
                          children: [
                            _TableCell(d.fileNumber),
                            _TableCell(d.complainantName),
                            _TableCell(d.offense.label),
                            _TableCell(_formatDate(d.filedOn)),
                            _TableCellWidget(_StatusChip(status: d.status)),
                            _TableCellWidget(_EvidenceChip(completeness: d.artifactCompleteness)),
                            _TableCellWidget(_MissingInfoChip(completeness: d.artifactCompleteness)),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: InvestigatorPalette.inkMuted, letterSpacing: 0.5)),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(text, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkDark), overflow: TextOverflow.ellipsis),
    );
  }
}

class _TableCellWidget extends StatelessWidget {
  final Widget child;
  const _TableCellWidget(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: child,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final DossierStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(status.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Color _colorFor(DossierStatus s) {
    switch (s) {
      case DossierStatus.open: return InvestigatorPalette.evidenceBlue;
      case DossierStatus.underInvestigation: return InvestigatorPalette.cautionAmber;
      case DossierStatus.awaitingReview: return InvestigatorPalette.resolvedGreen;
      case DossierStatus.archived: return InvestigatorPalette.inkMuted;
    }
  }
}

class _EvidenceChip extends StatelessWidget {
  final double completeness;
  const _EvidenceChip({required this.completeness});

  @override
  Widget build(BuildContext context) {
    final pct = (completeness * 100).toInt();
    final color = completeness >= 1.0 ? InvestigatorPalette.resolvedGreen : completeness >= 0.5 ? InvestigatorPalette.cautionAmber : InvestigatorPalette.alertRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text('$pct%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _MissingInfoChip extends StatelessWidget {
  final double completeness;
  const _MissingInfoChip({required this.completeness});

  @override
  Widget build(BuildContext context) {
    if (completeness >= 1.0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: InvestigatorPalette.resolvedGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
        child: const Text('Complete', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: InvestigatorPalette.resolvedGreen)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: InvestigatorPalette.cautionAmber.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.warning_amber, size: 12, color: InvestigatorPalette.cautionAmber),
        const SizedBox(width: 4),
        const Text('Gaps', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: InvestigatorPalette.cautionAmber)),
      ]),
    );
  }
}
