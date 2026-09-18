# Story 2-1: Show the Next Local Study Session

Epic: 2 — Next Session and Daily Agenda
Source: `_bmad-output/planning-artifacts/epics.md` (Story 2.1)

As a student,
I want Home to show my next relevant local Session,
So that I immediately know what to study and when.

## Acceptance Criteria

**Given** one or more future local Sessions exist
**When** the student opens Home
**Then** the earliest relevant Session is shown as the dominant primary surface
**And** it shows type, title or fallback label, planned time, duration, status, material context, and available action.

**Given** the student activates the primary Session by mouse or keyboard
**When** the action is accepted
**Then** Session detail opens through the application facade
**And** the UI does not mutate or query IndexedDB directly.

**Given** no future Session exists
**When** Home loads
**Then** it states that no Session is scheduled
**And** it retains the daily agenda and clear Create Session action.

**Given** the application reconciles persisted Sessions before reading Home data
**When** a Pending or Started Session has crossed a timing boundary
**Then** Home reflects the reconciled status
**And** the primary surface promotes the next valid Session when applicable.

**Given** Home displays a Session status
**When** the user views it with any supported input mode
**Then** text and structure communicate the status
**And** color is supplementary only.

## References

FR-1, FR-13, NFR-5, NFR-6, AD-1, AD-2, AD-7, UX-DR1 through UX-DR3, UX-DR9 through UX-DR11.