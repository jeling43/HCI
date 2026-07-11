import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Step 3 – captures incident specifics: date, platform, loss, suspect data.
class IncidentDetailForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController dateCtrl;
  final TextEditingController platformCtrl;
  final TextEditingController urlCtrl;
  final TextEditingController narrativeCtrl;
  final TextEditingController lossCtrl;
  final TextEditingController suspectCtrl;
  final String urgencyLabel;
  final ValueChanged<String> onUrgencyChanged;
  final VoidCallback onLoadExample;

  const IncidentDetailForm({super.key, required this.formKey, required this.dateCtrl, required this.platformCtrl, required this.urlCtrl, required this.narrativeCtrl, required this.lossCtrl, required this.suspectCtrl, required this.urgencyLabel, required this.onUrgencyChanged, required this.onLoadExample});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Incident Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
          SizedBox(height: 8),
          Text('Document the specifics of the cybercrime incident.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
        ])),
        ElevatedButton.icon(
          onPressed: onLoadExample,
          icon: const Icon(Icons.file_download_outlined, size: 18),
          label: const Text('Load Example Incident'),
          style: ElevatedButton.styleFrom(backgroundColor: InvestigatorPalette.evidenceBlue),
        ),
      ]),
      const SizedBox(height: 24),
      Form(key: formKey, child: Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: TextFormField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Date of Incident *', prefixIcon: Icon(Icons.calendar_today), hintText: 'MM/DD/YYYY'))),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(controller: platformCtrl, decoration: const InputDecoration(labelText: 'Digital Platform', prefixIcon: Icon(Icons.devices)))),
        ]),
        const SizedBox(height: 16),
        TextFormField(controller: narrativeCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Incident Narrative *', alignLabelWithHint: true, hintText: 'Describe what occurred...')),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextFormField(controller: lossCtrl, decoration: const InputDecoration(labelText: 'Financial Loss (\$)', prefixIcon: Icon(Icons.attach_money)))),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(controller: suspectCtrl, decoration: const InputDecoration(labelText: 'Suspect Name / Info (if known)', prefixIcon: Icon(Icons.person_search)))),
        ]),
      ])))),
    ]);
  }
}
