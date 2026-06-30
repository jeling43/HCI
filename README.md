# CCIS – Cybercrime Complaint Intake System

**Georgia Tech CS6750 – Human-Computer Interaction**
Medium-Fidelity Desktop Prototype

## Overview

CCIS is an interactive desktop prototype demonstrating an improved cybercrime complaint intake process for law enforcement investigators. It is built with Flutter 3.x and Material 3, targeting desktop platforms.

This is **not production software** — it is a prototype built for usability evaluation, screenshots, and a five-minute walkthrough video.

## Design Alternatives

| Prototype | Concept | Key Feature | Route |
|-----------|---------|-------------|-------|
| 1 | Guided Intake Wizard | Step-by-step complaint filing with progress breadcrumb | `/p1` |
| 2 | Investigator Dashboard | Case-management-first view with tabbed dossier inspector | `/p2` |
| 3 | Smart Interview Assistant | AI-guided adaptive interview with mock recommendations | `/p3` |
| **Final** | **Combined** | Wizard + Dashboard + Optional Smart Assistant panel | `/final` |

## How to Access Each Prototype

When the application starts it shows the **Prototype Selector** screen.
Every prototype is reachable in **≤ 2 clicks** from startup.

### Click path

```
App launch → Prototype Selector screen
  → Click "Launch Prototype" on any card
      Prototype 1 (P1) – Guided Intake Wizard         → route /p1
      Prototype 2 (P2) – Investigator Dashboard       → route /p2
      Prototype 3 (P3) – Smart Interview Assistant    → route /p3
      Final Prototype   – Combined                    → route /final
```

### Prototype 1 · Guided Intake Wizard `/p1`

Opens directly to the **New Complaint** wizard.
The side rail highlights **"New Complaint"** and a blue **P1** badge is shown.
Navigate the six-step intake: Offense Type → Complainant → Incident →
Artifacts → Chronology → Review.

### Prototype 2 · Investigator Dashboard `/p2`

Opens directly to the **Dashboard** (case-management-first).
The side rail highlights **"Dashboard"** and a green **P2** badge is shown.
Click any dossier row to open the tabbed **Dossier Inspector** with
Overview, Evidence, Timeline, Notes, and Activity tabs.

### Prototype 3 · Smart Interview Assistant `/p3`

Opens directly to the **Smart Interview Assistant** pane (rail index 7,
"Smart Assist"). A purple **P3** badge is shown.
Select a case from the dropdown, then advance through adaptive interview
questions. The right-hand panel updates in real time with:
- Auto-generated case summary
- Missing-evidence alerts
- Suggested follow-up questions
- Pattern-match recommendation cards

### Final Prototype · Combined `/final`

Opens to the **Dashboard** with all navigation destinations available,
including the Smart Assist pane. An **FINAL** badge is shown in the rail.

### Back to Selector

Inside any prototype, click the **← Selector** button at the bottom
of the side rail to return to the Prototype Selector screen.

## Getting Started

```bash
# Ensure Flutter ≥ 3.2 is installed
flutter doctor

# Get dependencies
flutter pub get

# Run on desktop
flutter run -d linux   # or macos / windows
```

## Folder Structure

```
lib/
  core/
    theme/          # InvestigatorPalette, GovernmentDesignTokens
    navigation/     # PrimaryWorkspaceShell, WorkspaceIndexNotifier, PrototypeMode
    models/         # ComplaintDossier, ArtifactRecord, ChronologyEntry, etc.
    mock_data/      # SyntheticRecords (all demo data)
  features/
    selector/       # PrototypeSelectorScreen (landing page)
    dashboard/      # InvestigatorDashboard  (Prototype 2 entry point)
    wizard/         # ComplaintIntakeWizard  (Prototype 1 entry point)
    smart_assistant/ # SmartInterviewAssistantScreen (Prototype 3 entry point)
    cases/          # CaseRegistryBrowser, DossierInspector
    evidence/       # EvidenceVaultScreen
    timeline/       # ChronologyWorkbench
    reports/        # AnalyticsOverview
    settings/       # PreferencesPanel
  shared/
    widgets/        # MetricTile, ConditionPill, WorkspaceBanner, InsightBubble, etc.
```

## HCI Principles Demonstrated

- **Recognition Rather Than Recall** — large category tiles, progress breadcrumbs
- **Visibility of System Status** — artifact completion gauges, phase indicators
- **Consistency** — uniform card styling, persistent side rail
- **Low Cognitive Load** — wizard phasing, section grouping
- **Immediate Feedback** — hover states, selection highlights, snack bars
- **Direct Manipulation** — checkbox checklists, timeline builder
- **Accessibility** — large controls, readable text, high contrast option

## Tech Stack

- Flutter 3.x (Desktop)
- Material 3
- Provider (state management)
- No backend / No authentication / No persistence
