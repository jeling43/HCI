import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navigation_provider.dart';
import '../theme/app_colors.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/wizard/screens/wizard_screen.dart';
import '../../features/cases/screens/cases_screen.dart';
import '../../features/evidence/screens/evidence_screen.dart';
import '../../features/timeline/screens/timeline_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/smart_assistant/screens/smart_assistant_screen.dart';

/// The outermost shell: a permanent side rail on the left and a
/// content pane on the right that swaps based on the active workspace.
///
/// The shell is mode-aware: it reads [PrototypeMode] from the
/// [WorkspaceIndexNotifier] to show the correct prototype badge,
/// set the initial active pane, and optionally surface the
/// Smart Interview Assistant pane (P3 / Final modes only).
class PrimaryWorkspaceShell extends StatelessWidget {
  const PrimaryWorkspaceShell({super.key});

  /// Pane index → widget mapping.  Indices 0–6 are stable across all
  /// modes; index 7 (Smart Interview Assistant) is only reachable in
  /// p3SmartAssist and finalCombined modes.
  static List<Widget> panesFor(PrototypeMode mode) {
    final base = <Widget>[
      const InvestigatorDashboard(),       // 0
      const ComplaintIntakeWizard(),       // 1
      const CaseRegistryBrowser(),        // 2
      const EvidenceVaultScreen(),        // 3
      const ChronologyWorkbench(),        // 4
      const AnalyticsOverview(),          // 5
      const PreferencesPanel(),           // 6
    ];
    if (mode == PrototypeMode.p3SmartAssist ||
        mode == PrototypeMode.finalCombined) {
      base.add(const SmartInterviewAssistantScreen()); // 7
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceIndexNotifier>(
      builder: (context, workspace, _) {
        final panes = panesFor(workspace.mode);
        final safeIndex = workspace.activePane.clamp(0, panes.length - 1);
        return Scaffold(
          body: Row(
            children: [
              _AgencySideRail(workspace: workspace),
              const VerticalDivider(thickness: 1, width: 1, color: InvestigatorPalette.ruleLine),
              Expanded(child: panes[safeIndex]),
            ],
          ),
        );
      },
    );
  }
}

/// The dark navy rail that persists across every workspace.
class _AgencySideRail extends StatelessWidget {
  final WorkspaceIndexNotifier workspace;
  const _AgencySideRail({required this.workspace});

  @override
  Widget build(BuildContext context) {
    final railItems = WorkspaceIndexNotifier.railItemsFor(workspace.mode);
    final accent = workspace.mode.accentColor;

    return Container(
      width: 80,
      color: InvestigatorPalette.sidebarFill,
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Shield emblem
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shield_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          const Text(
            'CCIS',
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5),
          ),
          const SizedBox(height: 6),
          // ── Prototype mode badge ──────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              workspace.mode.shortLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, indent: 16, endIndent: 16),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: railItems.length,
              itemBuilder: (_, idx) {
                final dest = railItems[idx];
                return _RailIcon(
                  glyph: workspace.activePane == idx ? dest.litIcon : dest.dormantIcon,
                  caption: dest.caption,
                  isLit: workspace.activePane == idx,
                  onTap: () => workspace.jumpTo(idx),
                );
              },
            ),
          ),
          const Divider(color: Colors.white24, indent: 16, endIndent: 16),
          // ── Back to Selector ──────────────────────────────────
          _BackToSelectorButton(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  child: const Text('JD', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 4),
                const Text('J. Doe', style: TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single clickable icon+caption inside the side rail.
class _RailIcon extends StatefulWidget {
  final IconData glyph;
  final String caption;
  final bool isLit;
  final VoidCallback onTap;

  const _RailIcon({required this.glyph, required this.caption, required this.isLit, required this.onTap});

  @override
  State<_RailIcon> createState() => _RailIconState();
}

class _RailIconState extends State<_RailIcon> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: widget.isLit
                  ? Colors.white.withOpacity(0.15)
                  : _hovering
                      ? Colors.white.withOpacity(0.08)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.glyph, size: 22, color: widget.isLit ? Colors.white : InvestigatorPalette.sidebarDormant),
                const SizedBox(height: 4),
                Text(
                  widget.caption,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: widget.isLit ? FontWeight.w600 : FontWeight.normal,
                    color: widget.isLit ? Colors.white : InvestigatorPalette.sidebarDormant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small button at the bottom of the rail that navigates back to the
/// prototype selector screen, giving the reviewer a clear exit path.
class _BackToSelectorButton extends StatefulWidget {
  @override
  State<_BackToSelectorButton> createState() => _BackToSelectorButtonState();
}

class _BackToSelectorButtonState extends State<_BackToSelectorButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _hovering
                  ? Colors.white.withOpacity(0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 18, color: InvestigatorPalette.sidebarDormant),
                SizedBox(height: 4),
                Text(
                  '← Selector',
                  style: TextStyle(
                    fontSize: 9,
                    color: InvestigatorPalette.sidebarDormant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
