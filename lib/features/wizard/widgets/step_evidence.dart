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
    'Screenshots': Icons.screenshot,
    'Emails': Icons.email,
    'Phone Records': Icons.phone,
    'Bank Statements': Icons.account_balance,
    'Receipts': Icons.receipt,
    'Chat Logs': Icons.chat,
    'Wallet Addresses': Icons.account_balance_wallet,
    'Wallet Address': Icons.account_balance_wallet,
    'Wire Receipt': Icons.receipt_long,
    'Coinbase Transaction ID': Icons.tag,
    'Credit Reports': Icons.credit_score,
    'Identity Documents': Icons.badge,
    'Fraud Alerts': Icons.notification_important,
    'Dating App Messages': Icons.favorite,
    'Gift Card Receipts': Icons.card_giftcard,
    'Video Call Recordings': Icons.videocam,
    'Spoofed Email Headers': Icons.alternate_email,
    'Wire Transfer Docs': Icons.send,
    'Server Logs': Icons.dns,
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
        children: manifest.entries.map((e) => CheckboxListTile(
          value: e.value, onChanged: (v) => onToggle(e.key, v ?? false),
          title: Text(e.key, style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkDark, decoration: e.value ? TextDecoration.lineThrough : null)),
          secondary: Icon(_glyphs[e.key] ?? Icons.attachment, color: e.value ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.inkFaint),
          activeColor: InvestigatorPalette.resolvedGreen,
          controlAffinity: ListTileControlAffinity.leading, dense: true,
        )).toList(),
      ))),
    ]);
  }

  /// Returns the evidence items appropriate for a given offense category.
  static Map<String, bool> evidenceForOffense(OffenseCategory? offense) {
    switch (offense) {
      case OffenseCategory.cryptoFraud:
        return {'Wallet Address': false, 'Wire Receipt': false, 'Coinbase Transaction ID': false, 'Screenshots': false};
      case OffenseCategory.identityTheft:
        return {'Credit Reports': false, 'Identity Documents': false, 'Fraud Alerts': false, 'Bank Statements': false, 'Screenshots': false};
      case OffenseCategory.onlineScam:
        return {'Screenshots': false, 'Emails': false, 'Receipts': false, 'Chat Logs': false, 'Bank Statements': false};
      case OffenseCategory.romanceScam:
        return {'Dating App Messages': false, 'Screenshots': false, 'Gift Card Receipts': false, 'Wire Receipt': false, 'Video Call Recordings': false};
      case OffenseCategory.businessEmailCompromise:
        return {'Spoofed Email Headers': false, 'Wire Transfer Docs': false, 'Server Logs': false, 'Screenshots': false};
      case OffenseCategory.socialMediaCrime:
        return {'Screenshots': false, 'Chat Logs': false, 'Phone Records': false, 'Emails': false};
      default:
        return {'Screenshots': false, 'Emails': false, 'Phone Records': false, 'Bank Statements': false, 'Receipts': false, 'Chat Logs': false, 'Wallet Addresses': false};
    }
  }
}
