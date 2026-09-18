# Story 4-2: Review Local Session History

Epic: 4 — Study Continuity and Materials
Source: `_bmad-output/planning-artifacts/epics.md` (Story 4.2)

As a student,
I want to review past Sessions and their lifecycle outcomes,
So that I can understand completed, Lost, replaced, and adjusted study work without losing the original record.

## Acceptance Criteria

**Given** locally persisted lifecycle events exist
**When** the student opens History from Home or a weekly counter
**Then** the application shows Session outcomes including `Completed`, `Lost`, `Incomplete`, `Rescheduled`, and `Cancelled`
**And** the data is read through the application facade.

**Given** a Lost Managed Lesson has a Replacement
**When** the student views either Session in History
**Then** the original and replacement relationship is visible
**And** the original Lost outcome and lifecycle events remain auditable.

**Given** a Session has been manually adjusted
**When** the student reviews its history
**Then** the prior lifecycle event remains present
**And** the adjustment does not erase earlier outcome information.

**Given** there are no historical Sessions
**When** the student opens History
**Then** the application presents an explicit empty-history state
**And** it provides a route back to Home without introducing gamified language.

**Given** the student navigates History by keyboard
**When** they move through records or open a Session detail
**Then** focus order is predictable and status is textual
**And** all interactive controls have accessible names.

## References

FR-9, FR-15, NFR-3, NFR-5, AD-1, AD-2, AD-8, AD-9, UX-DR7, UX-DR9, UX-DR10.