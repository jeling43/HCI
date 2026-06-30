import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_navigation.dart';
import 'core/navigation/navigation_provider.dart';

/// Entry point for the CCIS Prototype — a medium-fidelity
/// desktop prototype built for Georgia Tech CS6750.
void main() {
  runApp(const CCISPrototypeRoot());
}

/// Root-level widget that wires up state management and theming
/// for the entire Cybercrime Complaint Intake System prototype.
class CCISPrototypeRoot extends StatelessWidget {
  const CCISPrototypeRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkspaceIndexNotifier(),
      child: MaterialApp(
        title: 'CCIS – Cybercrime Complaint Intake System',
        theme: GovernmentDesignTokens.materialTheme,
        debugShowCheckedModeBanner: false,
        home: const PrimaryWorkspaceShell(),
      ),
    );
  }
}
