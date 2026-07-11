import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/case_model.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/navigation/navigation_provider.dart';
import '../../../shared/widgets/page_header.dart';
import '../widgets/wizard_progress.dart';
import '../widgets/step_complaint_type.dart';
import '../widgets/step_victim_info.dart';
import '../widgets/step_incident_info.dart';
import '../widgets/step_evidence.dart';
import '../widgets/step_timeline.dart';
import '../widgets/step_review.dart';

/// The six-step guided intake wizard (Prototype 1 concept).
class ComplaintIntakeWizard extends StatefulWidget {
  const ComplaintIntakeWizard({super.key});

  @override
  State<ComplaintIntakeWizard> createState() => _ComplaintIntakeWizardState();
}

class _ComplaintIntakeWizardState extends State<ComplaintIntakeWizard> {
  int _phase = 0;
  static const int _phaseCount = 6;

  OffenseCategory? _chosenOffense;
  final _complainantKey = GlobalKey<FormState>();
  final _incidentKey = GlobalKey<FormState>();

  // complainant fields
  final _cName = TextEditingController();
  final _cPhone = TextEditingController();
  final _cEmail = TextEditingController();
  final _cAddress = TextEditingController();
  final _cOccupation = TextEditingController();
  final _cDob = TextEditingController();
  String _contactMethod = 'Email';

  // incident fields
  final _iDate = TextEditingController();
  final _iPlatform = TextEditingController();
  final _iUrl = TextEditingController();
  final _iNarrative = TextEditingController();
  final _iLoss = TextEditingController();
  final _iSuspect = TextEditingController();
  String _urgencyLabel = 'Medium';

  // artifact manifest – dynamically set based on crime type
  Map<String, bool> _artifacts = {
    'Screenshots': false, 'Emails': false, 'Phone Records': false,
    'Bank Statements': false, 'Receipts': false, 'Chat Logs': false, 'Wallet Addresses': false,
  };

  // chronology rows
  final List<Map<String, String>> _chronRows = [];
  bool _filed = false;
  String _filedCaseNumber = '';

  final _phaseLabels = const ['Crime Type', 'Complainant', 'Incident', 'Evidence', 'Timeline', 'Review'];
  final _phaseGlyphs = const [Icons.category, Icons.person, Icons.description, Icons.attachment, Icons.timeline, Icons.check_circle];

  @override
  void dispose() {
    for (final c in [_cName, _cPhone, _cEmail, _cAddress, _cOccupation, _cDob, _iDate, _iPlatform, _iUrl, _iNarrative, _iLoss, _iSuspect]) { c.dispose(); }
    super.dispose();
  }

  void _advance() {
    if (_phase == 0 && _chosenOffense == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a crime type'), behavior: SnackBarBehavior.floating));
      return;
    }
    if (_phase == 0 && _chosenOffense != null) {
      // Update evidence checklist when advancing past crime type selection
      setState(() {
        _artifacts = ArtifactChecklist.evidenceForOffense(_chosenOffense);
      });
    }
    if (_phase < _phaseCount - 1) setState(() => _phase++);
  }

  void _retreat() { if (_phase > 0) setState(() => _phase--); }

  void _file() {
    final caseNum = SyntheticRecords.mintCaseNumber();
    // Add the new case to the mock data registry
    SyntheticRecords.dossiers.add(ComplaintDossier(
      uid: 'wizard-${DateTime.now().millisecondsSinceEpoch}',
      fileNumber: caseNum,
      offense: _chosenOffense ?? OffenseCategory.other,
      status: DossierStatus.open,
      urgency: UrgencyTier.elevated,
      complainantName: _cName.text.isNotEmpty ? _cName.text : 'Unknown',
      complainantPhone: _cPhone.text,
      complainantEmail: _cEmail.text,
      complainantAddress: _cAddress.text,
      complainantOccupation: _cOccupation.text,
      contactPreference: _contactMethod,
      occurredOn: DateTime.now(),
      digitalPlatform: _iPlatform.text,
      relatedUrl: _iUrl.text,
      narrative: _iNarrative.text,
      monetaryImpact: double.tryParse(_iLoss.text) ?? 0,
      suspectDetails: _iSuspect.text.isNotEmpty ? _iSuspect.text : null,
      assignedInvestigator: 'Det. John Doe',
      filedOn: DateTime.now(),
      lastTouched: DateTime.now(),
      artifactCompleteness: 0.0,
      statusNote: 'Awaiting Detective Review',
      artifacts: const [],
      chronology: const [],
      memos: const [],
    ));
    setState(() {
      _filed = true;
      _filedCaseNumber = caseNum;
    });
  }

  void _fillSampleComplainant() {
    setState(() {
      _cName.text = 'Jennifer Martinez';
      _cPhone.text = '(555) 867-5309';
      _cEmail.text = 'j.martinez@email.com';
      _cAddress.text = '742 Evergreen Terrace, Atlanta, GA 30308';
      _cOccupation.text = 'Financial Analyst';
      _cDob.text = '03/15/1988';
      _contactMethod = 'Email';
    });
  }

  void _loadExampleIncident() {
    setState(() {
      _iDate.text = '06/28/2026';
      _iPlatform.text = 'WhatsApp';
      _iNarrative.text = 'Complainant was contacted through WhatsApp by an individual claiming to represent a cryptocurrency investment firm. After building rapport over two weeks, the suspect persuaded the complainant to transfer funds to a digital wallet for "guaranteed returns." The platform showed fabricated gains before blocking all withdrawal attempts.';
      _iLoss.text = '15,000';
      _iSuspect.text = 'John Smith (alias), WhatsApp: +1-555-012-3456';
    });
  }

  void _generateTimeline() {
    setState(() {
      _chronRows.clear();
      _chronRows.addAll([
        {'date': '06/14/2026', 'time': '10:30', 'summary': 'Victim contacted by suspect via messaging platform', 'tag': 'Initial Contact'},
        {'date': '06/18/2026', 'time': '14:00', 'summary': 'Money transferred to suspect-controlled account', 'tag': 'Financial'},
        {'date': '06/24/2026', 'time': '09:15', 'summary': 'Communication stopped — suspect became unreachable', 'tag': 'Discovery'},
        {'date': '06/28/2026', 'time': '11:00', 'summary': 'Complaint filed with law enforcement', 'tag': 'Response'},
      ]);
    });
  }

  void _returnToDashboard() {
    // Reset wizard state for next use
    setState(() {
      _phase = 0; _chosenOffense = null;
      for (final c in [_cName, _cPhone, _cEmail, _cAddress, _cOccupation, _cDob, _iDate, _iPlatform, _iUrl, _iNarrative, _iLoss, _iSuspect]) { c.clear(); }
      _contactMethod = 'Email'; _urgencyLabel = 'Medium';
      _artifacts = ArtifactChecklist.evidenceForOffense(null);
      _chronRows.clear(); _filed = false; _filedCaseNumber = '';
    });
    // Navigate to dashboard
    context.read<WorkspaceIndexNotifier>().jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    if (_filed) return _filedConfirmation();

    return Column(children: [
      WorkspaceBanner(title: 'New Complaint', caption: 'Step ${_phase + 1} of $_phaseCount: ${_phaseLabels[_phase]}'),
      IntakeBreadcrumb(activeIndex: _phase, stepCount: _phaseCount, labels: _phaseLabels, glyphs: _phaseGlyphs),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(32), child: _phaseContent())),
      _navFooter(),
    ]);
  }

  Widget _phaseContent() {
    switch (_phase) {
      case 0: return OffenseSelector(chosen: _chosenOffense, onChosen: (o) => setState(() => _chosenOffense = o));
      case 1: return ComplainantForm(formKey: _complainantKey, nameCtrl: _cName, phoneCtrl: _cPhone, emailCtrl: _cEmail, addressCtrl: _cAddress, occupationCtrl: _cOccupation, dobCtrl: _cDob, contactMethod: _contactMethod, onContactMethodChanged: (m) => setState(() => _contactMethod = m), onFillSampleData: _fillSampleComplainant);
      case 2: return IncidentDetailForm(formKey: _incidentKey, dateCtrl: _iDate, platformCtrl: _iPlatform, urlCtrl: _iUrl, narrativeCtrl: _iNarrative, lossCtrl: _iLoss, suspectCtrl: _iSuspect, urgencyLabel: _urgencyLabel, onUrgencyChanged: (u) => setState(() => _urgencyLabel = u), onLoadExample: _loadExampleIncident);
      case 3: return ArtifactChecklist(manifest: _artifacts, onToggle: (k, v) => setState(() => _artifacts[k] = v), offense: _chosenOffense);
      case 4: return ChronologyBuilder(rows: _chronRows, onAppend: (r) => setState(() => _chronRows.add(r)), onDiscard: (i) => setState(() => _chronRows.removeAt(i)), onGenerateTimeline: _generateTimeline);
      case 5: return IntakeSummary(offense: _chosenOffense, complainantName: _cName.text, complainantEmail: _cEmail.text, complainantPhone: _cPhone.text, incidentDate: _iDate.text, platform: _iPlatform.text, narrative: _iNarrative.text, monetaryImpact: _iLoss.text, urgencyLabel: _urgencyLabel, artifactManifest: _artifacts, chronologyRows: _chronRows);
      default: return const SizedBox.shrink();
    }
  }

  Widget _navFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(color: InvestigatorPalette.cardWhite, border: Border(top: BorderSide(color: InvestigatorPalette.ruleLine))),
      child: Row(children: [
        if (_phase > 0) OutlinedButton.icon(onPressed: _retreat, icon: const Icon(Icons.arrow_back, size: 18), label: const Text('Back')) else const SizedBox.shrink(),
        const Spacer(),
        Text('Step ${_phase + 1} of $_phaseCount', style: const TextStyle(color: InvestigatorPalette.inkMuted, fontSize: 14)),
        const Spacer(),
        if (_phase < _phaseCount - 1)
          ElevatedButton.icon(onPressed: _advance, icon: const Icon(Icons.arrow_forward, size: 18), label: const Text('Next'))
        else
          ElevatedButton.icon(onPressed: _file, icon: const Icon(Icons.check, size: 18), label: const Text('Submit Complaint'), style: ElevatedButton.styleFrom(backgroundColor: InvestigatorPalette.resolvedGreen)),
      ]),
    );
  }

  Widget _filedConfirmation() {
    return Center(child: Card(child: Padding(padding: const EdgeInsets.all(48), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: InvestigatorPalette.resolvedGreen.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle, size: 64, color: InvestigatorPalette.resolvedGreen)),
      const SizedBox(height: 24),
      const Text('Complaint Successfully Created', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 12),
      const Text('Case Number', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
      const SizedBox(height: 4),
      Text(_filedCaseNumber, style: const TextStyle(fontSize: 28, color: InvestigatorPalette.evidenceBlue, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      const Text('The complaint has been recorded and assigned for review.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
      const SizedBox(height: 32),
      ElevatedButton.icon(
        onPressed: _returnToDashboard,
        icon: const Icon(Icons.dashboard, size: 18),
        label: const Text('Return to Dashboard'),
      ),
    ]))));
  }
}
