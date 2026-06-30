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

  const IncidentDetailForm({super.key, required this.formKey, required this.dateCtrl, required this.platformCtrl, required this.urlCtrl, required this.narrativeCtrl, required this.lossCtrl, required this.suspectCtrl, required this.urgencyLabel, required this.onUrgencyChanged});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Incident Particulars', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 8),
      const Text('Document the specifics of the cybercrime incident.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
      const SizedBox(height: 24),
      Form(key: formKey, child: Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: TextFormField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Date of Incident *', prefixIcon: Icon(Icons.calendar_today), hintText: 'MM/DD/YYYY'))),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(controller: platformCtrl, decoration: const InputDecoration(labelText: 'Digital Platform', prefixIcon: Icon(Icons.devices)))),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextFormField(controller: urlCtrl, decoration: const InputDecoration(labelText: 'Related URL', prefixIcon: Icon(Icons.link)))),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(controller: lossCtrl, decoration: const InputDecoration(labelText: 'Monetary Impact (\$)', prefixIcon: Icon(Icons.attach_money)))),
        ]),
        const SizedBox(height: 16),
        TextFormField(controller: narrativeCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Incident Narrative *', alignLabelWithHint: true, hintText: 'Describe what occurred...')),
        const SizedBox(height: 16),
        TextFormField(controller: suspectCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Suspect Information (if known)', alignLabelWithHint: true, hintText: 'Usernames, phone numbers, wallet addresses...')),
        const SizedBox(height: 20),
        const Text('Urgency Assessment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: InvestigatorPalette.inkDark)),
        const SizedBox(height: 8),
        Row(children: ['Low', 'Medium', 'High', 'Critical'].map((u) {
          final tint = switch (u) { 'Low' => InvestigatorPalette.resolvedGreen, 'Medium' => InvestigatorPalette.cautionAmber, 'High' => InvestigatorPalette.alertRed, 'Critical' => const Color(0xFF7C2D12), _ => InvestigatorPalette.inkMuted };
          return Padding(padding: const EdgeInsets.only(right: 12), child: ChoiceChip(
            label: Text(u), selected: urgencyLabel == u, onSelected: (_) => onUrgencyChanged(u),
            selectedColor: tint.withOpacity(0.15),
            labelStyle: TextStyle(color: urgencyLabel == u ? tint : InvestigatorPalette.inkDark, fontWeight: urgencyLabel == u ? FontWeight.w600 : FontWeight.normal),
          ));
        }).toList()),
      ])))),
    ]);
  }
}
