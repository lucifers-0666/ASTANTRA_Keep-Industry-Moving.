---
description: Restyle one public page following the industrial design system with explainable Web Forms code.
---

# Workflow: /build-public-page

**Input**: Target public page (e.g., `Default.aspx`, `Public/Parts.aspx`).  
*Prerequisite*: Execute `/inspect-and-plan` first.

---

## Execution Steps

1. **Verify Foundation Assets**:
   - Ensure design system tokens (`Content/css/tokens.css`), base styles (`base.css`), and reusable components (`components.css`) are available.
2. **Apply Section & Density Budget**:
   - Limit page to authorized section count (Home: $\le 5$; other public pages: $\le 3\text{--}4$).
   - Ensure exactly one primary action (CTA) per viewport.
   - Collapse advanced filter panels by default.
3. **Restyle Web Forms Markup**:
   - Modify only HTML structure and `CssClass` / `class` attributes.
   - Strictly preserve all `runat="server"`, `ID`, and server event attributes.
   - Keep all `<%# Eval(...) %>` data-binding expressions intact.
4. **Author Page Stylesheet**:
   - Write dedicated styles in `Content/css/public/<page-name>.css`.
   - Add the mandatory explanatory header comment block.
   - Use CSS custom properties (`var(--bg)`, `var(--surface)`, `var(--blue)`) exclusively; avoid raw hex codes.
5. **Apply Motion & Accessibility**:
   - Restrict animation to GPU-accelerated micro-interactions (hover, 150ms).
   - Include the `@media (prefers-reduced-motion: reduce)` block.
   - Ensure external `<label>` elements accompany every input field.
6. **Domain Copy & Demo Labeling**:
   - Replace generic SaaS copy with authentic industrial B2B terminology.
   - Visibly label all prototype/sample items as "Demo Data".
7. **Verification & Audit**:
   - Compile the solution with MSBuild to ensure 0 errors.
   - Run the `anti-ai-ui-audit` checklist.
8. **Documentation**:
   - Trigger `/review-and-explain` to update viva notes and AI usage records.

