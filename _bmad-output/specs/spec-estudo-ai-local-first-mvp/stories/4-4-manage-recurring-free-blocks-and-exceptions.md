# Story 4-4: Manage Recurring Free Blocks and Exceptions

Epic: 4 — Study Continuity and Materials
Source: `_bmad-output/planning-artifacts/epics.md` (Story 4.4)

As a student,
I want to schedule recurring Free Blocks and adjust one occurrence or the entire series,
So that I can maintain a flexible study routine without changing unrelated sessions.

## Acceptance Criteria

**Given** the student creates or updates a Free Block
**When** recurrence is enabled
**Then** the application stores the recurrence rule in the Local Domain
**And** recurrence behavior does not depend on an external calendar service.

**Given** a recurring Free Block has future occurrences
**When** the student changes one occurrence
**Then** the application stores a local occurrence exception
**And** it does not silently rewrite unrelated occurrences or the remaining series.

**Given** the student chooses to change the entire series
**When** the updated recurrence is saved
**Then** future occurrences are recalculated under the new local rule
**And** historical occurrences and their lifecycle records remain unchanged.

**Given** an occurrence has started, completed, or become Lost
**When** a recurrence change is requested
**Then** the application preserves that occurrence's timing and status history
**And** only eligible future occurrences are affected.

**Given** recurrence creation or an exception cannot be persisted
**When** the application attempts the change
**Then** it shows an actionable local error
**And** it does not leave partial recurrence or exception data.

**Given** the student configures recurrence by keyboard
**When** selecting recurrence options and scope
**Then** all controls have accessible labels and predictable focus order
**And** the selected scope is communicated with text, not color alone.

## References

FR-11, FR-14, FR-15, NFR-3, NFR-5, AD-1, AD-2, AD-8, AD-9, AD-12, UX-DR4, UX-DR6, UX-DR9, UX-DR10.