import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/case_model.dart';
import '../../../shared/widgets/status_badge.dart';

/// Tabbed detail view for a single dossier (Prototype 2 concept).
class DossierInspector extends StatefulWidget {
  final ComplaintDossier dossier;
  final VoidCallback onDismiss;

  const DossierInspector({super.key, required this.dossier, required this.onDismiss});

  @override
  State<DossierInspector> createState() => _DossierInspectorState();
}

class _DossierInspectorState extends State<DossierInspector> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() { super.initState(); _tabs = TabController(length: 5, vsync: this); }
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final d = widget.dossier;
    return Column(children: [
      // chrome header
      Container(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 16),
        decoration: const BoxDecoration(color: InvestigatorPalette.cardWhite, border: Border(bottom: BorderSide(color: InvestigatorPalette.ruleLine))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onDismiss, tooltip: 'Back to Registry'),
            const SizedBox(width: 8),
            Text(d.fileNumber, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: InvestigatorPalette.inkDark)),
            const SizedBox(width: 12),
            ConditionPill.forStatus(d.status),
            const SizedBox(width: 8),
            ConditionPill.forUrgency(d.urgency),
            const Spacer(),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit, size: 18), label: const Text('Edit')),
            const SizedBox(width: 8),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.print, size: 18), label: const Text('Print')),
          ]),
          const SizedBox(height: 8),
          Text('${d.offense.label}  ·  ${d.assignedInvestigator}  ·  Last touched ${d.lastTouched.month}/${d.lastTouched.day}/${d.lastTouched.year}', style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
        ]),
      ),
      Container(color: InvestigatorPalette.cardWhite, child: TabBar(controller: _tabs, tabs: const [Tab(text: 'Overview'), Tab(text: 'Artifacts'), Tab(text: 'Chronology'), Tab(text: 'Memos'), Tab(text: 'Activity')])),
      Expanded(child: TabBarView(controller: _tabs, children: [
        _OverviewPane(d: d), _ArtifactPane(items: d.artifacts), _ChronologyPane(entries: d.chronology), _MemoPane(memos: d.memos), const _ActivityPane(),
      ])),
    ]);
  }
}

// ── Overview ─────────────────────────────────────────────────────
class _OverviewPane extends StatelessWidget {
  final ComplaintDossier d;
  const _OverviewPane({required this.d});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(32), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _FieldTable(heading: 'Complainant Details', glyph: Icons.person, rows: {'Name': d.complainantName, 'Phone': d.complainantPhone, 'Email': d.complainantEmail, 'Address': d.complainantAddress, 'Occupation': d.complainantOccupation, 'Contact Pref.': d.contactPreference}),
        const SizedBox(height: 16),
        _FieldTable(heading: 'Incident Particulars', glyph: Icons.description, rows: {'Date': '${d.occurredOn.month}/${d.occurredOn.day}/${d.occurredOn.year}', 'Platform': d.digitalPlatform, 'URL': d.relatedUrl, 'Loss': '\$${d.monetaryImpact.toStringAsFixed(2)}', 'Suspect': d.suspectDetails ?? 'Unknown'}),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.notes, size: 20, color: InvestigatorPalette.badgeNavy), const SizedBox(width: 8), const Text('Narrative', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark))]),
          const SizedBox(height: 12),
          Text(d.narrative, style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkDark, height: 1.5)),
        ]))),
      ])),
      const SizedBox(width: 24),
      Expanded(flex: 2, child: Column(children: [
        // circular gauge
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Artifact Completeness', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
          const SizedBox(height: 16),
          Center(child: SizedBox(width: 100, height: 100, child: Stack(alignment: Alignment.center, children: [
            SizedBox(width: 100, height: 100, child: CircularProgressIndicator(value: d.artifactCompleteness, strokeWidth: 8, backgroundColor: InvestigatorPalette.ruleLine, valueColor: AlwaysStoppedAnimation<Color>(d.artifactCompleteness >= 1.0 ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.evidenceBlue))),
            Text('${(d.artifactCompleteness * 100).toInt()}%', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: InvestigatorPalette.inkDark)),
          ]))),
          const SizedBox(height: 16),
          Text('${d.artifacts.where((a) => a.secured).length} of ${d.artifacts.length} items secured', style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted), textAlign: TextAlign.center),
        ]))),
        const SizedBox(height: 16),
        _FieldTable(heading: 'Dossier Metadata', glyph: Icons.info_outline, rows: {'File No.': d.fileNumber, 'Investigator': d.assignedInvestigator, 'Filed': '${d.filedOn.month}/${d.filedOn.day}/${d.filedOn.year}', 'Last Touched': '${d.lastTouched.month}/${d.lastTouched.day}/${d.lastTouched.year}'}),
      ])),
    ]));
  }
}

class _FieldTable extends StatelessWidget {
  final String heading; final IconData glyph; final Map<String, String> rows;
  const _FieldTable({required this.heading, required this.glyph, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(glyph, size: 20, color: InvestigatorPalette.badgeNavy), const SizedBox(width: 8), Text(heading, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark))]),
      const SizedBox(height: 16),
      ...rows.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 140, child: Text(e.key, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted))),
        Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: InvestigatorPalette.inkDark))),
      ]))),
    ])));
  }
}

// ── Artifacts ────────────────────────────────────────────────────
class _ArtifactPane extends StatelessWidget {
  final List<ArtifactRecord> items;
  const _ArtifactPane({required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Text('Evidence Artifacts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)), const Spacer(), ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file, size: 18), label: const Text('Upload'))]),
      const SizedBox(height: 16),
      ...items.map((a) => Card(child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: (a.secured ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.cautionAmber).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(a.secured ? Icons.check_circle : Icons.pending, color: a.secured ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.cautionAmber)),
        title: Text(a.label, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(a.secured ? 'Secured ${a.securedOn != null ? "${a.securedOn!.month}/${a.securedOn!.day}/${a.securedOn!.year}" : ""}' : 'Pending', style: const TextStyle(fontSize: 12)),
        trailing: Chip(label: Text(a.kind.label, style: const TextStyle(fontSize: 12))),
      ))),
    ]));
  }
}

// ── Chronology ───────────────────────────────────────────────────
class _ChronologyPane extends StatelessWidget {
  final List<ChronologyEntry> entries;
  const _ChronologyPane({required this.entries});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Incident Chronology', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 16),
      ...entries.asMap().entries.map((e) {
        final idx = e.key; final t = e.value; final last = idx == entries.length - 1;
        return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 40, child: Column(children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: InvestigatorPalette.evidenceBlue, shape: BoxShape.circle, border: Border.all(color: InvestigatorPalette.cardWhite, width: 2))),
            if (!last) Expanded(child: Container(width: 2, color: InvestigatorPalette.ruleLine)),
          ])),
          Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 16), child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('${t.occurredDate.month}/${t.occurredDate.day}/${t.occurredDate.year}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: InvestigatorPalette.evidenceBlue)),
              const SizedBox(width: 8),
              Text(t.clockTime, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
              const Spacer(),
              Chip(label: Text(t.tag, style: const TextStyle(fontSize: 11)), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
            ]),
            const SizedBox(height: 8),
            Text(t.summary, style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkDark)),
          ]))))),
        ]));
      }),
    ]));
  }
}

// ── Memos ────────────────────────────────────────────────────────
class _MemoPane extends StatelessWidget {
  final List<InvestigatorMemo> memos;
  const _MemoPane({required this.memos});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Text('Investigator Memos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)), const Spacer(), ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 18), label: const Text('Add Memo'))]),
      const SizedBox(height: 16),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        const TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Write a memo...', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {}, child: const Text('Save'))),
      ]))),
      const SizedBox(height: 16),
      ...memos.map((m) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 14, backgroundColor: InvestigatorPalette.badgeNavy.withOpacity(0.1), child: Text(m.author.split(' ').last[0], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: InvestigatorPalette.badgeNavy))),
          const SizedBox(width: 8),
          Text(m.author, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
          const Spacer(),
          Text('${m.writtenAt.month}/${m.writtenAt.day}/${m.writtenAt.year}', style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkMuted)),
        ]),
        const SizedBox(height: 10),
        Text(m.body, style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkDark, height: 1.5)),
      ]))))),
    ]));
  }
}

// ── Activity ─────────────────────────────────────────────────────
class _ActivityPane extends StatelessWidget {
  const _ActivityPane();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Audit Trail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 16),
      Card(child: Column(children: [
        _auditRow('Dossier created', 'System', '6/23/2026 10:30'),
        _auditRow('Assigned to Det. Jane Smith', 'System', '6/23/2026 10:31'),
        _auditRow('Artifact uploaded: Spoofed Emails', 'Det. Jane Smith', '6/23/2026 11:00'),
        _auditRow('Memo appended', 'Det. Jane Smith', '6/23/2026 11:15'),
        _auditRow('Status → In Progress', 'Det. Jane Smith', '6/24/2026 09:00'),
      ])),
    ]));
  }

  Widget _auditRow(String what, String who, String when) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: InvestigatorPalette.separatorWash))),
      child: Row(children: [
        const Icon(Icons.circle, size: 8, color: InvestigatorPalette.evidenceBlue),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(what, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkDark)),
          Text(who, style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkMuted)),
        ])),
        Text(when, style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkFaint)),
      ]),
    );
  }
}
