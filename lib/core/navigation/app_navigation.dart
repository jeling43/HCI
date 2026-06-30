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

/// The outermost shell: a permanent side rail on the left and a
/// content pane on the right that swaps based on the active workspace.
class PrimaryWorkspaceShell extends StatelessWidget {
  const PrimaryWorkspaceShell({super.key});

  static const List<Widget> _panes = [
    InvestigatorDashboard(),
    ComplaintIntakeWizard(),
    CaseRegistryBrowser(),
    EvidenceVaultScreen(),
    ChronologyWorkbench(),
    AnalyticsOverview(),
    PreferencesPanel(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceIndexNotifier>(
      builder: (context, workspace, _) {
        return Scaffold(
          body: Row(
            children: [
              _AgencySideRail(workspace: workspace),
              const VerticalDivider(thickness: 1, width: 1, color: InvestigatorPalette.ruleLine),
              Expanded(child: _panes[workspace.activePane]),
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
          const SizedBox(height: 8),
          const Text(
            'CCIS',
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24, indent: 16, endIndent: 16),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: WorkspaceIndexNotifier.railItems.length,
              itemBuilder: (_, idx) {
                final dest = WorkspaceIndexNotifier.railItems[idx];
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
          Padding(
            padding: const EdgeInsets.all(12),
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
