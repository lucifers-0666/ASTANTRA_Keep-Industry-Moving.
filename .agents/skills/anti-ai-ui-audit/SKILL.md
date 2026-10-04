---
name: anti-ai-ui-audit
description: Audit a SPAREFINDER page for generic AI-generated UI patterns, excessive density, and styling compliance. Use after building or restyling any page, or when checking whether a page looks AI-made or too complicated.
---

# Anti-AI UI & Industrial Design Audit

Evaluate each category as **PASS** or **FAIL**. For any item marked **FAIL**, specify the exact line/component fix.

---

## 1. Structural Architecture & Density
- [ ] **No Generic Hero**: The page does NOT feature a centered generic hero followed by 3 identical rounded cards.
- [ ] **Section Budget**: Homepage does not exceed 5 sections; other public pages do not exceed 3–4 sections.
- [ ] **Layout Variety**: Adjacent sections use contrasting layouts (e.g., split columns, ruled tabular ledgers, navy band).
- [ ] **Singular Focus**: Exactly one unambiguous primary action (CTA) per viewport.
- [ ] **Progressive Disclosure**: Advanced filters and technical parameters are collapsed by default.

---

## 2. Visual Identity & Design Tokens
- [ ] **Authentic Typography**: Headings use `Archivo`; body copy uses `IBM Plex Sans`; technical specs and IDs use `IBM Plex Mono`. Not default Inter, Roboto, or Arial.
- [ ] **Restrained Borders**: Border radius is tight (2px–4px); no hyper-rounded pill containers.
- [ ] **Ruled Surfaces**: Data tables, ledgers, and horizontal rules are preferred over endless floating card boxes.
- [ ] **Palette Discipline**: Uses CSS variables (`var(--bg)`, `var(--surface)`, `var(--blue)`). No raw hex values in page CSS.
- [ ] **Emergency Orange Restriction**: Orange is strictly isolated to emergency breakdown triggers; blue is used for standard primary actions.
- [ ] **No Gimmicks**: Zero purple gradients, frosted glassmorphism, glowing neon borders, or floating blobs.

---

## 3. Copy & Academic Integrity
- [ ] **Domain Specificity**: Copy uses authentic industrial B2B terminology (part numbers, OEM tolerances, RFQ bidding, lead time).
- [ ] **Zero Marketing Fluff**: Free of clichés like "seamless integration", "cutting-edge revolution", or "next-gen AI platform".
- [ ] **Demo Labeling**: Prototype data, test catalogs, and simulated pricing are clearly labeled as "Demo Data".
- [ ] **No Fabricated Trust**: No fake 5-star ratings, synthetic customer reviews, or unverified corporate logos.

---

## 4. Motion & Performance
- [ ] **Restrained Motion**: Subtle micro-interactions only; no scroll-jacking, mouse-follow trails, or heavy looping animations.
- [ ] **Hardware Acceleration**: Only `transform` and `opacity` are animated; zero `transition: all`.
- [ ] **Accessibility**: `@media (prefers-reduced-motion: reduce)` block is present and disables animations.
- [ ] **Asset Footprint**: Images have explicit width/height and lazy loading; fonts use `font-display: swap`.

---

## 5. Explainability & Web Forms Safety
- [ ] **File Headers**: Stylesheet and script contain mandatory descriptive header comments.
- [ ] **Server Controls**: Every `runat="server"`, `ID`, and event handler in the `.aspx` page is intact.
- [ ] **Viva Readiness**: A student can explain every CSS rule and JS function in under 30 seconds.
- [ ] **VIVA_NOTES Updated**: Relevant entry recorded in `docs/VIVA_NOTES.md`.

---

## The 5-Second Recognition Test
*If the SPAREFINDER logo is hidden, does the interface immediately read as an industrial technical datasheet rather than a generic SaaS marketing template?*

