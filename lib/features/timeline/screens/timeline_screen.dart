import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/case_model.dart';
import '../../../shared/widgets/page_header.dart';

/// Cross-dossier chronology workbench – merges every timeline
/// from every dossier into one scrollable vertical strip.
class ChronologyWorkbench extends StatefulWidget {
  const ChronologyWorkbench({super.key});

  @override
  State<ChronologyWorkbench> createState() => _ChronologyWorkbenchState();
}

class _ChronologyWorkbenchState extends State<ChronologyWorkbench> {
  String? _dossierFilter;

  @override
  Widget build(BuildContext context) {
    // Merge all chronology entries with their parent dossier reference
    final merged = <_MergedEvent>[];
    for (final d in SyntheticRecords.dossiers) {
      for (final c in d.chronology) {
        merged.add(_MergedEvent(entry: c, fileNumber: d.fileNumber, complainant: d.complainantName));
      }
    }
    merged.sort((a, b) => a.entry.occurredDate.compareTo(b.entry.occurredDate));

    final filtered = _dossierFilter == null ? merged : merged.where((e) => e.fileNumber == _dossierFilter).toList();
    final dossierNumbers = SyntheticRecords.dossiers.map((d) => d.fileNumber).toList();

    return Column(children: [
      WorkspaceBanner(title: 'Chronology Workbench', caption: '${merged.length} events across all dossiers'),
      Container(
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
        color: InvestigatorPalette.cardWhite,
        child: Row(children: [
          const Text('Filter by Dossier:', style: TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
          const SizedBox(width: 12),
          ChoiceChip(label: const Text('All'), selected: _dossierFilter == null, onSelected: (_) => setState(() => _dossierFilter = null)),
          const SizedBox(width: 8),
          ...dossierNumbers.map((fn) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(fn),
              selected: _dossierFilter == fn,
              onSelected: (_) => setState(() => _dossierFilter = fn),
              selectedColor: InvestigatorPalette.evidenceBlue.withOpacity(0.15),
            ),
          )),
        ]),
      ),
      const Divider(height: 1),
      Expanded(
        child: filtered.isEmpty
            ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.timeline, size: 48, color: InvestigatorPalette.inkFaint), const SizedBox(height: 12), const Text('No events to display', style: TextStyle(fontSize: 16, color: InvestigatorPalette.inkMuted))]))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ...filtered.asMap().entries.map((e) {
                    final idx = e.key;
                    final ev = e.value;
                    final isLast = idx == filtered.length - 1;
                    return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // vertical line
                      SizedBox(width: 48, child: Column(children: [
                        Container(width: 14, height: 14, decoration: BoxDecoration(color: InvestigatorPalette.evidenceBlue, shape: BoxShape.circle, border: Border.all(color: InvestigatorPalette.cardWhite, width: 3))),
                        if (!isLast) Expanded(child: Container(width: 2, color: InvestigatorPalette.ruleLine)),
                      ])),
                      // content
                      Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 16), child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: InvestigatorPalette.evidenceBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(ev.fileNumber, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: InvestigatorPalette.evidenceBlue)),
                          ),
                          const SizedBox(width: 8),
                          Text('${ev.entry.occurredDate.month}/${ev.entry.occurredDate.day}/${ev.entry.occurredDate.year}  ·  ${ev.entry.clockTime}', style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
                          const Spacer(),
                          Chip(label: Text(ev.entry.tag, style: const TextStyle(fontSize: 11)), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                        ]),
                        const SizedBox(height: 8),
                        Text(ev.entry.summary, style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkDark)),
                        const SizedBox(height: 4),
                        Text(ev.complainant, style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkFaint)),
                      ]))))),
                    ]));
                  }),
                ]),
              ),
      ),
    ]);
  }
}

class _MergedEvent {
  final ChronologyEntry entry;
  final String fileNumber;
  final String complainant;
  const _MergedEvent({required this.entry, required this.fileNumber, required this.complainant});
}
