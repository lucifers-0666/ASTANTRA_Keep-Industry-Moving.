---
description: Audit the implementation for AI-look and explainability, then record viva notes and decisions.
---

# Workflow: /review-and-explain

## Execution Steps

1. **Anti-AI Design Audit**:
   - Evaluate the changed page against `.agents/skills/anti-ai-ui-audit/SKILL.md`.
   - Resolve any identified violations (e.g., generic cards, missing labels, raw hex colors).
2. **Explainability Self-Review**:
   - Inspect the `git diff`.
   - Verify that every CSS rule and JavaScript function is straightforward enough for an MCA student to defend during a viva.
3. **Record Viva Documentation**:
   - Append an entry to [`docs/VIVA_NOTES.md`](file:///E:/ASP.NET%20MCA/docs/VIVA_NOTES.md) following the entry template:
     - Goal / problem solved
     - Technical implementation summary
     - Rejected alternatives
     - File location and selector/function
     - Expected viva question and model answer
4. **Update AI Usage Log**:
   - Append an entry to [`docs/AI_USAGE_LOG.md`](file:///E:/ASP.NET%20MCA/docs/AI_USAGE_LOG.md) documenting AI generation and student review.
5. **Record Architectural Decisions**:
   - If a significant design or technical decision was made, record an entry in [`docs/DECISIONS.md`](file:///E:/ASP.NET%20MCA/docs/DECISIONS.md).
6. **Final Task Report**:
   - Output the task summary: files changed, decisions made, tests conducted vs not run, and any remaining items.

