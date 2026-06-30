import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/case_model.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/status_badge.dart';

/// Central evidence vault – lists all artifacts across every dossier.
class EvidenceVaultScreen extends StatefulWidget {
  const EvidenceVaultScreen({super.key});

  @override
  State<EvidenceVaultScreen> createState() => _EvidenceVaultScreenState();
}

class _EvidenceVaultScreenState extends State<EvidenceVaultScreen> {
  String _search = '';
  ArtifactKind? _kindFilter;
  bool _pendingOnly = false;

  @override
  Widget build(BuildContext context) {
    // Flatten all artifacts from all dossiers
    final allArtifacts = <_ArtifactWithDossier>[];
    for (final d in SyntheticRecords.dossiers) {
      for (final a in d.artifacts) {
        allArtifacts.add(_ArtifactWithDossier(artifact: a, fileNumber: d.fileNumber, complainant: d.complainantName));
      }
    }

    final filtered = allArtifacts.where((item) {
      if (_search.isNotEmpty && !item.artifact.label.toLowerCase().contains(_search.toLowerCase()) && !item.fileNumber.toLowerCase().contains(_search.toLowerCase())) return false;
      if (_kindFilter != null && item.artifact.kind != _kindFilter) return false;
      if (_pendingOnly && item.artifact.secured) return false;
      return true;
    }).toList();

    final securedTotal = allArtifacts.where((i) => i.artifact.secured).length;
    final pendingTotal = allArtifacts.where((i) => !i.artifact.secured).length;

    return Column(children: [
      WorkspaceBanner(title: 'Evidence Vault', caption: '${allArtifacts.length} artifacts across all dossiers', controls: [
        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file, size: 18), label: const Text('Upload Artifact')),
      ]),
      // Summary strip
      Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        color: InvestigatorPalette.cardWhite,
        child: Row(children: [
          _MiniMetric(label: 'Total', value: '${allArtifacts.length}', tint: InvestigatorPalette.badgeNavy),
          const SizedBox(width: 24),
          _MiniMetric(label: 'Secured', value: '$securedTotal', tint: InvestigatorPalette.resolvedGreen),
          const SizedBox(width: 24),
          _MiniMetric(label: 'Pending', value: '$pendingTotal', tint: InvestigatorPalette.cautionAmber),
          const SizedBox(width: 32),
          Expanded(child: TextFormField(
            decoration: const InputDecoration(hintText: 'Search artifacts...', prefixIcon: Icon(Icons.search), isDense: true),
            onChanged: (v) => setState(() => _search = v),
          )),
          const SizedBox(width: 16),
          FilterChip(
            label: const Text('Pending Only'),
            selected: _pendingOnly,
            onSelected: (v) => setState(() => _pendingOnly = v),
            selectedColor: InvestigatorPalette.cautionAmber.withOpacity(0.15),
          ),
          const SizedBox(width: 8),
          DropdownButton<ArtifactKind?>(
            value: _kindFilter,
            hint: const Text('All Types', style: TextStyle(fontSize: 13)),
            items: [const DropdownMenuItem(value: null, child: Text('All Types')), ...ArtifactKind.values.map((k) => DropdownMenuItem(value: k, child: Text(k.label)))],
            onChanged: (v) => setState(() => _kindFilter = v),
            underline: const SizedBox.shrink(),
            isDense: true,
          ),
        ]),
      ),
      const Divider(height: 1),
      Expanded(
        child: filtered.isEmpty
            ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.inventory_2_outlined, size: 48, color: InvestigatorPalette.inkFaint), const SizedBox(height: 12), const Text('No artifacts match your filters', style: TextStyle(fontSize: 16, color: InvestigatorPalette.inkMuted))]))
            : ListView.separated(
                padding: const EdgeInsets.all(32),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, idx) {
                  final item = filtered[idx];
                  return Card(child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: (item.artifact.secured ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.cautionAmber).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(item.artifact.secured ? Icons.verified : Icons.hourglass_empty, color: item.artifact.secured ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.cautionAmber),
                    ),
                    title: Text(item.artifact.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text('${item.fileNumber}  ·  ${item.complainant}', style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkMuted)),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Chip(label: Text(item.artifact.kind.label, style: const TextStyle(fontSize: 11)), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                      const SizedBox(width: 8),
                      Text(
                        item.artifact.secured ? '${item.artifact.securedOn?.month}/${item.artifact.securedOn?.day}/${item.artifact.securedOn?.year}' : 'Pending',
                        style: TextStyle(fontSize: 12, color: item.artifact.secured ? InvestigatorPalette.inkMuted : InvestigatorPalette.cautionAmber),
                      ),
                    ]),
                  ));
                },
              ),
      ),
    ]);
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color tint;
  const _MiniMetric({required this.label, required this.value, required this.tint});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: tint)),
      Text(label, style: const TextStyle(fontSize: 11, color: InvestigatorPalette.inkMuted)),
    ]);
  }
}

class _ArtifactWithDossier {
  final ArtifactRecord artifact;
  final String fileNumber;
  final String complainant;
  const _ArtifactWithDossier({required this.artifact, required this.fileNumber, required this.complainant});
}
