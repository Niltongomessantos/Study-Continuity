# Story 4-1: Attach and Open Study Materials

Epic: 4 — Study Continuity and Materials
Source: `_bmad-output/planning-artifacts/epics.md` (Story 4.1)

As a student,
I want to attach and open external links or local study files for a Session,
So that I can access the planned material without the app tracking my external progress.

## Acceptance Criteria

**Given** the student adds an external material link
**When** the URL uses `http` or `https`
**Then** the application stores the URL and material metadata with the local Session
**And** it rejects unsupported or unsafe URL schemes.

**Given** the student selects a local file explicitly
**When** the file size is 5 MB or less
**Then** the application stores its blob and metadata through the material and persistence adapters
**And** the file remains associated with the Session after reload.

**Given** the student selects a local file larger than 5 MB
**When** the application stores the material reference
**Then** it preserves metadata without persisting the blob
**And** it clearly indicates that the user must reselect the file to open it later.

**Given** the student opens an attached external link or stored local file
**When** the material is available
**Then** it opens through the browser's normal external-content path
**And** the application does not control or report progress in the external platform.

**Given** a material cannot be opened or a file reference requires reselection
**When** the failure is reported
**Then** the application shows an actionable material-access message
**And** it does not mutate the Session status, timing, or lifecycle history.

**Given** material controls are used with keyboard navigation
**When** the student activates or leaves a material action
**Then** focus remains predictable
**And** material status is communicated without relying only on color.

## References

FR-12, NFR-4, NFR-5, AD-1, AD-2, AD-9, AD-10, AD-12, UX-DR3, UX-DR8, UX-DR9, UX-DR10.