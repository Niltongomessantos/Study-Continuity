# Contributing

## Branches

Use `main` as the protected default branch. Create work branches with one of these prefixes:

- `feat/<short-description>`
- `fix/<short-description>`
- `docs/<short-description>`
- `chore/<short-description>`

Do not commit directly to `main`. Submit changes through a Pull Request.

## Commits

Use Conventional Commits in the imperative mood:

```text
<type>(<scope>): <imperative description>
```

Allowed types are `feat`, `fix`, `docs`, `test`, `refactor`, and `chore`.

Examples:

```text
docs(prd): update MVP scope
docs(ux): define local study agenda experience
docs(architecture): add MVP architecture spine
docs(spec): add local-first MVP specification (#12)
```

Jira IDs are not required. GitHub Issue references are optional.

## Pull Requests

A Pull Request should explain the intent, list the affected artifacts, identify validation performed, and call out open decisions. Keep changes focused and preserve approved product, UX, architecture, and specification contracts.

## Validation

For documentation-only changes, inspect the rendered Markdown and run `git diff --check`. Once application code exists, add the project-specific typecheck, lint, and test commands to this section.

## BMAD artifacts

Version-control canonical PRD, UX, architecture, specification, course-correction, and `.memlog.md` files. Do not commit temporary `.working/` outputs or tool-generated scratch files unless explicitly promoted into a deliverable.
