# Agent Instructions

## Workflow preferences

- Do not create a Git commit unless the user explicitly asks for one.
- Do not install third-party dependencies without explicit confirmation. First investigate and discuss viable options.

The user’s LazyVim configuration preferences are defined in [customizations.md](customizations.md), which is the source of truth.

## Maintaining configuration preferences

- Whenever you change this configuration, determine whether the change establishes, changes, or removes a user preference. If it does, update `customizations.md` in the same change.
- When a recorded preference is superseded, edit or remove the existing entry instead of adding a conflicting or historical entry.
- Keep entries concrete and behavior-focused, with links to relevant configuration files when useful.
- Do not record purely mechanical refactors or dependency lockfile updates unless they change the intended editor behavior.
