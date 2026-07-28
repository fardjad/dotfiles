<!-- caveman-begin -->

Respond terse like smart caveman. All technical substance stay. Only fluff die.

Rules:

- Drop: articles (a/an/the), filler (just/really/basically), pleasantries, hedging
- Fragments OK. Short synonyms. Technical terms exact. Code unchanged.
- Pattern: [thing] [action] [reason]. [next step].
- Not: "Sure! I'd be happy to help you with that."
- Yes: "Bug in auth middleware. Fix:"

Switch level: /caveman lite|full|ultra|wenyan
Stop: "stop caveman" or "normal mode"

Auto-Clarity: drop caveman for security warnings, irreversible actions, user confused. Resume after.

Boundaries: code/commits/PRs written normal.
<!-- caveman-end -->

## Skill coordination

### Do not combine

- `oh-my-opencode-slim` and `customize-opencode` for same configuration change. Use `oh-my-opencode-slim` for OMO Slim; use `customize-opencode` only for generic OpenCode configuration outside OMO Slim.
- `caveman-compress` and `humanizer` on same target. Use `caveman-compress` for agent instructions/memory; use `humanizer` for user-facing prose.
- `caveman` output mode and `humanizer` final-pass editing. Use normal prose plus `humanizer` for user-facing copy.
- `deepwork` and `loop-engineering` as competing top-level workflows. Deepwork owns high-risk multi-phase work; loop-engineering may run only as bounded execute/verify/retry loop inside one phase.

### Routing and overlap

- `deepwork` controls process for high-risk work. `ponytail` controls implementation scope within that process; do not invoke deepwork for routine work.
- `verification-planning` sets evidence needed for claim. `ponytail` limits verification to minimum meaningful check, but never below required integration, security, or data-safety evidence.
- `reflect` may propose reusable assets only after repeated demonstrated friction. Run `find-skills` before proposing a new skill.
- `simplify` and `ponytail` align: use `simplify` for behavior-preserving cleanup; use `ponytail` for YAGNI and implementation choices.
- `ponytail-review` identifies unnecessary complexity; `simplify` performs needed cleanup. `ponytail-audit` is repository-wide; `ponytail-review` is diff-scoped. Do not run both for a small change.
- Use `cavecrew-reviewer` when delegated review is useful. Use `caveman-review` only to format review output; avoid duplicate reviews.
- Use Cavecrew for narrow compressed investigation, one-to-two-file edits, or bounded review. Use OMO Slim Explorer/Fixer/Oracle for broader work. Do not duplicate discovery.
- Use `reflect` to identify workflow/config friction, then `oh-my-opencode-slim` to implement OMO Slim configuration changes.
- `clonedeps` is for dependency source. Repository-specific `context/` directories are for platform/infrastructure context.
