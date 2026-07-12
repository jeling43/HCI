import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/case_model.dart';

/// Step 1 – user selects the category of cybercrime via large tap targets.
class OffenseSelector extends StatelessWidget {
  final OffenseCategory? chosen;
  final ValueChanged<OffenseCategory> onChosen;

  const OffenseSelector({super.key, required this.chosen, required this.onChosen});

  static const _glyphs = {
    OffenseCategory.identityTheft: Icons.fingerprint,
    OffenseCategory.romanceScam: Icons.favorite,
    OffenseCategory.wireFraud: Icons.send,
    OffenseCategory.cryptoFraud: Icons.currency_bitcoin,
    OffenseCategory.accountTakeover: Icons.lock_open,
    OffenseCategory.other: Icons.more_horiz,
  };

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Select Offense Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 8),
      const Text('Choose the classification that best matches the reported incident.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
      const SizedBox(height: 24),
      GridView.count(
        crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.2,
        children: OffenseCategory.values.map((cat) {
          final lit = chosen == cat;
          return _CategoryTile(category: cat, glyph: _glyphs[cat] ?? Icons.help, lit: lit, onTap: () => onChosen(cat));
        }).toList(),
      ),
    ]);
  }
}

class _CategoryTile extends StatefulWidget {
  final OffenseCategory category;
  final IconData glyph;
  final bool lit;
  final VoidCallback onTap;

  const _CategoryTile({required this.category, required this.glyph, required this.lit, required this.onTap});

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.lit ? InvestigatorPalette.evidenceBlue.withOpacity(0.05) : _hover ? InvestigatorPalette.cardOffWhite : InvestigatorPalette.cardWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.lit ? InvestigatorPalette.evidenceBlue : _hover ? InvestigatorPalette.badgeNavyMid : InvestigatorPalette.ruleLine, width: widget.lit ? 2 : 1),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: widget.lit ? InvestigatorPalette.evidenceBlue.withOpacity(0.1) : InvestigatorPalette.cardOffWhite, borderRadius: BorderRadius.circular(10)),
              child: Icon(widget.glyph, color: widget.lit ? InvestigatorPalette.evidenceBlue : InvestigatorPalette.badgeNavy, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(widget.category.label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: widget.lit ? InvestigatorPalette.evidenceBlue : InvestigatorPalette.inkDark)),
              const SizedBox(height: 4),
              Text(widget.category.briefing, style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
            if (widget.lit) const Icon(Icons.check_circle, color: InvestigatorPalette.evidenceBlue, size: 22),
          ]),
        ),
      ),
    );
  }
}
