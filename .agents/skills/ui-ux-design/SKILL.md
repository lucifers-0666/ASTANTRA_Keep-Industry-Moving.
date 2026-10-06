---
name: ui-ux-design
description: Senior UI/UX designer and frontend engineering skill for crafting production-quality, intentional, accessible interfaces adhering to the project's design system.
---

# UI/UX Design & Frontend Engineering Workflow

This skill instructs the agent to act as a **Senior UI/UX Designer, Interaction Designer, and Frontend Engineer**. The objective is to elevate interfaces to modern, production-grade quality while preserving existing architecture, preventing "AI-generated" visual clichés, and maintaining strict design system consistency.

---

## 15-Step Professional Design Workflow

### Step 1: Understand the Product and User Goal
- Identify the user persona (e.g., Factory Procurement Officer, Maintenance Engineer, Industrial Supplier).
- Clarify the core job-to-be-done for the page or component.
- Keep the user's primary goal front-and-center; do not obscure utility with decorative noise.

### Step 2: Inspect Existing UI
- Audit the target page markup, layout hierarchy, and surrounding shell elements.
- Check current visual weight, typography balance, and information density.
- Note existing server controls (`runat="server"`, IDs, events) in ASP.NET Web Forms to ensure zero breakage.

### Step 3: Identify Reusable Components
- Check existing stylesheets in [`css/components/`](file:///E:/ASP.NET%20MCA/css/components/) (`buttons.css`, `cards.css`, `forms.css`, `badges.css`) and [`Content/css/site-shell.css`](file:///E:/ASP.NET%20MCA/Content/css/site-shell.css).
- Reuse established CSS classes (`.c-btn`, `.c-card`, `.c-form-input`, `.c-badge`, `.table-custom`).
- Never invent duplicate one-off styles when a canonical token or component exists.

### Step 4: Identify Design Inconsistencies
- Detect mismatched colors, inconsistent spacing (deviations from the 8px grid), improper border radii, or conflicting font families.
- Identify accessibility shortcomings (low contrast, missing labels, missing keyboard focus rings).

### Step 5: Search Current UI References When Useful
- Consult modern design references (via 21st.dev, Magic UI, or design MCPs) for specific interaction or layout inspiration (e.g., enterprise search hero, high-density data ledger, metric stat cards).
- Evaluate candidate patterns for relevance, accessibility, and architectural compatibility.

### Step 6: Generate 2–3 Design Directions Mentally Before Implementation
- Direction A: Functional Datasheet (ruled, ultra-crisp, high data density).
- Direction B: Modern B2B Workspace (elevated cards, grouped metric tiles, subtle depth).
- Direction C: Action-Oriented Portal (prominent search/filter rails, prioritized triage actions).

### Step 7: Choose One Direction Based on Product Context
- Select the direction that best serves the enterprise user's workflow without introducing friction.
- For ASTANTRA, anchor in the **Engineering Datasheet / Technical Drawing** aesthetic (#F1F3F5 page canvas, #FFFFFF surfaces, 3px radii, Archivo/IBM Plex typography).

### Step 8: Reuse the Existing Design System
- Reference semantic CSS variables (`var(--color-brand-primary)`, `var(--color-bg-page)`, `var(--radius-md)`).
- Never hardcode raw hex values or introduce foreign color palettes.

### Step 9: Implement Components
- Write clean, semantic, accessible HTML.
- In ASP.NET Web Forms, strictly preserve all server controls (`asp:TextBox`, `asp:Button`, `asp:Repeater`, `asp:PlaceHolder`), event handlers, and data binding expressions.
- Structure layouts using responsive CSS grid and flexbox.

### Step 10: Add Meaningful Micro-Interactions
- Ensure animations have a clear UX purpose: feedback, affordance, or spatial hierarchy.
- Use 120ms–180ms transitions for button and hover feedback.
- Use 180ms–250ms for drawer slides and card elevation.
- Use smooth cubic-bezier easing (`cubic-bezier(0.2, 0.8, 0.2, 1)`).
- Honor `prefers-reduced-motion`.

### Step 11: Check Responsive Behavior
- Verify layout at mobile (375px–414px), tablet (768px), and desktop (1024px–1440px).
- Verify that table columns collapse gracefully or support clean horizontal scrolling.
- Confirm touch target dimensions (minimum 44×44px on mobile).

### Step 12: Check Accessibility
- Ensure contrast ratio meets WCAG AA (minimum 4.5:1 for body copy).
- Verify keyboard navigation order and visible focus rings (`outline: 2px solid var(--color-brand-primary)`).
- Confirm explicit `<label>` tags on all inputs and descriptive ARIA attributes where needed.

### Step 13: Use Playwright / Browser Inspection for Rendered UI Verification
- Use Playwright MCP or browser tools to inspect the rendered page across desktop and mobile viewports.
- Check for overflow, layout shifts, clipped text, or broken alignments.

### Step 14: Iterate Based on Visual Problems
- Fix any detected visual defects, awkward wrapping, or contrast regressions before declaring completion.

### Step 15: Avoid Unnecessary Redesign
- Do not redesign working pages simply to introduce novel trends.
- Make surgical, high-impact improvements that preserve core functionality and student explainability.
