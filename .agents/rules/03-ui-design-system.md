# 03 — UI Design System & Aesthetic Guidelines

SPAREFINDER is an **industrial B2B procurement network**, not a generic consumer e-commerce store or marketing SaaS website. The aesthetic direction is a **technical datasheet / engineering drawing**: precise, calm, ruled, data-dense, and restrained.

---

## 1. Mandatory Color Palette

Always reference semantic CSS variables (`var(--bg)`, `var(--surface)`, `var(--blue)`) in page stylesheets; never hardcode raw hex values.

| Semantic Token | Hex Code | Purpose & Strict Usage Rules |
| :--- | :--- | :--- |
| `--bg` | `#F1F3F5` | **Primary Page Background**. The entire page canvas must be light cool gray; never pure white. |
| `--surface` | `#FFFFFF` | **White Content Surfaces**. Reserved strictly for cards, tables, search boxes, forms, and panels. |
| `--text` | `#111827` | Primary dark navy-slate text (100% contrast). |
| `--text-2` | `#5F6B7A` | Secondary muted text for subtitles, metadata, and supporting labels. |
| `--border` | `#D9DEE5` | Structural 1px hairline rules and component borders. |
| `--blue` | `#1769E0` | **Primary Action Blue**. Main search tabs, primary action buttons, active indicators. |
| `--navy` | `#101C2C` | High-contrast industrial band (e.g., breakdown alert banner, footer). |
| `--navy-dark`| `#0B1422` | Deep navy anchor surfaces. |
| `--orange` | `#E87519` | **Emergency Orange (RESTRICTED)**. Reserved strictly for machine breakdown alerts. |
| `--green` | `#18865B` | **Verified Status Green**. Used only for verified supplier/technician badges. |

---

## 2. Signature Industrial Typography & Geometry

- **Headings**: `Archivo` (bold, condensed, geometric precision).
- **Body**: `IBM Plex Sans` (engineered legibility, clean neutral geometry).
- **Technical Specs & Metadata**: `IBM Plex Mono` (part numbers, OEM tolerances, lead times, pricing figures, serial IDs).
- **Corner Radius**: Restrained `2px – 4px` (`--radius: 3px`). No bubbly, hyper-rounded pills.
- **Structural Lines**: Clean `1px solid var(--border)` divider rules. Prefer structured tabular ledgers and split column layouts over floating card grids.

---

## 3. Information Density & Section Budgets

Faculty feedback: *"Keep it focused, uncluttered, and practical."*
- **Primary Call to Action**: Exactly one unambiguous primary action per page view.
- **Homepage Section Budget**: Maximum **5 sections**:
  1. Search-first hero (OEM part lookup + technical drawing)
  2. 4-step procurement rail (Search → RFQ → Compare → Order)
  3. Emergency breakdown navy band
  4. Ruled directory preview (Parts, Suppliers, Technicians)
  5. Closing procurement CTA & footer
- **Other Public Pages Budget**: Maximum **3 to 4 sections**.
- **Progressive Disclosure**: Advanced search filters must be collapsed by default.
- **Concise Copy**: Maximum ~60 words of text per narrative block. Use concise, authentic B2B terminology (e.g., "Request RFQ", "Lead Time: 24h", "Stock: 42 Units").

---

## 4. Prohibited "AI-Generated" Clichés

The following visual patterns are strictly forbidden:
- **Generic Fonts**: Inter, Roboto, or Arial as primary display faces.
- **Card Overuse**: Wrapping every single paragraph or metric in an identical rounded white card.
- **Gimmicky Visuals**: Purple/indigo gradients, frosted glassmorphism, glowing neon borders, floating blobs.
- **Decorative Clutter**: Using random emojis as feature icons. Use a single, cohesive inline SVG stroke set.
- **Unverified Content**: Fake star ratings, invented enterprise client logos, stock smiling model photos, fabricated case studies.
- **Marketing Buzzwords**: Vague phrases such as "Seamless experience", "Next-gen platform", "Revolutionize procurement".

---

## 5. Accessibility Baseline

- **Contrast**: Minimum 4.5:1 text contrast on all viewports.
- **Focus Rings**: Clear, visible keyboard focus indicators (`outline: 2px solid var(--blue); outline-offset: 2px`).
- **Form Labels**: Every input must feature an external, explicit `<label>` element.
- **Touch Targets**: Minimum 44×44px interactive tap area on mobile viewports.

