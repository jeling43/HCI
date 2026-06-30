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
import '../../shared/widgets/recommendation_card.dart';

/// Landing pane – the first thing an investigator sees after login.
/// Combines metric tiles, recent dossiers, activity feed, and
/// the optional Smart-Assistant panel (Prototype 3).
class InvestigatorDashboard extends StatefulWidget {
  const InvestigatorDashboard({super.key});

  @override
  State<InvestigatorDashboard> createState() => _InvestigatorDashboardState();
}

class _InvestigatorDashboardState extends State<InvestigatorDashboard> {
  bool _assistantEngaged = true;

  @override
  Widget build(BuildContext context) {
    final registry = SyntheticRecords.dossiers;
    final openCount     = registry.where((d) => d.status == DossierStatus.open).length;
    final reviewCount   = registry.where((d) => d.status == DossierStatus.awaitingReview).length;
    final gapCount      = registry.where((d) => d.artifactCompleteness < 1.0).length;

    return Column(
      children: [
        WorkspaceBanner(
          title: 'Dashboard',
          caption: 'Welcome back, Det. John Doe',
          controls: [
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.search, size: 18), label: const Text('Search Cases')),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => context.read<WorkspaceIndexNotifier>().jumpTo(1),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Complaint'),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Metric row ──────────────────────────────────────
                Row(children: [
                  Expanded(child: MetricTile(heading: "Today's Cases", figure: '2', glyph: Icons.today, tint: InvestigatorPalette.evidenceBlue, footnote: 'June 30, 2026')),
                  const SizedBox(width: 16),
                  Expanded(child: MetricTile(heading: 'Open Cases', figure: '$openCount', glyph: Icons.folder_open, tint: InvestigatorPalette.badgeNavy)),
                  const SizedBox(width: 16),
                  Expanded(child: MetricTile(heading: 'Pending Review', figure: '$reviewCount', glyph: Icons.pending_actions, tint: InvestigatorPalette.cautionAmber)),
                  const SizedBox(width: 16),
                  Expanded(child: MetricTile(heading: 'Evidence Gaps', figure: '$gapCount', glyph: Icons.warning_amber_rounded, tint: InvestigatorPalette.alertRed)),
                ]),
                const SizedBox(height: 32),

                // ── Shortcut row ────────────────────────────────────
                const ZoneLabel(text: 'Quick Actions'),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  _ShortcutChip(glyph: Icons.add_circle_outline, caption: 'New Complaint', onTap: () => context.read<WorkspaceIndexNotifier>().jumpTo(1)),
                  _ShortcutChip(glyph: Icons.search, caption: 'Search Cases', onTap: () => context.read<WorkspaceIndexNotifier>().jumpTo(2)),
                  _ShortcutChip(glyph: Icons.upload_file, caption: 'Upload Evidence', onTap: () => context.read<WorkspaceIndexNotifier>().jumpTo(3)),
                  _ShortcutChip(glyph: Icons.description, caption: 'Generate Report', onTap: () => context.read<WorkspaceIndexNotifier>().jumpTo(5)),
                ]),
                const SizedBox(height: 32),

                // ── Two-column body ─────────────────────────────────
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Left column – dossiers + feed
                  Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const ZoneLabel(text: 'Recent Dossiers', trailingLabel: 'View All'),
                    Card(child: Column(children: registry.take(4).map((d) => _DossierRow(dossier: d)).toList())),
                    const SizedBox(height: 24),
                    const ZoneLabel(text: 'Activity Feed'),
                    Card(child: Column(children: SyntheticRecords.activityFeed.take(5).map((f) => _FeedRow(entry: f)).toList())),
                  ])),
                  const SizedBox(width: 24),

                  // Right column – Smart Assistant
                  Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.auto_awesome, size: 20, color: InvestigatorPalette.evidenceBlue),
                      const SizedBox(width: 8),
                      const Text('Smart Assistant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
                      const Spacer(),
                      Switch(value: _assistantEngaged, onChanged: (v) => setState(() => _assistantEngaged = v), activeColor: InvestigatorPalette.evidenceBlue),
                    ]),
                    const SizedBox(height: 12),
                    if (_assistantEngaged)
                      ...SyntheticRecords.insights.map((i) => Padding(padding: const EdgeInsets.only(bottom: 8), child: InsightBubble(insight: i)))
                    else
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(child: Column(children: [
                            Icon(Icons.auto_awesome, size: 32, color: InvestigatorPalette.inkFaint),
                            const SizedBox(height: 12),
                            Text('Assistant paused', style: TextStyle(color: InvestigatorPalette.inkMuted, fontSize: 14)),
                          ])),
                        ),
                      ),
                  ])),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shortcut chip ──────────────────────────────────────────────────
class _ShortcutChip extends StatefulWidget {
  final IconData glyph;
  final String caption;
  final VoidCallback onTap;

  const _ShortcutChip({required this.glyph, required this.caption, required this.onTap});

  @override
  State<_ShortcutChip> createState() => _ShortcutChipState();
}

class _ShortcutChipState extends State<_ShortcutChip> {
  bool _lit = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _lit = true),
      onExit: (_) => setState(() => _lit = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: _lit ? InvestigatorPalette.badgeNavy.withOpacity(0.05) : InvestigatorPalette.cardWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _lit ? InvestigatorPalette.badgeNavy.withOpacity(0.3) : InvestigatorPalette.ruleLine),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(widget.glyph, size: 20, color: InvestigatorPalette.badgeNavy),
            const SizedBox(width: 8),
            Text(widget.caption, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: InvestigatorPalette.inkDark)),
          ]),
        ),
      ),
    );
  }
}

// ── Dossier row ────────────────────────────────────────────────────
class _DossierRow extends StatelessWidget {
  final ComplaintDossier dossier;
  const _DossierRow({required this.dossier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: InvestigatorPalette.separatorWash))),
      child: Row(children: [
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(dossier.fileNumber, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: InvestigatorPalette.evidenceBlue)),
          const SizedBox(height: 2),
          Text(dossier.complainantName, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
        ])),
        Expanded(flex: 2, child: Text(dossier.offense.label, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkDark))),
        ConditionPill.forStatus(dossier.status),
        const SizedBox(width: 16),
        ConditionPill.forUrgency(dossier.urgency),
        const SizedBox(width: 16),
        SizedBox(width: 60, child: _CompletionGauge(ratio: dossier.artifactCompleteness)),
      ]),
    );
  }
}

class _CompletionGauge extends StatelessWidget {
  final double ratio;
  const _CompletionGauge({required this.ratio});

  @override
  Widget build(BuildContext context) {
    final tint = ratio >= 1.0 ? InvestigatorPalette.resolvedGreen : ratio >= 0.5 ? InvestigatorPalette.cautionAmber : InvestigatorPalette.alertRed;
    return Column(children: [
      Text('${(ratio * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tint)),
      const SizedBox(height: 4),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: ratio, backgroundColor: InvestigatorPalette.ruleLine, valueColor: AlwaysStoppedAnimation<Color>(tint), minHeight: 4)),
    ]);
  }
}

// ── Feed row ───────────────────────────────────────────────────────
class _FeedRow extends StatelessWidget {
  final FeedEntry entry;
  const _FeedRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final glyph = switch (entry.kind) {
      FeedEventKind.dossierCreated     => Icons.add_circle_outline,
      FeedEventKind.artifactAttached   => Icons.attachment,
      FeedEventKind.statusTransitioned => Icons.swap_horiz,
      FeedEventKind.memoAppended       => Icons.note_add,
      FeedEventKind.dossierAssigned    => Icons.person_add,
      FeedEventKind.reportExported     => Icons.description,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: InvestigatorPalette.separatorWash))),
      child: Row(children: [
        Icon(glyph, size: 18, color: InvestigatorPalette.inkMuted),
        const SizedBox(width: 12),
        Expanded(child: Text(entry.headline, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkDark))),
        Text(_relativeStamp(entry.stamp), style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkFaint)),
      ]),
    );
  }

  String _relativeStamp(DateTime dt) {
    final ref = DateTime(2026, 6, 30);
    final gap = ref.difference(dt);
    if (gap.inDays == 0) return 'Today';
    if (gap.inDays == 1) return 'Yesterday';
    if (gap.inDays < 7) return '${gap.inDays}d ago';
    return '${dt.month}/${dt.day}';
  }
}
