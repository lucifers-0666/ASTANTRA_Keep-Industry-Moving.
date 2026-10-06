# Design System

## 1. Design Direction

ASTANTRA is an enterprise B2B platform connecting factories, spare-part suppliers, and field service technicians. The visual personality is **Industrial Field Guide meets Engineering Precision Datasheet**:

- **Visual Personality**: High-trust, professional, utilitarian, precise, and data-dense.
- **Aesthetic Metaphor**: Technical engineering drawings, industrial spec sheets, ruled ledgers, and aerospace instrumentation panels.
- **Tone & Mood**: Calm, focused, and restrained. No consumer e-commerce gimmickry, no neon glow, no purple/indigo gradients, and no generic marketing hyperbole.
- **Information Architecture**: Clear visual hierarchy, ruled data dividers, high contrast, explicit external form labels, and progressive disclosure for complex filters.

---

## 2. Color System

All colors are defined semantically via CSS Custom Properties in [`css/variables.css`](file:///E:/ASP.NET%20MCA/css/variables.css) and [`Content/css/site-shell.css`](file:///E:/ASP.NET%20MCA/Content/css/site-shell.css).

| Semantic Token | Variable | Hex / RGBA | Intended Usage & Constraint |
| :--- | :--- | :--- | :--- |
| **Primary** | `--color-brand-primary` | `#1769E0` | Electric industrial blue. Primary actions, main search triggers, active navigation rules, and focus rings. |
| **Primary Hover** | `--color-brand-hover` | `#1257BE` | Darkened state on hover/focus. |
| **Primary Tint** | `--color-brand-primary-light` | `#EAF2FF` | Selected table row background, subtle blue pill background. |
| **Secondary** | `--color-deep-navy` | `#142337` / `#101C2C` | Deep structural anchor. Used for breakdown warning bands and footer containers. |
| **Accent (Emergency)** | `--color-emergency` | `#F07818` / `#E87519` | Dedicated safety orange. **Strictly restricted** to emergency breakdown protocols and hotline actions. |
| **Background (Page)** | `--color-bg-page` / `--bg` | `#F1F3F5` | Light cool industrial gray canvas. The page canvas is never pure white, preventing eye strain. |
| **Background (Subtle)**| `--color-bg-subtle` | `#E7EBEF` | Secondary section bands and alternating zebra stripes. |
| **Surface** | `--color-bg-surface` / `--surface` | `#FFFFFF` | Elevated crisp white surfaces. Reserved strictly for functional cards, tables, forms, and panels. |
| **Elevated Surface** | `--glass-bg-elevated` | `rgba(255, 255, 255, 0.96)` | Scrolled header, dropdowns, and flyout navigation drawers. |
| **Text (Primary)** | `--color-text-primary` / `--text` | `#202833` / `#111827` | High-contrast charcoal text ensuring > 10:1 contrast on white surfaces. |
| **Text (Body)** | `--color-text-body` | `#2C384A` | Primary body reading text (line-height 1.6). |
| **Muted Text** | `--color-text-secondary` | `#667180` / `#5F6B7A` | Metadata, subheadings, and secondary descriptions. |
| **Tertiary Text** | `--color-text-muted` | `#8792A0` | Form hint text, table column captions, serial numbers. |
| **Border (Default)** | `--color-border-default` | `#D7DDE4` / `#D9DEE5` | Structural 1px hairline rules and component borders. |
| **Border (Strong)** | `--color-border-strong` | `#C4CDD7` | Emphasized perimeter borders, active container boundaries. |
| **Success** | `--color-status-success` | `#16845B` / `#18865B` | Verified supplier GSTIN, active technician beacon, in-stock status. |
| **Warning** | `--color-status-warning` | `#B96A13` | Low stock warning, quotation pending review. |
| **Error** | `--color-status-error` | `#C53D45` | Validation failures, rejected RFQs, breakdown state. |
| **Info** | `--color-status-info` | `#0284C7` | Informational announcements and system telemetry. |

---

## 3. Typography

Fonts are imported via Google Fonts: **Archivo** (Display & Headings), **IBM Plex Sans** (Body & Interface), and **IBM Plex Mono** (Technical Specs & Data).

| Hierarchy | Font Family | Size (Desktop / Mobile) | Weight | Line Height | Letter Spacing | Usage |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Display** | `Archivo` | `clamp(2.25rem, 5vw, 3.5rem)` | 800 / 900 | 1.15 | `-0.025em` | Hero landing headlines |
| **Heading 1** | `Archivo` | `2rem` (32px) / `1.75rem` | 700 | 1.25 | `-0.02em` | Primary page headers (`<h1>`) |
| **Heading 2** | `Archivo` | `1.5rem` (24px) / `1.375rem` | 600 | 1.3 | `-0.015em` | Section headings (`<h2>`) |
| **Subheading** | `Archivo` | `1.125rem` (18px) | 600 | 1.4 | `0` | Card titles, group headers |
| **Body (Default)** | `IBM Plex Sans` | `1rem` (16px) | 400 | 1.6 | `0` | Explanatory narrative, descriptions |
| **Body (Dense)** | `IBM Plex Sans` | `0.875rem` (14px) | 500 | 1.5 | `0` | Table cell data, input text |
| **Caption & Meta** | `IBM Plex Mono` | `0.75rem` (12px) | 500 | 1.3 | `+0.05em` | Timestamps, part counts, tolerances |
| **Button** | `IBM Plex Sans` | `0.875rem` (14px) | 700 | 1.0 | `+0.02em` | Interactive buttons (`.c-btn`) |
| **Navigation** | `IBM Plex Sans` | `0.875rem` (14px) | 600 | 1.0 | `+0.01em` | Header navigation links |
| **Technical Specs** | `IBM Plex Mono` | `0.875rem` (14px) | 600 | 1.2 | `+0.02em` | OEM Part Numbers, GSTIN, prices |

---

## 4. Spacing Scale

Based on a strict 8px harmonic grid with a 4px half-step for micro-alignments:

| Token | Pixels | Rem Equivalent | Common Application |
| :--- | :--- | :--- | :--- |
| `--s1` | `4px` | `0.25rem` | Badge padding, icon gap, border offset |
| `--s2` | `8px` | `0.5rem` | Inner element gap, compact button padding |
| `--s3` | `16px` | `1rem` | Standard component padding, card gap |
| `--s4` | `24px` | `1.5rem` | Card body padding, grid row gap |
| `--s5` | `40px` | `2.5rem` | Section padding (mobile), card container inset |
| `--s6` | `64px` | `4rem` | Section padding (desktop) |
| `--s7` | `96px` | `6rem` | Hero block spacing, major architectural divides |

---

## 5. Border Radius

Industrial precision dictates crisp geometry. Bubbly, pill-shaped cards (16px–24px) are strictly prohibited.

- **Small (`--radius-sm`)**: `2px` — Monospace tags, technical spec chips.
- **Medium (`--radius-md` / `--radius`)**: `3px` — **Authoritative project standard**. Applied to buttons, cards, panels, and table shells.
- **Large (`--radius-lg` / `--radius-xl`)**: `4px – 6px` — Form inputs, modal dialogs, and outer container frames.
- **Pill (`rounded-full`)**: `9999px` — **Strictly isolated** to compact status badges (`.c-badge`, `.badge-verified`) and pulse beacon indicators.

---

## 6. Shadows & Physical Depth

Shadows are calibrated to be subtle, clean, and physically grounded. No muddy diffuse blurs or colored neon drop shadows.

- **Subtle (`--shadow-subtle`)**: `0 1px 2px 0 rgba(20, 35, 55, 0.04)` — Default static cards, form inputs.
- **Card (`--shadow-card`)**: `0 1px 3px 0 rgba(20, 35, 55, 0.04)` — Resting surface containers with 1px border.
- **Elevated (`--shadow-card-hover`)**: `0 6px 16px -2px rgba(20, 35, 55, 0.08)` — Interactive cards on hover.
- **Modal / Dropdown (`--shadow-dropdown`)**: `0 6px 20px 0 rgba(20, 35, 55, 0.08)` — Floating menus, popovers, and dialogs.
- **Header Glass (`--glass-shadow`)**: `0 4px 20px -2px rgba(32, 40, 51, 0.05)` — Scrolled fixed navigation shell.

---

## 7. Reusable Component Patterns

All UI elements follow BEM naming conventions (`.c-*` for components, `.l-*` for layouts, `.u-*` for utilities).

### 1. Buttons (`.c-btn`)
- `.c-btn--primary`: Industrial Blue (`#1769E0`), white text, 150ms hover elevation.
- `.c-btn--secondary`: Pure white surface, 1px `#D7DDE4` border, `#202833` text, subtle hover.
- `.c-btn--emergency`: Safety Orange (`#F07818`), reserved strictly for breakdown submission.
- `.c-btn--success`: Emerald Green (`#16845B`), verified actions and order approvals.

### 2. Form Inputs (`.c-form-input`, `.c-form-group`)
- High-contrast background (`#FFFFFF`), 1px `#D7DDE4` border, 3px–6px radius.
- Focus: 2px solid `#1769E0` with 2px offset; zero layout displacement.
- Explicit uppercase mono/sans label (`.c-form-label`) placed outside and above input.
- Clear error state with inline explanation text and subtle shake utility (`.u-shake`).

### 3. Cards & Surfaces (`.c-card`, `.c-stat-card`, `.panel`)
- Crisp white surface (`#FFFFFF`), hairline border (`1px solid #D7DDE4`), 3px border radius.
- `.c-stat-card`: Key industrial metric displayed in bold `IBM Plex Mono` with uppercase caption.

### 4. Badges & Tags (`.c-badge`)
- `.c-badge--verified`: Light green tint (`#E8F5F0`), `#16845B` text, 1px green border.
- `.c-badge--emergency`: Safety orange tint (`#FEF4EC`), `#F07818` text, 1px orange border.
- `.c-badge--blue`: Light blue tint (`#EAF2FF`), `#1769E0` text.
- `.c-badge--neutral`: Gray tint (`#E7EBEF`), `#667180` text.

### 5. Navigation Shell (`.site-header`, `.site-desktop-nav`)
- Fixed at top with authoritative `68px` height (desktop) / `60px` (mobile).
- Restrained 2px bottom accent indicator (`border-bottom: 2px solid var(--color-brand-primary)`) for the active page. Never heavy pill fills.
- Mobile drawer with accessible backdrop, `Escape` key capture, and body scroll lock (`body.menu-open`).

### 6. Data Tables & Ledgers (`.table-custom`, `.ledger`)
- Ruled tabular layout (`border-collapse: collapse; width: 100%`).
- Monospace numerical columns (pricing, OEM codes, lead times).
- Subtle `#F7F8FA` row highlight on hover.

### 7. Alerts & Banners (`.c-alert`, `.band--navy`)
- Emergency breakdown alert: High-contrast navy container (`#101C2C`) with orange warning accent.
- Inline form alerts: 1px border with matching tinted background for warning, success, or error.

### 8. Loading & Empty States
- **Loading State**: Subtle mechanical skeleton shimmer (`.u-shimmer`) with calm opacity pulse. No chaotic full-screen spinners.
- **Empty State**: Ruled container with clean technical icon, monospace label ("0 RECORDS FOUND"), and clear corrective action button.

---

## 8. Motion & Micro-Interactions

Every animation serves a distinct UX purpose: state confirmation, spatial continuity, or focus guidance.

- **Fast Micro-Interactions (120ms – 180ms)**: Button hover, focus ring reveal, active state press. Easing: `cubic-bezier(0.2, 0.8, 0.2, 1)`.
- **Normal UI Transitions (180ms – 250ms)**: Dropdown menus, mobile navigation drawer slide, card elevation.
- **Entrance Cascade (300ms)**: Hero item load sequence ([`.u-animate-cascade`](file:///E:/ASP.NET%20MCA/css/animations.css#L7-L27)) staggered at 40ms intervals.
- **Status Beacons**: Subtle mechanical 2.5s pulse glow ([`.u-pulse-beacon`](file:///E:/ASP.NET%20MCA/css/animations.css#L41-L53)) for verified online technicians.
- **Reduced Motion Support**:
  ```css
  @media (prefers-reduced-motion: reduce) {
      *, *::before, *::after {
          animation-duration: 0.01ms !important;
          animation-iteration-count: 1 !important;
          transition-duration: 0.01ms !important;
      }
  }
  ```

---

## 9. Responsive Breakpoints

- **Mobile (< 640px)**: Single-column stacked layouts, full-width buttons, collapsible filter panels, accessible 60px fixed header with hamburger drawer.
- **Tablet (640px – 1023px)**: 2-column card layouts, compact table view with horizontal scrolling wrappers, hybrid navigation.
- **Desktop (1024px – 1440px)**: 3-to-4 column grids, full horizontal navigation bar with route indicators, side-by-side filter rails and data tables.
- **Wide Screens (> 1440px)**: Content bounded by `max-w-[1440px]` centered canvas; never stretched indefinitely.

---

## 10. Accessibility Standards

- **Contrast Ratios**: Minimum **4.5:1** contrast on body copy and **3:1** on large display headings against `#FFFFFF` and `#F1F3F5`. Charcoal `#202833` achieves > 10:1.
- **Keyboard Navigation**: Fully tab-navigable. Interactive elements feature visible focus rings: `outline: 2px solid var(--color-brand-primary); outline-offset: 2px;`.
- **Form Labels**: Every form field features an explicit, external `<label>` tag with `for` attribute matching input IDs.
- **Semantic HTML**: Proper heading hierarchy (`h1` → `h2` → `h3`), semantic landmarks (`<header>`, `<nav>`, `<main>`, `<footer>`, `<section>`), and `aria-expanded` / `aria-current="page"` attributes on navigational elements.
