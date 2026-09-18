---
title: Study Continuity Local-First Web App
status: final
created: 2026-09-15
updated: 2026-09-15
---

# PRD: Study Continuity Local-First Web App
*[ASSUMPTION: “Study Continuity” is a provisional working title; confirm before implementation.]*

## 0. Document Purpose

This PRD defines the product intent, MVP scope, user journeys, business rules, and testable functional requirements for a browser-accessed local-first study application. It is intended for product, UX, architecture, and story-planning work. It is based on the hardened idea, brainstorming artifact, and current technical research listed in the source register below. Technical mechanism details that do not belong in product requirements are retained in `addendum.md`.

### Source register

- Primary: `_bmad-output/forge/app-estudos-local-google-calendar-2026-09-15/forged-idea.md`
- Primary: `_bmad-output/brainstorming/brainstorm-app-de-estudos-unificado-2026-09-14/brainstorm-intent.md`
- Primary: `_bmad-output/planning-artifacts/research/technical-web-local-google-calendar-2026-09-14/research.md`
- Complementary: `_bmad-output/forge/app-estudos-local-google-calendar-2026-09-15/forge-report.html`
- Excluded: superseded desktop research.

## 1. Vision

Study Continuity is a local-first web application that helps a student know what to study next, when to study it, and how a study session ended. It brings study schedules, materials, external links, session timing, and history into one local domain without attempting to become a generic productivity planner or to control external learning platforms.

The application is accessed directly through a browser and is hosted locally for the MVP. Its local domain owns study continuity, session status, timing rules, rescheduling, and history. The MVP is self-contained for study planning and session continuity and does not depend on external calendars or notification services.

The product thesis is that continuity improves when the next step, its timing, its material, and its session outcome are visible in one focused place. The MVP therefore prioritizes scheduling and session discipline over deep content management, AI tutoring, or broad platform integrations.

## 2. Target User

### 2.1 Jobs To Be Done

- Organize study sessions across courses, videos, PDFs, playlists, and external platforms.
- Know the next study action without reconstructing a plan from several places.
- Know when the next study session is scheduled by consulting the local study agenda.
- Start a planned session and have its timing and outcome recorded consistently.
- Distinguish a managed lesson from a free study block.
- Recover from a missed session without losing the original duration, objective, or material context.
- Review past and upcoming sessions to maintain continuity.

### 2.2 Non-Users (v1)

- Students who require institutional multi-user administration.
- Users expecting the application to track progress inside third-party learning platforms.
- Users expecting local or browser push notifications.
- Users looking for an AI tutor, a mobile application, a cloud planner, or a general-purpose task manager.

### 2.3 Key User Journeys

- **UJ-1. Alex creates the next study step.**
  - **Persona + context:** Alex studies across several external platforms and needs a predictable schedule.
  - **Entry state:** Alex is using the local application in a browser.
  - **Path:** Alex creates a session, explicitly chooses Managed Lesson or Free Block, enters the required time and duration, and optionally adds material or a link.
  - **Climax:** The local application shows the new session as the next step in the study agenda.
  - **Resolution:** Alex has one local session record, a visible status, and a scheduled time available in the local agenda.
  - **Edge case:** The local session remains available after browser reload or temporary application interruption.

- **UJ-2. Alex completes a managed lesson.**
  - **Persona + context:** Alex has a scheduled lesson with a defined duration and objective.
  - **Entry state:** The lesson is pending and visible in the next-session view.
  - **Path:** Alex opens the session, optionally opens its material, and presses Start. The local timer begins immediately. The application records late arrival without compensating lost time.
  - **Climax:** At the configured end, the application marks the lesson completed automatically, subject to the defined minimum-validity rule.
  - **Resolution:** The history records the outcome and the next step is recalculated.
  - **Edge case:** If Alex does not start within tolerance, the lesson becomes lost and only then may be offered for replacement.

- **UJ-3. Alex uses a free study block.**
  - **Persona + context:** Alex wants time for a video, lecture, course, or external material whose internal progress the application cannot control.
  - **Entry state:** A recurring Free Block is scheduled with optional external material.
  - **Path:** Alex starts the local timer, opens the external material in the browser or on the computer, and returns to see the elapsed local study time and session status.
  - **Climax:** The application records the attention time without claiming knowledge of progress in the external platform.
  - **Resolution:** The block outcome is available in local history and the next local study step is recalculated.

- **UJ-4. Alex recovers from a missed lesson.**
  - **Persona + context:** Alex did not start a Managed Lesson within its tolerance window.
  - **Entry state:** The local domain has marked the lesson Lost.
  - **Path:** Alex opens the lost lesson, reviews its original duration, objective, and material, and chooses a locally available replacement time.
  - **Climax:** The application creates a replacement session without silently changing the original history.
  - **Resolution:** The original remains Lost, the replacement is linked to it, and the local agenda is updated only after the replacement is committed.

## 3. Glossary

- **Local Domain** - The application-owned source of truth for study sessions, timing, statuses, history, recurrence, and replacement rules.
- **Managed Lesson** - A session whose start, timing, status, and study continuity impact are governed by the Local Domain.
- **Free Block** - A scheduled study period where the application measures local attention time but does not control external content or platform progress.
- **Session** - A scheduled instance of either a Managed Lesson or a Free Block.
- **Tolerance Window** - The allowed period after the planned start during which a Session may be started before being marked Lost.
- **Replacement** - A new Session offered after a Managed Lesson is not started or is Lost; it preserves the original lesson context.
- **Session Status** - The Local Domain state of a Session, including Pending, Started, Completed, Lost, Incomplete, Rescheduled, or Cancelled.

## 4. Features

### 4.1 Next Step and Study Agenda

**Description:** The application presents the next Session prominently and provides context from earlier and upcoming Sessions on the same day. It emphasizes continuity rather than a generic calendar-first experience. Realizes UJ-1, UJ-2, UJ-3, and UJ-4.

**Functional Requirements:**

#### FR-1: Show the next study step

The student can open the application and immediately see the next relevant Session, its type, planned time, duration, status, and available material context.

**Consequences (testable):**
- The initial study surface identifies one next Session when one exists.
- The next-session view shows whether the Session is a Managed Lesson or Free Block.
- The view exposes the Session status and the action available at that state.

#### FR-2: Show daily continuity context

The student can inspect past and upcoming Sessions for the current day without losing the next-step context.

**Consequences (testable):**
- Past Sessions retain their recorded Session Status.
- Upcoming Sessions are distinguishable from completed or Lost Sessions.
- Selecting a Session opens its local record and available actions.

### 4.2 Session Creation and Classification

**Description:** Every new Session is explicitly classified as a Managed Lesson or Free Block. Creation requires the minimum scheduling information while allowing material and detailed content to be added later. Realizes UJ-1.

#### FR-3: Require explicit Session type

The student can create a Session only after choosing Managed Lesson or Free Block.

**Consequences (testable):**
- The creation flow presents both types as explicit choices.
- A Session cannot be saved without a type.
  - The stored type is explicit and cannot be inferred from external services.

#### FR-4: Create the minimum scheduled record

The student can create a Session with planned time and duration, then add optional title, objective, material, link, and recurrence details when applicable.

**Consequences (testable):**
- Planned time and duration are required for saving a Session.
- Optional details can be added or edited after creation.
  - The initial Session is stored in the Local Domain before it appears in the local agenda.

### 4.3 Managed Lesson Lifecycle

**Description:** A Managed Lesson is controlled by local business rules for starting, timing, completion, loss, and replacement. The local timer starts only when the student presses Start. Realizes UJ-2 and UJ-4.

#### FR-5: Start a Managed Lesson explicitly

The student can start a pending Managed Lesson by pressing Start.

**Consequences (testable):**
- Pressing Start records a local start timestamp.
- Pressing Start changes the Session Status to Started.
- The local timer begins immediately from the recorded start action.

#### FR-6: Enforce the Tolerance Window

The system marks a Managed Lesson Lost when it is not started within its Tolerance Window.

**Consequences (testable):**
- A Session outside its Tolerance Window cannot be started as an on-time lesson.
  - The Local Domain records the Lost outcome independently of network access or external services.
- A Lost Session remains visible in history.

#### FR-7: Preserve late-arrival timing

The system records late arrival without compensating the lost scheduled time.

**Consequences (testable):**
- The planned end is not extended automatically because the student starts late.
- The recorded planned time and actual start time remain distinguishable.
- The duration used by completion rules is derived from the defined product rule, not silently extended.

#### FR-8: Complete or lose a Managed Lesson

The system completes a Managed Lesson automatically when its configured time ends, while applying the minimum-validity rule and the interruption rule defined by the product.

**Consequences (testable):**
- A normally running lesson reaches Completed at its configured end when the minimum-validity rule is satisfied.
- An interrupted lesson is recorded as Lost unless the approved 30-minute exception applies.
- The lesson can be adjusted manually after the event without deleting the original history.
  - The Local Domain records the final Session Status independently of external services.

**Notes:** The 50% minimum-validity rule applies to every Managed Lesson regardless of duration. If an interrupted lesson has completed at least 50% of its planned duration, it may be recorded as Completed; otherwise it is Lost.

#### FR-9: Offer replacement for eligible lessons

The student can request a Replacement only for a Managed Lesson that was not started or was marked Lost.

**Consequences (testable):**
- Completed, Incomplete, or Cancelled Sessions do not automatically create a Replacement.
- A Replacement preserves the original duration, objective, and material context.
- The original Session remains in history and is linked to the Replacement.
  - Replacement scheduling uses availability represented in the local agenda and does not depend on external services.

### 4.4 Free Block Timing and Recurrence

**Description:** A Free Block provides a local time container for studying external content. It may include links, materials, recurrence, and manual occurrence exceptions, but it does not control the external platform or claim external progress. Realizes UJ-3.

#### FR-10: Run a local Free Block timer

The student can start a Free Block timer and record local attention time.

**Consequences (testable):**
- Starting a Free Block records a local start timestamp and changes its status.
- The timer measures time in the Local Domain and does not depend on the external platform.
- The Free Block does not write progress or completion data to an external learning platform.

#### FR-11: Manage recurring Free Blocks

The student can create a recurring Free Block and change one occurrence or the entire series. `[ASSUMPTION: recurrence is owned by the Local Domain and does not depend on an external calendar.]`

**Consequences (testable):**
- Recurrence is represented in the Local Domain.
- An occurrence exception does not silently rewrite unrelated occurrences.
- Pausing, finalizing, or releasing a recurring schedule is visible locally.

### 4.5 Materials and External Access

**Description:** The application stores references to external courses, videos, playlists, PDFs, and local files while keeping the external content outside the product domain. Realizes UJ-1 and UJ-3.

#### FR-12: Attach and open study material

The student can associate optional links, external references, PDFs, or local file references with a Session and open them through the normal browser or computer path.

**Consequences (testable):**
- A Session can exist without material.
- Opening material does not imply that the external platform has reported progress.
- The application preserves the Session and its local status if the external material cannot be opened.

### 4.6 Local Agenda and Scheduled Sessions

**Description:** The application presents scheduled Sessions through the local study agenda. The agenda is the MVP mechanism for consulting planned study times and does not send notifications or depend on external calendar services.

#### FR-13: Show scheduled Sessions in the local agenda

The student can inspect scheduled, active, completed, Lost, Rescheduled, and Cancelled Sessions in the local agenda.

**Consequences (testable):**
- Scheduled Sessions show their planned time, duration, type, status, and available material context.
- The local agenda remains usable without network access or external service authorization.
- The application does not send local, browser, operating-system, or external-service notifications.

### 4.7 Local Persistence and Session History

**Description:** The Local Domain persists scheduling, Session lifecycle, history, recurrence, and replacement relationships locally. It is the authority for study behavior.

#### FR-14: Persist the Local Domain

The system can store and reload Sessions, Session Status, timing records, materials, recurrence, and replacements locally.

**Consequences (testable):**
- Reloading the application preserves committed local records.
- Session history remains available after a browser reload or local interruption.

#### FR-15: Show lifecycle history

The student can review past Sessions and their outcomes, including Completed, Lost, Incomplete, Rescheduled, and Cancelled states.

**Consequences (testable):**
- History distinguishes original Sessions from Replacements.
- A Session marked Lost because it was not started remains auditable.
- Manual adjustments do not erase the prior lifecycle event.

## 5. Non-Functional Requirements

### 5.1 Local operation and reliability

- The application must run through a browser in the local MVP environment and keep the Local Domain available without cloud hosting.
- Committed local changes must survive normal browser reloads.
- The application must expose actionable errors for local persistence, timer recovery, and invalid Session operations.

### 5.2 Security and privacy

- The application must keep the local service bound to loopback in the MVP.
- External links and local file references must be validated according to the selected runtime and browser security model.

### 5.3 Accessibility and usability

- Core Session creation, Start, rescheduling, local agenda, and history actions must be keyboard accessible.
- Session type and status must not be conveyed by color alone.
- The next-step surface must remain understandable when material is unavailable.

### 5.4 Performance and observability

- The next-step view should load directly from local data without network access.
- Local errors must expose enough state to diagnose persistence, timer, validation, and Session lifecycle failures.
- `[ASSUMPTION: specific latency budgets are deferred to architecture because the MVP is single-user and local.]`

## 6. Constraints and Guardrails

### 6.1 Product constraints

- Local browser access and local hosting are the MVP deployment model.
- The Local Domain is authoritative.
- The MVP sends no notifications through the application, browser, operating system, or external services.
- The local agenda is the only MVP mechanism for consulting planned study times.
- Google Calendar integration is deferred to post-MVP.
- The MVP is not a generic planner, AI tutor, mobile application, cloud service, or external-platform automation layer.

### 6.2 Data and recovery guardrails

- The product must define a backup and recovery path before implementation because browser-local data can be lost through browser storage clearing or environment failure.

## 7. Non-Goals (Explicit)

- Desktop installation or a desktop wrapper.
- Local operating-system notifications or browser notifications.
- Google Calendar integration in the MVP.
- Notifications through the application, browser, operating system, or external services.
- External calendar synchronization or account authorization in the MVP.
- Progress tracking inside external learning platforms.
- AI tutoring or automated content generation.
- Mobile application support.
- Cloud hosting in the MVP.
- Multiple Google accounts or broad third-party integrations.
- Iframes or webviews as the default external-content path.
- A generic productivity planner without a continuity-of-study focus.

## 8. MVP Scope

### 8.1 In Scope

- Local browser application and local hosting workflow.
- Next-step agenda with same-day history and upcoming context.
- Explicit creation of Managed Lessons and Free Blocks.
- Planned time and duration as required Session fields.
- Managed Lesson lifecycle: start, local timing, tolerance, loss, completion, interruption, and eligible replacement.
- Free Block local timer, external material reference, recurrence, and occurrence exceptions.
- Materials and links without external-platform progress control.
- Local Session history and lifecycle statuses.
- Local persistence as the source of truth.

### 8.2 Out of Scope for MVP

- Cloud hosting and multi-user operation; deferred until local behavior is validated.
- AI tutor; deferred because continuity and scheduling are the core thesis.
- Mobile application; deferred until the browser workflow is validated.
- Deep material management and curriculum tracking; deferred to avoid shifting the MVP away from continuity.
- External learning-platform integrations or automated progress collection; excluded because external content remains outside the Local Domain.
- Google Calendar integration, including OAuth, event projection, reminders, synchronization, and retry handling; deferred to post-MVP.
- Local, browser, or operating-system notifications; deferred to post-MVP.
- Multiple Google accounts and broad third-party integrations.
- Advanced recurrence semantics beyond the local Session model.

## 9. Success Metrics

These metrics are intentionally lightweight for a personal-use MVP and should be revisited if the product moves toward launch.

### Primary

- **SM-1:** The student can identify the next Session and its required action from the initial view. Validates FR-1, FR-2, and FR-3.
- **SM-2:** The student can complete a full Session lifecycle while preserving local history across browser reloads and local interruptions. Validates FR-5 through FR-9 and FR-14.

### Secondary

- **SM-4:** A Free Block records local attention time without claiming progress in external platforms. Validates FR-10 through FR-12.
- **SM-5:** A missed Managed Lesson can be reviewed and replaced without mutating the original history. Validates FR-6, FR-9, and FR-15.

### Counter-metrics

- **SM-C1:** Do not optimize for the number of features, integrations, or calendar events created; feature breadth must not reduce clarity of the next study step.
- **SM-C2:** Do not optimize for automated completion rate by weakening the explicit Start action or the local lifecycle rules.

## 10. Risks and Mitigations

- **Local data loss:** Provide export/import or an explicit backup strategy before relying on the application for long-term history.
- **Variable session durations:** Apply the 50% minimum proportionally so that short and long sessions follow the same rule.
- **Planner dilution:** Keep every MVP feature tied to next step, schedule, session timing, or continuity; do not reintroduce notification or calendar integration scope.
- **Missed sessions without notifications:** Make the next local Session and its planned time immediately visible in the initial view.
- **Browser lifecycle limitations:** Ensure timer state is persisted as events and timestamps, not only held in volatile UI state.

## 11. Dependencies

- Local browser persistence strategy and recovery mechanism.
- Local agenda and Session lifecycle rules.
- Timer recovery after tab closure, browser suspension, or local process restart.
- Backup/export and recovery strategy for local data.

## 12. Open Questions

1. What is the exact default Tolerance Window, and is it configurable per Managed Lesson or global for MVP?
2. What should happen when a Managed Lesson is started after tolerance: immediate Lost status, or a blocked start with a replacement action?
3. Which local persistence strategy will be selected: browser SQLite/WASM plus OPFS, a local backend with SQLite, or another option?
4. What is the explicit backup/export and recovery flow for local data?
5. Should a Free Block ending automatically be Completed, Incomplete, or simply Closed when the timer stops?
6. How should the local agenda represent overdue Sessions when no notification channel exists?
7. Which local agenda view is sufficient for the first MVP: next Session only, daily agenda, or both?
8. What product name should replace the working title “Study Continuity”?

## 13. Assumptions Index

- `[ASSUMPTION: specific latency budgets are deferred to architecture because the MVP is single-user and local.]` — §5.4.
- `[ASSUMPTION: the product name “Study Continuity” is provisional.]` — document purpose and §12.
- `[ASSUMPTION: recurrence is owned by the Local Domain and does not depend on an external calendar.]` — §4.4, FR-11.

## 14. High-Level Acceptance Criteria

- A student can create a Session only after choosing Managed Lesson or Free Block.
- The student can see the next Session and its status from the initial local view.
- Starting a Managed Lesson or Free Block records a local start and begins local timing.
- A Managed Lesson not started within its Tolerance Window becomes Lost according to the Local Domain.
- Late arrival does not automatically extend the planned duration.
- Managed Lesson completion, interruption, loss, and eligible replacement remain in local history.
- Free Blocks measure local attention time without controlling external platform content or progress.
- The local agenda shows planned Sessions without requiring network access or external authorization.
- The MVP sends no local, browser, operating-system, or external-service notifications.
- Local persistence, backup/recovery, and the 50% session-validity rule are resolved before architecture is finalized.
