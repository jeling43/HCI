import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/case_model.dart';

/// Step 4 – dynamic checklist of evidence types based on selected crime.
class ArtifactChecklist extends StatelessWidget {
  final Map<String, bool> manifest;
  final void Function(String key, bool val) onToggle;
  final OffenseCategory? offense;

  const ArtifactChecklist({super.key, required this.manifest, required this.onToggle, this.offense});

  static const _glyphs = {
    'Screenshots of conversations': Icons.screenshot,
    'Email messages': Icons.email,
    'Transaction receipts': Icons.receipt,
    'Bank records': Icons.account_balance,
    'Cryptocurrency wallet address': Icons.account_balance_wallet,
    'Transaction hash or ID': Icons.tag,
    'Profile or account information': Icons.badge,
    'Phone numbers': Icons.phone,
    'Website URLs': Icons.link,
    'Credit Reports': Icons.credit_score,
    'Identity Documents': Icons.badge,
    'Fraud Alerts': Icons.notification_important,
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
      const Text('Evidence Collection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 8),
      Text(
        offense != null
            ? 'Evidence checklist for ${offense!.label} — check items as they are secured.'
            : 'Indicate which evidence categories have been secured or are available.',
        style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted),
      ),
      const SizedBox(height: 24),

      // gauge bar
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
        const Icon(Icons.assessment, color: InvestigatorPalette.evidenceBlue),
        const SizedBox(width: 12),
        Text('Collection Progress: $secured of $total items secured', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: InvestigatorPalette.inkDark)),
        const Spacer(),
        SizedBox(width: 120, child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, backgroundColor: InvestigatorPalette.ruleLine, valueColor: AlwaysStoppedAnimation<Color>(secured == total ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.evidenceBlue), minHeight: 8))),
        const SizedBox(width: 8),
        Text('${(pct * 100).toInt()}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkMuted)),
      ]))),
      const SizedBox(height: 16),

      // checkboxes
      Card(child: Padding(padding: const EdgeInsets.all(8), child: Column(
        children: manifest.entries.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(children: [
            Checkbox(
              value: e.value,
              onChanged: (v) => onToggle(e.key, v ?? false),
              activeColor: InvestigatorPalette.resolvedGreen,
            ),
            Icon(_glyphs[e.key] ?? Icons.attachment, color: e.value ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.inkFaint, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(e.key, style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkDark, decoration: e.value ? TextDecoration.lineThrough : null))),
            SizedBox(
              height: 30,
              child: OutlinedButton.icon(
                onPressed: () => onToggle(e.key, true),
                icon: const Icon(Icons.upload_file, size: 14),
                label: const Text('Upload', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
              ),
            ),
          ]),
        )).toList(),
      ))),
    ]);
  }

  /// Returns the evidence items appropriate for a given offense category.
  static Map<String, bool> evidenceForOffense(OffenseCategory? offense) {
    switch (offense) {
      case OffenseCategory.cryptoFraud:
        return {'Screenshots of conversations': false, 'Email messages': false, 'Transaction receipts': false, 'Bank records': false, 'Cryptocurrency wallet address': false, 'Transaction hash or ID': false, 'Profile or account information': false, 'Phone numbers': false, 'Website URLs': false};
      case OffenseCategory.identityTheft:
        return {'Credit Reports': false, 'Identity Documents': false, 'Fraud Alerts': false, 'Bank records': false, 'Screenshots of conversations': false, 'Email messages': false};
      case OffenseCategory.romanceScam:
        return {'Screenshots of conversations': false, 'Email messages': false, 'Transaction receipts': false, 'Bank records': false, 'Cryptocurrency wallet address': false, 'Transaction hash or ID': false, 'Profile or account information': false, 'Phone numbers': false, 'Website URLs': false};
      case OffenseCategory.wireFraud:
        return {'Transaction receipts': false, 'Bank records': false, 'Email messages': false, 'Screenshots of conversations': false, 'Phone numbers': false, 'Website URLs': false};
      case OffenseCategory.accountTakeover:
        return {'Screenshots of conversations': false, 'Email messages': false, 'Profile or account information': false, 'Phone numbers': false, 'Website URLs': false, 'Bank records': false};
      default:
        return {'Screenshots of conversations': false, 'Email messages': false, 'Transaction receipts': false, 'Bank records': false, 'Profile or account information': false, 'Phone numbers': false, 'Website URLs': false};
    }
  }
}
