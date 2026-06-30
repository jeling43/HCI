import '../models/case_model.dart';

/// Central mock-data repository for the CCIS prototype.
/// Every record is hand-crafted for demo fidelity; no backend exists.
class SyntheticRecords {
  SyntheticRecords._();

  // ═══════════════════════════════════════════════════════════════
  //  Dossier catalogue
  // ═══════════════════════════════════════════════════════════════
  static final List<ComplaintDossier> dossiers = [
    ComplaintDossier(
      uid: 'd1',
      fileNumber: 'CC-2026-001',
      offense: OffenseCategory.onlineScam,
      status: DossierStatus.underInvestigation,
      urgency: UrgencyTier.urgent,
      complainantName: 'Sarah Johnson',
      complainantPhone: '(555) 123-4567',
      complainantEmail: 'sarah.johnson@email.com',
      complainantAddress: '123 Oak Street, Atlanta, GA 30301',
      complainantOccupation: 'Software Engineer',
      contactPreference: 'Email',
      occurredOn: DateTime(2026, 6, 15),
      digitalPlatform: 'Facebook Marketplace',
      relatedUrl: 'facebook.com/marketplace',
      narrative: 'Complainant purchased electronics through Facebook Marketplace. Seller supplied a fabricated tracking number and ceased all communication after receiving payment via Cash App.',
      monetaryImpact: 2500.00,
      suspectDetails: 'Username: TechDeals2026, payment via Cash App',
      assignedInvestigator: 'Det. John Doe',
      filedOn: DateTime(2026, 6, 16),
      lastTouched: DateTime(2026, 6, 28),
      artifactCompleteness: 0.75,
      artifacts: [
        ArtifactRecord(uid: 'a1', label: 'Marketplace Listing Capture', kind: ArtifactKind.screenshot, secured: true, securedOn: DateTime(2026, 6, 16)),
        ArtifactRecord(uid: 'a2', label: 'Cash App Transfer Receipt', kind: ArtifactKind.receipt, secured: true, securedOn: DateTime(2026, 6, 16)),
        ArtifactRecord(uid: 'a3', label: 'Messenger Thread Export', kind: ArtifactKind.chatLog, secured: true, securedOn: DateTime(2026, 6, 17)),
        ArtifactRecord(uid: 'a4', label: 'Checking Account Statement', kind: ArtifactKind.bankStatement, secured: false),
        ArtifactRecord(uid: 'a5', label: 'Seller Profile Capture', kind: ArtifactKind.screenshot, secured: false),
      ],
      chronology: [
        ChronologyEntry(uid: 'c1', occurredDate: DateTime(2026, 6, 10), clockTime: '14:30', summary: 'Complainant discovered listing on Marketplace', tag: 'Initial Contact'),
        ChronologyEntry(uid: 'c2', occurredDate: DateTime(2026, 6, 11), clockTime: '09:15', summary: 'Exchanged messages with seller via Messenger', tag: 'Communication'),
        ChronologyEntry(uid: 'c3', occurredDate: DateTime(2026, 6, 12), clockTime: '11:00', summary: 'Transferred \$2,500 through Cash App', tag: 'Financial'),
        ChronologyEntry(uid: 'c4', occurredDate: DateTime(2026, 6, 13), clockTime: '16:45', summary: 'Received fabricated shipment tracking number', tag: 'Deception'),
        ChronologyEntry(uid: 'c5', occurredDate: DateTime(2026, 6, 15), clockTime: '10:00', summary: 'Seller profile deactivated from platform', tag: 'Discovery'),
      ],
      memos: [
        InvestigatorMemo(uid: 'm1', author: 'Det. John Doe', writtenAt: DateTime(2026, 6, 16), body: 'Initial intake completed. Complainant presents as credible. Cash App transaction independently verified.'),
        InvestigatorMemo(uid: 'm2', author: 'Det. John Doe', writtenAt: DateTime(2026, 6, 18), body: 'Legal process submitted to Facebook for seller account subscriber information.'),
      ],
    ),

    ComplaintDossier(
      uid: 'd2',
      fileNumber: 'CC-2026-002',
      offense: OffenseCategory.identityTheft,
      status: DossierStatus.open,
      urgency: UrgencyTier.critical,
      complainantName: 'Michael Chen',
      complainantPhone: '(555) 234-5678',
      complainantEmail: 'michael.chen@email.com',
      complainantAddress: '456 Pine Avenue, Marietta, GA 30060',
      complainantOccupation: 'Accountant',
      contactPreference: 'Phone',
      occurredOn: DateTime(2026, 6, 20),
      digitalPlatform: 'Multiple',
      relatedUrl: 'N/A',
      narrative: 'Complainant identified several unauthorized credit accounts opened using stolen personal identifiers. Social Security number appears to have been exposed in a prior corporate data breach.',
      monetaryImpact: 45000.00,
      assignedInvestigator: 'Det. Jane Smith',
      filedOn: DateTime(2026, 6, 21),
      lastTouched: DateTime(2026, 6, 29),
      artifactCompleteness: 0.50,
      artifacts: [
        ArtifactRecord(uid: 'a6', label: 'Three-Bureau Credit Report', kind: ArtifactKind.bankStatement, secured: true, securedOn: DateTime(2026, 6, 21)),
        ArtifactRecord(uid: 'a7', label: 'Fraud Alert Acknowledgment', kind: ArtifactKind.email, secured: true, securedOn: DateTime(2026, 6, 21)),
        ArtifactRecord(uid: 'a8', label: 'Unauthorized Account Records', kind: ArtifactKind.bankStatement, secured: false),
        ArtifactRecord(uid: 'a9', label: 'Breach Disclosure Letter', kind: ArtifactKind.email, secured: false),
      ],
      chronology: [
        ChronologyEntry(uid: 'c6', occurredDate: DateTime(2026, 6, 18), clockTime: '08:00', summary: 'Received credit monitoring alert on mobile', tag: 'Discovery'),
        ChronologyEntry(uid: 'c7', occurredDate: DateTime(2026, 6, 19), clockTime: '10:30', summary: 'Identified three fraudulent credit accounts', tag: 'Investigation'),
        ChronologyEntry(uid: 'c8', occurredDate: DateTime(2026, 6, 20), clockTime: '14:00', summary: 'Filed FTC Identity Theft Report online', tag: 'Reporting'),
      ],
      memos: [
        InvestigatorMemo(uid: 'm3', author: 'Det. Jane Smith', writtenAt: DateTime(2026, 6, 21), body: 'Elevated-value identity theft with multiple financial institution exposure. Coordinating with federal partners.'),
      ],
    ),

    ComplaintDossier(
      uid: 'd3',
      fileNumber: 'CC-2026-003',
      offense: OffenseCategory.cryptoFraud,
      status: DossierStatus.awaitingReview,
      urgency: UrgencyTier.elevated,
      complainantName: 'Emily Rodriguez',
      complainantPhone: '(555) 345-6789',
      complainantEmail: 'emily.r@email.com',
      complainantAddress: '789 Elm Drive, Decatur, GA 30030',
      complainantOccupation: 'Marketing Manager',
      contactPreference: 'Email',
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

    ComplaintDossier(
      uid: 'd4',
      fileNumber: 'CC-2026-004',
      offense: OffenseCategory.businessEmailCompromise,
      status: DossierStatus.open,
      urgency: UrgencyTier.urgent,
      complainantName: 'Robert Williams',
      complainantPhone: '(555) 456-7890',
      complainantEmail: 'r.williams@company.com',
      complainantAddress: '101 Corporate Blvd, Atlanta, GA 30309',
      complainantOccupation: 'CFO',
      contactPreference: 'Phone',
      occurredOn: DateTime(2026, 6, 22),
      digitalPlatform: 'Email',
      relatedUrl: 'N/A',
      narrative: 'CEO email address was spoofed to authorize a wire transfer of \$125,000 to an offshore account. An employee processed what appeared to be a legitimate executive directive.',
      monetaryImpact: 125000.00,
      suspectDetails: 'Spoofed address: ceo@comp4ny.com (numeral substitution)',
      assignedInvestigator: 'Det. Jane Smith',
      filedOn: DateTime(2026, 6, 23),
      lastTouched: DateTime(2026, 6, 30),
      artifactCompleteness: 0.60,
      artifacts: [
        ArtifactRecord(uid: 'a16', label: 'Spoofed Email Headers + Body', kind: ArtifactKind.email, secured: true, securedOn: DateTime(2026, 6, 23)),
        ArtifactRecord(uid: 'a17', label: 'Wire Transfer Documentation', kind: ArtifactKind.bankStatement, secured: true, securedOn: DateTime(2026, 6, 24)),
        ArtifactRecord(uid: 'a18', label: 'Mail Server Authentication Logs', kind: ArtifactKind.other, secured: true, securedOn: DateTime(2026, 6, 25)),
        ArtifactRecord(uid: 'a19', label: 'Employee Witness Statement', kind: ArtifactKind.other, secured: false),
        ArtifactRecord(uid: 'a20', label: 'Bank Account Freeze Order', kind: ArtifactKind.bankStatement, secured: false),
      ],
      chronology: [
        ChronologyEntry(uid: 'c14', occurredDate: DateTime(2026, 6, 22), clockTime: '09:30', summary: 'Spoofed directive received by accounting department', tag: 'Initial Contact'),
        ChronologyEntry(uid: 'c15', occurredDate: DateTime(2026, 6, 22), clockTime: '11:15', summary: 'Wire transfer executed per directive', tag: 'Financial'),
        ChronologyEntry(uid: 'c16', occurredDate: DateTime(2026, 6, 22), clockTime: '15:00', summary: 'Actual CEO confirmed directive was not genuine', tag: 'Discovery'),
        ChronologyEntry(uid: 'c17', occurredDate: DateTime(2026, 6, 23), clockTime: '08:00', summary: 'Receiving bank notified; freeze petition filed', tag: 'Response'),
      ],
      memos: [
        InvestigatorMemo(uid: 'm6', author: 'Det. Jane Smith', writtenAt: DateTime(2026, 6, 23), body: 'Time-critical matter. Financial institution has 72-hour recall window remaining.'),
      ],
    ),

    ComplaintDossier(
      uid: 'd5',
      fileNumber: 'CC-2026-005',
      offense: OffenseCategory.socialMediaCrime,
      status: DossierStatus.archived,
      urgency: UrgencyTier.routine,
      complainantName: 'Amanda Foster',
      complainantPhone: '(555) 567-8901',
      complainantEmail: 'a.foster@email.com',
      complainantAddress: '222 Birch Lane, Roswell, GA 30075',
      complainantOccupation: 'Student',
      contactPreference: 'Email',
      occurredOn: DateTime(2026, 5, 28),
      digitalPlatform: 'Instagram',
      relatedUrl: 'instagram.com',
      narrative: 'Complainant\'s Instagram account was hijacked through a phishing link. The attacker used the compromised account to solicit cryptocurrency from the complainant\'s followers under false pretenses.',
      monetaryImpact: 800.00,
      assignedInvestigator: 'Det. John Doe',
      filedOn: DateTime(2026, 5, 30),
      lastTouched: DateTime(2026, 6, 20),
      artifactCompleteness: 1.0,
      artifacts: [
        ArtifactRecord(uid: 'a21', label: 'Login Activity Audit', kind: ArtifactKind.screenshot, secured: true, securedOn: DateTime(2026, 5, 30)),
        ArtifactRecord(uid: 'a22', label: 'Direct Message Thread Exports', kind: ArtifactKind.chatLog, secured: true, securedOn: DateTime(2026, 5, 30)),
        ArtifactRecord(uid: 'a23', label: 'IP-Based Login History', kind: ArtifactKind.other, secured: true, securedOn: DateTime(2026, 6, 5)),
      ],
      chronology: [
        ChronologyEntry(uid: 'c18', occurredDate: DateTime(2026, 5, 28), clockTime: '22:00', summary: 'Account compromised after clicking phishing link', tag: 'Initial Contact'),
        ChronologyEntry(uid: 'c19', occurredDate: DateTime(2026, 5, 29), clockTime: '06:00', summary: 'Fraudulent DMs dispatched to follower list', tag: 'Attack'),
        ChronologyEntry(uid: 'c20', occurredDate: DateTime(2026, 5, 29), clockTime: '10:00', summary: 'Friends alerted complainant to suspicious messages', tag: 'Discovery'),
      ],
      memos: [
        InvestigatorMemo(uid: 'm7', author: 'Det. John Doe', writtenAt: DateTime(2026, 5, 30), body: 'Account access restored. Instagram legal compliance provided originating IP addresses.'),
        InvestigatorMemo(uid: 'm8', author: 'Det. John Doe', writtenAt: DateTime(2026, 6, 20), body: 'Case resolved. Account secured. Nominal financial loss reimbursed by platform.'),
      ],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════
  //  Activity feed
  // ═══════════════════════════════════════════════════════════════
  static final List<FeedEntry> activityFeed = [
    FeedEntry(uid: 'f1', headline: 'New dossier filed: CC-2026-004', stamp: DateTime(2026, 6, 23, 10, 30), actor: 'Det. Jane Smith', kind: FeedEventKind.dossierCreated),
    FeedEntry(uid: 'f2', headline: 'Artifact uploaded for CC-2026-001', stamp: DateTime(2026, 6, 22, 14, 15), actor: 'Det. John Doe', kind: FeedEventKind.artifactAttached),
    FeedEntry(uid: 'f3', headline: 'CC-2026-003 advanced to Pending Review', stamp: DateTime(2026, 6, 22, 11, 00), actor: 'Det. John Doe', kind: FeedEventKind.statusTransitioned),
    FeedEntry(uid: 'f4', headline: 'Memo appended to CC-2026-002', stamp: DateTime(2026, 6, 21, 16, 45), actor: 'Det. Jane Smith', kind: FeedEventKind.memoAppended),
    FeedEntry(uid: 'f5', headline: 'CC-2026-005 archived', stamp: DateTime(2026, 6, 20, 13, 30), actor: 'Det. John Doe', kind: FeedEventKind.statusTransitioned),
    FeedEntry(uid: 'f6', headline: 'Weekly analytics digest exported', stamp: DateTime(2026, 6, 20, 09, 00), actor: 'System', kind: FeedEventKind.reportExported),
  ];

  // ═══════════════════════════════════════════════════════════════
  //  Smart-assistant insight cards (Prototype 3)
  // ═══════════════════════════════════════════════════════════════
  static const List<InsightCard> insights = [
    InsightCard(heading: 'Missing Bank Records', detail: 'Dossier CC-2026-001 lacks checking account statements. Consider requesting copies from the complainant.', severity: InsightSeverity.gapAlert),
    InsightCard(heading: 'Suggested Interview Question', detail: 'CC-2026-002: Inquire whether the complainant\'s employer has disclosed any recent data-breach incidents.', severity: InsightSeverity.followUp),
    InsightCard(heading: 'Pattern Match Detected', detail: 'CC-2026-003 exhibits hallmarks of a pig-butchering scheme. Cross-reference with the FBI IC3 complaint database.', severity: InsightSeverity.tip),
    InsightCard(heading: 'Recall Window Closing', detail: 'CC-2026-004: The bank\'s wire-recall window expires within 48 hours. Expedite inter-agency coordination.', severity: InsightSeverity.urgentFlag),
  ];
}
