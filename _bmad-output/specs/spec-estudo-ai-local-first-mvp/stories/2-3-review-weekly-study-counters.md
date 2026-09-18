# Story 2-3:  Review Weekly Study Counters

Epic: 2 — Next Session and Daily Agenda
Source: `_bmad-output/planning-artifacts/epics.md` (Story 2.3)

As a student,
I want to see weekly counts of completed and Lost lessons on Home,
So that I can assess my recent study continuity at a glance.

## Acceptance Criteria

**Given** lifecycle events exist for the current local week
**When** Home loads
**Then** it shows separate labeled counters for completed and Lost Managed Lessons
**And** the counters are derived from locally persisted lifecycle data.

**Given** no completed or Lost Managed Lessons exist in the current week
**When** Home loads
**Then** each counter shows zero
**And** the zero state is not presented as an achievement or failure message.

**Given** the student activates a weekly counter
**When** the action is accepted
**Then** the application opens History filtered or positioned to the relevant outcome
**And** the counter itself does not become a chart, streak, badge, or notification.

**Given** lifecycle reconciliation changes a session outcome
**When** Home is refreshed through the application facade
**Then** the affected weekly counter reflects the persisted outcome
**And** no network access or external service is required.

**Given** the counters are displayed
**When** the student uses keyboard navigation or assistive technology
**Then** each counter has an accessible label and outcome count
**And** its meaning does not rely on color or visual position alone.

## References

FR-1, FR-13, FR-15, NFR-5, NFR-6, AD-1, AD-2, AD-7, AD-8, UX-DR1, UX-DR7, UX-DR10, UX-DR11.