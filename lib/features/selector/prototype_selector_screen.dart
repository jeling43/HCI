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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: const Text(
                          'Each card launches a distinct prototype concept. '
                          'Select P1, P2, or P3 to explore the original design '
                          'alternatives, or open the Final Medium-Fidelity '
                          'Prototype to view the design developed after evaluation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: InvestigatorPalette.inkMuted,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ProjectDescription(),
                      const SizedBox(height: 32),
                      _prototypeGrid(context),
                      const SizedBox(height: 32),
                      const _RouteHint(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prototypeGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount;
        if (width >= 1000) {
          crossAxisCount = 4;
        } else if (width >= 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        final cards = <_PrototypeCard>[
          _PrototypeCard(
            mode: PrototypeMode.p1Wizard,
            route: '/p1',
            glyph: Icons.linear_scale,
            tagline: 'Step-by-step cybercrime complaint intake using a structured, crime-specific workflow.',
            bullets: const [
              'Progress indicator',
              'Crime-specific questions',
              'Evidence checklist',
              'Review before submission',
            ],
          ),
          _PrototypeCard(
            mode: PrototypeMode.p2SinglePage,
            route: '/p2',
            glyph: Icons.article,
            tagline: 'A conventional intake form that places all complaint information on one scrollable page.',
            bullets: const [
              'All fields on one page',
              'Flexible section navigation',
              'Evidence checklist',
              'Timeline entry section',
            ],
          ),
          _PrototypeCard(
            mode: PrototypeMode.p3SmartAssist,
            route: '/p3',
            glyph: Icons.auto_awesome,
            tagline: 'A concept that provides real-time suggestions during an investigator\'s interview.',
            bullets: const [
              'Suggested follow-up questions',
              'Missing-evidence alerts',
              'Interview summary',
              'Decision support',
            ],
          ),
          _PrototypeCard(
            mode: PrototypeMode.finalCombined,
            route: '/final',
            glyph: Icons.merge_type,
            tagline: 'The preferred Guided Intake Wizard combined with an Investigator Dashboard added during the second design iteration.',
            bullets: const [
              'Guided intake workflow',
              'Crime-specific evidence checklist',
              'Timeline generation',
              'Post-intake dashboard',
            ],
          ),
        ];

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards.map((card) {
            final cardWidth = crossAxisCount == 1
                ? width
                : (width - (crossAxisCount - 1) * 16) / crossAxisCount;
            return SizedBox(
              width: cardWidth,
              child: card,
            );
          }).toList(),
        );
      },
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
          Flexible(
            child: const Column(
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
          ),
        ],
      ),
    );
  }
}

// ── Project description ───────────────────────────────────────────────
class _ProjectDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: InvestigatorPalette.cardWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: InvestigatorPalette.ruleLine),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Improving the Cybercrime Complaint Intake Process for Investigators',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: InvestigatorPalette.inkDark,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'This Flutter web prototype explores ways to improve the cybercrime '
              'complaint intake process for investigators handling reports involving '
              'fraud, identity theft, account compromise, cryptocurrency scams, and '
              'other internet-related offenses.\n\n'
              'The prototype demonstrates three original design alternatives and one '
              'final medium-fidelity design.\n\n'
              'P1, the Guided Intake Wizard, provides a structured step-by-step '
              'intake workflow.\n\n'
              'P2, the Single-Page Digital Intake Form, places all intake sections '
              'on one scrollable page.\n\n'
              'P3, the Smart Interview Assistant, demonstrates real-time interview '
              'support as a separate design concept.\n\n'
              'The Final Medium-Fidelity Prototype combines the preferred Guided '
              'Intake Wizard with an Investigator Dashboard introduced during the '
              'second design iteration.',
              style: TextStyle(
                fontSize: 13,
                color: InvestigatorPalette.inkMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Coloured top band ─────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.glyph, color: accent, size: 20),
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.mode.fullLabel,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: InvestigatorPalette.inkDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.tagline,
                    style: const TextStyle(
                      fontSize: 12,
                      color: InvestigatorPalette.inkMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.bullets.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(Icons.check_circle_outline, size: 13, color: accent),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            b,
                            style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkDark, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launch(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.launch, size: 16),
                      label: const Text('Launch Prototype', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 6),
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
          Flexible(
            child: Text(
              'Click any card above to launch that prototype. '
              'Use the ← Back to Selector button inside the app to return here.',
              style: TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted),
            ),
          ),
        ],
      ),
    );
  }
}
