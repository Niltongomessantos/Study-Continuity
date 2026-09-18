---
name: Study AI
status: final
sources:
  - _bmad-output/planning-artifacts/prds/prd-estudo AI-2026-09-15/prd.md
  - _bmad-output/planning-artifacts/prds/prd-estudo AI-2026-09-15/addendum.md
  - _bmad-output/planning-artifacts/sprint-change-proposal-2026-09-16.md
updated: 2026-09-16
---

## Foundation

Responsive behavior is not part of the MVP. The primary form factor is a desktop/laptop browser running against a local application. The first user is a solo student. The product is local-first: core agenda, Session creation, timing, history, and persistence do not require network access or external authorization. Primary surfaces use {colors.surface-base}; the next Session uses {colors.surface-raised} and {rounded.md}.

`DESIGN.md` is the visual identity reference. The MVP uses a provisional, generic visual baseline and should not introduce Google Calendar, OAuth, synchronization, reminder, or notification surfaces.

## Information Architecture

| Surface | Reached from | Purpose |
|---|---|---|
| Home | App open | Next Session, daily continuity, and weekly counters |
| Session detail | Next Session or agenda row | Session context, material, timer, and available actions |
| Create Session | Home primary action | Choose Managed Lesson or Free Block and enter scheduling data |
| History | Home weekly counters | Review local Session outcomes and lifecycle records |

Home is the primary navigation surface. The MVP does not require a calendar view, week view, settings area, notification center, account authorization, or external synchronization area.

### Home composition

1. Primary Session surface, or an explicit no-scheduled-Session state.
2. Daily agenda with past and upcoming Sessions at lower emphasis.
3. Weekly counters for completed and missed lessons.
4. Clear create-session action.

The daily agenda is the MVP mechanism for consulting planned times. Week-level visualization is deferred. Use {spacing.3} between major Home regions.

## Voice and Tone

Microcopy is direct, factual, and calm. The product helps the student understand the local study state; it does not pressure or reward them.

| Do | Don't |
|---|---|
| `Next session` | `Don't lose your momentum!` |
| `No session scheduled` | `You're all caught up!` |
| `Started at 09:30` | `You're crushing it!` |
| `Completed` / `Lost` | Ambiguous color-only labels |
| `No notifications are enabled in this MVP` only when relevant | Notification prompts or provider language |

## Component Patterns

| Component | Use | Behavioral rules |
|---|---|---|
| Primary Session surface | Home | Shows the next Session and its available action. Clicking opens Session detail. |
| Session row | Daily agenda | Past and future rows are consult-only in MVP. Clicking opens detail without edit or reschedule actions. |
| Type selector | Create Session | Managed Lesson and Free Block are explicit mutually exclusive choices. |
| Session form | Create Session | Planned time and duration are required. Title, objective, material, link, and recurrence are optional where applicable. |
| Timer control group | Session detail | Start records the local timestamp. Stop evaluates the 50% rule and persists the result. |
| Material link | Session detail | Opens material in the user's browser without tracking external progress. |
| Weekly counter | Home | Shows completed and missed lesson counts only. Clicking may open History; it does not show charts in MVP. |
| History list | History | Shows local lifecycle outcomes and preserves original Sessions and replacements. |

## State Patterns

| State | Surface | Treatment |
|---|---|---|
| First open with no Sessions | Home | Explain that no Session is scheduled and offer Create Session. |
| No primary Session, daily Sessions exist | Home | State no scheduled primary Session; keep past and upcoming daily rows visible. |
| No Sessions today | Home | Show a quiet empty agenda and keep the create action available. |
| Loading local data | Home / History | Use stable skeleton regions that do not shift the primary action. |
| Pending Session | Session detail | Show Start and local schedule context. |
| Started Session | Session detail | Show elapsed or remaining local time and Stop. Persist timing facts, not only display state. |
| Stopped at or above 50% | Session detail / History | Show Completed with recorded start, stop, and duration. |
| Stopped below 50% | Session detail / History | Show Lost and preserve the original record. |
| Missed Managed Lesson | Home / History | Show Lost and expose a replacement action only where the product rule permits it. |
| Material unavailable | Session detail | Preserve the Session and status; show an actionable open failure without blocking the timer. |
| Local persistence failure | Any affected surface | Keep entered data visible where possible, explain that it was not saved, and provide retry. |
| Browser interruption | Reopen | Reconstruct timer state from persisted timestamps and show the resulting state clearly. |

No state depends on network availability, notifications, external authorization, or Google Calendar.

## Interaction Primitives

- Click or keyboard activate the entire primary Session surface to open details.
- `Start` is explicit and begins timing immediately when the local action is committed.
- `Stop` is explicit and records the stop timestamp before applying the 50% completion rule.
- Editing and rescheduling from past or upcoming agenda rows are deferred; these rows are consult-only in MVP.
- Material links open in the user's browser without tracking progress on the external platform.
- Recurring Free Blocks expose the distinction between changing one occurrence and changing the series.
- Destructive or status-changing actions require clear text confirmation where accidental activation could alter history.
- No notification permission prompt, calendar connection, OAuth flow, sync status, or external reminder control appears in the MVP.

## Accessibility Floor

- All core actions are keyboard accessible: create, select type, save, open Session, Start, Stop, open material, and open History.
- Focus order follows the visual reading order: primary Session, daily agenda, counters, create action.
- Focus indicators remain visible against every surface and use more than color to communicate focus.
- Session type and status are conveyed by text and structure, not color alone.
- Timer updates must not steal focus. Announcements should be meaningful and not excessively frequent.
- Dialogs, if used for creation or confirmation, trap focus and close with Escape without losing entered data.
- Text can wrap under browser zoom without clipping session titles, statuses, or timer actions.
- Tables or counter summaries include accessible names and do not rely on visual position alone.

## MVP Blockers

Resolve these before architecture and stories are finalized:

- Exact default Tolerance Window.
- Timer recovery after browser interruption.
- Local persistence, backup, and recovery model.
- Whether the primary timer shows elapsed time, remaining time, or both.

## Responsive & Platform

Desktop/laptop is the only committed MVP form factor. The layout should have a stable desktop width and preserve the primary-session hierarchy. Mobile and narrow responsive behavior are deferred rather than implicitly promised. The architecture should avoid making the domain model depend on desktop-only concepts.

## Key Flows

### Flow 1 - First local setup (Alex, first use)

1. Alex opens the local application in a browser.
2. Home shows that no Session is scheduled and offers Create Session.
3. Alex chooses Managed Lesson or Free Block.
4. Alex enters the required planned time and duration, then optional context.
5. The Session is persisted locally.
6. **Climax:** Home immediately promotes the new Session into the primary Session surface, making the next action obvious.

Failure: local persistence fails; entered values remain visible and the UI offers retry without pretending the Session exists.

### Flow 2 - Start and stop a Managed Lesson (Alex, scheduled study time)

1. Alex opens Home and sees the next Managed Lesson.
2. Alex opens the primary Session surface.
3. Alex reviews time, duration, objective, and material.
4. Alex presses Start; the local start timestamp is committed immediately.
5. Alex studies and may open the material in the browser.
6. Alex presses Stop.
7. The product applies the 50% rule: at or above 50% is Completed; below 50% is Lost.
8. **Climax:** The resulting status is visible in Session detail and the weekly counter updates without erasing the lifecycle record.

### Flow 3 - Use a Free Block (Alex, open-ended external material)

1. Alex opens a Free Block from Home or the daily agenda.
2. Alex reviews the planned time, duration, recurrence, and material link.
3. Alex presses Start; the local timer begins.
4. Alex studies the external content in the user's browser.
5. Alex returns and presses Stop.
6. The same 50% rule records Completed or Lost for the local block.
7. **Climax:** History records attention time without claiming progress inside the external platform.

### Flow 4 - Recover a missed Managed Lesson (Alex, after tolerance)

1. Alex opens Home after the planned start and sees the lesson marked Lost according to the tolerance rule.
2. Alex opens the Session detail and reviews the original duration, objective, and material.
3. Alex chooses a replacement time from the local agenda.
4. The product creates a linked replacement without mutating the original Lost record.
5. **Climax:** Home shows the replacement as the next local step and History preserves both records.

### Flow 5 - Consult continuity (Alex, end of week)

1. Alex opens Home.
2. Alex sees the next or current Session first.
3. Alex scans the daily agenda below for past and upcoming Sessions.
4. Alex reads the completed and missed weekly counters.
5. Alex opens History only when the counter context needs detail.
6. **Climax:** Alex can understand continuity from local records without needing a week calendar or notification channel.

## Open Questions

- What is the exact default Tolerance Window?
- What should a Session show when it is overdue but not yet transitioned to Lost?
- Should the primary Session surface include a visible countdown, elapsed time, or both?
- What local agenda fields are sufficient for consult-only rows?
- Should replacement be exposed directly in the Lost detail or through a secondary action?
- What is the final local persistence and recovery model?
- What is the final visual identity after the generic MVP baseline is validated?
