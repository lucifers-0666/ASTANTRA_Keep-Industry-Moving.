# UI/UX Engineering Rules & Design Principles

These authoritative rules govern all user interface development, restyling tasks, and component creation in ASTANTRA. Every design decision must be intentional, grounded, and aligned with enterprise B2B standards.

---

## The 15 Core Design Principles

### 1. Design Before Decorating
Start with content hierarchy, information architecture, and user task completion. Never begin by adding visual flourishes or decorative shapes to a poorly organized page.

### 2. Consistency Before Novelty
Maintain uniform patterns across all pages. A user should experience the same layout rhythm, button behavior, and table styling whether navigating `Public/Parts.aspx`, `Public/Suppliers.aspx`, or `Default.aspx`. Do not introduce a new aesthetic on every page.

### 3. Hierarchy Before Animation
Ensure visual priority is crystal clear before introducing any motion. The user's eye should naturally flow from Primary Heading (`h1`) → Search / Filter Rail → Tabular Content → Primary Action (`#1769E0` Blue).

### 4. Usability Before Visual Effects
Prioritize immediate clarity, fast comprehension, and rapid interaction over visual gimmicks. If a visual effect slows down scanning or obscures technical data, eliminate it.

### 5. Reuse Components Before Creating Duplicates
Before creating a new component, check existing styles in [`css/components/`](file:///E:/ASP.NET%20MCA/css/components/) (`buttons.css`, `cards.css`, `forms.css`, `badges.css`). Extend canonical classes (`.c-btn`, `.c-card`, `.c-form-input`, `.c-badge`) rather than generating duplicate variants (`btn2`, `card-new`).

### 6. Use Semantic Colors
Always utilize semantic CSS Custom Properties (`var(--color-brand-primary)`, `var(--color-bg-page)`, `var(--color-status-success)`). Never hardcode raw hex codes in markup or inline styles.

### 7. Use Restrained Gradients
Avoid loud, multi-hue, or saturated gradients (e.g., purple-to-pink or rainbow fades). ASTANTRA uses solid industrial surfaces or ultra-subtle monochromatic technical tints (e.g., `#FFFFFF` to `#F7F8FA`).

### 8. Avoid Excessive Glassmorphism
Glassmorphic materials are reserved strictly for the fixed master header (`.site-header`) with subtle blur (`blur(12px)`) to provide contextual transparency during scrolling. Never apply glassmorphism to data tables, form inputs, or content cards.

### 9. Avoid Excessive Rounded Cards
Industrial precision dictates crisp geometry. The project standard corner radius is **3px** (`--radius-md: 3px`) with a maximum of **6px** for inputs and dialogs. Hyper-rounded bubble cards (16px–24px) are strictly forbidden.

### 10. Avoid Excessive Shadows
Shadows must feel physically grounded and subtle. Use hairline 1px borders (`#D7DDE4`) for definition. Shadows are restricted to 1–3px resting elevations and 4–8px interactive hover states. Avoid heavy, dark, or diffuse drop shadows.

### 11. Avoid Excessive Animations
Every animation must have an explicit UX purpose (state feedback, error shake, or entrance sequence). Never animate elements merely because motion is possible. Cap all UI transitions at 150ms–250ms with smooth cubic-bezier easing.

### 12. Never Use Random Colors
Every color must stem from the official brand palette:
- Industrial Blue (`#1769E0`) for primary actions.
- Cool Gray (`#F1F3F5`) for canvas background.
- Charcoal Navy (`#101C2C` / `#202833`) for high-contrast bands and typography.
- Emergency Orange (`#F07818`) strictly for breakdown operations.
- Status Green (`#16845B`) strictly for verified credentials.

### 13. Never Use Random Font Combinations
Typography is locked to three purposeful Google Fonts:
- **Archivo**: Headings & display titles.
- **IBM Plex Sans**: Body text, form controls, and general reading.
- **IBM Plex Mono**: Technical specs, OEM part numbers, GSTIN codes, and pricing.

### 14. Never Introduce a Component Library Without Checking the Existing Stack
The technology stack is locked to **ASP.NET Web Forms, Tailwind CSS compilation pipeline, BEM modular CSS, and Vanilla JavaScript**. Do not introduce React, Vue, shadcn/ui, Bootstrap, or heavy JS runtime bundlers.

### 15. Preserve Existing Functionality
Zero regression tolerance. When enhancing markup or styling:
- Never alter server control IDs (`ID="..." runat="server"`).
- Never remove server event handlers (`OnClick="..."`, `OnPageIndexChanging="..."`).
- Never delete or corrupt data-binding expressions (`<%# Eval(...) %>`).
- Maintain Phase 1 Backend Freeze: do not touch `Database/`, `App_Code/`, or `*.aspx.cs` business logic.
