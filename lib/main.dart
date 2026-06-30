import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_navigation.dart';
import 'core/navigation/navigation_provider.dart';
import 'features/selector/prototype_selector_screen.dart';

/// Entry point for the CCIS Prototype — a medium-fidelity
/// desktop prototype built for Georgia Tech CS6750.
void main() {
  runApp(const CCISPrototypeRoot());
}

/// Root-level widget that wires up theming and named routes for the
/// entire Cybercrime Complaint Intake System prototype.
///
/// Named routes:
///   /        → PrototypeSelectorScreen (landing page)
///   /p1      → Prototype 1 · Guided Intake Wizard
///   /p2      → Prototype 2 · Investigator Dashboard
///   /p3      → Prototype 3 · Smart Interview Assistant
///   /final   → Final Combined Prototype
class CCISPrototypeRoot extends StatelessWidget {
  const CCISPrototypeRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCIS – Cybercrime Complaint Intake System',
      theme: GovernmentDesignTokens.materialTheme,
      debugShowCheckedModeBanner: false,
      // ── Landing screen ──────────────────────────────────────────
      home: const PrototypeSelectorScreen(),
      // ── Named prototype routes ───────────────────────────────────
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/p1':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => ChangeNotifierProvider(
                create: (_) => WorkspaceIndexNotifier(mode: PrototypeMode.p1Wizard),
                child: const PrimaryWorkspaceShell(),
              ),
            );
          case '/p2':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => ChangeNotifierProvider(
                create: (_) => WorkspaceIndexNotifier(mode: PrototypeMode.p2Dashboard),
                child: const PrimaryWorkspaceShell(),
              ),
            );
          case '/p3':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => ChangeNotifierProvider(
                create: (_) => WorkspaceIndexNotifier(mode: PrototypeMode.p3SmartAssist),
                child: const PrimaryWorkspaceShell(),
              ),
            );
          case '/final':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => ChangeNotifierProvider(
                create: (_) => WorkspaceIndexNotifier(mode: PrototypeMode.finalCombined),
                child: const PrimaryWorkspaceShell(),
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}
