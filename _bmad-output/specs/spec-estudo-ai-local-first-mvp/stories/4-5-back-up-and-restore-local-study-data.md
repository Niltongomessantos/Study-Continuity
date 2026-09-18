# Story 4-5: Back Up and Restore Local Study Data

Epic: 4 — Study Continuity and Materials
Source: `_bmad-output/planning-artifacts/epics.md` (Story 4.5)

As a student,
I want to export and restore my local study data through a validated backup file,
So that I can recover my schedule and history if browser storage is lost.

## Acceptance Criteria

**Given** local study data exists
**When** the student exports a backup
**Then** the application generates versioned JSON containing `schemaVersion`, stable IDs, timestamps, Sessions, lifecycle events, recurrence, replacements, material metadata, and eligible file blobs
**And** files larger than 5 MB remain metadata-only and require reselection after restore.

**Given** the student selects a valid backup file
**When** import validation completes
**Then** the application verifies the schema version, duplicate IDs, material limits, dangling replacement references, and cyclic replacement links
**And** it shows validation errors before replacing any local state.

**Given** a backup passes all validation
**When** the student confirms restoration
**Then** the application atomically replaces all local IndexedDB state
**And** it does not merge imported records with existing local records.

**Given** a backup is malformed or fails validation
**When** the student attempts restoration
**Then** the application shows an actionable import error
**And** the existing local state remains unchanged.

**Given** restore succeeds
**When** the student returns to Home or History
**Then** restored Sessions, timing records, lifecycle history, recurrence, replacements, and material metadata are available through the application facade
**And** the application remains usable without network access, authorization, or notifications.

**Given** export or import controls are used by keyboard
**When** the student starts, cancels, or completes the operation
**Then** focus handling and status feedback are accessible
**And** no browser, operating-system, or external-service notification is required.

## References

FR-14, FR-15, NFR-1, NFR-2, NFR-3, NFR-5, AD-1, AD-2, AD-8, AD-9, AD-10, AD-11, AD-12, UX-DR9, UX-DR10.
