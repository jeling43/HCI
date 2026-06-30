import 'package:flutter/material.dart';
import '../../core/navigation/navigation_provider.dart';
import '../../core/theme/app_colors.dart';

/// Landing screen displayed when the application first launches.
/// Presents four labelled entry-point cards — one per design
/// alternative plus the final combined prototype — so that a
/// reviewer can reach any prototype in a single click.
class PrototypeSelectorScreen extends StatelessWidget {
  const PrototypeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InvestigatorPalette.canvasWash,
      body: Column(
        children: [
          _SelectorHeader(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select a Design Alternative',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: InvestigatorPalette.inkDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Each card below launches a distinct prototype variant. '
                      'Choose one to begin the walkthrough, or select '
                      'the Final Prototype to explore the combined design.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: InvestigatorPalette.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _prototypeGrid(context),
                    const SizedBox(height: 40),
                    const _RouteHint(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prototypeGrid(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _PrototypeCard(
            mode: PrototypeMode.p1Wizard,
            route: '/p1',
            glyph: Icons.linear_scale,
            tagline: 'Step-by-step complaint filing guided by a structured wizard.',
            bullets: const [
              'Progress breadcrumb',
              'Evidence checklist',
              'Phase-by-phase navigation',
              'Confirmation review page',
            ],
          )),
          const SizedBox(width: 16),
          Expanded(child: _PrototypeCard(
            mode: PrototypeMode.p2Dashboard,
            route: '/p2',
            glyph: Icons.dashboard,
            tagline: 'Case-management-first view with dossier inspection.',
            bullets: const [
              'Dashboard landing',
              'Recent-cases panel',
              'Evidence status tracking',
              'Tabbed dossier inspector',
            ],
          )),
          const SizedBox(width: 16),
          Expanded(child: _PrototypeCard(
            mode: PrototypeMode.p3SmartAssist,
            route: '/p3',
            glyph: Icons.auto_awesome,
            tagline: 'Adaptive interview driven by mock AI decision support.',
            bullets: const [
              'AI-suggested questions',
              'Missing-evidence alerts',
              'Real-time auto-summary',
              'Pattern-match recommendations',
            ],
          )),
          const SizedBox(width: 16),
          Expanded(child: _PrototypeCard(
            mode: PrototypeMode.finalCombined,
            route: '/final',
            glyph: Icons.merge_type,
            tagline: 'Best ideas from all three alternatives combined.',
            bullets: const [
              'Wizard intake flow',
              'Dashboard overview',
              'Optional Smart Assistant',
              'Full navigation rail',
            ],
          )),
        ],
      ),
    );
  }
}

// ── Header bar ─────────────────────────────────────────────────────
class _SelectorHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(48, 28, 48, 20),
      decoration: const BoxDecoration(
        color: InvestigatorPalette.badgeNavy,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shield_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CCIS – Cybercrime Complaint Intake System',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Georgia Tech CS6750 · HCI Individual Project · Prototype Selector',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Prototype card ──────────────────────────────────────────────────
class _PrototypeCard extends StatefulWidget {
  final PrototypeMode mode;
  final String route;
  final IconData glyph;
  final String tagline;
  final List<String> bullets;

  const _PrototypeCard({
    required this.mode,
    required this.route,
    required this.glyph,
    required this.tagline,
    required this.bullets,
  });

  @override
  State<_PrototypeCard> createState() => _PrototypeCardState();
}

class _PrototypeCardState extends State<_PrototypeCard> {
  bool _hovered = false;

  void _launch(BuildContext context) {
    Navigator.pushNamed(context, widget.route);
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.mode.accentColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: InvestigatorPalette.cardWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? accent : InvestigatorPalette.ruleLine,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: accent.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4))]
              : [const BoxShadow(color: Color(0x0C000000), blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Coloured top band ─────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.06),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.glyph, color: accent, size: 22),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.mode.shortLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.mode.fullLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: InvestigatorPalette.inkDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.tagline,
                    style: const TextStyle(
                      fontSize: 13,
                      color: InvestigatorPalette.inkMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...widget.bullets.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(children: [
                      Icon(Icons.check_circle_outline, size: 14, color: accent),
                      const SizedBox(width: 6),
                      Text(b, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkDark)),
                    ]),
                  )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launch(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.launch, size: 18),
                      label: const Text('Launch Prototype', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Route: ${widget.route}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: InvestigatorPalette.inkFaint,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Route hint footer ────────────────────────────────────────────────
class _RouteHint extends StatelessWidget {
  const _RouteHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: InvestigatorPalette.cardWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: InvestigatorPalette.ruleLine),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 16, color: InvestigatorPalette.inkMuted),
          SizedBox(width: 8),
          Text(
            'Click any card above to launch that prototype. '
            'Use the ← Back to Selector button inside the app to return here.',
            style: TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted),
          ),
        ],
      ),
    );
  }
}
