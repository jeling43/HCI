import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Step 2 – collects complainant demographic and contact data.
class ComplainantForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController occupationCtrl;
  final String contactMethod;
  final ValueChanged<String> onContactMethodChanged;

  const ComplainantForm({super.key, required this.formKey, required this.nameCtrl, required this.phoneCtrl, required this.emailCtrl, required this.addressCtrl, required this.occupationCtrl, required this.contactMethod, required this.onContactMethodChanged});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Complainant Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 8),
      const Text('Record the complainant\'s contact and personal details.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
      const SizedBox(height: 24),
      Form(
        key: formKey,
        child: Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *', prefixIcon: Icon(Icons.person_outline)))),
            const SizedBox(width: 16),
            Expanded(child: TextFormField(controller: occupationCtrl, decoration: const InputDecoration(labelText: 'Occupation', prefixIcon: Icon(Icons.work_outline)))),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: TextFormField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number *', prefixIcon: Icon(Icons.phone_outlined)))),
            const SizedBox(width: 16),
            Expanded(child: TextFormField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Address *', prefixIcon: Icon(Icons.email_outlined)))),
          ]),
          const SizedBox(height: 16),
          TextFormField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Mailing Address', prefixIcon: Icon(Icons.location_on_outlined))),
          const SizedBox(height: 20),
          const Text('Preferred Contact Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: InvestigatorPalette.inkDark)),
          const SizedBox(height: 8),
          Row(children: ['Email', 'Phone', 'Mail'].map((m) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ChoiceChip(
              label: Text(m),
              selected: contactMethod == m,
              onSelected: (_) => onContactMethodChanged(m),
              selectedColor: InvestigatorPalette.evidenceBlue.withOpacity(0.15),
              labelStyle: TextStyle(color: contactMethod == m ? InvestigatorPalette.evidenceBlue : InvestigatorPalette.inkDark, fontWeight: contactMethod == m ? FontWeight.w600 : FontWeight.normal),
            ),
          )).toList()),
        ]))),
      ),
    ]);
  }
}
