# Story 3-3: Stop a Study Session and Record Its Outcome

Epic: 3 — Local Session Timing and Outcomes
Source: `_bmad-output/planning-artifacts/epics.md` (Story 3.3)

As a student,
I want to stop an active Managed Lesson or Free Block,
So that the application records a consistent final result and preserves my study history.

## Acceptance Criteria

**Given** a Session is `Started` before its planned end
**When** the student activates Stop
**Then** the application records `stoppedAt` using the injected Clock
**And** calculates the completed proportion against `plannedDurationMs`.

**Given** the completed proportion is at least 50%
**When** Stop is committed
**Then** the Session transitions to `Completed`
**And** one terminal lifecycle event is stored atomically with the Session state.

**Given** the completed proportion is below 50%
**When** Stop is committed
**Then** the Session transitions to `Lost`
**And** the original Session remains available in history.

**Given** the student activates Stop more than once
**When** the Session is already `Completed` or `Lost`
**Then** the application returns the current state
**And** it does not overwrite `stoppedAt` or create another terminal lifecycle event.

**Given** a Managed Lesson or Free Block is stopped
**When** the outcome is shown in Session detail, Home, or History
**Then** the UI shows a textual status with recorded timing context
**And** status color remains supplementary.

**Given** an active Session is stopped after `plannedEndAt`
**When** the application processes the action
**Then** reconciliation resolves the terminal outcome before the Stop operation reads state
**And** Stop does not create a competing transition.

## References

FR-7, FR-8, FR-10, FR-15, NFR-2, NFR-3, NFR-5, AD-1 through AD-8, UX-DR3, UX-DR5, UX-DR9, UX-DR10.
