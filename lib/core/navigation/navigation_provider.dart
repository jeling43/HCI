import 'package:flutter/material.dart';

/// Tracks which workspace pane is active in the side rail.
/// Named "Workspace" because each rail destination opens
/// a distinct functional workspace inside the CCIS shell.
class WorkspaceIndexNotifier extends ChangeNotifier {
  int _activePane = 0;

  int get activePane => _activePane;

  void jumpTo(int pane) {
    if (_activePane != pane) {
      _activePane = pane;
      notifyListeners();
    }
  }

  /// Canonical list of workspaces shown in the side rail.
  static const List<SideRailDestination> railItems = [
    SideRailDestination(dormantIcon: Icons.dashboard_outlined, litIcon: Icons.dashboard, caption: 'Dashboard'),
    SideRailDestination(dormantIcon: Icons.add_circle_outline, litIcon: Icons.add_circle, caption: 'New Complaint'),
    SideRailDestination(dormantIcon: Icons.folder_outlined, litIcon: Icons.folder, caption: 'Cases'),
    SideRailDestination(dormantIcon: Icons.attachment_outlined, litIcon: Icons.attachment, caption: 'Evidence'),
    SideRailDestination(dormantIcon: Icons.timeline_outlined, litIcon: Icons.timeline, caption: 'Timeline'),
    SideRailDestination(dormantIcon: Icons.assessment_outlined, litIcon: Icons.assessment, caption: 'Reports'),
    SideRailDestination(dormantIcon: Icons.settings_outlined, litIcon: Icons.settings, caption: 'Settings'),
  ];
}

/// Describes a single entry in the permanent side rail.
class SideRailDestination {
  final IconData dormantIcon;
  final IconData litIcon;
  final String caption;

  const SideRailDestination({
    required this.dormantIcon,
    required this.litIcon,
    required this.caption,
  });
}
