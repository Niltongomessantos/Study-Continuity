# Story 2-2: Inspect Daily Session Continuity

Epic: 2 — Next Session and Daily Agenda
Source: `_bmad-output/planning-artifacts/epics.md` (Story 2.2)

As a student,
I want to inspect past and upcoming Sessions for the current day,
So that I can understand my study continuity without leaving Home.

## Acceptance Criteria

**Given** local Sessions exist on the current day
**When** Home loads
**Then** it shows past and upcoming Sessions below the primary Session surface
**And** past, upcoming, active, completed, Lost, Rescheduled, and Cancelled states are distinguishable by text and structure.

**Given** the student selects a daily agenda row
**When** the row is activated by mouse or keyboard
**Then** the application opens that Session's local detail record
**And** the agenda row exposes no edit or reschedule action in the MVP.

**Given** the current day has only past Sessions or only upcoming Sessions
**When** Home renders the agenda
**Then** the available group remains visible
**And** the missing group is represented without confusing it with a loading failure.

**Given** the current day has no Sessions
**When** Home renders
**Then** it shows a quiet empty daily-agenda state
**And** the Create Session action remains available.

**Given** the user navigates the agenda by keyboard
**When** moving between rows and opening a detail record
**Then** focus order follows the reading order
**And** focus returns to the originating agenda row when the detail is closed.

## References

FR-2, FR-13, NFR-5, NFR-6, AD-1, AD-2, AD-7, UX-DR1, UX-DR2, UX-DR6, UX-DR9, UX-DR10, UX-DR11.