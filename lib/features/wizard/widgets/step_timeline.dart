import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Step 5 – lets the investigator build a chronological event sequence.
class ChronologyBuilder extends StatefulWidget {
  final List<Map<String, String>> rows;
  final void Function(Map<String, String> row) onAppend;
  final void Function(int idx) onDiscard;
  final VoidCallback onGenerateTimeline;

  const ChronologyBuilder({super.key, required this.rows, required this.onAppend, required this.onDiscard, required this.onGenerateTimeline});

  @override
  State<ChronologyBuilder> createState() => _ChronologyBuilderState();
}

class _ChronologyBuilderState extends State<ChronologyBuilder> {
  final _dateInput = TextEditingController();
  final _timeInput = TextEditingController();
  final _summaryInput = TextEditingController();
  String _tag = 'General';

  final List<String> _tags = ['General', 'Initial Contact', 'Communication', 'Financial', 'Deception', 'Discovery', 'Investigation', 'Response'];

  @override
  void dispose() { _dateInput.dispose(); _timeInput.dispose(); _summaryInput.dispose(); super.dispose(); }

  void _commit() {
    if (_summaryInput.text.isEmpty) return;
    widget.onAppend({'date': _dateInput.text.isNotEmpty ? _dateInput.text : 'N/A', 'time': _timeInput.text.isNotEmpty ? _timeInput.text : 'N/A', 'summary': _summaryInput.text, 'tag': _tag});
    _dateInput.clear(); _timeInput.clear(); _summaryInput.clear();
    setState(() => _tag = 'General');
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Timeline', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
          SizedBox(height: 8),
          Text('Construct a timeline of events related to the incident.', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
        ])),
        ElevatedButton.icon(
          onPressed: widget.onGenerateTimeline,
          icon: const Icon(Icons.auto_fix_high, size: 18),
          label: const Text('Generate Timeline'),
          style: ElevatedButton.styleFrom(backgroundColor: InvestigatorPalette.evidenceBlue),
        ),
      ]),
      const SizedBox(height: 24),

      // entries
      if (widget.rows.isNotEmpty) ...[
        Text('${widget.rows.length} Events Recorded', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
        const SizedBox(height: 12),
        ...widget.rows.asMap().entries.map((e) => _EventCard(seq: e.key, data: e.value, onDiscard: () => widget.onDiscard(e.key))),
      ] else
        Card(child: Padding(padding: const EdgeInsets.all(32), child: Center(child: Column(children: [
          Icon(Icons.timeline, size: 40, color: InvestigatorPalette.inkFaint),
          const SizedBox(height: 12),
          const Text('No events recorded yet', style: TextStyle(fontSize: 14, color: InvestigatorPalette.inkMuted)),
          const SizedBox(height: 4),
          const Text('Click "Generate Timeline" to auto-create events, or add manually below', style: TextStyle(fontSize: 13, color: InvestigatorPalette.inkFaint)),
        ])))),
      const SizedBox(height: 24),

      // input form
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Add Event Manually', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextFormField(controller: _dateInput, decoration: const InputDecoration(labelText: 'Date', prefixIcon: Icon(Icons.calendar_today), hintText: 'MM/DD/YYYY'))),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(controller: _timeInput, decoration: const InputDecoration(labelText: 'Time', prefixIcon: Icon(Icons.access_time), hintText: 'HH:MM'))),
          const SizedBox(width: 16),
          Expanded(child: DropdownButtonFormField<String>(
            value: _tag, decoration: const InputDecoration(labelText: 'Tag', prefixIcon: Icon(Icons.category)),
            items: _tags.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _tag = v ?? 'General'),
          )),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextFormField(controller: _summaryInput, decoration: const InputDecoration(labelText: 'Event Summary *', prefixIcon: Icon(Icons.notes)))),
          const SizedBox(width: 16),
          ElevatedButton.icon(onPressed: _commit, icon: const Icon(Icons.add, size: 18), label: const Text('Add')),
        ]),
      ]))),
    ]);
  }
}

class _EventCard extends StatelessWidget {
  final int seq;
  final Map<String, String> data;
  final VoidCallback onDiscard;

  const _EventCard({required this.seq, required this.data, required this.onDiscard});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Card(child: ListTile(
      leading: CircleAvatar(
        radius: 16, backgroundColor: InvestigatorPalette.evidenceBlue.withOpacity(0.1),
        child: Text('${seq + 1}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: InvestigatorPalette.evidenceBlue)),
      ),
      title: Text(data['summary'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text('${data['date']} at ${data['time']}  ·  ${data['tag']}', style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkMuted)),
      trailing: IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: onDiscard, color: InvestigatorPalette.alertRed, tooltip: 'Remove'),
    )));
  }
}
