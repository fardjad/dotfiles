# Swarm cost routing

Use subagents only when they reduce total cost or elapsed time enough to justify their coordination overhead. Favor delegation for independent, bounded work that does not need the main agent's full context or judgment, including:

- repository or documentation lookup and fact gathering
- narrow code or configuration inspection
- mechanical, well-specified edits in isolated files
- focused test, lint, or validation runs
- parallel investigation of independent alternatives or failures

Keep work with cross-cutting design decisions, security-sensitive judgment, integration, final synthesis, or tightly sequential dependencies with the main agent. Treat delegation as a cost-sensitive mechanism, not a default workflow.

Do not add workflow, planning, communication, review, or lifecycle instructions: those are provided by Jcode's built-in agent system.
