---
id: SPEC-estudo-ai-local-first-mvp
companions:
  - domain-model.md
  - ../../planning-artifacts/architecture/architecture-estudo AI-2026-09-16/ARCHITECTURE-SPINE.md
  - ../../planning-artifacts/ux-designs/ux-estudo AI-2026-09-16/DESIGN.md
  - ../../planning-artifacts/ux-designs/ux-estudo AI-2026-09-16/EXPERIENCE.md
sources:
  - ../../planning-artifacts/prds/prd-estudo AI-2026-09-15/prd.md
  - ../../planning-artifacts/prds/prd-estudo AI-2026-09-15/addendum.md
  - ../../planning-artifacts/sprint-change-proposal-2026-09-16.md
---

# Study AI Local-First MVP

## Why

Study AI addresses the continuity gap faced by a solo student who plans work across external courses, videos, PDFs, playlists, and files but needs one local place to know the next study action and record how a session ended. The MVP validates focused local scheduling and session discipline before adding external calendar or notification integrations.

## Capabilities

- **CAP-1**
  - **intent:** The student can see the next local Session, its required action, and same-day context.
  - **success:** Home identifies the next Session or clearly states that none is scheduled while retaining daily past and future Sessions.

- **CAP-2**
  - **intent:** The student can create an explicitly typed Managed Lesson or Free Block with a planned time and duration.
  - **success:** Invalid records cannot be saved, and a valid record appears in the local agenda.

- **CAP-3**
  - **intent:** The system can run the local lifecycle of a Managed Lesson, including start, timing, completion, loss, and eligible replacement.
  - **success:** Each valid transition is persisted with its outcome, and the original Session remains auditable after replacement or adjustment.

- **CAP-4**
  - **intent:** The system can time local attention for Free Blocks and preserve recurrence with occurrence exceptions.
  - **success:** A Free Block records local timing without claiming progress inside an external platform.

- **CAP-5**
  - **intent:** The student can attach and open external links, PDFs, and local file references associated with a Session.
  - **success:** Material access failures do not change Session lifecycle state.

- **CAP-6**
  - **intent:** The student can review lifecycle history and export or import local data.
  - **success:** Reloads preserve committed records, and validated versioned JSON restores local state atomically.

## Constraints

- The Local Domain is the sole source of truth for Session status, timing, recurrence, replacement, and history; architecture decisions AD-1 through AD-12 are binding.
- The MVP is a browser-first, local-hosted, single-user, single-active-tab desktop/laptop experience that works without network access or external authorization.
- The implementation uses a lean hexagonal modular monolith with TypeScript, React, Vite, and IndexedDB behind a persistence port.
- Timer truth comes from persisted timestamps and an injected Clock. The global tolerance is 50% of planned duration for both Session types; after the boundary Start is blocked and the Session is Lost. Planned end is never extended, and Start and Stop are idempotent.
- Local material persistence is hybrid: validated `http`/`https` links store metadata, files up to 5 MB may store blobs in IndexedDB, and larger files require reselection.
- Versioned JSON import validates the complete document before replacing all local state.
- The MVP has no notifications, Google Calendar, OAuth, synchronization, local backend, multi-tab coordination, external-platform progress tracking, or generic planner behavior. Google Calendar is post-MVP only.

## Non-goals

- Google Calendar, OAuth, synchronization, or any external reminder service in the MVP.
- Local, browser, or operating-system notifications.
- Cloud hosting, mobile support, multi-user operation, or multi-tab coordination.
- Automatic progress tracking or control of third-party learning platforms.
- AI tutoring, deep curriculum management, or a generic productivity planner.
- A local backend or arbitrary automatic filesystem scanning.

## Success signal

A solo student can open the local app, identify the next Session, create and run either Session type, recover correctly after browser interruption, review completed and Lost history, and restore a validated backup without network access or external authorization. The MVP demonstrates that local next-step visibility and lifecycle discipline are useful before any calendar or notification integration is added.

## Assumptions

- TypeScript and React versions remain unpinned until the project starter is created; Vite 7 documentation and the current Vite starter were verified during architecture work.
- The provisional visual baseline in `DESIGN.md` is sufficient for the first implementation and may be refined later.
- The browser environment provides the required IndexedDB behavior for the supported-browser matrix, which remains to be confirmed before release.

## Open Questions

- What exact overdue-session presentation should appear before automatic Lost reconciliation?
- Which browsers and storage-quota behaviors are supported at release?
- Should the provisional visual identity be refined before implementation or after workflow validation?
