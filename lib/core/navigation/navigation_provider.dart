import 'package:flutter/material.dart';

/// Identifies which design alternative prototype is active.
/// Each value corresponds to one of the three required design
/// alternatives or the final combined prototype.
enum PrototypeMode {
  p1Wizard,
  p2SinglePage,
  p3SmartAssist,
  finalCombined,
}

/// Convenience accessors for UI display of the active prototype mode.
extension PrototypeModeDisplay on PrototypeMode {
  /// Short badge text shown inside the side rail header.
  String get shortLabel {
    switch (this) {
      case PrototypeMode.p1Wizard:      return 'P1';
      case PrototypeMode.p2SinglePage:  return 'P2';
      case PrototypeMode.p3SmartAssist: return 'P3';
      case PrototypeMode.finalCombined: return 'FINAL';
    }
  }

  /// Full prototype name shown on cards and banners.
  String get fullLabel {
    switch (this) {
      case PrototypeMode.p1Wizard:      return 'Guided Intake Wizard';
      case PrototypeMode.p2SinglePage:  return 'Single-Page Digital Intake Form';
      case PrototypeMode.p3SmartAssist: return 'Smart Interview Assistant';
      case PrototypeMode.finalCombined: return 'Final Medium-Fidelity Prototype';
    }
  }

  /// Accent colour used for the prototype badge chip in the rail.
  Color get accentColor {
    switch (this) {
      case PrototypeMode.p1Wizard:      return const Color(0xFF2563EB);
      case PrototypeMode.p2SinglePage:  return const Color(0xFF16A34A);
      case PrototypeMode.p3SmartAssist: return const Color(0xFF7C3AED);
      case PrototypeMode.finalCombined: return const Color(0xFF1B3A5C);
    }
  }

  /// The pane index that should be active when first launching this mode.
  int get initialPane {
    switch (this) {
      case PrototypeMode.p1Wizard:      return 1; // New Complaint / wizard
      case PrototypeMode.p2SinglePage:  return 0; // Single-page form
      case PrototypeMode.p3SmartAssist: return 7; // Smart Interview Assistant
      case PrototypeMode.finalCombined: return 0; // Dashboard
    }
  }
}

/// Tracks which workspace pane is active in the side rail.
/// Named "Workspace" because each rail destination opens
/// a distinct functional workspace inside the CCIS shell.
class WorkspaceIndexNotifier extends ChangeNotifier {
  final PrototypeMode mode;
  late int _activePane;

  WorkspaceIndexNotifier({this.mode = PrototypeMode.finalCombined}) {
    _activePane = mode.initialPane;
  }

  int get activePane => _activePane;

  void jumpTo(int pane) {
    if (_activePane != pane) {
      _activePane = pane;
      notifyListeners();
    }
  }

  /// Base rail destinations shared across all prototype modes.
  /// Pane indices 0–6 are stable; index 7 (Smart Assist) is added
  /// for p3SmartAssist and finalCombined modes via [railItemsFor].
  static const List<SideRailDestination> _baseRailItems = [
    SideRailDestination(dormantIcon: Icons.dashboard_outlined, litIcon: Icons.dashboard, caption: 'Dashboard'),
    SideRailDestination(dormantIcon: Icons.add_circle_outline, litIcon: Icons.add_circle, caption: 'New Complaint'),
    SideRailDestination(dormantIcon: Icons.folder_outlined, litIcon: Icons.folder, caption: 'Cases'),
    SideRailDestination(dormantIcon: Icons.attachment_outlined, litIcon: Icons.attachment, caption: 'Evidence'),
    SideRailDestination(dormantIcon: Icons.timeline_outlined, litIcon: Icons.timeline, caption: 'Timeline'),
    SideRailDestination(dormantIcon: Icons.assessment_outlined, litIcon: Icons.assessment, caption: 'Reports'),
    SideRailDestination(dormantIcon: Icons.settings_outlined, litIcon: Icons.settings, caption: 'Settings'),
  ];

  static const SideRailDestination _smartAssistItem = SideRailDestination(
    dormantIcon: Icons.auto_awesome_outlined,
    litIcon: Icons.auto_awesome,
    caption: 'Smart\nAssist',
  );

  /// Returns the rail item list appropriate for [mode].
  static List<SideRailDestination> railItemsFor(PrototypeMode mode) {
    if (mode == PrototypeMode.p3SmartAssist) {
      return [..._baseRailItems, _smartAssistItem];
    }
    return _baseRailItems;
  }
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
