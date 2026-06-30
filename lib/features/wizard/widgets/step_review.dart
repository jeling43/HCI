import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/case_model.dart';

/// Step 6 – read-only summary of all wizard data with completeness gauge.
class IntakeSummary extends StatelessWidget {
  final OffenseCategory? offense;
  final String complainantName;
  final String complainantEmail;
  final String complainantPhone;
  final String incidentDate;
  final String platform;
  final String narrative;
  final String monetaryImpact;
  final String urgencyLabel;
  final Map<String, bool> artifactManifest;
  final List<Map<String, String>> chronologyRows;

  const IntakeSummary({super.key, required this.offense, required this.complainantName, required this.complainantEmail, required this.complainantPhone, required this.incidentDate, required this.platform, required this.narrative, required this.monetaryImpact, required this.urgencyLabel, required this.artifactManifest, required this.chronologyRows});

  @override
  Widget build(BuildContext context) {
    final gaps = <String>[];
    if (complainantName.isEmpty) gaps.add('Complainant Name');
    if (complainantPhone.isEmpty) gaps.add('Phone');
    if (complainantEmail.isEmpty) gaps.add('Email');
    if (incidentDate.isEmpty) gaps.add('Incident Date');
    if (narrative.isEmpty) gaps.add('Narrative');

    final securedCount = artifactManifest.values.where((v) => v).length;
    final totalArtifacts = artifactManifest.length;
    final pctArtifacts = totalArtifacts > 0 ? ((securedCount / totalArtifacts) * 100).toInt() : 0;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Review & Submit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 8),
      const Text('Verify all information before filing the complaint.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
      const SizedBox(height: 24),

      // gap warning
      if (gaps.isNotEmpty) ...[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: InvestigatorPalette.cautionAmber.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: InvestigatorPalette.cautionAmber.withOpacity(0.3))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.warning_amber_rounded, color: InvestigatorPalette.cautionAmber),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Incomplete Fields', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
              const SizedBox(height: 4),
              Text('The following fields are blank: ${gaps.join(", ")}', style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
            ])),
          ]),
        ),
        const SizedBox(height: 16),
      ],

      // completion gauge
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Intake Completeness', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
            value: _completeness(), backgroundColor: InvestigatorPalette.ruleLine,
            valueColor: AlwaysStoppedAnimation<Color>(_completeness() >= 0.8 ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.cautionAmber), minHeight: 8,
          )),
        ])),
        const SizedBox(width: 16),
        Text('${(_completeness() * 100).toInt()}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: InvestigatorPalette.inkDark)),
      ]))),
      const SizedBox(height: 16),

      // detail panels
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _SummaryBlock(heading: 'Offense Classification', glyph: Icons.category, pairs: [
          _KV('Category', offense?.label ?? 'Not selected'),
          _KV('Urgency', urgencyLabel),
        ])),
        const SizedBox(width: 16),
        Expanded(child: _SummaryBlock(heading: 'Complainant', glyph: Icons.person, pairs: [
          _KV('Name', complainantName.isEmpty ? '—' : complainantName),
          _KV('Phone', complainantPhone.isEmpty ? '—' : complainantPhone),
          _KV('Email', complainantEmail.isEmpty ? '—' : complainantEmail),
        ])),
      ]),
      const SizedBox(height: 16),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _SummaryBlock(heading: 'Incident Particulars', glyph: Icons.description, pairs: [
          _KV('Date', incidentDate.isEmpty ? '—' : incidentDate),
          _KV('Platform', platform.isEmpty ? '—' : platform),
          _KV('Loss', monetaryImpact.isEmpty ? '—' : '\$$monetaryImpact'),
          _KV('Narrative', narrative.isEmpty ? '—' : (narrative.length > 80 ? '${narrative.substring(0, 80)}...' : narrative)),
        ])),
        const SizedBox(width: 16),
        Expanded(child: _SummaryBlock(heading: 'Artifacts & Chronology', glyph: Icons.attachment, pairs: [
          _KV('Artifacts Secured', '$securedCount of $totalArtifacts ($pctArtifacts%)'),
          _KV('Chronology Events', '${chronologyRows.length}'),
        ])),
      ]),
    ]);
  }

  double _completeness() {
    int filled = 0; const total = 6;
    if (offense != null) filled++;
    if (complainantName.isNotEmpty) filled++;
    if (complainantEmail.isNotEmpty || complainantPhone.isNotEmpty) filled++;
    if (incidentDate.isNotEmpty) filled++;
    if (narrative.isNotEmpty) filled++;
    if (artifactManifest.values.any((v) => v)) filled++;
    return filled / total;
  }
}

class _KV { final String k; final String v; const _KV(this.k, this.v); }

class _SummaryBlock extends StatelessWidget {
  final String heading;
  final IconData glyph;
  final List<_KV> pairs;

  const _SummaryBlock({required this.heading, required this.glyph, required this.pairs});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(glyph, size: 20, color: InvestigatorPalette.badgeNavy),
        const SizedBox(width: 8),
        Text(heading, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      ]),
      const SizedBox(height: 16),
      ...pairs.map((p) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 120, child: Text(p.k, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted))),
        Expanded(child: Text(p.v, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: p.v == '—' ? InvestigatorPalette.inkFaint : InvestigatorPalette.inkDark))),
      ]))),
    ])));
  }
}
