import '../models/case_model.dart';

/// Central mock-data repository for the CCIS prototype.
/// Every record is hand-crafted for demo fidelity; no backend exists.
class SyntheticRecords {
  SyntheticRecords._();

  /// Tracks the next case number suffix for newly filed complaints.
  static int _nextCaseSeq = 125;

  /// Generates the next sequential case number in the format 25-000XXX.
  static String mintCaseNumber() {
    final seq = _nextCaseSeq++;
    return '25-${seq.toString().padLeft(6, '0')}';
  }

  // ═══════════════════════════════════════════════════════════════
  //  Dossier catalogue
  // ═══════════════════════════════════════════════════════════════
  static final List<ComplaintDossier> dossiers = [
    ComplaintDossier(
      uid: 'd1',
      fileNumber: '25-000123',
      offense: OffenseCategory.identityTheft,
      status: DossierStatus.underInvestigation,
      urgency: UrgencyTier.urgent,
      complainantName: 'Sarah Johnson',
      complainantPhone: '(555) 123-4567',
      complainantEmail: 'sarah.johnson@email.com',
      complainantAddress: '123 Oak Street, Atlanta, GA 30301',
      complainantOccupation: 'Software Engineer',
      contactPreference: 'Email',
      occurredOn: DateTime(2026, 6, 15),
      digitalPlatform: 'Multiple',
      relatedUrl: 'N/A',
      narrative: 'Complainant identified several unauthorized credit accounts opened using stolen personal identifiers. Social Security number appears to have been exposed in a prior corporate data breach.',
      monetaryImpact: 45000.00,
      suspectDetails: 'Unknown – data breach origin suspected',
      assignedInvestigator: 'Det. John Doe',
      filedOn: DateTime(2026, 6, 16),
      lastTouched: DateTime(2026, 6, 28),
      artifactCompleteness: 0.75,
      statusNote: 'Waiting for Bank Records',
      artifacts: [
        ArtifactRecord(uid: 'a1', label: 'Three-Bureau Credit Report', kind: ArtifactKind.bankStatement, secured: true, securedOn: DateTime(2026, 6, 16)),
        ArtifactRecord(uid: 'a2', label: 'Fraud Alert Acknowledgment', kind: ArtifactKind.email, secured: true, securedOn: DateTime(2026, 6, 16)),
        ArtifactRecord(uid: 'a3', label: 'Unauthorized Account Records', kind: ArtifactKind.bankStatement, secured: false),
        ArtifactRecord(uid: 'a4', label: 'Breach Disclosure Letter', kind: ArtifactKind.email, secured: false),
      ],
      chronology: [
        ChronologyEntry(uid: 'c1', occurredDate: DateTime(2026, 6, 10), clockTime: '14:30', summary: 'Received credit monitoring alert on mobile', tag: 'Discovery'),
        ChronologyEntry(uid: 'c2', occurredDate: DateTime(2026, 6, 11), clockTime: '09:15', summary: 'Identified three fraudulent credit accounts', tag: 'Investigation'),
        ChronologyEntry(uid: 'c3', occurredDate: DateTime(2026, 6, 12), clockTime: '11:00', summary: 'Filed FTC Identity Theft Report online', tag: 'Reporting'),
      ],
      memos: [
        InvestigatorMemo(uid: 'm1', author: 'Det. John Doe', writtenAt: DateTime(2026, 6, 16), body: 'Elevated-value identity theft with multiple financial institution exposure. Coordinating with federal partners.'),
      ],
    ),

    ComplaintDossier(
      uid: 'd2',
      fileNumber: '25-000124',
      offense: OffenseCategory.cryptoFraud,
      status: DossierStatus.awaitingReview,
      urgency: UrgencyTier.elevated,
      complainantName: 'Michael Chen',
      complainantPhone: '(555) 234-5678',
      complainantEmail: 'michael.chen@email.com',
      complainantAddress: '456 Pine Avenue, Marietta, GA 30060',
      complainantOccupation: 'Accountant',
      contactPreference: 'Phone',
      occurredOn: DateTime(2026, 6, 5),
      digitalPlatform: 'WhatsApp',
      relatedUrl: 'cryptoinvest-pro.com',
      narrative: 'Complainant was solicited via WhatsApp to join a cryptocurrency investment platform. Platform displayed fabricated portfolio returns to encourage additional deposits before locking withdrawals.',
      monetaryImpact: 18500.00,
      suspectDetails: 'WhatsApp: +1-555-999-0000, Domain: cryptoinvest-pro.com',
      assignedInvestigator: 'Det. John Doe',
      filedOn: DateTime(2026, 6, 8),
      lastTouched: DateTime(2026, 6, 25),
      artifactCompleteness: 0.85,
      statusNote: 'Ready for Review',
      artifacts: [
        ArtifactRecord(uid: 'a10', label: 'WhatsApp Conversation Captures', kind: ArtifactKind.screenshot, secured: true, securedOn: DateTime(2026, 6, 8)),
        ArtifactRecord(uid: 'a11', label: 'Platform Dashboard Captures', kind: ArtifactKind.screenshot, secured: true, securedOn: DateTime(2026, 6, 8)),
        ArtifactRecord(uid: 'a12', label: 'Blockchain Transaction Hashes', kind: ArtifactKind.walletAddress, secured: true, securedOn: DateTime(2026, 6, 9)),
        ArtifactRecord(uid: 'a13', label: 'Wire Transfer Confirmations', kind: ArtifactKind.bankStatement, secured: true, securedOn: DateTime(2026, 6, 10)),
        ArtifactRecord(uid: 'a14', label: 'WhatsApp Chat Export', kind: ArtifactKind.chatLog, secured: true, securedOn: DateTime(2026, 6, 8)),
        ArtifactRecord(uid: 'a15', label: 'Carrier Call Detail Records', kind: ArtifactKind.phoneRecord, secured: false),
      ],
      chronology: [
        ChronologyEntry(uid: 'c9', occurredDate: DateTime(2026, 5, 15), clockTime: '20:00', summary: 'Unsolicited WhatsApp message from unknown number', tag: 'Initial Contact'),
        ChronologyEntry(uid: 'c10', occurredDate: DateTime(2026, 5, 20), clockTime: '12:00', summary: 'Created account on cryptoinvest-pro.com', tag: 'Engagement'),
        ChronologyEntry(uid: 'c11', occurredDate: DateTime(2026, 5, 25), clockTime: '09:00', summary: 'First deposit of \$5,000 via wire transfer', tag: 'Financial'),
        ChronologyEntry(uid: 'c12', occurredDate: DateTime(2026, 6, 1), clockTime: '14:00', summary: 'Second deposit of \$13,500 after seeing fake gains', tag: 'Financial'),
        ChronologyEntry(uid: 'c13', occurredDate: DateTime(2026, 6, 5), clockTime: '11:00', summary: 'Withdrawal requests blocked by platform', tag: 'Discovery'),
      ],
      memos: [
        InvestigatorMemo(uid: 'm4', author: 'Det. John Doe', writtenAt: DateTime(2026, 6, 8), body: 'Pattern consistent with pig butchering scheme. Domain registrar shows 3-month-old registration.'),
        InvestigatorMemo(uid: 'm5', author: 'Det. John Doe', writtenAt: DateTime(2026, 6, 15), body: 'Blockchain tracing reveals funds cascaded through six intermediate wallets before consolidation.'),
      ],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════
  //  Activity feed
  // ═══════════════════════════════════════════════════════════════
  static final List<FeedEntry> activityFeed = [
    FeedEntry(uid: 'f1', headline: 'New case filed: 25-000124', stamp: DateTime(2026, 6, 23, 10, 30), actor: 'Det. John Doe', kind: FeedEventKind.dossierCreated),
    FeedEntry(uid: 'f2', headline: 'Evidence uploaded for 25-000123', stamp: DateTime(2026, 6, 22, 14, 15), actor: 'Det. John Doe', kind: FeedEventKind.artifactAttached),
    FeedEntry(uid: 'f3', headline: '25-000124 advanced to Ready for Review', stamp: DateTime(2026, 6, 22, 11, 00), actor: 'Det. John Doe', kind: FeedEventKind.statusTransitioned),
    FeedEntry(uid: 'f4', headline: 'Memo appended to 25-000123', stamp: DateTime(2026, 6, 21, 16, 45), actor: 'Det. John Doe', kind: FeedEventKind.memoAppended),
    FeedEntry(uid: 'f5', headline: 'Bank records requested for 25-000123', stamp: DateTime(2026, 6, 20, 13, 30), actor: 'Det. John Doe', kind: FeedEventKind.artifactAttached),
    FeedEntry(uid: 'f6', headline: 'Weekly analytics digest exported', stamp: DateTime(2026, 6, 20, 09, 00), actor: 'System', kind: FeedEventKind.reportExported),
  ];

  // ═══════════════════════════════════════════════════════════════
  //  Smart-assistant insight cards (Prototype 3)
  // ═══════════════════════════════════════════════════════════════
  static const List<InsightCard> insights = [
    InsightCard(heading: 'Missing Bank Records', detail: 'Case 25-000123 lacks checking account statements. Consider requesting copies from the complainant.', severity: InsightSeverity.gapAlert),
    InsightCard(heading: 'Suggested Interview Question', detail: '25-000123: Inquire whether the complainant\'s employer has disclosed any recent data-breach incidents.', severity: InsightSeverity.followUp),
    InsightCard(heading: 'Pattern Match Detected', detail: '25-000124 exhibits hallmarks of a pig-butchering scheme. Cross-reference with the FBI IC3 complaint database.', severity: InsightSeverity.tip),
    InsightCard(heading: 'Review Ready', detail: '25-000124: All required evidence has been collected. Case is ready for detective review.', severity: InsightSeverity.followUp),
  ];
}
