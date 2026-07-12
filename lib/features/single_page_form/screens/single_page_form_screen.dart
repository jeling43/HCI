import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/case_model.dart';
import '../../../shared/widgets/page_header.dart';

/// P2 – Single-Page Digital Intake Form.
/// All complaint sections appear on one scrollable page.
class SinglePageFormScreen extends StatefulWidget {
  const SinglePageFormScreen({super.key});

  @override
  State<SinglePageFormScreen> createState() => _SinglePageFormScreenState();
}

class _SinglePageFormScreenState extends State<SinglePageFormScreen> {
  final _scrollController = ScrollController();

  // Crime type
  OffenseCategory? _selectedCrime;

  // Complainant
  final _cName = TextEditingController();
  final _cPhone = TextEditingController();
  final _cEmail = TextEditingController();
  final _cAddress = TextEditingController();
  String _contactMethod = 'Email';

  // Incident
  final _iDescription = TextEditingController();
  final _iDateContacted = TextEditingController();
  final _iDateTransaction = TextEditingController();
  final _iLoss = TextEditingController();
  final _iSuspect = TextEditingController();
  final _iPlatform = TextEditingController();
  final _iPaymentMethod = TextEditingController();
  final _iNotes = TextEditingController();

  // Evidence
  Map<String, String> _evidenceStatus = {
    'Screenshots of conversations': 'missing',
    'Email messages': 'missing',
    'Transaction receipts': 'missing',
    'Bank records': 'missing',
    'Profile or account information': 'missing',
    'Phone numbers': 'missing',
    'Website URLs': 'missing',
  };

  // Timeline
  final List<Map<String, String>> _timelineEvents = [];
  final _tlDate = TextEditingController();
  final _tlTime = TextEditingController();
  final _tlSummary = TextEditingController();

  // Notes
  final _generalNotes = TextEditingController();

  bool _submitted = false;
  String _caseNumber = '';

  @override
  void dispose() {
    _scrollController.dispose();
    for (final c in [_cName, _cPhone, _cEmail, _cAddress, _iDescription, _iDateContacted, _iDateTransaction, _iLoss, _iSuspect, _iPlatform, _iPaymentMethod, _iNotes, _tlDate, _tlTime, _tlSummary, _generalNotes]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fillSampleData() {
    setState(() {
      _selectedCrime = OffenseCategory.romanceScam;
      _cName.text = 'Jennifer Martinez';
      _cPhone.text = '(555) 867-5309';
      _cEmail.text = 'j.martinez@email.com';
      _cAddress.text = '742 Evergreen Terrace, Atlanta, GA 30308';
      _contactMethod = 'Email';
      _iDescription.text = 'I sent money to someone I met online after they claimed they needed help with an emergency.';
      _iDateContacted.text = '05/10/2026';
      _iDateTransaction.text = '06/15/2026';
      _iLoss.text = '12,500';
      _iSuspect.text = 'Alex Morgan (alias), dating profile username: heart_seeker99';
      _iPlatform.text = 'Match.com, WhatsApp';
      _iPaymentMethod.text = 'Wire transfer, Gift cards';
      _iNotes.text = 'Suspect claimed to be deployed overseas military personnel.';
      _evidenceStatus = {
        'Screenshots of conversations': 'collected',
        'Email messages': 'collected',
        'Transaction receipts': 'collected',
        'Bank records': 'missing',
        'Profile or account information': 'collected',
        'Phone numbers': 'collected',
        'Website URLs': 'notApplicable',
      };
      _timelineEvents.clear();
      _timelineEvents.addAll([
        {'date': '05/10/2026', 'time': '19:30', 'summary': 'First contact on dating platform'},
        {'date': '05/20/2026', 'time': '21:00', 'summary': 'Moved conversation to WhatsApp'},
        {'date': '06/01/2026', 'time': '14:00', 'summary': 'Suspect claimed emergency situation'},
        {'date': '06/15/2026', 'time': '10:30', 'summary': 'Wire transfer sent to suspect account'},
        {'date': '06/20/2026', 'time': '08:00', 'summary': 'Suspect became unreachable'},
      ]);
      _generalNotes.text = 'Complainant cooperated fully. Additional victims may exist on same platform.';
    });
  }

  void _submitForm() {
    final seq = DateTime.now().millisecondsSinceEpoch % 10000;
    setState(() {
      _submitted = true;
      _caseNumber = '25-${seq.toString().padLeft(6, "0")}';
    });
  }

  void _reset() {
    setState(() {
      _submitted = false;
      _caseNumber = '';
      _selectedCrime = null;
      for (final c in [_cName, _cPhone, _cEmail, _cAddress, _iDescription, _iDateContacted, _iDateTransaction, _iLoss, _iSuspect, _iPlatform, _iPaymentMethod, _iNotes, _tlDate, _tlTime, _tlSummary, _generalNotes]) {
        c.clear();
      }
      _contactMethod = 'Email';
      _evidenceStatus = {
        'Screenshots of conversations': 'missing',
        'Email messages': 'missing',
        'Transaction receipts': 'missing',
        'Bank records': 'missing',
        'Profile or account information': 'missing',
        'Phone numbers': 'missing',
        'Website URLs': 'missing',
      };
      _timelineEvents.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _confirmationView();

    return Column(
      children: [
        WorkspaceBanner(
          title: 'Single-Page Digital Intake Form',
          caption: 'All complaint sections on one scrollable page',
          controls: [
            ElevatedButton.icon(
              onPressed: _fillSampleData,
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: const Text('Fill Sample Data'),
              style: ElevatedButton.styleFrom(backgroundColor: InvestigatorPalette.evidenceBlue),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCrimeTypeSection(),
                const SizedBox(height: 32),
                _buildComplainantSection(),
                const SizedBox(height: 32),
                _buildIncidentSection(),
                const SizedBox(height: 32),
                _buildEvidenceSection(),
                const SizedBox(height: 32),
                _buildTimelineSection(),
                const SizedBox(height: 32),
                _buildNotesSection(),
                const SizedBox(height: 32),
                _buildReviewSection(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: InvestigatorPalette.evidenceBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: InvestigatorPalette.evidenceBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
      ]),
    );
  }

  Widget _buildCrimeTypeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Crime Type', Icons.category),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: OffenseCategory.values.map((cat) {
                final selected = _selectedCrime == cat;
                return ChoiceChip(
                  label: Text(cat.label),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCrime = cat),
                  selectedColor: InvestigatorPalette.evidenceBlue.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: selected ? InvestigatorPalette.evidenceBlue : InvestigatorPalette.inkDark,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplainantSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Complainant Information', Icons.person),
            Row(children: [
              Expanded(child: TextFormField(controller: _cName, decoration: const InputDecoration(labelText: 'Full Name *', prefixIcon: Icon(Icons.person_outline)))),
              const SizedBox(width: 16),
              Expanded(child: TextFormField(controller: _cPhone, decoration: const InputDecoration(labelText: 'Phone Number *', prefixIcon: Icon(Icons.phone_outlined)))),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextFormField(controller: _cEmail, decoration: const InputDecoration(labelText: 'Email Address *', prefixIcon: Icon(Icons.email_outlined)))),
              const SizedBox(width: 16),
              Expanded(child: TextFormField(controller: _cAddress, decoration: const InputDecoration(labelText: 'Physical Address', prefixIcon: Icon(Icons.location_on_outlined)))),
            ]),
            const SizedBox(height: 16),
            const Text('Preferred Contact Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: InvestigatorPalette.inkDark)),
            const SizedBox(height: 8),
            Row(children: ['Email', 'Phone', 'Mail'].map((m) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ChoiceChip(
                label: Text(m),
                selected: _contactMethod == m,
                onSelected: (_) => setState(() => _contactMethod = m),
                selectedColor: InvestigatorPalette.evidenceBlue.withOpacity(0.15),
              ),
            )).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Incident Information', Icons.description),
            TextFormField(controller: _iDescription, maxLines: 3, decoration: const InputDecoration(labelText: 'Incident Description *', alignLabelWithHint: true)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextFormField(controller: _iDateContacted, decoration: const InputDecoration(labelText: 'Date First Contacted', prefixIcon: Icon(Icons.calendar_today), hintText: 'MM/DD/YYYY'))),
              const SizedBox(width: 16),
              Expanded(child: TextFormField(controller: _iDateTransaction, decoration: const InputDecoration(labelText: 'Date of Financial Transaction', prefixIcon: Icon(Icons.calendar_today), hintText: 'MM/DD/YYYY'))),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextFormField(controller: _iLoss, decoration: const InputDecoration(labelText: 'Amount of Financial Loss (\$)', prefixIcon: Icon(Icons.attach_money)))),
              const SizedBox(width: 16),
              Expanded(child: TextFormField(controller: _iSuspect, decoration: const InputDecoration(labelText: 'Suspect Name or Username', prefixIcon: Icon(Icons.person_search)))),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextFormField(controller: _iPlatform, decoration: const InputDecoration(labelText: 'Website / Application / Platform', prefixIcon: Icon(Icons.devices)))),
              const SizedBox(width: 16),
              Expanded(child: TextFormField(controller: _iPaymentMethod, decoration: const InputDecoration(labelText: 'Payment Method', prefixIcon: Icon(Icons.payment)))),
            ]),
            const SizedBox(height: 16),
            TextFormField(controller: _iNotes, maxLines: 2, decoration: const InputDecoration(labelText: 'Additional Notes', alignLabelWithHint: true)),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceSection() {
    final collected = _evidenceStatus.values.where((v) => v == 'collected').length;
    final total = _evidenceStatus.length;
    final pct = total > 0 ? collected / total : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Evidence Collection', Icons.attachment),
            // Progress bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: InvestigatorPalette.cardOffWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                const Icon(Icons.assessment, color: InvestigatorPalette.evidenceBlue),
                const SizedBox(width: 12),
                Text('$collected of $total items collected', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const Spacer(),
                SizedBox(width: 120, child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: InvestigatorPalette.ruleLine, valueColor: AlwaysStoppedAnimation(collected == total ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.evidenceBlue)),
                )),
                const SizedBox(width: 8),
                Text('${(pct * 100).toInt()}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkMuted)),
              ]),
            ),
            const SizedBox(height: 16),
            ..._evidenceStatus.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Icon(
                  entry.value == 'collected' ? Icons.check_circle : entry.value == 'notApplicable' ? Icons.remove_circle_outline : Icons.radio_button_unchecked,
                  size: 20,
                  color: entry.value == 'collected' ? InvestigatorPalette.resolvedGreen : entry.value == 'notApplicable' ? InvestigatorPalette.inkFaint : InvestigatorPalette.cautionAmber,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(entry.key, style: const TextStyle(fontSize: 14))),
                _evidenceDropdown(entry.key, entry.value),
              ]),
            )),
          ],
        ),
      ),
    );
  }

  Widget _evidenceDropdown(String key, String value) {
    return DropdownButton<String>(
      value: value,
      underline: const SizedBox.shrink(),
      isDense: true,
      items: const [
        DropdownMenuItem(value: 'collected', child: Text('Collected', style: TextStyle(fontSize: 13))),
        DropdownMenuItem(value: 'missing', child: Text('Missing', style: TextStyle(fontSize: 13))),
        DropdownMenuItem(value: 'notApplicable', child: Text('Not Applicable', style: TextStyle(fontSize: 13))),
      ],
      onChanged: (v) {
        if (v != null) setState(() => _evidenceStatus[key] = v);
      },
    );
  }

  Widget _buildTimelineSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Timeline', Icons.timeline),
            if (_timelineEvents.isNotEmpty) ...[
              ..._timelineEvents.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: InvestigatorPalette.evidenceBlue.withOpacity(0.1),
                    child: Text('${e.key + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: InvestigatorPalette.evidenceBlue)),
                  ),
                  const SizedBox(width: 12),
                  Text('${e.value['date']} ${e.value['time']}', style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkMuted)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value['summary'] ?? '', style: const TextStyle(fontSize: 14))),
                  IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => setState(() => _timelineEvents.removeAt(e.key)), color: InvestigatorPalette.alertRed),
                ]),
              )),
              const SizedBox(height: 16),
            ],
            Row(children: [
              Expanded(child: TextFormField(controller: _tlDate, decoration: const InputDecoration(labelText: 'Date', hintText: 'MM/DD/YYYY', isDense: true))),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(controller: _tlTime, decoration: const InputDecoration(labelText: 'Time', hintText: 'HH:MM', isDense: true))),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: TextFormField(controller: _tlSummary, decoration: const InputDecoration(labelText: 'Event Summary', isDense: true))),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _addTimelineEvent, child: const Text('Add')),
            ]),
          ],
        ),
      ),
    );
  }

  void _addTimelineEvent() {
    if (_tlSummary.text.isEmpty) return;
    setState(() {
      _timelineEvents.add({'date': _tlDate.text.isNotEmpty ? _tlDate.text : 'N/A', 'time': _tlTime.text.isNotEmpty ? _tlTime.text : 'N/A', 'summary': _tlSummary.text});
      _tlDate.clear();
      _tlTime.clear();
      _tlSummary.clear();
    });
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Notes', Icons.note),
            TextFormField(controller: _generalNotes, maxLines: 4, decoration: const InputDecoration(labelText: 'General Notes', alignLabelWithHint: true, hintText: 'Any additional information relevant to this complaint...')),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    final gaps = <String>[];
    if (_selectedCrime == null) gaps.add('Crime Type');
    if (_cName.text.isEmpty) gaps.add('Complainant Name');
    if (_iDescription.text.isEmpty) gaps.add('Incident Description');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Review and Submit', Icons.check_circle),
            if (gaps.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: InvestigatorPalette.cautionAmber.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: InvestigatorPalette.cautionAmber.withOpacity(0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.warning_amber_rounded, color: InvestigatorPalette.cautionAmber, size: 20),
                  const SizedBox(width: 12),
                  Text('Missing: ${gaps.join(", ")}', style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
                ]),
              ),
              const SizedBox(height: 16),
            ],
            Center(
              child: SizedBox(
                width: 280,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text('Submit Complaint', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(backgroundColor: InvestigatorPalette.resolvedGreen),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmationView() {
    final collected = _evidenceStatus.values.where((v) => v == 'collected').length;
    final total = _evidenceStatus.length;

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: InvestigatorPalette.resolvedGreen.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, size: 64, color: InvestigatorPalette.resolvedGreen),
            ),
            const SizedBox(height: 24),
            const Text('Complaint Successfully Submitted', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: InvestigatorPalette.inkDark)),
            const SizedBox(height: 16),
            Text('Case Number: $_caseNumber', style: const TextStyle(fontSize: 20, color: InvestigatorPalette.evidenceBlue, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text('Complainant: ${_cName.text}', style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
            Text('Crime Type: ${_selectedCrime?.label ?? "Not specified"}', style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
            Text('Evidence: $collected of $total items collected', style: const TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Start New Complaint'),
            ),
          ]),
        ),
      ),
    );
  }
}
