import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/case_model.dart';
import '../../../shared/widgets/page_header.dart';

/// Analytics overview with mock charts rendered as custom-painted bars.
class AnalyticsOverview extends StatelessWidget {
  const AnalyticsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final dossiers = SyntheticRecords.dossiers;
    // Compute simple stats
    final byOffense = <String, int>{};
    final byStatus = <String, int>{};
    for (final d in dossiers) {
      byOffense[d.offense.label] = (byOffense[d.offense.label] ?? 0) + 1;
      byStatus[d.status.label] = (byStatus[d.status.label] ?? 0) + 1;
    }

    return Column(children: [
      const WorkspaceBanner(title: 'Analytics & Reports', caption: 'Aggregate metrics for the current reporting period'),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Top metric strip
        Row(children: [
          Expanded(child: _BriefingCard(label: 'Total Dossiers', figure: '${dossiers.length}', glyph: Icons.folder, tint: InvestigatorPalette.badgeNavy)),
          const SizedBox(width: 16),
          Expanded(child: _BriefingCard(label: 'Total Monetary Impact', figure: '\$${dossiers.fold<double>(0, (s, d) => s + d.monetaryImpact).toStringAsFixed(0)}', glyph: Icons.attach_money, tint: InvestigatorPalette.alertRed)),
          const SizedBox(width: 16),
          Expanded(child: _BriefingCard(label: 'Avg. Artifact Completion', figure: '${(dossiers.fold<double>(0, (s, d) => s + d.artifactCompleteness) / dossiers.length * 100).toInt()}%', glyph: Icons.pie_chart, tint: InvestigatorPalette.evidenceBlue)),
          const SizedBox(width: 16),
          Expanded(child: _BriefingCard(label: 'Resolved', figure: '${dossiers.where((d) => d.status == DossierStatus.archived).length}', glyph: Icons.check_circle, tint: InvestigatorPalette.resolvedGreen)),
        ]),
        const SizedBox(height: 32),
        // Two chart panels
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _BarChartPanel(title: 'Dossiers by Offense Category', data: byOffense, barColor: InvestigatorPalette.evidenceBlue)),
          const SizedBox(width: 16),
          Expanded(child: _BarChartPanel(title: 'Dossiers by Status', data: byStatus, barColor: InvestigatorPalette.badgeNavy)),
        ]),
        const SizedBox(height: 24),
        // Investigator workload & evidence completion
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _BarChartPanel(title: 'Investigator Workload', data: _investigatorLoad(dossiers), barColor: InvestigatorPalette.cautionAmber)),
          const SizedBox(width: 16),
          Expanded(child: _CompletionPanel(dossiers: dossiers)),
        ]),
        const SizedBox(height: 24),
        // Export bar
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          const Icon(Icons.download, color: InvestigatorPalette.badgeNavy),
          const SizedBox(width: 12),
          const Text('Export analytics as PDF or CSV for official reporting.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkDark)),
          const Spacer(),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf, size: 18), label: const Text('Export PDF')),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.table_chart, size: 18), label: const Text('Export CSV')),
        ]))),
      ]))),
    ]);
  }

  Map<String, int> _investigatorLoad(List<ComplaintDossier> ds) {
    final m = <String, int>{};
    for (final d in ds) { m[d.assignedInvestigator] = (m[d.assignedInvestigator] ?? 0) + 1; }
    return m;
  }
}

class _BriefingCard extends StatelessWidget {
  final String label; final String figure; final IconData glyph; final Color tint;
  const _BriefingCard({required this.label, required this.figure, required this.glyph, required this.tint});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: tint.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(glyph, color: tint, size: 22)),
      const SizedBox(width: 16),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(figure, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: tint)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkMuted)),
      ]),
    ])));
  }
}

class _BarChartPanel extends StatelessWidget {
  final String title; final Map<String, int> data; final Color barColor;
  const _BarChartPanel({required this.title, required this.data, required this.barColor});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.values.fold<int>(0, (a, b) => a > b ? a : b);
    return Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 20),
      ...data.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
        SizedBox(width: 180, child: Text(e.key, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkDark))),
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: maxVal > 0 ? e.value / maxVal : 0, minHeight: 18, backgroundColor: InvestigatorPalette.canvasWash, valueColor: AlwaysStoppedAnimation<Color>(barColor.withOpacity(0.7))))),
        const SizedBox(width: 12),
        Text('${e.value}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      ]))),
    ])));
  }
}

class _CompletionPanel extends StatelessWidget {
  final List<ComplaintDossier> dossiers;
  const _CompletionPanel({required this.dossiers});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Artifact Completion by Dossier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 20),
      ...dossiers.map((d) {
        final pct = d.artifactCompleteness;
        final tint = pct >= 1.0 ? InvestigatorPalette.resolvedGreen : pct >= 0.7 ? InvestigatorPalette.evidenceBlue : InvestigatorPalette.cautionAmber;
        return Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
          SizedBox(width: 120, child: Text(d.fileNumber, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: InvestigatorPalette.evidenceBlue))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, minHeight: 14, backgroundColor: InvestigatorPalette.canvasWash, valueColor: AlwaysStoppedAnimation<Color>(tint)))),
          const SizedBox(width: 12),
          Text('${(pct * 100).toInt()}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tint)),
        ]));
      }),
    ])));
  }
}
