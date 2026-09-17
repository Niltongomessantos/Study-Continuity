# Study AI Domain Contract

This companion carries the detailed domain, lifecycle, persistence, and acceptance rules that would overfill the SPEC kernel. The architecture spine remains the binding boundary contract; this file does not renumber or weaken AD-1 through AD-12.

## Domain Model

- **Session:** the scheduled local study record with a stable ID, explicit type, planned start, planned duration, planned end, status, optional context, materials, recurrence data, and replacement links.
- **Managed Lesson:** a Session whose local lifecycle determines study continuity and eligible replacement.
- **Free Block:** a Session that measures local attention while leaving external content and platform progress outside the product domain.
- **Recurrence:** a Local Domain rule that produces recurring Free Block occurrences.
- **Occurrence Exception:** a local change to one recurrence occurrence without silently rewriting unrelated occurrences.
- **Replacement:** a new Session linked to an original Managed Lesson that was not started or became Lost.
- **Lifecycle Event:** append-only record of a meaningful Session transition or manual adjustment.
- **Material Reference:** validated external URL metadata or explicit local-file metadata with an optional stored blob.

## Session Status

The implementation must support the PRD statuses: `Pending`, `Started`, `Completed`, `Lost`, `Incomplete`, `Rescheduled`, and `Cancelled`. The domain owns transitions; UI controls cannot assign statuses directly.

Minimum transition rules:

- `Pending` can become `Started` only at or before the global tolerance deadline.
- `Pending` becomes `Lost` when reconciliation reaches the tolerance boundary without a start.
- `Started` becomes terminal at the planned end or when Stop is invoked.
- Stop applies the 50% planned-duration rule: at or above 50% is `Completed`; below 50% is `Lost`.
- A Lost Managed Lesson can produce a linked Replacement without changing the original history.
- Completed, Incomplete, and Cancelled Sessions do not automatically produce a Replacement.
- Start and Stop are idempotent and do not create duplicate lifecycle events.

## Time Rules

Persist these facts with millisecond precision:

- `plannedStartAt`;
- `plannedDurationMs`;
- `plannedEndAt = plannedStartAt + plannedDurationMs`;
- `actualStartAt`, when started;
- `stoppedAt`, when stopped;
- lifecycle event timestamps.

Define:

- `toleranceDeadline = plannedStartAt + (plannedDurationMs * 0.5)`;
- `elapsed = currentTime - actualStartAt` for a Started Session;
- `remaining = plannedEndAt - currentTime` while the planned window remains open.

The timer continues while the browser is closed or suspended. On application open, focus, every query, and every mutation, the application facade reconciles persisted Sessions before reading state. A display interval may refresh elapsed and remaining values but cannot establish truth.

## Materials

- External links accept only validated `http` or `https` URLs.
- Local files enter through explicit browser selection.
- A selected blob up to 5 MB per file may be stored in IndexedDB with metadata.
- Larger files retain metadata and require reselection.
- Attached content is inert data and is never executed as HTML or script.
- Failure to open a material leaves Session status unchanged.

## Persistence and Recovery

- IndexedDB is accessed only through the persistence port.
- Current Session state and lifecycle events commit atomically in one transaction.
- Export uses versioned JSON containing stable IDs, timestamps, recurrence, replacements, material metadata, and eligible blobs.
- Import validates schema version, duplicate IDs, material limits, dangling replacement references, and replacement cycles before replacing all local state atomically.
- Persistence errors are actionable and never reported as successful saves.
- The MVP assumes one active browser tab; cross-tab coordination is deferred.

## UX Contract

- Home prioritizes the next Session, then daily past/future context, then weekly completed and Lost counters.
- When no primary Session exists, Home states that clearly and retains the daily agenda.
- Session detail exposes local context, material access, and Start/Stop as permitted by state.
- Agenda rows are consult-only in the MVP; editing and rescheduling from the agenda are deferred.
- The primary form factor is desktop/laptop. Mobile and week views are post-MVP.
- Core actions are keyboard accessible, status is not color-only, and timer updates do not steal focus.

## Acceptance Criteria

- A Session cannot be saved without an explicit type, planned time, and duration.
- A Pending Managed Lesson or Free Block cannot start after 50% of its planned duration has elapsed.
- A late start never changes `plannedEndAt`.
- Closing or suspending the browser does not reset a Started timer.
- Duplicate Start or Stop attempts do not overwrite timestamps or create duplicate events.
- Stopping at 50% or more records `Completed`; stopping below 50% records `Lost`.
- A Lost eligible Managed Lesson can be replaced while the original remains auditable.
- A valid material failure does not change Session status.
- Reloading preserves committed Sessions, history, recurrence, and replacements.
- Invalid backup imports leave existing local state unchanged.
- Core workflows operate without network access, authorization, or notifications.
