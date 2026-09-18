# Sprint Change Proposal

- Project: estudo AI
- Date: 2026-09-16
- Change scope: Moderate
- Status: Approved and implemented

## 1. Issue Summary

The current PRD includes Google Calendar as an MVP integration for event projection, reminders, OAuth authorization, synchronization state, retry handling, and external calendar identifiers. The product decision is to remove this integration from the MVP to keep the first release smaller and simpler.

The MVP will send no notifications through Google Calendar, the browser, the operating system, or another external service. Google Calendar remains a future post-MVP capability.

The change is a deliberate MVP scope reduction. The local study domain remains the product authority and continues to own scheduling, Session lifecycle, timing, replacement, materials, and history.

## 2. Impact Analysis

### Epic impact

No epics or stories currently exist in the workspace. No epic can be updated or reordered at this stage.

When epics and stories are created, Google Calendar, OAuth, synchronization, notification, retry, and external event projection must not be included in MVP stories. They may be created as a separate post-MVP epic later.

### Story impact

No existing stories were found. Future stories should cover only the local MVP domain:

- local agenda and next Session;
- Managed Lessons;
- Free Blocks;
- local timer;
- tolerance, late arrival, completion, loss, and replacement rules;
- materials and links;
- local history;
- local persistence and recovery.

### PRD impact

The PRD requires updates to:

- Vision and Jobs To Be Done;
- UJ-1, UJ-3, and UJ-4;
- the glossary;
- FR-4, FR-10, FR-11, and FR-17 references;
- the Google Calendar requirements block FR-13 through FR-16;
- non-functional requirements;
- product constraints and non-goals;
- MVP scope;
- metrics, risks, dependencies, open questions, assumptions, and acceptance criteria.

The approved direction is to remove FR-13 through FR-16 from the MVP and replace that capability with a local agenda requirement.

### Addendum impact

The addendum currently describes OAuth, Calendar API projection, Sync Queue, retry, token handling, and external recurrence. These sections should be removed from the MVP technical context.

The addendum should retain local runtime, persistence, backup, export, timer recovery, local file handling, and local security considerations. It should include a short future-integration boundary stating that Google Calendar may later be added as an optional external projection without becoming the Local Domain authority.

### Discovery artifact impact

The following discovery artifacts should remain unchanged as historical records:

- `_bmad-output/brainstorming/brainstorm-app-de-estudos-unificado-2026-09-14/brainstorm-intent.md`
- `_bmad-output/forge/app-estudos-local-google-calendar-2026-09-15/forged-idea.md`
- `_bmad-output/forge/app-estudos-local-google-calendar-2026-09-15/forge-report.html`
- `_bmad-output/planning-artifacts/research/technical-web-local-google-calendar-2026-09-14/research.md`
- the related research imports, digests, and claims file.

These documents accurately record the previous direction. The current PRD, addendum, and this proposal supersede that scope for implementation purposes. The integration should be described as post-MVP in the current planning documents, not erased from discovery history.

### Architecture impact

No architecture document was found. The immediate architecture scope becomes smaller:

- no Google Cloud project;
- no Calendar API client;
- no OAuth callback or token storage;
- no external event identifier mapping;
- no Sync Queue or retry worker;
- no external recurrence projection;
- no notification provider.

Architecture still needs to resolve local persistence, backup/export, timer recovery, local file references, loopback operation if a local service is used, and local error handling.

### UX impact

No UX document was found. The MVP UX should provide:

- a clear local agenda;
- a prominent next Session;
- planned time, duration, type, status, and available material;
- no notification settings or calendar authorization flow;
- clear handling of overdue Sessions without relying on notifications.

### Technical and operational impact

The change removes external credentials, network dependency, API failure states, OAuth security work, and synchronization observability from the MVP. It does not remove the need for local persistence, timer recovery, backup/recovery planning, or accessible Session lifecycle actions.

## 3. Recommended Approach

### Selected approach: Option 3, MVP review and scope reduction

This is a direct product scope reduction with a small hybrid adjustment to the future backlog.

Rationale:

- It reduces implementation complexity and technical risk.
- It allows the core study continuity hypothesis to be validated independently.
- It removes authentication and network dependencies from the primary user workflow.
- It preserves the Google Calendar direction for a later iteration.
- It prevents notification behavior from becoming an implicit MVP requirement.

### Alternatives considered

- Direct adjustment only: not sufficient because the current PRD contains cross-cutting Calendar, OAuth, notification, metric, dependency, and security references.
- Rollback: unnecessary because no implementation artifacts or stories were found.

### Effort and risk

- Documentation effort: Medium, because several PRD sections and the addendum are affected.
- Implementation effort saved: High.
- Product risk: Low to Medium, because the MVP has no notification channel and must make the local agenda highly visible.
- Technical risk after change: Lower than the current plan.

## 4. Detailed Change Proposals

The following proposals were reviewed incrementally and approved:

1. Update PRD MVP scope.
   - Remove Google Calendar Projection, OAuth, synchronization state, retry queue, and visible synchronization errors from In Scope.
   - Add Google Calendar and all notification channels to Out of Scope for MVP.

2. Remove Calendar dependency from the vision and journeys.
   - Remove calendar reminders and synchronization from Jobs To Be Done and UJ-1, UJ-3, and UJ-4.
   - Reframe the local agenda as the mechanism for consulting planned study times.

3. Replace the Calendar Projection requirements block.
   - Remove FR-13 through FR-16.
   - Add a local agenda requirement covering scheduled Sessions without network access, authorization, or notifications.
   - Renumber later requirements consistently.

4. Remove Calendar technical requirements.
   - Remove OAuth, tokens, callback, Calendar API, permissions, synchronization, and external failure requirements.
   - Retain local runtime, local security, persistence, timer recovery, and accessible local workflows.

5. Update metrics, risks, dependencies, questions, assumptions, and acceptance criteria.
   - Remove Calendar-specific metrics and dependencies.
   - Add local-agenda and no-notification criteria.
   - Retain backup/recovery and local lifecycle decisions.

6. Reclassify the addendum.
   - Remove Calendar implementation details from the current MVP technical context.
   - Retain a future integration boundary for post-MVP work.

7. Preserve discovery artifacts.
   - Do not rewrite brainstorming, forge, or research artifacts.
   - Treat them as historical evidence of the prior MVP direction.

## 5. MVP Definition After Change

The MVP includes:

- browser-accessed local application and local hosting;
- local agenda and prominent next Session;
- explicit Managed Lesson and Free Block creation;
- required planned time and duration;
- local timer;
- Managed Lesson start, tolerance, late-arrival, completion, interruption, loss, and replacement rules;
- Free Block recurrence and local occurrence exceptions;
- materials, external links, PDFs, and local file references;
- local Session history and lifecycle statuses;
- local persistence as the source of truth;
- local backup/recovery planning;
- keyboard-accessible core workflows;
- no notifications of any kind.

## 6. Post-MVP Items

The following are deferred:

- Google Calendar integration;
- Google OAuth and account authorization;
- event projection and external event identifiers;
- Calendar reminders;
- local synchronization queue and retry handling;
- external calendar recurrence projection;
- browser notifications;
- operating-system notifications;
- any other notification provider.

When revisited, Google Calendar must remain an optional projection and reminder extension. It must not replace the Local Domain as the source of truth.

## 7. Risks and Decisions Pending

### Risks

- Without notifications, users may miss scheduled Sessions.
- Browser suspension or closure may affect timer continuity if timestamps are not persisted correctly.
- Local browser data may be lost without backup/export and recovery.
- A weak agenda experience could make the product feel incomplete without external reminders.

### Decisions pending

- Exact default Tolerance Window.
- Behavior when a Managed Lesson starts after tolerance.
- Browser persistence versus local backend with SQLite.
- Backup/export and recovery flow.
- Timer recovery after tab closure, browser suspension, or process restart.
- Behavior when a Free Block ends.
- Minimum local agenda view for the first prototype.
- Product name replacing the provisional “Study Continuity”.

## 8. Recommended Update Order

1. Update the PRD as the source of truth.
2. Update the addendum to remove obsolete MVP technical context.
3. Create or update epics and stories from the corrected PRD.
4. Create architecture and UX artifacts from the corrected scope, if needed.
5. Keep brainstorming, forge, and research artifacts as historical records.
6. Validate the resulting MVP scope before implementation begins.

## 9. Implementation Handoff

### Classification

Moderate change. The change requires product-document and backlog alignment but does not require a fundamental product replan.

### Handoff recipients

- Product Manager (`bmad-agent-pm`): update the PRD and addendum according to the approved proposals.
- Architect (`bmad-agent-architect`): use the corrected scope when producing architecture; do not design Calendar or notification infrastructure for MVP.
- UX Designer (`bmad-agent-ux-designer`): design the local agenda and next-Session experience without notification or calendar flows.
- Developer (`bmad-agent-dev`): implement only after the corrected PRD and downstream planning artifacts are approved.

### Success criteria

- The PRD has no Google Calendar or notification capability in MVP In Scope.
- The PRD clearly lists Google Calendar as post-MVP.
- The MVP can create, run, complete, lose, replace, and review Sessions locally.
- The local agenda remains usable without network access or external authorization.
- No notification mechanism is required or implemented in the MVP.
- Discovery artifacts remain available as historical context.

## 10. Checklist Status

- [x] Trigger and core problem identified.
- [x] Evidence gathered from the current PRD and discovery artifacts.
- [N/A] Existing epic assessment; no epics found.
- [N/A] Existing story assessment; no stories found.
- [!] PRD updates required.
- [!] Addendum updates required.
- [N/A] Existing architecture review; no architecture document found.
- [N/A] Existing UX review; no UX document found.
- [x] Recommended path selected: MVP scope reduction.
- [x] Incremental proposals reviewed and approved by the user.
- [x] Final approval of this complete Sprint Change Proposal.
- [x] Implementation handoff completed: PRD, addendum, and review rubric updated; discovery artifacts preserved.
