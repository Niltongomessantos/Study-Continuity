---
stepsCompleted:
  - step-01-validate-prerequisites
  - step-02-design-epics
  - step-03-create-stories
  - step-04-final-validation
inputDocuments:
  - _bmad-output/planning-artifacts/prds/prd-estudo AI-2026-09-15/prd.md
  - _bmad-output/specs/spec-estudo-ai-local-first-mvp/SPEC.md
  - _bmad-output/specs/spec-estudo-ai-local-first-mvp/domain-model.md
  - _bmad-output/planning-artifacts/architecture/architecture-estudo AI-2026-09-16/ARCHITECTURE-SPINE.md
  - _bmad-output/planning-artifacts/ux-designs/ux-estudo AI-2026-09-16/DESIGN.md
  - _bmad-output/planning-artifacts/ux-designs/ux-estudo AI-2026-09-16/EXPERIENCE.md
---

# estudo AI - Epic Breakdown

## Overview

This document inventories the approved MVP requirements for later decomposition into implementation epics and stories. The canonical product contract is the linked SPEC package; its architecture companion preserves AD-1 through AD-12 as binding invariants.

## Requirements Inventory

### Functional Requirements

FR-1: The student can see the next relevant Session with type, planned time, duration, status, material context, and state-appropriate action.

FR-2: The student can inspect past and upcoming Sessions for the current day and open their local records.

FR-3: The student must explicitly choose Managed Lesson or Free Block before saving a Session.

FR-4: The student can create a Session with required planned time and duration and optional title, objective, material, link, and recurrence details.

FR-5: The student can explicitly start a Pending Managed Lesson, recording a local start timestamp and entering Started state.

FR-6: The system marks a Pending Session Lost when it passes the global tolerance boundary and blocks Start afterward.

FR-7: The system preserves planned end time and distinguishes planned start from actual start; late arrival never extends the Session.

FR-8: The system records Managed Lesson completion or loss at Stop or planned end using the 50% planned-duration rule.

FR-9: The student can create a Replacement only for an eligible Lost Managed Lesson while retaining the original history and context.

FR-10: The student can start and stop a Free Block local timer, recording local attention time without controlling external content.

FR-11: The student can create recurring Free Blocks and change one occurrence or an entire series without silently rewriting unrelated occurrences.

FR-12: The student can attach and open external links, PDFs, and local file references without external-platform progress tracking.

FR-13: The student can inspect scheduled, active, completed, Lost, Rescheduled, and Cancelled Sessions in the local agenda without network access or notifications.

FR-14: The system stores and reloads Sessions, timing, materials, recurrence, replacements, and lifecycle records locally.

FR-15: The student can review lifecycle history, including original and replacement relationships, without losing prior events after manual adjustment.

### NonFunctional Requirements

NFR-1: The application runs locally in a desktop/laptop browser and does not require cloud hosting, network access, or external authorization for core workflows.

NFR-2: Committed local records survive normal browser reloads; timer state is recovered from persisted timestamps after tab closure, suspension, or restart.

NFR-3: Local persistence, validation, timer recovery, and Session lifecycle failures are actionable and never reported as successful commits.

NFR-4: External links and local file references are validated under the browser security model; content is treated as inert data.

NFR-5: Core creation, Start, Stop, replacement, local agenda, material access, and history workflows are keyboard accessible; status is not conveyed by color alone.

NFR-6: The next-session view loads from local data without network access and remains understandable when material is unavailable.

NFR-7: The MVP is a single-user, single-active-tab experience. Cross-tab coordination is out of scope.

NFR-8: The MVP sends no application, browser, operating-system, or external-service notifications.

### Additional Requirements

- Use a lean hexagonal modular monolith: React UI, application facade/use cases, Local Domain, and browser adapters.
- Preserve AD-1 through AD-12 from `ARCHITECTURE-SPINE.md` without renumbering or weakening them.
- UI queries and mutations enter through an application facade; reconcile affected Sessions before every query or mutation reads state.
- Use IndexedDB only behind a persistence port; commit current Session state and lifecycle events atomically in one transaction.
- Persist planned and actual timestamps with millisecond precision. The injected Clock, not a UI interval, establishes time truth.
- Apply `toleranceDeadline = plannedStartAt + (plannedDurationMs * 0.5)` to Managed Lessons and Free Blocks. At or after the deadline, reconcile Pending to Lost and block Start.
- Start and Stop are idempotent. A browser display interval refreshes only elapsed and remaining time.
- Preserve lifecycle events and immutable replacement links; reject dangling or cyclic replacement references on import.
- Store validated `http`/`https` material links and metadata. Store local blobs only after explicit selection and only up to 5 MB per file; larger files require reselection.
- Export and import versioned JSON with stable IDs and timestamps. Validate schema, duplicate IDs, material limits, and replacement links before atomically replacing all state.
- Use TypeScript, React, Vite, and a local development/build server. Exact TypeScript and React versions remain deferred until the starter is created.

### UX Design Requirements

UX-DR1: Implement a desktop/laptop Home surface with a visually dominant next Session and lower-emphasis same-day agenda plus weekly completed and Lost counters.

UX-DR2: Present an explicit no-scheduled-Session state while retaining the daily agenda and a clear create-session action.

UX-DR3: Provide a Session detail surface with type, title, planned time, duration, status, material context, and state-appropriate Start or Stop controls.

UX-DR4: Provide an explicit mutually exclusive type selector for Managed Lesson and Free Block, and require planned time plus duration in the create-session form.

UX-DR5: Display elapsed and remaining time for Started Sessions without stealing keyboard focus.

UX-DR6: Keep past and upcoming agenda rows consult-only; no agenda edit or reschedule control is included in the MVP.

UX-DR7: Provide weekly labeled counters for completed and missed lessons, without charts, streaks, achievement badges, or gamified language.

UX-DR8: Provide explicit material-link behavior that opens in the user's browser without claiming external progress tracking.

UX-DR9: Support local loading, persistence-failure, material-unavailable, browser-interruption, Pending, Started, Completed, Lost, and empty states without network, OAuth, sync, or notification UI.

UX-DR10: Preserve keyboard access, reading-order focus traversal, visible focus indicators, text-based status communication, non-disruptive timer updates, and dialog focus management.

UX-DR11: Use the DESIGN.md token baseline for neutral surfaces, restrained primary action emphasis, textual status, stable timer controls, and no Google Calendar or notification branding.

### FR Coverage Map

FR-1: Epic 2 - Next Session and Daily Agenda.

FR-2: Epic 2 - Next Session and Daily Agenda.

FR-3: Epic 1 - Local Study Foundation.

FR-4: Epic 1 - Local Study Foundation.

FR-5: Epic 3 - Local Session Timing and Outcomes.

FR-6: Epic 3 - Local Session Timing and Outcomes.

FR-7: Epic 3 - Local Session Timing and Outcomes.

FR-8: Epic 3 - Local Session Timing and Outcomes.

FR-9: Epic 4 - Study Continuity and Materials.

FR-10: Epic 3 - Local Session Timing and Outcomes.

FR-11: Epic 4 - Study Continuity and Materials.

FR-12: Epic 4 - Study Continuity and Materials.

FR-13: Epic 2 - Next Session and Daily Agenda.

FR-14: Epic 1 - Local Study Foundation.

FR-15: Epic 4 - Study Continuity and Materials.

## Epic List

### Epic 1: Local Study Foundation

The student can open a reliable local application and create a first explicitly typed Session that persists locally.

**FRs covered:** FR-3, FR-4, FR-14.

**Implementation notes:** Establish the React/Vite starter, lean hexagonal boundaries, IndexedDB persistence port, Clock port, atomic lifecycle persistence, local validation, and keyboard-accessible creation.

### Epic 2: Next Session and Daily Agenda

The student can understand the next study action and inspect same-day continuity from a local desktop Home experience.

**FRs covered:** FR-1, FR-2, FR-13.

**Implementation notes:** Deliver the Home surface, no-scheduled-Session state, consult-only agenda rows, Session detail entry points, weekly completed and Lost counters, local loading/error states, and UX token baseline.

### Epic 3: Local Session Timing and Outcomes

The student can start and stop Managed Lessons and Free Blocks under consistent local timing, tolerance, and outcome rules.

**FRs covered:** FR-5, FR-6, FR-7, FR-8, FR-10.

**Implementation notes:** Use persisted timestamps, global 50% tolerance, fixed planned end, idempotent Start/Stop, elapsed and remaining display, reconciliation on observation and mutation, recovery after interruption, and lifecycle events.

### Epic 4: Study Continuity and Materials

The student can recover from missed lessons, use study materials, manage recurring Free Blocks, preserve history, and back up local study data.

**FRs covered:** FR-9, FR-11, FR-12, FR-15.

**Implementation notes:** Deliver eligible replacements, recurrence and occurrence exceptions, safe external/local material behavior, 5 MB blob policy, auditable history, and validate-before-replace JSON backup/import.

## Epic 1: Local Study Foundation

The student can open a reliable local application and create a first explicitly typed Session that persists locally.

### Story 1.1: Initialize the Local Study Application

As a student,
I want to open the Study AI application locally in my desktop/laptop browser,
So that I can use the study workspace without cloud access, authorization, or external services.

**Acceptance Criteria:**

**Given** the project has not yet been initialized
**When** a developer starts the documented local development command
**Then** the React and Vite application opens in a desktop/laptop browser through a local server
**And** no backend, cloud service, OAuth flow, notification permission, or Google Calendar integration is required.

**Given** the application opens for the first time
**When** the persistence adapter initializes
**Then** the IndexedDB schema is initialized through the persistence port
**And** the UI does not access IndexedDB directly.

**Given** the application is loading local data
**When** initialization is still in progress
**Then** Home displays stable loading regions without shifting the main layout 
**And** no network request is required to complete loading.

**Given** local persistence initialization fails
**When** Home is opened
**Then** the application shows an actionable persistence error
**And** it does not claim that local data was loaded or saved.

**Given** a user navigates the initial Home surface by keyboard
**When** focus moves through available controls
**Then** focus indicators are visible and follow reading order
**And** status is not conveyed by color alone.

**References:** FR-14, NFR-1, NFR-3, NFR-5, NFR-6, AD-1, AD-2, AD-9, AD-12, UX-DR9 through UX-DR11.

### Story 1.2: Create an Explicitly Typed Study Session

As a student,
I want to create a Managed Lesson or Free Block with the required schedule,
So that my next study action is stored locally and can appear in the agenda.

**Acceptance Criteria:**

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

**References:** FR-3, FR-4, FR-14, NFR-1, NFR-3, NFR-5, AD-1, AD-2, AD-8, AD-9, AD-12, UX-DR4, UX-DR9, UX-DR10.

### Story 1.3: Restore Local Study Sessions

As a student,
I want my previously committed sessions to return when I reopen the local application,
So that my study schedule is not lost after a browser reload or interruption.

**Acceptance Criteria:**

**Given** sessions were successfully committed locally
**When** the application is reopened or reloaded
**Then** it loads Sessions, status, planned schedule, timing data, recurrence, replacement links, materials, and lifecycle events from IndexedDB
**And** the restored data is available through the application facade.

**Given** a persisted record is malformed or cannot be read
**When** the application attempts restoration
**Then** the affected failure is surfaced as an actionable local persistence error
**And** the application does not silently claim the record was restored.

**Given** persisted sessions include no external configuration
**When** restoration completes
**Then** the application operates without network access, OAuth, sync state, or notification setup
**And** no external service is contacted.

**Given** a user returns to the initial Home view after restoration
**When** the UI renders restored data
**Then** it preserves keyboard access and status text
**And** it does not access IndexedDB directly.

**References:** FR-14, NFR-1, NFR-2, NFR-3, NFR-5, NFR-6, NFR-7, AD-1, AD-2, AD-3, AD-9, AD-12, UX-DR9, UX-DR10.

## Epic 2: Next Session and Daily Agenda

The student can understand the next study action and inspect same-day continuity from a local desktop Home experience.

### Story 2.1: Show the Next Local Study Session

As a student,
I want Home to show my next relevant local Session,
So that I immediately know what to study and when.

**Acceptance Criteria:**

**Given** one or more future local Sessions exist
**When** the student opens Home
**Then** the earliest relevant Session is shown as the dominant primary surface
**And** it shows type, title or fallback label, planned time, duration, status, material context, and available action.

**Given** the student activates the primary Session by mouse or keyboard
**When** the action is accepted
**Then** Session detail opens through the application facade
**And** the UI does not mutate or query IndexedDB directly.

**Given** no future Session exists
**When** Home loads
**Then** it states that no Session is scheduled
**And** it retains the daily agenda and clear Create Session action.

**Given** the application reconciles persisted Sessions before reading Home data
**When** a Pending or Started Session has crossed a timing boundary
**Then** Home reflects the reconciled status
**And** the primary surface promotes the next valid Session when applicable.

**Given** Home displays a Session status
**When** the user views it with any supported input mode
**Then** text and structure communicate the status
**And** color is supplementary only.

**References:** FR-1, FR-13, NFR-5, NFR-6, AD-1, AD-2, AD-7, UX-DR1 through UX-DR3, UX-DR9 through UX-DR11.

### Story 2.2: Inspect Daily Session Continuity

As a student,
I want to inspect past and upcoming Sessions for the current day,
So that I can understand my study continuity without leaving Home.

**Acceptance Criteria:**

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

**References:** FR-2, FR-13, NFR-5, NFR-6, AD-1, AD-2, AD-7, UX-DR1, UX-DR2, UX-DR6, UX-DR9, UX-DR10, UX-DR11.

### Story 2.3: Review Weekly Study Counters

As a student,
I want to see weekly counts of completed and Lost lessons on Home,
So that I can assess my recent study continuity at a glance.

**Acceptance Criteria:**

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

**References:** FR-1, FR-13, FR-15, NFR-5, NFR-6, AD-1, AD-2, AD-7, AD-8, UX-DR1, UX-DR7, UX-DR10, UX-DR11.

## Epic 3: Local Session Timing and Outcomes

The student can start and stop Managed Lessons and Free Blocks under consistent local timing, tolerance, and outcome rules.

### Story 3.1: Reconcile Session Time and Loss

As a student,
I want overdue Sessions to be reconciled automatically from their saved timing data,
So that the agenda and history show the correct local state after time passes or the browser is interrupted.

**Acceptance Criteria:**

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

**References:** FR-6, FR-8, FR-10, FR-13, FR-14, NFR-2, NFR-3, NFR-6, AD-1, AD-2, AD-3, AD-4, AD-5, AD-7, AD-8, AD-9, UX-DR5, UX-DR9.

### Story 3.2: Start a Local Study Session

As a student,
I want to start a Pending Managed Lesson or Free Block within its allowed time,
So that the application records the actual start and begins local study timing.

**Acceptance Criteria:**

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

**References:** FR-5, FR-6, FR-7, FR-10, NFR-2, NFR-5, AD-1 through AD-7, UX-DR3, UX-DR5, UX-DR9, UX-DR10.

### Story 3.3: Stop a Study Session and Record Its Outcome

As a student,
I want to stop an active Managed Lesson or Free Block,
So that the application records a consistent final result and preserves my study history.

**Acceptance Criteria:**

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

**References:** FR-7, FR-8, FR-10, FR-15, NFR-2, NFR-3, NFR-5, AD-1 through AD-8, UX-DR3, UX-DR5, UX-DR9, UX-DR10.

### Story 3.4: Recover Active Sessions After Browser Interruption

As a student,
I want an active Session to recover correctly after a reload, tab closure, browser suspension, or local restart,
So that interruption does not silently reset or falsify my study time.

**Acceptance Criteria:**

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

**References:** FR-6, FR-8, FR-10, FR-14, FR-15, NFR-2, NFR-3, NFR-6, AD-2 through AD-9, UX-DR5, UX-DR9, UX-DR10.

## Epic 4: Study Continuity and Materials

The student can recover from missed lessons, use study materials, manage recurring Free Blocks, preserve history, and back up local study data.

### Story 4.1: Attach and Open Study Materials

As a student,
I want to attach and open external links or local study files for a Session,
So that I can access the planned material without the app tracking my external progress.

**Acceptance Criteria:**

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

**References:** FR-12, NFR-4, NFR-5, AD-1, AD-2, AD-9, AD-10, AD-12, UX-DR3, UX-DR8, UX-DR9, UX-DR10.

### Story 4.2: Review Local Session History

As a student,
I want to review past Sessions and their lifecycle outcomes,
So that I can understand completed, Lost, replaced, and adjusted study work without losing the original record.

**Acceptance Criteria:**

**Given** locally persisted lifecycle events exist
**When** the student opens History from Home or a weekly counter
**Then** the application shows Session outcomes including `Completed`, `Lost`, `Incomplete`, `Rescheduled`, and `Cancelled`
**And** the data is read through the application facade.

**Given** a Lost Managed Lesson has a Replacement
**When** the student views either Session in History
**Then** the original and replacement relationship is visible
**And** the original Lost outcome and lifecycle events remain auditable.

**Given** a Session has been manually adjusted
**When** the student reviews its history
**Then** the prior lifecycle event remains present
**And** the adjustment does not erase earlier outcome information.

**Given** there are no historical Sessions
**When** the student opens History
**Then** the application presents an explicit empty-history state
**And** it provides a route back to Home without introducing gamified language.

**Given** the student navigates History by keyboard
**When** they move through records or open a Session detail
**Then** focus order is predictable and status is textual
**And** all interactive controls have accessible names.

**References:** FR-9, FR-15, NFR-3, NFR-5, AD-1, AD-2, AD-8, AD-9, UX-DR7, UX-DR9, UX-DR10.

### Story 4.3: Create a Replacement for a Lost Managed Lesson

As a student,
I want to create a replacement for an eligible Lost Managed Lesson,
So that I can reschedule the same study context without rewriting the original history.

**Acceptance Criteria:**

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

**References:** FR-9, FR-13, FR-15, NFR-3, NFR-5, AD-1, AD-2, AD-7, AD-8, AD-9, UX-DR3, UX-DR9, UX-DR10.

### Story 4.4: Manage Recurring Free Blocks and Exceptions

As a student,
I want to schedule recurring Free Blocks and adjust one occurrence or the entire series,
So that I can maintain a flexible study routine without changing unrelated sessions.

**Acceptance Criteria:**

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

**References:** FR-11, FR-14, FR-15, NFR-3, NFR-5, AD-1, AD-2, AD-8, AD-9, AD-12, UX-DR4, UX-DR6, UX-DR9, UX-DR10.

### Story 4.5: Back Up and Restore Local Study Data

As a student,
I want to export and restore my local study data through a validated backup file,
So that I can recover my schedule and history if browser storage is lost.

**Acceptance Criteria:**

**Given** local study data exists
**When** the student exports a backup
**Then** the application generates versioned JSON containing `schemaVersion`, stable IDs, timestamps, Sessions, lifecycle events, recurrence, replacements, material metadata, and eligible file blobs
**And** files larger than 5 MB remain metadata-only and require reselection after restore.

**Given** the student selects a valid backup file
**When** import validation completes
**Then** the application verifies the schema version, duplicate IDs, material limits, dangling replacement references, and cyclic replacement links
**And** it shows validation errors before replacing any local state.

**Given** a backup passes all validation
**When** the student confirms restoration
**Then** the application atomically replaces all local IndexedDB state
**And** it does not merge imported records with existing local records.

**Given** a backup is malformed or fails validation
**When** the student attempts restoration
**Then** the application shows an actionable import error
**And** the existing local state remains unchanged.

**Given** restore succeeds
**When** the student returns to Home or History
**Then** restored Sessions, timing records, lifecycle history, recurrence, replacements, and material metadata are available through the application facade
**And** the application remains usable without network access, authorization, or notifications.

**Given** export or import controls are used by keyboard
**When** the student starts, cancels, or completes the operation
**Then** focus handling and status feedback are accessible
**And** no browser, operating-system, or external-service notification is required.

**References:** FR-14, FR-15, NFR-1, NFR-2, NFR-3, NFR-5, AD-1, AD-2, AD-8, AD-9, AD-10, AD-11, AD-12, UX-DR9, UX-DR10.
