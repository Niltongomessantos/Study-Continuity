<!-- bmad:context -->
<!-- Verified 2026-09-16 against 48a7443. Managed by bmad-project-context; edits inside this block are replaced on refresh. -->

## estudo AI

Planning-first local-first study application. Product decisions live in `_bmad-output/`; the current MVP contract is `_bmad-output/specs/spec-estudo-ai-local-first-mvp/SPEC.md`. Architecture and UX companions are linked from that spec.

## Policy

- Use `main` as the protected default branch.
- Do not commit directly to `main`; use a Pull Request.
- Use branch prefixes `feat/`, `fix/`, `docs/`, or `chore/`.
- Use Conventional Commits: `<type>(<scope>): <imperative description>`.
- Use `feat`, `fix`, `docs`, `test`, `refactor`, or `chore` as commit types.
- Do not reintroduce Google Calendar, OAuth, synchronization, or notifications into the MVP.
- Preserve approved PRD, UX, architecture, and SPEC decisions unless the relevant planning workflow updates them.

## Where things are

- Product requirements: `_bmad-output/planning-artifacts/prds/`
- UX contracts: `_bmad-output/planning-artifacts/ux-designs/`
- Architecture spine: `_bmad-output/planning-artifacts/architecture/`
- Canonical MVP spec: `_bmad-output/specs/spec-estudo-ai-local-first-mvp/`
- Course corrections: `_bmad-output/planning-artifacts/sprint-change-proposal-*.md`

## Running and verifying

- No application runtime or automated project test command exists yet.
- Before documentation commits, validate changed Markdown and inspect `git diff --check`.
- Before implementation commits, add and run the project-specific typecheck, lint, and test commands.

## Conventions that differ from defaults

- Commit directly to `main` is prohibited; use a Pull Request.
- Jira IDs are not required. GitHub Issue references are optional, for example `docs(spec): add local-first MVP specification (#12)`.
- BMAD planning artifacts are source-controlled project documents, not generated build output.

## Known pitfalls

- Treat `_bmad-output/` as intentional planning content; do not ignore it wholesale.
- Preserve `.memlog.md` files when they are the canonical memory for a BMAD artifact.
- Do not commit temporary `.working/` outputs or tool-generated scratch files unless they are explicitly promoted into a deliverable.
<!-- /bmad:context -->
