import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/case_model.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/recommendation_card.dart';

/// Prototype 3 – Smart Interview Assistant.
///
/// This screen presents a fundamentally different interaction model
/// from the linear wizard (P1) or case-management dashboard (P2).
/// The primary metaphor is a live, AI-guided interview:
///   • The left panel shows one adaptive question at a time and
///     collects the investigator's response.
///   • The right panel shows a Smart Assistant pane that updates
///     continuously with an auto-generated case summary, missing-
///     evidence alerts, suggested follow-up questions, and pattern-
///     match recommendation cards.
///
/// All suggestions are mock data — no real AI is involved.
class SmartInterviewAssistantScreen extends StatefulWidget {
  const SmartInterviewAssistantScreen({super.key});

  @override
  State<SmartInterviewAssistantScreen> createState() =>
      _SmartInterviewAssistantScreenState();
}

class _SmartInterviewAssistantScreenState
    extends State<SmartInterviewAssistantScreen> {
  // ── State ───────────────────────────────────────────────────────
  ComplaintDossier? _activeDossier;
  int _questionIndex = 0;
  final Map<int, String> _responses = {};
  final TextEditingController _responseCtrl = TextEditingController();

  @override
  void dispose() {
    _responseCtrl.dispose();
    super.dispose();
  }

  // ── Adaptive question bank ──────────────────────────────────────
  /// Questions change based on the dossier's offense category.
  List<_InterviewQuestion> get _questions {
    final offense = _activeDossier?.offense;
    return [
      const _InterviewQuestion(
        phase: 'Opening',
        text: 'Please describe in your own words what happened and how you first discovered the incident.',
        hint: 'Encourage a narrative account before asking specific questions.',
        inputKind: _InputKind.narrative,
      ),
      const _InterviewQuestion(
        phase: 'Contact',
        text: 'How did the suspect first make contact with you? Through which platform or channel?',
        hint: 'Note platform, date, and any identifiers the suspect used.',
        inputKind: _InputKind.shortText,
      ),
      _InterviewQuestion(
        phase: 'Financial',
        text: offense == OffenseCategory.cryptoFraud
            ? 'What cryptocurrency wallets or exchange accounts were involved? List all transaction hashes you have access to.'
            : 'What payment methods were used? List each transaction, amount, and date.',
        hint: 'Capture all financial movement details for the evidence record.',
        inputKind: _InputKind.shortText,
      ),
      _InterviewQuestion(
        phase: 'Evidence',
        text: offense == OffenseCategory.businessEmailCompromise
            ? 'Have you preserved the original email headers from the suspicious message?'
            : 'Which digital evidence have you already preserved (screenshots, logs, receipts)?',
        hint: 'Flag any evidence that may require urgent preservation before it is deleted.',
        inputKind: _InputKind.checklist,
        checklistItems: const [
          'Screenshots / Screen recordings',
          'Email headers & body',
          'Chat / messaging logs',
          'Bank or transaction records',
          'Wallet addresses or TX hashes',
          'Phone / call records',
        ],
      ),
      const _InterviewQuestion(
        phase: 'Suspect',
        text: 'What identifiers do you have for the suspect (username, email, phone, address, IP address)?',
        hint: 'Record every identifier even if not yet verified.',
        inputKind: _InputKind.shortText,
      ),
      const _InterviewQuestion(
        phase: 'Reporting',
        text: 'Have you reported this incident to any other agency (FTC, IC3, financial institution)?',
        hint: 'Note any reference numbers from prior reports for cross-referencing.',
        inputKind: _InputKind.shortText,
      ),
    ];
  }

  // ── Assistant panel data ────────────────────────────────────────
  List<InsightCard> get _liveInsights {
    if (_activeDossier == null) return SyntheticRecords.insights;
    return SyntheticRecords.insights
        .where((i) => i.detail.contains(_activeDossier!.fileNumber))
        .toList();
  }

  List<_EvidenceGap> get _evidenceGaps {
    if (_activeDossier == null) return _EvidenceGap.defaults;
    return _activeDossier!.artifacts
        .where((a) => !a.secured)
        .map((a) => _EvidenceGap(label: a.label, kind: a.kind.label))
        .toList();
  }

  List<String> get _suggestedFollowUps {
    final idx = _questionIndex;
    final offense = _activeDossier?.offense;

    if (idx == 0) {
      return [
        'Ask when the complainant first suspected fraud.',
        'Request a timeline of initial contacts.',
      ];
    }
    if (idx == 1) {
      return [
        'Confirm whether any prior relationship existed with the suspect.',
        'Request any usernames, profile URLs, or phone numbers.',
      ];
    }
    if (idx == 2) {
      if (offense == OffenseCategory.cryptoFraud) {
        return [
          'Ask for screenshots of the platform dashboard.',
          'Request any withdrawal-request confirmation emails.',
        ];
      }
      return [
        'Confirm whether a bank recall request has been filed.',
        'Ask whether a wire-transfer receipt is available.',
      ];
    }
    if (idx == 3) {
      return [
        'Emphasise the importance of preserving originals, not copies.',
        'Ask whether any accounts have been changed/deleted.',
      ];
    }
    if (idx == 4) {
      return [
        'Check if the suspect\'s platform account is still active.',
        'Ask whether the complainant has any mutual contacts with the suspect.',
      ];
    }
    return [
      'Provide IC3.gov and FTC.gov complaint links.',
      'Advise on a fraud alert with the major credit bureaus.',
    ];
  }

  String get _autoSummary {
    if (_activeDossier == null) {
      return 'No case selected. Choose a dossier from the dropdown above to begin the assisted interview.';
    }

    final answered = _responses.values.where((r) => r.trim().isNotEmpty).length;
    final total = _questions.length;
    final pct = (answered / total * 100).round();

    return 'Case ${_activeDossier!.fileNumber} · '
        '${_activeDossier!.offense.label} · '
        'Complainant: ${_activeDossier!.complainantName}.\n\n'
        'Interview progress: $answered of $total questions answered ($pct%). '
        'Estimated loss: \$${_activeDossier!.monetaryImpact.toStringAsFixed(0)}. '
        'Status: ${_activeDossier!.status.label}. '
        'Evidence completeness: ${(_activeDossier!.artifactCompleteness * 100).toInt()}%.';
  }

  // ── Navigation helpers ──────────────────────────────────────────
  void _saveAndAdvance() {
    _responses[_questionIndex] = _responseCtrl.text;
    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
        _responseCtrl.text = _responses[_questionIndex] ?? '';
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _retreat() {
    if (_questionIndex > 0) {
      _responses[_questionIndex] = _responseCtrl.text;
      setState(() {
        _questionIndex--;
        _responseCtrl.text = _responses[_questionIndex] ?? '';
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Interview Complete'),
        content: const Text(
          'All questions have been answered. The auto-summary has been '
          'updated with the collected responses. You may now proceed to '
          'file the complaint or add additional notes.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _questionIndex = 0;
                _responses.clear();
                _responseCtrl.clear();
              });
            },
            child: const Text('Start New Interview'),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final q = _questions[_questionIndex];

    return Column(
      children: [
        WorkspaceBanner(
          title: 'Smart Interview Assistant',
          caption: 'Prototype 3 · AI-guided adaptive intake interview',
          controls: [
            _CasePicker(
              selected: _activeDossier,
              onChanged: (d) => setState(() {
                _activeDossier = d;
                _questionIndex = 0;
                _responses.clear();
                _responseCtrl.clear();
              }),
            ),
          ],
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Left: interview panel ──────────────────────────
              Expanded(
                flex: 6,
                child: _InterviewPanel(
                  question: q,
                  questionIndex: _questionIndex,
                  totalQuestions: _questions.length,
                  responseCtrl: _responseCtrl,
                  responses: _responses,
                  onAdvance: _saveAndAdvance,
                  onRetreat: _retreat,
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1, color: InvestigatorPalette.ruleLine),
              // ── Right: smart assistant panel ───────────────────
              SizedBox(
                width: 360,
                child: _AssistantPanel(
                  autoSummary: _autoSummary,
                  evidenceGaps: _evidenceGaps,
                  followUps: _suggestedFollowUps,
                  insights: _liveInsights,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Interview panel
// ════════════════════════════════════════════════════════════════════

class _InterviewPanel extends StatelessWidget {
  final _InterviewQuestion question;
  final int questionIndex;
  final int totalQuestions;
  final TextEditingController responseCtrl;
  final Map<int, String> responses;
  final VoidCallback onAdvance;
  final VoidCallback onRetreat;

  const _InterviewPanel({
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
    required this.responseCtrl,
    required this.responses,
    required this.onAdvance,
    required this.onRetreat,
  });

  @override
  Widget build(BuildContext context) {
    final answeredCount = responses.values.where((r) => r.trim().isNotEmpty).length;

    return Column(
      children: [
        // ── Phase + progress bar ────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Phase: ${question.phase}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Q ${questionIndex + 1} of $totalQuestions',
                style: const TextStyle(fontSize: 13, color: InvestigatorPalette.inkMuted),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (questionIndex + 1) / totalQuestions,
              backgroundColor: InvestigatorPalette.ruleLine,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
              minHeight: 5,
            ),
          ),
        ),

        // ── Question card ───────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  color: const Color(0xFF7C3AED).withOpacity(0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF7C3AED), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.record_voice_over_outlined, size: 20, color: Color(0xFF7C3AED)),
                            SizedBox(width: 8),
                            Text('Interview Question',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF7C3AED))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          question.text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: InvestigatorPalette.inkDark,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: InvestigatorPalette.canvasWash,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lightbulb_outline, size: 14, color: InvestigatorPalette.inkMuted),
                              const SizedBox(width: 6),
                              Expanded(child: Text(question.hint,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: InvestigatorPalette.inkMuted))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Response input ──────────────────────────────
                if (question.inputKind == _InputKind.checklist && question.checklistItems != null)
                  _ChecklistInput(
                    items: question.checklistItems!,
                    responseCtrl: responseCtrl,
                  )
                else
                  _TextInput(
                    responseCtrl: responseCtrl,
                    multiline: question.inputKind == _InputKind.narrative,
                  ),

                const SizedBox(height: 16),

                // ── Answered count badge ────────────────────────
                if (answeredCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 14, color: InvestigatorPalette.resolvedGreen),
                        const SizedBox(width: 6),
                        Text(
                          '$answeredCount of $totalQuestions questions answered',
                          style: const TextStyle(fontSize: 12, color: InvestigatorPalette.resolvedGreen),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        // ── Navigation footer ──────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: const BoxDecoration(
            color: InvestigatorPalette.cardWhite,
            border: Border(top: BorderSide(color: InvestigatorPalette.ruleLine)),
          ),
          child: Row(
            children: [
              if (questionIndex > 0)
                OutlinedButton.icon(
                  onPressed: onRetreat,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Previous'),
                )
              else
                const SizedBox.shrink(),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onAdvance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                ),
                icon: Icon(
                  questionIndex < totalQuestions - 1 ? Icons.arrow_forward : Icons.check,
                  size: 18,
                ),
                label: Text(questionIndex < totalQuestions - 1
                    ? 'Next Question'
                    : 'Complete Interview'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Text input ──────────────────────────────────────────────────────
class _TextInput extends StatelessWidget {
  final TextEditingController responseCtrl;
  final bool multiline;

  const _TextInput({required this.responseCtrl, required this.multiline});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: responseCtrl,
      maxLines: multiline ? 6 : 3,
      decoration: InputDecoration(
        hintText: multiline
            ? 'Provide a detailed narrative response…'
            : 'Type your response here…',
        filled: true,
        fillColor: InvestigatorPalette.canvasWash,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: InvestigatorPalette.ruleLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: InvestigatorPalette.ruleLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
        ),
      ),
    );
  }
}

// ── Checklist input ─────────────────────────────────────────────────
class _ChecklistInput extends StatefulWidget {
  final List<String> items;
  final TextEditingController responseCtrl;

  const _ChecklistInput({required this.items, required this.responseCtrl});

  @override
  State<_ChecklistInput> createState() => _ChecklistInputState();
}

class _ChecklistInputState extends State<_ChecklistInput> {
  final Set<String> _checked = {};

  void _toggle(String item) {
    setState(() {
      if (_checked.contains(item)) {
        _checked.remove(item);
      } else {
        _checked.add(item);
      }
      widget.responseCtrl.text = _checked.join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Check all that apply:',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark),
        ),
        const SizedBox(height: 8),
        ...widget.items.map((item) => CheckboxListTile(
          dense: true,
          value: _checked.contains(item),
          onChanged: (_) => _toggle(item),
          title: Text(item, style: const TextStyle(fontSize: 14)),
          activeColor: const Color(0xFF7C3AED),
          contentPadding: EdgeInsets.zero,
        )),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Smart Assistant panel
// ════════════════════════════════════════════════════════════════════

class _AssistantPanel extends StatelessWidget {
  final String autoSummary;
  final List<_EvidenceGap> evidenceGaps;
  final List<String> followUps;
  final List<InsightCard> insights;

  const _AssistantPanel({
    required this.autoSummary,
    required this.evidenceGaps,
    required this.followUps,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: InvestigatorPalette.canvasWash,
      child: Column(
        children: [
          // ── Panel header ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: const BoxDecoration(
              color: InvestigatorPalette.cardWhite,
              border: Border(bottom: BorderSide(color: InvestigatorPalette.ruleLine)),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, size: 18, color: Color(0xFF7C3AED)),
                SizedBox(width: 8),
                Text(
                  'Smart Assistant',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: InvestigatorPalette.inkDark,
                  ),
                ),
                SizedBox(width: 8),
                _AssistantBadge(),
              ],
            ),
          ),

          // ── Scrollable content ─────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AssistantSection(
                    icon: Icons.summarize_outlined,
                    title: 'Auto-Summary',
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: InvestigatorPalette.cardWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: InvestigatorPalette.ruleLine),
                      ),
                      child: Text(
                        autoSummary,
                        style: const TextStyle(
                          fontSize: 13,
                          color: InvestigatorPalette.inkDark,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _AssistantSection(
                    icon: Icons.warning_amber_rounded,
                    title: 'Missing Evidence',
                    iconColor: InvestigatorPalette.cautionAmber,
                    child: evidenceGaps.isEmpty
                        ? const _AllClearChip()
                        : Column(
                            children: evidenceGaps.map((g) => _GapRow(gap: g)).toList(),
                          ),
                  ),
                  const SizedBox(height: 16),

                  _AssistantSection(
                    icon: Icons.help_outline,
                    title: 'Suggested Follow-ups',
                    iconColor: InvestigatorPalette.evidenceBlue,
                    child: Column(
                      children: followUps.map((f) => _FollowUpRow(text: f)).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (insights.isNotEmpty) ...[
                    _AssistantSection(
                      icon: Icons.tips_and_updates_outlined,
                      title: 'Recommendations',
                      child: Column(
                        children: insights
                            .map((i) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: InsightBubble(insight: i),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Assistant sub-widgets ────────────────────────────────────────────

class _AssistantBadge extends StatelessWidget {
  const _AssistantBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'LIVE',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Color(0xFF7C3AED),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _AssistantSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Color? iconColor;

  const _AssistantSection({
    required this.icon,
    required this.title,
    required this.child,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: iconColor ?? const Color(0xFF7C3AED)),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: iconColor ?? const Color(0xFF7C3AED),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _GapRow extends StatelessWidget {
  final _EvidenceGap gap;

  const _GapRow({required this.gap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: InvestigatorPalette.cautionAmber.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: InvestigatorPalette.cautionAmber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 14, color: InvestigatorPalette.cautionAmber),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gap.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: InvestigatorPalette.inkDark)),
                Text(gap.kind, style: const TextStyle(fontSize: 11, color: InvestigatorPalette.inkMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowUpRow extends StatelessWidget {
  final String text;

  const _FollowUpRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: InvestigatorPalette.evidenceBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: InvestigatorPalette.evidenceBlue.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.help_outline, size: 14, color: InvestigatorPalette.evidenceBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, color: InvestigatorPalette.inkDark, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _AllClearChip extends StatelessWidget {
  const _AllClearChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: InvestigatorPalette.resolvedGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: InvestigatorPalette.resolvedGreen.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_outline, size: 14, color: InvestigatorPalette.resolvedGreen),
          SizedBox(width: 8),
          Text('No evidence gaps detected', style: TextStyle(fontSize: 12, color: InvestigatorPalette.resolvedGreen)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Case picker dropdown
// ════════════════════════════════════════════════════════════════════

class _CasePicker extends StatelessWidget {
  final ComplaintDossier? selected;
  final ValueChanged<ComplaintDossier?> onChanged;

  const _CasePicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final dossiers = SyntheticRecords.dossiers;
    return DropdownButton<ComplaintDossier?>(
      value: selected,
      hint: const Text('Select case…', style: TextStyle(fontSize: 14)),
      underline: const SizedBox.shrink(),
      items: [
        const DropdownMenuItem(value: null, child: Text('— No case selected —')),
        ...dossiers.map((d) => DropdownMenuItem(
          value: d,
          child: Text('${d.fileNumber} · ${d.complainantName}',
              style: const TextStyle(fontSize: 14)),
        )),
      ],
      onChanged: onChanged,
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Data models local to this screen
// ════════════════════════════════════════════════════════════════════

enum _InputKind { narrative, shortText, checklist }

class _InterviewQuestion {
  final String phase;
  final String text;
  final String hint;
  final _InputKind inputKind;
  final List<String>? checklistItems;

  const _InterviewQuestion({
    required this.phase,
    required this.text,
    required this.hint,
    required this.inputKind,
    this.checklistItems,
  });
}

class _EvidenceGap {
  final String label;
  final String kind;

  const _EvidenceGap({required this.label, required this.kind});

  static const List<_EvidenceGap> defaults = [
    _EvidenceGap(label: 'Bank / transaction records', kind: 'Bank Statements'),
    _EvidenceGap(label: 'Communication logs', kind: 'Chat Logs'),
  ];
}
