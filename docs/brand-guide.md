# ASTANTRA — Official Brand Identity & Design Guidelines

> **Platform**: ASTANTRA — B2B Industrial Spare Parts Procurement & Maintenance Network  
> **Brand Identity Version**: 1.0  
> **Effective Date**: October 2026  
> **Scope**: Master Brand Architecture, Vector Logo System, Favicons, Color Palette, Typography & Academic Viva Defense

---

## 1. Brand Strategy & Positioning

### 1.1 Brand Name
* **Working Brand**: **ASTANTRA**
* **Pronunciation**: */uh-STAN-truh/* (`uh-STAN-tra`)
* **Linguistic Origin & Etymology**:
  - Rooted in the Sanskrit / Indic technical concept **Tantra** (तन्त्र — *system, apparatus, underlying mechanism, interwoven network*).
  - Combined with the dynamic apex prefix **A-** (*continuous, sovereign, universal*), signifying an unbroken, highly reliable industrial mechanical system.
  - Conveys operational engineering, structured procurement discipline, and industrial continuity.

### 1.2 Core Positioning
> **"The digital nervous system for manufacturing plant procurement, connecting factory buyers with verified regional stockists and specialized field engineers."**

ASTANTRA replaces chaotic, unrecorded telephone sourcing and weeks of machine downtime with OEM-indexed part cross-referencing, multi-vendor quotation comparison (RFQ), and priority emergency breakdown dispatch.

### 1.3 Tagline & Category Hierarchy
| Hierarchy Level | Copy | Typography & Color | Application |
|---|---|---|---|
| **Primary Tagline** | `KEEP INDUSTRY MOVING` | Archivo Bold, Tracking +0.14em, Cobalt Blue (`#1769E0`) | Hero units, official logo lockups, corporate headers |
| **Subtitle / Category** | `Industrial Parts · Procurement · Services` | Archivo SemiBold, Slate Gray (`#5F6B7A`) | Full brand lockups, presentation slides, print collaterals |
| **System Descriptor** | `Industrial Spare Parts Procurement Network` | IBM Plex Sans, Charcoal (`#17212F`) | Master headers, footer copyright line, metadata tags |

---

## 2. Logo Design Concept: The Structural Apex

The ASTANTRA logo is built on **Concept A — The Structural Apex**.

```
             ▲             <-- 1. High-Tensile Cobalt Chevron (#1769E0)
            / \                Represents upward momentum, industrial precision,
           /   \               and modern B2B technology.
          /  ▲  \
         /  / \  \
        /  /===\  \        <-- 2. Charcoal Navy Cross-Member (#17212F)
       /__/     \__\           Represents heavy machine structural foundation,
                               rigidity, and operational resilience.
```

### Key Symbolic Rationale:
1. **The Letterform 'A'**: Distinctive architectural monogram that establishes instant brand recognition across favicons, application headers, and mobile home-screens.
2. **Delta Chevron**: Evokes delta engineering mechanics, precision tools, calipers, and progressive industrial momentum.
3. **Dual-Tone Interlock**: The interplay between Cobalt Blue (`#1769E0`) and Charcoal Navy (`#17212F`) reflects the convergence of heavy manufacturing infrastructure with digital procurement agility.

---

## 3. Official Logo System & Asset Manifest

All vector assets are generated in standards-compliant SVG with explicit viewBox geometry and self-contained vector paths.

| Asset File | Dimensions | Intended Usage |
|---|---|---|
| `Content/images/brand/logo-symbol.svg` | `100x100` (Vector) | Standalone mark, app launcher, favicon source, watermark |
| `Content/images/brand/logo-primary.svg` | `280x44` (Vector) | Primary horizontal header lockup (Symbol + Wordmark + Tagline) |
| `Content/images/brand/logo-compact.svg` | `180x38` (Vector) | Compact navbar, mobile header, invoices, and table headers |
| `Content/images/brand/logo-stacked.svg` | `240x200` (Vector) | Official splash screen, auth portal right panel, documentation cover |
| `Content/images/brand/logo-dark.svg` | `280x44` (Vector) | Dark backgrounds, terminal interfaces, and supplier dark-mode |
| `Content/images/brand/logo-monochrome.svg` | `280x44` (Vector) | Single-color laser etching, shipping labels, black-and-white print |

---

## 4. Multi-Resolution Favicon System

ASTANTRA implements a comprehensive favicon architecture supporting legacy Windows browsers, modern multi-density screens, and mobile application wrappers:

| File Location | Format / Spec | Resolution | Purpose |
|---|---|---|---|
| `favicon.ico` (Root) | Windows Multi-Icon | 16x16, 32x32, 48x48 | Legacy IE, Chrome/Edge address bar & bookmarks |
| `Content/images/brand/favicon.ico` | Windows Multi-Icon | 16x16, 32x32, 48x48 | Direct resource fallback |
| `Content/images/brand/favicon.svg` | Scalable Vector Graphic | Any (Vector) | Modern evergreen browsers (Chrome, Firefox, Safari) |
| `Content/images/brand/favicon-16.png` | Standard PNG | 16x16 px | Standard browser tab icon |
| `Content/images/brand/favicon-32.png` | Standard PNG | 32x32 px | High-DPI browser tab / bookmarks |
| `Content/images/brand/favicon-48.png` | Standard PNG | 48x48 px | Windows desktop shortcut icon |
| `Content/images/brand/apple-touch-icon.png` | iOS App Icon | 180x180 px | iOS Safari home screen bookmark |
| `Content/images/brand/icon-192.png` | Android PWA Icon | 192x192 px | Android home screen / PWA launch screen |
| `Content/images/brand/icon-512.png` | Hi-Res Splash Icon | 512x512 px | App store listings, PWA splash screens |

### Web Forms MasterPage Implementation:
```html
<!-- Favicon & Brand Icons -->
<link rel="icon" type="image/svg+xml" href="<%= ResolveUrl("~/Content/images/brand/favicon.svg") %>" />
<link rel="alternate icon" href="<%= ResolveUrl("~/favicon.ico") %>" />
<link rel="icon" type="image/png" sizes="32x32" href="<%= ResolveUrl("~/Content/images/brand/favicon-32.png") %>" />
<link rel="icon" type="image/png" sizes="16x16" href="<%= ResolveUrl("~/Content/images/brand/favicon-16.png") %>" />
<link rel="apple-touch-icon" sizes="180x180" href="<%= ResolveUrl("~/Content/images/brand/apple-touch-icon.png") %>" />
```

---

## 5. Color Palette System

The ASTANTRA color system combines a disciplined, light industrial gray baseline with high-contrast charcoal typography, authoritative cobalt blue, and safety-compliant emergency indicators.

### 5.1 Primary Brand Colors
```
#1769E0                        #17212F                        #F1F3F5
Primary Cobalt Blue            Charcoal Navy                  Industrial Neutral Gray
RGB(23, 105, 224)              RGB(23, 33, 47)                RGB(241, 243, 245)
Accent, Primary CTAs           Structural Text, Mark Core     Page Canvas Background
```

### 5.2 Complete Color Matrix
| Token Name | Hex Code | RGB | Purpose & Semantic Role |
|---|---|---|---|
| `--color-brand-primary` | `#1769E0` | `23, 105, 224` | Primary brand blue, interactive links, primary buttons |
| `--color-brand-hover` | `#1257BE` | `18, 87, 190` | Hover state for primary cobalt interactive elements |
| `--color-brand-dark` | `#17212F` | `23, 33, 47` | Logo inner wedge, authoritative wordmark, deepest text |
| `--color-bg-base` | `#F1F3F5` | `241, 243, 245` | Global body background (eliminates harsh white glare) |
| `--color-surface-white` | `#FFFFFF` | `255, 255, 255` | Card surfaces, modals, input backgrounds, navigation |
| `--color-text-primary` | `#202833` | `32, 40, 51` | Primary heading and high-emphasis body text |
| `--color-text-secondary`| `#667180` | `102, 113, 128` | Secondary labels, descriptions, subheadings |
| `--color-text-muted` | `#8792A0` | `135, 146, 160` | Metadata timestamps, breadcrumbs, placeholder text |
| `--color-border-default`| `#D7DDE4` | `215, 221, 228` | Authoritative 1px structural hairline borders |
| `--color-emergency` | `#F07818` | `240, 120, 24` | Emergency breakdown CTAs, urgent equipment alerts |
| `--color-success` | `#16845B` | `22, 132, 91` | Verified supplier badge, in-stock indicators |

---

## 6. Typography Guidelines

| Application | Font Family | Weights | Rationale |
|---|---|---|---|
| **Brand Wordmark & Major Headings** | `Archivo` | `800` (ExtraBold), `900` (Black) | Heavy industrial DIN-inspired geometry, clean mechanical terminals, excellent authority at distance. |
| **User Interface & Body Copy** | `IBM Plex Sans` | `400` (Regular), `500` (Medium), `600` (SemiBold) | Highly legible grotesque humanist typeface developed specifically for technical applications. |
| **OEM Numbers, Metrics & Monospace**| `IBM Plex Mono` | `500` (Medium), `700` (Bold) | Prevents visual confusion between `0` / `O` and `1` / `I` when cross-referencing serial numbers. |

---

## 7. Logo Clear Space & Minimum Sizing Rules

```
     ┌────────────────────────────────────────────────────┐
     │                     ↑ (0.5X)                       │
     │            ┌───────────────────────────┐           │
     │   ← (0.5X) │  [LOGO APEX]   ASTANTRA   │ (0.5X) →  │
     │            └───────────────────────────┘           │
     │                     ↓ (0.5X)                       │
     └────────────────────────────────────────────────────┘
```

1. **Clear Space Rule**: Maintain minimum clear space equal to `0.5X` around all edges of the logo lockup, where `X` is the height of the apex mark. No text, competing icons, or page borders may encroach within this perimeter.
2. **Minimum Digital Height**:
   - Primary Logo Lockup: Minimum height `32px` (desktop), `28px` (mobile).
   - Standalone Symbol Mark: Minimum size `16x16px`.
3. **Prohibited Variations**:
   - Do NOT rotate or tilt the Structural Apex delta.
   - Do NOT apply neon drop shadows, glowing halos, or radial gradient fills.
   - Do NOT alter the proportions between the outer chevron and inner cross-member.
   - Do NOT place the dark logo version directly onto low-contrast dark charcoal surfaces.

---

## 8. Academic Viva Voce Examination Defense Guide

When asked by academic examiners about the brand identity and frontend system during the viva:

### Q1: What is the origin and business rationale behind the name "ASTANTRA"?
> **Student Answer**:  
> *"The name ASTANTRA is derived from the Sanskrit root 'Tantra', which means system, apparatus, or underlying mechanism. We combined it with the prefix 'A-' to signify an unbroken, universal operating network. For an industrial B2B portal connecting factories with suppliers, the name conveys structural reliability, Indian industrial heritage, and modern tech capability, avoiding generic synthetic suffixes like '-ify' or '-ly'."*

### Q2: How does the logo concept reflect the portal's functional domain?
> **Student Answer**:  
> *"The logo is based on Concept A — The Structural Apex. The outer cobalt blue chevron represents technical momentum and digital procurement agility. The grounded charcoal navy trapezoidal cross-member symbolizes heavy machine foundations and plant resilience. Together, they form an architectural 'A' monogram that remains sharp and legible even at a 16x16 favicon size."*

### Q3: How is brand consistency enforced across ASP.NET Web Forms?
> **Student Answer**:  
> *"Brand consistency is enforced hierarchically:*
> *1. **Master Page Architecture**: `Site.Master`, `Factory.Master`, `Supplier.Master`, and `Technician.Master` consume centralized SVG assets via `<%= ResolveUrl("~/Content/images/brand/...") %>`.*
> *2. **Design Token Centralization**: The brand palette (`#1769E0`, `#17212F`, `#F1F3F5`) is declared in `css/variables.css` and compiled Tailwind CSS (`Content/css/site.css`), preventing ad-hoc hardcoded hex values.*
> *3. **Postback Safety**: All branding updates are purely presentational; zero server control IDs or code-behind logic were altered, guaranteeing postback integrity."*

