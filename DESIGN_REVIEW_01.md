# Design Review 01 — Phase 1 public pages (7 screenshots)

Status: **Foundation accepted as a base. Page layouts NOT yet accepted as the
standard for later phases.** Fix G1-G15 first (the "Design v2 gate" below).
Based on screenshots only; code was not inspected.

## Keep (accepted foundation)
- Palette applied correctly; no gradients or glass.
- Small radius, hairline borders, mono used for part numbers/specs.
- Home inventory table: the strongest, most distinctive element. Use it as
  the model for Parts, Suppliers, Technicians.
- Emergency form plus the honest note "requires authenticated Factory account".
- Why Us "offline vs SPAREFINDER" comparison table (concept).

## Global defects (fix on every page)
- **G1 Repeated page header.** Every inner page is: gray band + mono eyebrow +
  big H1 + subtitle. Limit eyebrows to one per page and only where they carry
  information; use a compact header on inner pages.
- **G2 Equal-card grids** (the main "AI look"): Home 4 steps, Parts 3-column
  cards, How It Works 8 cards, Why Us 3 cards, Emergency 4 steps. Replace with a
  process rail, ruled tables, or numbered hairline lists.
- **G3 Misaligned left edges.** Logo, H1 and content sit on three different
  left edges on inner pages; Emergency band differs from the rest on Home. Use
  ONE `.container` for nav, headers, content, footer.
- **G4 Unverifiable or fake content.** Remove or label "Sample data":
  "Live Availability" (hard-coded sample), "< 24 Hrs RFQ turnaround",
  "< 2 Hrs emergency target", "sub-millisecond query performance",
  star rating 4.85, "~15-30 Mins" supplier lead time, "0 SKUs" next to
  "Issue RFQ", "verified distributors", "GSTIN auditing" (only if implemented).
- **G5 Imagery.** The hero and How It Works photos look like stock or
  AI-generated images (cannot confirm). Confirm source and license. The caption
  "Regional Procurement Desk, Gujarat & Maharashtra" claims something a generic
  photo cannot show. Use a licensed/own photo or an original SVG drawing.
- **G6 Tiny text.** Many labels are ~11px gray mono on gray. Minimum 12px for
  labels, 14px supporting text, 16px body.
- **G7 Mono overuse.** Mono appears in eyebrows, buttons, descriptions, footer.
  Mono only for: part numbers, specs, prices, lead times, IDs, status codes,
  table headers. Buttons and prose use IBM Plex Sans.
- **G8 Repeated emergency band** on Home, Parts and Why Us (plus nav and footer).
  Keep the nav entry; one band on Home only; a small inline link elsewhere.
- **G9 Orange misuse.** Orange appears on phase labels, Step 04 and Backorder.
  Orange = emergency only. Backorder uses secondary text plus an icon.
- **G10 Left-border accent cards** (Emergency steps) are a known AI tell. Remove.
- **G11 Footer.** Icon headings, long blurb, "Platform Comparison" link of
  unclear purpose. Simplify to logo, one line, two link groups, copyright.
- **G12 Crowded nav.** 6 links + pill + Sign In + Register. Recommend 4 primary
  links + Emergency + Sign In/Register; move Why Us to the footer (team decides).
- **G13 Button type is inconsistent** (sans on some pages, mono on others).
  One button style, sans, set in `components.css`.
- **G14 Signature layer missing.** The documented identity (SVG part drawing,
  sourcing rail, corner ticks, scroll reveals) is not present yet; the design is
  currently "mono font + gray bands". Build the signature layer.
- **G15 Low-result layouts.** Suppliers and Technicians show one floating card
  with ~70% empty space. Use full-width ruled rows and a useful empty state.

## Per-page fixes
**Home (6 sections -> 5):** Hero (search + chips) / sourcing rail (replaces the 4
cards) / sample-data ledger / single emergency band / closing action merged with
footer. Drop the separate "Join network" panel. Hero visual per G5.

**Parts:** One ruled table: Part no. | Description | Category | Compatible
machine | Stock | Action. Specs open in an expandable row. One ghost-style
"Request quote" per row (not four solid blue buttons). Remove repeated
"Quote on Request" and "Verified Regional Supplier" placeholders. Chips either
act as the filter or are removed (they duplicate the dropdown).

**Suppliers:** Ruled rows: Supplier | City | Specialization | Status | Action.
Show rating, lead time, SKU count only if they come from real data.

**Technicians:** Ruled rows with skill tags. Fix the truncated search
placeholder. Show the rate only if it is real data; label demo records.

**How It Works:** One vertical numbered list (8 stages grouped in 3 phases) with
large mono numerals and hairlines. No SLA numbers. At most one real image.

**Why Us:** Keep the comparison table (columns: "Phone / offline sourcing" vs
"With SPAREFINDER"). Delete the 3 cards. Technical internals (ADO.NET, SQL)
belong in the project report, not on a buyer page. Claim only implemented features.

**Emergency:** The form leads (left). A compact 3-step list on the right
replaces the 4 step cards and 2 side panels. Remove "Target Response < 2 Hours".
Orange only on the submit button and the page marker. Keep the login note.

## Design v2 gate (required before this becomes the standard for Phase 2+)
- [ ] G1-G15 resolved on all 7 pages
- [ ] `anti-ai-ui-audit` passes on every page
- [ ] One container; left edges aligned at 360 / 768 / 1280px
- [ ] No unverifiable claim; all demo data labeled "Sample data"
- [ ] Image sources and licenses recorded in `docs/DECISIONS.md`
- [ ] Lighthouse accessibility and performance run; results recorded
- [ ] `docs/VIVA_NOTES.md` entry per page

## Portal design principles (Phases 2-5)
Portals are work tools, not marketing pages.
- Layout: left sidebar + top bar, one container, dense ruled tables.
- No hero, no eyebrow labels, no marketing copy, no repeated emergency bands.
- Status chips use fixed meanings (green = done/verified, blue = active,
  gray = pending, orange = emergency only, red-tone text = error).
- Forms: single or two columns, section titles separated by hairlines, labels
  above inputs, inline validation, clear primary action.
- Every list has an empty state that says what to do next.
- Detail views open as a page or side drawer, not a modal on top of a modal.
- Same tokens and components as the public site; add components only when two
  pages need them, and record them in `docs/DESIGN_SYSTEM.md`.
