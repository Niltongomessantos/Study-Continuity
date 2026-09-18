# Story 4-3: Create a Replacement for a Lost Managed Lesson

Epic: 4 — Study Continuity and Materials
Source: `_bmad-output/planning-artifacts/epics.md` (Story 4.3)

As a student,
I want to create a replacement for an eligible Lost Managed Lesson,
So that I can reschedule the same study context without rewriting the original history.

## Acceptance Criteria

**Given** a Managed Lesson is `Lost` because it was not started or ended below the 50% rule
**When** the student opens its detail or history record
**Then** a replacement action is available
**And** the action is unavailable for `Completed`, `Incomplete`, or `Cancelled` Sessions.

**Given** the student chooses a replacement time from the local agenda
**When** the replacement is created
**Then** the application creates a new Session linked by an immutable `originatingSessionId`
**And** copies the original duration, objective, and material context.

**Given** a replacement is committed
**When** the original and replacement are viewed
**Then** the original remains `Lost` with its lifecycle history unchanged
**And** Home can promote the replacement as the next relevant Session.

**Given** the chosen replacement time conflicts with an existing local Session
**When** the student attempts to save
**Then** the application identifies the conflict before committing
**And** the original Lost Session remains unchanged.

**Given** replacement persistence fails
**When** the application attempts to create it
**Then** it shows an actionable local error
**And** it commits neither a partial replacement nor a broken replacement link.

## References

FR-9, FR-13, FR-15, NFR-3, NFR-5, AD-1, AD-2, AD-7, AD-8, AD-9, UX-DR3, UX-DR9, UX-DR10.