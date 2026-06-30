import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/case_model.dart';
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
  String _contactMethod = 'Email';

  // incident fields
  final _iDate = TextEditingController();
  final _iPlatform = TextEditingController();
  final _iUrl = TextEditingController();
  final _iNarrative = TextEditingController();
  final _iLoss = TextEditingController();
  final _iSuspect = TextEditingController();
  String _urgencyLabel = 'Medium';

  // artifact manifest
  final Map<String, bool> _artifacts = {
    'Screenshots': false, 'Emails': false, 'Phone Records': false,
    'Bank Statements': false, 'Receipts': false, 'Chat Logs': false, 'Wallet Addresses': false,
  };

  // chronology rows
  final List<Map<String, String>> _chronRows = [];
  bool _filed = false;

  final _phaseLabels = const ['Offense Type', 'Complainant', 'Incident', 'Artifacts', 'Chronology', 'Review'];
  final _phaseGlyphs = const [Icons.category, Icons.person, Icons.description, Icons.attachment, Icons.timeline, Icons.check_circle];

  @override
  void dispose() {
    for (final c in [_cName, _cPhone, _cEmail, _cAddress, _cOccupation, _iDate, _iPlatform, _iUrl, _iNarrative, _iLoss, _iSuspect]) { c.dispose(); }
    super.dispose();
  }

  void _advance() {
    if (_phase == 0 && _chosenOffense == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an offense category'), behavior: SnackBarBehavior.floating));
      return;
    }
    if (_phase < _phaseCount - 1) setState(() => _phase++);
  }

  void _retreat() { if (_phase > 0) setState(() => _phase--); }

  void _file() => setState(() => _filed = true);

  void _startOver() {
    setState(() {
      _phase = 0; _chosenOffense = null;
      for (final c in [_cName, _cPhone, _cEmail, _cAddress, _cOccupation, _iDate, _iPlatform, _iUrl, _iNarrative, _iLoss, _iSuspect]) { c.clear(); }
      _contactMethod = 'Email'; _urgencyLabel = 'Medium';
      _artifacts.updateAll((_, __) => false);
      _chronRows.clear(); _filed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_filed) return _filedConfirmation();

    return Column(children: [
      WorkspaceBanner(title: 'New Complaint', caption: 'Phase ${_phase + 1} of $_phaseCount: ${_phaseLabels[_phase]}'),
      IntakeBreadcrumb(activeIndex: _phase, stepCount: _phaseCount, labels: _phaseLabels, glyphs: _phaseGlyphs),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(32), child: _phaseContent())),
      _navFooter(),
    ]);
  }

  Widget _phaseContent() {
    switch (_phase) {
      case 0: return OffenseSelector(chosen: _chosenOffense, onChosen: (o) => setState(() => _chosenOffense = o));
      case 1: return ComplainantForm(formKey: _complainantKey, nameCtrl: _cName, phoneCtrl: _cPhone, emailCtrl: _cEmail, addressCtrl: _cAddress, occupationCtrl: _cOccupation, contactMethod: _contactMethod, onContactMethodChanged: (m) => setState(() => _contactMethod = m));
      case 2: return IncidentDetailForm(formKey: _incidentKey, dateCtrl: _iDate, platformCtrl: _iPlatform, urlCtrl: _iUrl, narrativeCtrl: _iNarrative, lossCtrl: _iLoss, suspectCtrl: _iSuspect, urgencyLabel: _urgencyLabel, onUrgencyChanged: (u) => setState(() => _urgencyLabel = u));
      case 3: return ArtifactChecklist(manifest: _artifacts, onToggle: (k, v) => setState(() => _artifacts[k] = v));
      case 4: return ChronologyBuilder(rows: _chronRows, onAppend: (r) => setState(() => _chronRows.add(r)), onDiscard: (i) => setState(() => _chronRows.removeAt(i)));
      case 5: return IntakeSummary(offense: _chosenOffense, complainantName: _cName.text, complainantEmail: _cEmail.text, complainantPhone: _cPhone.text, incidentDate: _iDate.text, platform: _iPlatform.text, narrative: _iNarrative.text, monetaryImpact: _iLoss.text, urgencyLabel: _urgencyLabel, artifactManifest: _artifacts, chronologyRows: _chronRows);
      default: return const SizedBox.shrink();
    }
  }

  Widget _navFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(color: InvestigatorPalette.cardWhite, border: Border(top: BorderSide(color: InvestigatorPalette.ruleLine))),
      child: Row(children: [
        if (_phase > 0) OutlinedButton.icon(onPressed: _retreat, icon: const Icon(Icons.arrow_back, size: 18), label: const Text('Previous')) else const SizedBox.shrink(),
        const Spacer(),
        Text('${_phase + 1} / $_phaseCount', style: const TextStyle(color: InvestigatorPalette.inkMuted, fontSize: 14)),
        const Spacer(),
        if (_phase < _phaseCount - 1)
          ElevatedButton.icon(onPressed: _advance, icon: const Icon(Icons.arrow_forward, size: 18), label: const Text('Next'))
        else
          ElevatedButton.icon(onPressed: _file, icon: const Icon(Icons.check, size: 18), label: const Text('File Complaint'), style: ElevatedButton.styleFrom(backgroundColor: InvestigatorPalette.resolvedGreen)),
      ]),
    );
  }

  Widget _filedConfirmation() {
    return Center(child: Card(child: Padding(padding: const EdgeInsets.all(48), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: InvestigatorPalette.resolvedGreen.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle, size: 64, color: InvestigatorPalette.resolvedGreen)),
      const SizedBox(height: 24),
      const Text('Complaint Filed Successfully', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: InvestigatorPalette.inkDark)),
      const SizedBox(height: 8),
      const Text('Dossier Number: CC-2026-006', style: TextStyle(fontSize: 16, color: InvestigatorPalette.evidenceBlue, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      const Text('The complaint has been recorded and assigned to your caseload.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
      const SizedBox(height: 32),
      Row(mainAxisSize: MainAxisSize.min, children: [
        OutlinedButton.icon(onPressed: _startOver, icon: const Icon(Icons.add, size: 18), label: const Text('New Complaint')),
        const SizedBox(width: 12),
        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.folder_open, size: 18), label: const Text('View Dossier')),
      ]),
    ]))));
  }
}
