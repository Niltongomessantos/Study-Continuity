# Story 3-4: Recover Active Sessions After Browser Interruption

Epic: 3 — Local Session Timing and Outcomes
Source: `_bmad-output/planning-artifacts/epics.md` (Story 3.4)

As a student,
I want an active Session to recover correctly after a reload, tab closure, browser suspension, or local restart,
So that interruption does not silently reset or falsify my study time.

## Acceptance Criteria

**Given** a Session was `Started` and its timestamps were committed
**When** the application is reopened after a reload, tab closure, suspension, or restart
**Then** it derives elapsed and remaining time from persisted timestamps and the injected Clock
**And** it does not restore an in-memory timer value.

**Given** an active Session reaches `plannedEndAt` while the browser is unavailable
**When** the application next opens or gains focus
**Then** reconciliation persists its terminal outcome before displaying the Session
**And** Home and History show the persisted result.

**Given** a Pending Session reaches the 50% tolerance deadline while the browser is unavailable
**When** the application next opens or serves a query
**Then** reconciliation records the Session as `Lost`
**And** Start remains unavailable.

**Given** an active Session is restored before `plannedEndAt`
**When** Session detail renders
**Then** it shows both elapsed and remaining time
**And** the display refresh does not create lifecycle events or change status.

**Given** recovery cannot read or persist required timing data
**When** the application tries to reconcile the Session
**Then** it shows an actionable local error
**And** it does not represent an uncommitted recovery result as final.

## References

FR-6, FR-8, FR-10, FR-14, FR-15, NFR-2, NFR-3, NFR-6, AD-2 through AD-9, UX-DR5, UX-DR9, UX-DR10.