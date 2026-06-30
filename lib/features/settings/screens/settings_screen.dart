import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/page_header.dart';

/// User preferences pane – theme toggle, notifications, accessibility, about.
class PreferencesPanel extends StatefulWidget {
  const PreferencesPanel({super.key});

  @override
  State<PreferencesPanel> createState() => _PreferencesPanelState();
}

class _PreferencesPanelState extends State<PreferencesPanel> {
  bool _highContrast = false;
  bool _largeText = false;
  bool _emailAlerts = true;
  bool _desktopAlerts = true;
  bool _soundAlerts = false;
  double _fontScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const WorkspaceBanner(title: 'Preferences', caption: 'Customize your CCIS workspace'),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Appearance
        _SettingsGroup(heading: 'Appearance', glyph: Icons.palette, children: [
          SwitchListTile(
            title: const Text('High-Contrast Mode'), subtitle: const Text('Increase visual distinction between elements'),
            value: _highContrast, onChanged: (v) => setState(() => _highContrast = v), activeColor: InvestigatorPalette.evidenceBlue,
          ),
          SwitchListTile(
            title: const Text('Large Text'), subtitle: const Text('Increase base font size for readability'),
            value: _largeText, onChanged: (v) => setState(() => _largeText = v), activeColor: InvestigatorPalette.evidenceBlue,
          ),
          ListTile(
            title: const Text('Font Scale'),
            subtitle: Slider(
              value: _fontScale, min: 0.8, max: 1.5, divisions: 7, label: '${_fontScale.toStringAsFixed(1)}x',
              onChanged: (v) => setState(() => _fontScale = v), activeColor: InvestigatorPalette.evidenceBlue,
            ),
          ),
        ]),
        const SizedBox(height: 24),

        // Notifications
        _SettingsGroup(heading: 'Notifications', glyph: Icons.notifications_outlined, children: [
          SwitchListTile(title: const Text('Email Notifications'), subtitle: const Text('Receive case updates via email'), value: _emailAlerts, onChanged: (v) => setState(() => _emailAlerts = v), activeColor: InvestigatorPalette.evidenceBlue),
          SwitchListTile(title: const Text('Desktop Notifications'), subtitle: const Text('Show system notifications for new assignments'), value: _desktopAlerts, onChanged: (v) => setState(() => _desktopAlerts = v), activeColor: InvestigatorPalette.evidenceBlue),
          SwitchListTile(title: const Text('Sound Alerts'), subtitle: const Text('Play a tone for critical-urgency updates'), value: _soundAlerts, onChanged: (v) => setState(() => _soundAlerts = v), activeColor: InvestigatorPalette.evidenceBlue),
        ]),
        const SizedBox(height: 24),

        // Accessibility
        _SettingsGroup(heading: 'Accessibility', glyph: Icons.accessibility_new, children: [
          const ListTile(title: Text('Keyboard Navigation'), subtitle: Text('All interactive elements are reachable via Tab / Shift+Tab'), trailing: Icon(Icons.check_circle, color: InvestigatorPalette.resolvedGreen)),
          const ListTile(title: Text('Focus Indicators'), subtitle: Text('Visible focus ring on active elements'), trailing: Icon(Icons.check_circle, color: InvestigatorPalette.resolvedGreen)),
          const ListTile(title: Text('Screen Reader Support'), subtitle: Text('Semantic labels provided for all controls'), trailing: Icon(Icons.check_circle, color: InvestigatorPalette.resolvedGreen)),
        ]),
        const SizedBox(height: 24),

        // About
        _SettingsGroup(heading: 'About CCIS', glyph: Icons.info_outline, children: [
          const ListTile(title: Text('Application'), subtitle: Text('Cybercrime Complaint Intake System (Prototype)')),
          const ListTile(title: Text('Version'), subtitle: Text('1.0.0-prototype')),
          const ListTile(title: Text('Course'), subtitle: Text('Georgia Tech CS6750 – Human-Computer Interaction')),
          const ListTile(title: Text('Framework'), subtitle: Text('Flutter 3.x (Desktop) with Material 3')),
        ]),
      ]))),
    ]);
  }
}

class _SettingsGroup extends StatelessWidget {
  final String heading;
  final IconData glyph;
  final List<Widget> children;

  const _SettingsGroup({required this.heading, required this.glyph, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 8), child: Row(children: [
        Icon(glyph, size: 20, color: InvestigatorPalette.badgeNavy),
        const SizedBox(width: 8),
        Text(heading, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      ])),
      ...children,
      const SizedBox(height: 8),
    ]));
  }
}
