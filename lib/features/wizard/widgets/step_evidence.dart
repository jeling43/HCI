import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Step 4 – checklist of artifact types plus mock upload area.
class ArtifactChecklist extends StatelessWidget {
  final Map<String, bool> manifest;
  final void Function(String key, bool val) onToggle;

  const ArtifactChecklist({super.key, required this.manifest, required this.onToggle});

  static const _glyphs = {
    'Screenshots': Icons.screenshot,
    'Emails': Icons.email,
    'Phone Records': Icons.phone,
    'Bank Statements': Icons.account_balance,
    'Receipts': Icons.receipt,
    'Chat Logs': Icons.chat,
    'Wallet Addresses': Icons.account_balance_wallet,
  };

  @override
  Widget build(BuildContext context) {
    final secured = manifest.values.where((v) => v).length;
    final total = manifest.length;
    final pct = total > 0 ? secured / total : 0.0;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Artifact Collection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 8),
      const Text('Indicate which artifact categories have been secured or are available.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
      const SizedBox(height: 24),

      // gauge bar
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
        const Icon(Icons.assessment, color: InvestigatorPalette.evidenceBlue),
        const SizedBox(width: 12),
        Text('Collection Progress: $secured of $total categories secured', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: InvestigatorPalette.inkDark)),
        const Spacer(),
        SizedBox(width: 120, child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, backgroundColor: InvestigatorPalette.ruleLine, valueColor: AlwaysStoppedAnimation<Color>(secured == total ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.evidenceBlue), minHeight: 8))),
        const SizedBox(width: 8),
        Text('${(pct * 100).toInt()}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkMuted)),
      ]))),
      const SizedBox(height: 16),

      // checkboxes
      Card(child: Padding(padding: const EdgeInsets.all(8), child: Column(
        children: manifest.entries.map((e) => CheckboxListTile(
          value: e.value, onChanged: (v) => onToggle(e.key, v ?? false),
          title: Text(e.key, style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkDark, decoration: e.value ? TextDecoration.lineThrough : null)),
          secondary: Icon(_glyphs[e.key] ?? Icons.attachment, color: e.value ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.inkFaint),
          activeColor: InvestigatorPalette.resolvedGreen,
          controlAffinity: ListTileControlAffinity.leading, dense: true,
        )).toList(),
      ))),
      const SizedBox(height: 24),

      // upload zone (mock)
      const Text('Upload Artifact Files', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 12),
      Container(
        width: double.infinity, padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(border: Border.all(color: InvestigatorPalette.ruleLine), borderRadius: BorderRadius.circular(12), color: InvestigatorPalette.cardOffWhite),
        child: Column(children: [
          Icon(Icons.cloud_upload_outlined, size: 48, color: InvestigatorPalette.inkFaint),
          const SizedBox(height: 12),
          const Text('Drag files here or click to browse', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
          const SizedBox(height: 4),
          const Text('Accepted: PDF, JPG, PNG, DOCX, XLSX (max 25 MB)', style: TextStyle(fontSize: 12, color: InvestigatorPalette.inkFaint)),
          const SizedBox(height: 16),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.folder_open, size: 18), label: const Text('Browse Files')),
        ]),
      ),
    ]);
  }
}
