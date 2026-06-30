# CCIS – Cybercrime Complaint Intake System

**Georgia Tech CS6750 – Human-Computer Interaction**
Medium-Fidelity Desktop Prototype

## Overview

CCIS is an interactive desktop prototype demonstrating an improved cybercrime complaint intake process for law enforcement investigators. It is built with Flutter 3.x and Material 3, targeting desktop platforms.

This is **not production software** — it is a prototype built for usability evaluation, screenshots, and a five-minute walkthrough video.

## Design Alternatives

| Prototype | Concept | Key Feature |
|-----------|---------|-------------|
| 1 | Guided Intake Wizard | Step-by-step complaint filing with progress breadcrumb |
| 2 | Investigator Dashboard | Case-management-first view with tabbed dossier inspector |
| 3 | Smart Interview Assistant | Optional insight panel with mock AI recommendations |
| **Final** | **Combined** | Wizard + Dashboard + Optional Smart Assistant panel |

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
    navigation/     # PrimaryWorkspaceShell, WorkspaceIndexNotifier
    models/         # ComplaintDossier, ArtifactRecord, ChronologyEntry, etc.
    mock_data/      # SyntheticRecords (all demo data)
  features/
    dashboard/      # InvestigatorDashboard
    wizard/         # ComplaintIntakeWizard (6-phase guided intake)
    cases/          # CaseRegistryBrowser, DossierInspector
    evidence/       # EvidenceVaultScreen
    timeline/       # ChronologyWorkbench
    reports/        # AnalyticsOverview
    settings/       # PreferencesPanel
  shared/
    widgets/        # MetricTile, ConditionPill, WorkspaceBanner, etc.
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
