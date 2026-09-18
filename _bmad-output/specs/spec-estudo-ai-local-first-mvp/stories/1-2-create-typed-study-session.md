# Story 1-2: Create an Explicitly Typed Study Session

Epic: 1 — Local Study Foundation
Source: `_bmad-output/planning-artifacts/epics.md` (Story 1.2)

As a student,
I want to create a Managed Lesson or Free Block with the required schedule,
So that my next study action is stored locally and can appear in the agenda.

## Acceptance Criteria

**Given** the student opens Create Session
**When** choosing the session type
**Then** Managed Lesson and Free Block are explicit, mutually exclusive choices
**And** the session cannot be saved without one selected.

**Given** the student enters a planned time and duration
**When** saving a valid session
**Then** the application creates it through an application use case
**And** it persists the current Session state and initial lifecycle event atomically in IndexedDB.

**Given** the student omits planned time or duration
**When** attempting to save
**Then** the application prevents the save and identifies the missing fields
**And** entered values remain available for correction.

**Given** the student provides optional title, objective, material, link, or recurrence details
**When** saving the session
**Then** the details are associated with the local Session
**And** no external service, notification, or authorization is requested.

**Given** the session was saved successfully
**When** Home reloads local data
**Then** the session appears in the local agenda
**And** its explicit type and current status are visible without relying on color alone.

## References

FR-3, FR-4, FR-14, NFR-1, NFR-3, NFR-5, AD-1, AD-2, AD-8, AD-9, AD-12, UX-DR4, UX-DR9, UX-DR10.
