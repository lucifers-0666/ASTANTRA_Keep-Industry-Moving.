# Industrial Design System & Specification
## SPAREFINDER — Industrial Spare Parts Procurement Network

---

## 1. Design Direction: Datasheet & Engineering Precision

SPAREFINDER is an enterprise B2B platform connecting factories, spare-part suppliers, and maintenance technicians. The aesthetic direction is modeled on an **engineering datasheet / technical drawing**:
- **Light Cool Gray Background (`#F1F3F5`)**: Eliminates glaring white page canvases; grounds the technical content.
- **Crisp White Content Surfaces (`#FFFFFF`)**: Used strictly for functional panels, tables, forms, and cards.
- **Data-First Readability**: High-contrast dark navy text (`#111827`) paired with secondary metadata gray (`#5F6B7A`).
- **Semantic Color Restraint**: Blue is reserved for primary actions; safety orange is strictly isolated to emergency breakdown protocols; green indicates verified operational status.

---

## 2. Master Token Reference

All styles must derive from CSS Custom Properties defined in `Content/css/tokens.css`:

```css
:root {
  /* Surface & Base Colors */
  --bg: #F1F3F5;             /* Primary Page Background */
  --surface: #FFFFFF;        /* Elevated Content Surfaces */
  --text: #111827;           /* High-contrast Primary Text */
  --text-2: #5F6B7A;         /* Secondary / Metadata Text */
  --border: #D9DEE5;         /* Hairline 1px Structural Borders */

  /* Brand & Status Accents */
  --blue: #1769E0;           /* Primary Action Blue */
  --navy: #101C2C;           /* High-contrast Navy Section Band */
  --navy-dark: #0B1422;      /* Deep Navy Structural Anchor */
  --orange: #E87519;         /* Emergency Breakdown Orange (RESTRICTED) */
  --green: #18865B;          /* Verified Entity Status Green */

  /* Typography Stacks */
  --font-head: "Archivo", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  --font-body: "IBM Plex Sans", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  --font-mono: "IBM Plex Mono", Consolas, "Courier New", monospace;

  /* Geometry & Spacing (8px Base Scale) */
  --radius: 3px;             /* Crisp 2-4px Border Radius */
  --s1: 4px;   --s2: 8px;   --s3: 16px; 
  --s4: 24px;  --s5: 40px;  --s6: 64px;  --s7: 96px;
  --rule: 1px solid var(--border);

  /* Micro-Interactions & Transitions */
  --ease-out: cubic-bezier(0.2, 0.7, 0.2, 1);
  --t-fast: 150ms;
  --t-ui: 250ms;
  --t-reveal: 600ms;
}
```

---

## 3. Typography Scale & Application

| Hierarchy | Font Family | Size / Weight | Intended Usage |
| :--- | :--- | :--- | :--- |
| **Hero Title** | `Archivo` | `clamp(2.25rem, 5vw, 3.75rem)` / 700 | Primary landing page statement |
| **Section Heading** | `Archivo` | `clamp(1.5rem, 3vw, 2.25rem)` / 600 | Clear section boundaries |
| **Body Paragraph** | `IBM Plex Sans`| `1rem (16px)` / 400 (Line-height 1.6) | Explanatory text (max 65ch per line) |
| **Labels & Tags** | `IBM Plex Mono` | `0.75rem (12px)` / 500 (Uppercase, letter-spacing 0.08em) | Form labels, category badges, table headers |
| **Technical Specs** | `IBM Plex Mono` | `0.875rem–1rem` / 500 | Part numbers, OEM codes, lead times, pricing |

---

## 4. Reusable Component Patterns (`Content/css/components.css`)

- **`.btn`**: Base button with 3px radius, inline-flex alignment, and 150ms hover feedback.
  - `.btn--primary`: Solid industrial blue (`var(--blue)`).
  - `.btn--ghost`: Bordered outline button (`1px solid var(--border)`).
  - `.btn--emergency`: Dedicated safety orange button (`var(--orange)`), reserved exclusively for machine breakdown requests.
- **`.field`**: Accessible form group with upper label, 1px border, blue focus ring, and validation message container.
- **`.ledger`, `.ledger__row`**: Ruled data list rows for spare parts, suppliers, and technicians with subtle hover highlighting.
- **`.badge`**: Monospace metadata badge. `.badge--verified` uses green token for authenticated GSTIN entities.
- **`.panel`**: White surface container with 1px border. Optional `.panel--ticks` adds subtle engineering corner crosshairs.
- **`.rail`**: Sequential procurement milestone indicator (Search → RFQ → Compare → Order).
- **`.band--navy`**: Full-bleed high-contrast navy container for emergency alerts or critical focal sections.
- **`.reveal`**: Single-pass scroll reveal utility powered by a lightweight `IntersectionObserver`.

---

## 5. Navigation & Form Accessibility Standards

- **Active Navigation State**: Restrained 2px bottom accent rule (`border-bottom: 2px solid var(--blue)`) with bold text and `aria-current="page"`. Never use heavy, saturated pill fills.
- **Mobile Navigation Drawer**: Clean side-draw menu with subtle left border highlight (`border-left: 3px solid var(--blue)`).
- **Keyboard Tab Navigation**: Visible focus rings on all interactive elements (`outline: 2px solid var(--blue); outline-offset: 2px`).
- **Input Labels & Autocomplete**: Labels are placed externally above inputs; inputs specify standard `autocomplete` attributes.

---

## 6. Page Budgets & Structural Recipes

### A. Homepage (Maximum 5 Sections)
1. **Search-First Hero**: Immediate OEM part number input + schematic line art.
2. **Procurement Process Rail**: 4-step clear workflow (Search, RFQ, Quotes, Order).
3. **Emergency Breakdown Band**: High-contrast navy block with single orange CTA.
4. **Directory Preview Ledger**: Ruled rows previewing popular parts, suppliers, and technicians.
5. **Closing Action & Footer**: Compact enterprise procurement sign-off.

### B. Public Directory & Information Pages (Maximum 3 to 4 Sections)
- **Parts Catalog (`Public/Parts.aspx`)**: Search bar, collapsed category filters, and tabular part comparison ledger.
- **Suppliers Directory (`Public/Suppliers.aspx`)**: Verified supplier directory, location distance, and capability tags.
- **Technicians Directory (`Public/Technicians.aspx`)**: Field technician credentials, specializations, and real-time duty status.
- **How It Works (`Public/HowItWorks.aspx`)**: 3-phase industrial lifecycle explanation.
- **Why Choose Us (`Public/WhyUs.aspx`)**: Honest tabular comparison between traditional sourcing and digital procurement.
- **Emergency Breakdown (`Public/Emergency.aspx`)**: High-priority alert submission form and emergency hotline details.

