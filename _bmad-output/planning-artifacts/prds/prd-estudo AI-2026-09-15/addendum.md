# PRD Addendum: Technical Context

This addendum preserves technical depth from the research without turning implementation choices into product requirements. Architecture must validate these options before implementation.

## Local runtime and persistence options

The MVP requires browser access and local hosting. Two candidate shapes remain:

- Browser-first local application using persistent browser storage such as SQLite/WASM with OPFS, with an optional local service for protected integration work.
- Local backend plus browser frontend, using a local SQLite database and a local API boundary.

The decision must account for data durability, backup/export, timer recovery, startup ergonomics, Windows local operation, and local file reference behavior. The Local Domain must remain authoritative under either option.

## Security and local operation

A local service, if required by the selected architecture, should bind to loopback only. The implementation should validate local file references according to the selected browser/runtime model. Core Session creation, timing, history, and review must not require external authorization or network access.

## Research items to resolve in architecture

- Browser persistence versus local backend with SQLite.
- Backup/export and recovery format.
- Timer recovery after tab closure, browser suspension, or local process restart.
- Local file reference and access model.
- Error taxonomy for persistence, validation, and Session lifecycle failures.
- Whether a local runtime is optional or required for the MVP.

## Future integration boundary

Google Calendar is deferred to post-MVP. When revisited, it should be designed as an optional external projection and reminder capability that does not replace the Local Domain as the source of truth.
