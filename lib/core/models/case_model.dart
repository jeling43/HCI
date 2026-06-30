/// Domain models for the CCIS prototype.
/// Every type uses a distinctive name tied to the law-enforcement domain.

enum OffenseCategory {
  onlineScam('Online Scam', 'Fraudulent schemes conducted through digital channels'),
  identityTheft('Identity Theft', 'Unauthorized acquisition or use of personal identifiers'),
  cryptoFraud('Cryptocurrency Fraud', 'Deceptive practices involving digital currencies'),
  socialMediaCrime('Social Media Crime', 'Criminal activity perpetrated via social platforms'),
  businessEmailCompromise('Business Email Compromise', 'Impersonation-based email fraud targeting organizations'),
  other('Other', 'Cybercrime categories not listed above');

  const OffenseCategory(this.label, this.briefing);
  final String label;
  final String briefing;
}

enum DossierStatus {
  open('Open'),
  underInvestigation('In Progress'),
  awaitingReview('Pending Review'),
  archived('Closed');

  const DossierStatus(this.label);
  final String label;
}

enum UrgencyTier {
  routine('Low'),
  elevated('Medium'),
  urgent('High'),
  critical('Critical');

  const UrgencyTier(this.label);
  final String label;
}

/// A single complaint/case record in the system.
class ComplaintDossier {
  final String uid;
  final String fileNumber;
  final OffenseCategory offense;
  final DossierStatus status;
  final UrgencyTier urgency;
  final String complainantName;
  final String complainantPhone;
  final String complainantEmail;
  final String complainantAddress;
  final String complainantOccupation;
  final String contactPreference;
  final DateTime occurredOn;
  final String digitalPlatform;
  final String relatedUrl;
  final String narrative;
  final double monetaryImpact;
  final String? suspectDetails;
  final String assignedInvestigator;
  final DateTime filedOn;
  final DateTime lastTouched;
  final double artifactCompleteness;
  final List<ArtifactRecord> artifacts;
  final List<ChronologyEntry> chronology;
  final List<InvestigatorMemo> memos;

  const ComplaintDossier({
    required this.uid,
    required this.fileNumber,
    required this.offense,
    required this.status,
    required this.urgency,
    required this.complainantName,
    required this.complainantPhone,
    required this.complainantEmail,
    required this.complainantAddress,
    required this.complainantOccupation,
    required this.contactPreference,
    required this.occurredOn,
    required this.digitalPlatform,
    required this.relatedUrl,
    required this.narrative,
    required this.monetaryImpact,
    this.suspectDetails,
    required this.assignedInvestigator,
    required this.filedOn,
    required this.lastTouched,
    required this.artifactCompleteness,
    required this.artifacts,
    required this.chronology,
    required this.memos,
  });
}

/// A piece of evidence linked to a dossier.
class ArtifactRecord {
  final String uid;
  final String label;
  final ArtifactKind kind;
  final bool secured;
  final DateTime? securedOn;
  final String? remarks;

  const ArtifactRecord({
    required this.uid,
    required this.label,
    required this.kind,
    required this.secured,
    this.securedOn,
    this.remarks,
  });
}

enum ArtifactKind {
  screenshot('Screenshots'),
  email('Emails'),
  phoneRecord('Phone Records'),
  bankStatement('Bank Statements'),
  receipt('Receipts'),
  chatLog('Chat Logs'),
  walletAddress('Wallet Addresses'),
  other('Other');

  const ArtifactKind(this.label);
  final String label;
}

/// A single event on the incident timeline.
class ChronologyEntry {
  final String uid;
  final DateTime occurredDate;
  final String clockTime;
  final String summary;
  final String tag;

  const ChronologyEntry({
    required this.uid,
    required this.occurredDate,
    required this.clockTime,
    required this.summary,
    required this.tag,
  });
}

/// An investigator's note attached to a dossier.
class InvestigatorMemo {
  final String uid;
  final String author;
  final DateTime writtenAt;
  final String body;

  const InvestigatorMemo({
    required this.uid,
    required this.author,
    required this.writtenAt,
    required this.body,
  });
}

/// Feed item for the dashboard activity stream.
class FeedEntry {
  final String uid;
  final String headline;
  final DateTime stamp;
  final String actor;
  final FeedEventKind kind;

  const FeedEntry({
    required this.uid,
    required this.headline,
    required this.stamp,
    required this.actor,
    required this.kind,
  });
}

enum FeedEventKind {
  dossierCreated,
  artifactAttached,
  statusTransitioned,
  memoAppended,
  dossierAssigned,
  reportExported,
}

/// A suggestion surfaced by the "Smart Assistant" panel (Prototype 3).
class InsightCard {
  final String heading;
  final String detail;
  final InsightSeverity severity;

  const InsightCard({
    required this.heading,
    required this.detail,
    required this.severity,
  });
}

enum InsightSeverity {
  gapAlert,
  followUp,
  tip,
  urgentFlag,
}
