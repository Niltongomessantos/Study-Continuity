---
name: Study AI
status: final
sources:
  - _bmad-output/planning-artifacts/prds/prd-estudo AI-2026-09-15/prd.md
  - _bmad-output/planning-artifacts/prds/prd-estudo AI-2026-09-15/addendum.md
  - _bmad-output/planning-artifacts/sprint-change-proposal-2026-09-16.md
updated: 2026-09-16
colors:
  surface-base: '#F7F8FA'
  surface-raised: '#FFFFFF'
  ink-primary: '#17202A'
  ink-secondary: '#5B6673'
  border-subtle: '#DCE2E8'
  action-primary: '#2457A6'
  action-primary-foreground: '#FFFFFF'
  state-success: '#287A52'
  state-danger: '#A43D3D'
  state-neutral: '#6B7480'
typography:
  display:
    fontFamily: 'sans-serif'
    fontSize: '32px'
    fontWeight: '700'
    lineHeight: '1.2'
  heading:
    fontFamily: 'sans-serif'
    fontSize: '22px'
    fontWeight: '700'
    lineHeight: '1.3'
  body:
    fontFamily: 'sans-serif'
    fontSize: '16px'
    fontWeight: '400'
    lineHeight: '1.5'
  label:
    fontFamily: 'sans-serif'
    fontSize: '14px'
    fontWeight: '600'
    lineHeight: '1.4'
  meta:
    fontFamily: 'sans-serif'
    fontSize: '13px'
    fontWeight: '400'
    lineHeight: '1.4'
rounded:
  sm: '4px'
  md: '8px'
spacing:
  '1': '8px'
  '2': '16px'
  '3': '24px'
  '4': '32px'
  '5': '48px'
components:
  primary-session:
    background: '{colors.surface-raised}'
    foreground: '{colors.ink-primary}'
    radius: '{rounded.md}'
  primary-action:
    background: '{colors.action-primary}'
    foreground: '{colors.action-primary-foreground}'
    radius: '{rounded.sm}'
---

## Brand & Style

Study AI is a focused local study tool for one student. The MVP visual direction is intentionally generic and functional: clear hierarchy, quiet surfaces, readable session states, and emphasis on the next study action. This is a provisional visual baseline to be refined after the core workflow is validated.

The interface should feel dependable and calm rather than gamified or productivity-heavy. It should not use streaks, achievement language, notification prompts, or calendar-provider branding.

## Colors

The palette uses neutral surfaces and a restrained blue action color. Color supports hierarchy and interaction, but session status must never rely on color alone.

- `{colors.surface-base}` is the application canvas.
- `{colors.surface-raised}` is the primary session surface.
- `{colors.ink-primary}` is used for headings and essential values.
- `{colors.ink-secondary}` is used for supporting descriptions and metadata.
- `{colors.border-subtle}` separates sections and inputs.
- `{colors.action-primary}` is the main action and current-session emphasis.
- `{colors.state-success}`, `{colors.state-danger}`, and `{colors.state-neutral}` communicate labeled session states.

Avoid gradients, decorative color fields, gamification colors, and dense status badges. Error and lost states should use text, iconography, and structure in addition to color.

## Typography

Use a highly readable sans-serif family for the provisional MVP. Typography should distinguish the next session from supporting agenda content without becoming display-oriented.

- `{typography.display}` is reserved for the next-session title.
- `{typography.heading}` is used for section headings.
- `{typography.body}` is used for descriptions and controls.
- `{typography.label}` is used for field labels and status text.
- `{typography.meta}` is used for time, duration, and secondary context.

Do not use all-caps for important session names. Respect browser zoom and allow text to wrap.

## Layout & Spacing

The primary surface is desktop/laptop. Use a centered content region with a stable maximum width and a two-part hierarchy:

- primary session region at the top;
- lower-emphasis daily agenda and weekly counters below.

Use the `{spacing.1}` through `{spacing.5}` scale for 8, 16, 24, 32, and 48px spacing. Keep the next-session region visually distinct through placement, size, and whitespace rather than decoration. The MVP targets desktop and laptop browsers; smaller viewport behavior is deferred.

## Elevation & Depth

Use one raised surface for the next session and restrained borders for supporting sections. Shadows should be subtle and used only to separate the primary session from the canvas. Do not stack cards inside cards.

## Shapes

Use small, consistent corner radii: 4px for controls and 8px for the primary session surface. Avoid pill-shaped controls except where a compact status label genuinely requires it. Use familiar symbols only when paired with accessible names.

## Components

- **Primary session surface** — Shows session type, title, planned time, duration, status, material context, and the available action. It is the dominant surface on Home.
- **Session row** — Shows time, title, type, duration, and status for past or upcoming Sessions. Rows are consult-only in the MVP.
- **Timer control group** — Provides Start and Stop with stable dimensions. Stop requires a clear outcome treatment after the action.
- **Daily agenda** — Shows past and future Sessions below the primary surface with lower visual emphasis.
- **Weekly counters** — Shows completed and missed lesson totals as simple labeled counters, not charts or achievement badges.
- **Empty primary session** — States that no Session is scheduled and keeps the daily agenda visible below.
- **Material link** — Uses an explicit text label and opens the material in the user's browser without tracking progress on the external platform.

## Do's and Don'ts

| Do | Don't |
|---|---|
| Make the next Session the first visual decision | Make the agenda look like a generic productivity dashboard |
| Pair status color with text and structure | Communicate status by color alone |
| Keep counters factual and quiet | Add streaks, celebrations, or motivational badges |
| Preserve stable control sizes for timer actions | Let labels resize or shift the timer controls |
| Treat visual choices as provisional until workflow validation | Introduce Google Calendar or notification branding |

