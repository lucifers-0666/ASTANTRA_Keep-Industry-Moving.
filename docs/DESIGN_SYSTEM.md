# SPAREFINDER Design System (human-readable reference)

Direction: **datasheet / engineering drawing**. Precise, ruled, mono-labelled,
calm. Fonts and details below are the team's starting choices; change them via
`docs/DECISIONS.md`, not silently.

## 1. Tokens (`Content/css/tokens.css`)
```css
:root {
  /* Color */
  --bg: #F1F3F5;         --surface: #FFFFFF;
  --text: #111827;       --text-2: #5F6B7A;
  --border: #D9DEE5;
  --blue: #1769E0;       --navy: #101C2C;   --navy-dark: #0B1422;
  --orange: #E87519;     --green: #18865B;

  /* Type */
  --font-head: "Archivo", "Segoe UI", sans-serif;
  --font-body: "IBM Plex Sans", "Segoe UI", sans-serif;
  --font-mono: "IBM Plex Mono", Consolas, monospace;

  /* Shape and spacing (8px base) */
  --radius: 3px;
  --s1: 4px; --s2: 8px; --s3: 16px; --s4: 24px; --s5: 40px; --s6: 64px; --s7: 96px;
  --rule: 1px solid var(--border);

  /* Motion */
  --ease-out: cubic-bezier(.2,.7,.2,1);
  --t-fast: 150ms; --t-ui: 250ms; --t-reveal: 600ms;
}
```

## 2. Type scale
| Use | Font | Size / weight |
|---|---|---|
| Hero heading | Archivo | clamp(2.25rem, 5vw, 3.75rem) / 700 |
| Section heading | Archivo | clamp(1.5rem, 3vw, 2.25rem) / 600 |
| Body | IBM Plex Sans | 1rem / 400, line-height 1.6, max 65ch |
| Label (uppercase) | IBM Plex Mono | 0.75rem / 500, letter-spacing .08em |
| Part no., specs, lead time | IBM Plex Mono | 0.875-1rem |

## 3. Components (`Content/css/components.css`)
| Component | Notes |
|---|---|
| `.btn`, `.btn--primary`, `.btn--ghost`, `.btn--emergency` | Blue primary; orange only emergency; arrow nudges 3px on hover |
| `.field` | Label above, 1px border, blue focus ring, error text in orange-red token |
| `.ledger`, `.ledger__row` | Ruled list rows for parts/suppliers/technicians; row highlight on hover |
| `.badge`, `.badge--verified` | Mono text; green only for real verified status |
| `.panel` | White surface, 1px border, optional corner ticks (`.panel--ticks`) |
| `.rail` | Horizontal numbered process line (Search, RFQ, Quotes, Order) |
| `.band--navy` | Full-bleed navy section for the single high-impact block |
| `.reveal` | Scroll reveal hook, used with `site.js` |

## 4. Layout rules
- Page container max 1200px; 12-column grid; mobile first.
- Alternate section layouts (split, full-bleed band, ruled list) so no two
  neighbors look the same.
- Wide tables scroll inside their own container on mobile.

## 5. Homepage recipe (5 sections)
1. **Search-first hero:** part-number search + animated SVG part drawing.
2. **Sourcing rail:** Search, RFQ, Quotes, Order; line draws on scroll.
3. **Emergency band:** navy, one orange action, short text.
4. **Directory ledger:** parts / suppliers / technicians as ruled rows.
5. **Closing action + footer.**

## 6. Page budgets
| Page | Sections | Primary action |
|---|---|---|
| Home | 5 | Search a part |
| Parts | 3 (search, filters, results) | Open part / request quote |
| Suppliers | 3 | View supplier |
| Technicians | 3 | View technician |
| How It Works | 3 | Start searching |
| Why Us | 3 (reasons are real project capabilities only) | Register |
| Emergency | 2 (form + 3 steps) | Submit request |

## 7. File map
`Content/css/` : tokens.css, base.css, components.css, animations.css,
`public/` : home.css, parts.css, suppliers.css, technicians.css,
how-it-works.css, why-us.css, emergency.css. `Content/js/site.js`.
Adapt to what already exists; do not create duplicate systems.
