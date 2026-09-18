# Story 3-1: Reconcile Session Time and Loss

Epic: 3 — Local Session Timing and Outcomes
Source: `_bmad-output/planning-artifacts/epics.md` (Story 3.1)

As a student,
I want overdue Sessions to be reconciled automatically from their saved timing data,
So that the agenda and history show the correct local state after time passes or the browser is interrupted.

## Acceptance Criteria

**Given** a Pending Managed Lesson or Free Block has reached its tolerance deadline without `actualStartAt`
**When** the application opens, gains focus, serves a query, or begins a mutation
**Then** reconciliation changes the Session to `Lost` before the requested state is read
**And** persists one Lost lifecycle event atomically with the Session state.

**Given** a Started Session reaches `plannedEndAt`
**When** reconciliation runs
**Then** the domain determines its terminal outcome using the 50% planned-duration rule
**And** persists the terminal state and lifecycle event before exposing the Session to the UI.

**Given** reconciliation runs repeatedly without a new timing boundary crossed
**When** it evaluates an already reconciled Session
**Then** it returns the existing state
**And** it creates no duplicate lifecycle event.

**Given** Home or Session detail queries current data
**When** a timing boundary was crossed while the browser was closed or suspended
**Then** the returned view reflects the reconciled outcome
**And** no UI interval, network request, or external service is used as the time authority.

**Given** reconciliation cannot commit its persistence transaction
**When** the application attempts to expose the affected state
**Then** it surfaces an actionable local persistence error
**And** it does not represent the uncommitted transition as completed.


FR-6, FR-8, FR-10, FR-13, FR-14, NFR-2, NFR-3, NFR-6, AD-1, AD-2, AD-3, AD-4, AD-5, AD-7, AD-8, AD-9, UX-DR5, UX-DR9.