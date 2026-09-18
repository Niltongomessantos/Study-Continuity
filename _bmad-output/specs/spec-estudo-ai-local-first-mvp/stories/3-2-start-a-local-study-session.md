# Story 3-2: Reconcile Session Time and Loss

Epic: 3 — Local Session Timing and Outcomes
Source: `_bmad-output/planning-artifacts/epics.md` (Story 3.2)

As a student,
I want to start a Pending Managed Lesson or Free Block within its allowed time,
So that the application records the actual start and begins local study timing.

## Acceptance Criteria

**Given** a Pending Managed Lesson or Free Block is opened at or before its tolerance deadline
**When** the student activates Start
**Then** the application records `actualStartAt` from the injected Clock
**And** changes the Session status to `Started` with one lifecycle event.

**Given** a Pending Session is started after its planned start but before its tolerance deadline
**When** the student activates Start
**Then** the system records the late actual start
**And** preserves `plannedEndAt` without extending it.

**Given** a Pending Session has reached or passed its tolerance deadline
**When** the student opens it or tries to activate Start
**Then** reconciliation records it as `Lost`
**And** Start is unavailable.

**Given** the student attempts Start again for a `Started` Session
**When** the application receives the repeated action
**Then** it returns the current Session state
**And** it does not overwrite `actualStartAt` or create another lifecycle event.

**Given** a Session is Started
**When** Session detail renders the timer
**Then** it shows both elapsed and remaining time derived from persisted timestamps and the Clock
**And** visual refreshes do not mutate Session state or steal keyboard focus.

## References

FR-5, FR-6, FR-7, FR-10, NFR-2, NFR-5, AD-1 through AD-7, UX-DR3, UX-DR5, UX-DR9, UX-DR10.