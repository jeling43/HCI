import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Horizontal breadcrumb strip across the top of the wizard.
class IntakeBreadcrumb extends StatelessWidget {
  final int activeIndex;
  final int stepCount;
  final List<String> labels;
  final List<IconData> glyphs;

  const IntakeBreadcrumb({super.key, required this.activeIndex, required this.stepCount, required this.labels, required this.glyphs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: InvestigatorPalette.cardWhite,
      child: Row(
        children: List.generate(stepCount * 2 - 1, (i) {
          if (i.isOdd) {
            final seg = i ~/ 2;
            return Expanded(child: Container(height: 2, color: seg < activeIndex ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.ruleLine));
          }
          final seg = i ~/ 2;
          return _Crumb(position: seg, label: labels[seg], glyph: glyphs[seg], done: seg < activeIndex, current: seg == activeIndex);
        }),
      ),
    );
  }
}

class _Crumb extends StatelessWidget {
  final int position;
  final String label;
  final IconData glyph;
  final bool done;
  final bool current;

  const _Crumb({required this.position, required this.label, required this.glyph, required this.done, required this.current});

  @override
  Widget build(BuildContext context) {
    final tint = done ? InvestigatorPalette.resolvedGreen : current ? InvestigatorPalette.evidenceBlue : InvestigatorPalette.inkFaint;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: done ? InvestigatorPalette.resolvedGreen : current ? InvestigatorPalette.evidenceBlue : InvestigatorPalette.cardOffWhite,
          shape: BoxShape.circle,
          border: Border.all(color: tint, width: current ? 2 : 1),
        ),
        child: Center(
          child: done
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : Icon(glyph, color: current ? Colors.white : InvestigatorPalette.inkFaint, size: 18),
        ),
      ),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 11, fontWeight: current ? FontWeight.w600 : FontWeight.normal, color: current ? InvestigatorPalette.inkDark : InvestigatorPalette.inkMuted), textAlign: TextAlign.center),
    ]);
  }
}
