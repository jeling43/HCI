import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/case_model.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/status_badge.dart';
import 'case_detail_screen.dart';

/// Tabular browser for all complaint dossiers.
class CaseRegistryBrowser extends StatefulWidget {
  const CaseRegistryBrowser({super.key});

  @override
  State<CaseRegistryBrowser> createState() => _CaseRegistryBrowserState();
}

class _CaseRegistryBrowserState extends State<CaseRegistryBrowser> {
  String _query = '';
  DossierStatus? _statusFilter;
  OffenseCategory? _offenseFilter;
  String _ordering = 'Updated';
  ComplaintDossier? _inspecting;

  @override
  Widget build(BuildContext context) {
    if (_inspecting != null) {
      return DossierInspector(dossier: _inspecting!, onDismiss: () => setState(() => _inspecting = null));
    }

    final visible = SyntheticRecords.dossiers.where((d) {
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        if (!d.fileNumber.toLowerCase().contains(q) && !d.complainantName.toLowerCase().contains(q) && !d.offense.label.toLowerCase().contains(q)) return false;
      }
      if (_statusFilter != null && d.status != _statusFilter) return false;
      if (_offenseFilter != null && d.offense != _offenseFilter) return false;
      return true;
    }).toList();

    return Column(children: [
      WorkspaceBanner(title: 'Case Registry', caption: '${SyntheticRecords.dossiers.length} dossiers on file', controls: [
        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 18), label: const Text('New Dossier')),
      ]),
      // search & filters
      Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16), color: InvestigatorPalette.cardWhite,
        child: Column(children: [
          TextFormField(decoration: const InputDecoration(hintText: 'Search by file number, complainant, or offense...', prefixIcon: Icon(Icons.search)), onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Filters:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: InvestigatorPalette.inkMuted)),
            const SizedBox(width: 12),
            _Dropdown<DossierStatus?>(val: _statusFilter, hint: 'Status', items: [const DropdownMenuItem(value: null, child: Text('All Status')), ...DossierStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label)))], onPick: (v) => setState(() => _statusFilter = v)),
            const SizedBox(width: 12),
            _Dropdown<OffenseCategory?>(val: _offenseFilter, hint: 'Offense', items: [const DropdownMenuItem(value: null, child: Text('All Offenses')), ...OffenseCategory.values.map((o) => DropdownMenuItem(value: o, child: Text(o.label)))], onPick: (v) => setState(() => _offenseFilter = v)),
            const Spacer(),
            const Text('Sort:', style: TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted)),
            const SizedBox(width: 8),
            _Dropdown<String>(val: _ordering, hint: 'Sort', items: ['Updated', 'Filed', 'Urgency', 'File Number'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onPick: (v) => setState(() => _ordering = v ?? 'Updated')),
          ]),
        ]),
      ),
      const Divider(height: 1),
      Expanded(
        child: visible.isEmpty
            ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.search_off, size: 48, color: InvestigatorPalette.inkFaint), const SizedBox(height: 12), const Text('No dossiers match your criteria', style: TextStyle(fontSize: 16, color: InvestigatorPalette.inkMuted))]))
            : SingleChildScrollView(padding: const EdgeInsets.all(32), child: Card(child: SizedBox(width: double.infinity, child: DataTable(
                headingRowHeight: 48, dataRowMinHeight: 56, dataRowMaxHeight: 56, columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('File No.')), DataColumn(label: Text('Complainant')),
                  DataColumn(label: Text('Offense')), DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Urgency')), DataColumn(label: Text('Artifacts')),
                  DataColumn(label: Text('Last Touched')),
                ],
                rows: visible.map((d) => DataRow(
                  onSelectChanged: (_) => setState(() => _inspecting = d),
                  cells: [
                    DataCell(Text(d.fileNumber, style: const TextStyle(fontWeight: FontWeight.w600, color: InvestigatorPalette.evidenceBlue))),
                    DataCell(Text(d.complainantName)),
                    DataCell(Text(d.offense.label)),
                    DataCell(ConditionPill.forStatus(d.status)),
                    DataCell(ConditionPill.forUrgency(d.urgency)),
                    DataCell(_gauge(d.artifactCompleteness)),
                    DataCell(Text('${d.lastTouched.month}/${d.lastTouched.day}/${d.lastTouched.year}', style: const TextStyle(color: InvestigatorPalette.inkMuted, fontSize: 13))),
                  ],
                )).toList(),
              )))),
      ),
    ]);
  }

  Widget _gauge(double ratio) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(width: 60, child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: ratio, backgroundColor: InvestigatorPalette.ruleLine, valueColor: AlwaysStoppedAnimation<Color>(ratio >= 1.0 ? InvestigatorPalette.resolvedGreen : InvestigatorPalette.cautionAmber), minHeight: 6))),
      const SizedBox(width: 8),
      Text('${(ratio * 100).toInt()}%', style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkMuted)),
    ]);
  }
}

class _Dropdown<T> extends StatelessWidget {
  final T val;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onPick;

  const _Dropdown({required this.val, required this.hint, required this.items, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: InvestigatorPalette.ruleLine), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(child: DropdownButton<T>(value: val, items: items, onChanged: onPick, isDense: true, style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkDark))),
    );
  }
}
