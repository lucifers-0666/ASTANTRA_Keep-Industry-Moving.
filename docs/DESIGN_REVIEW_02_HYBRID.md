# Design Review 02 — Astantra Home vs Figma, and the Hybrid Plan

Reviewed: the current Astantra Home screenshot, and 3 of 10 Figma frames
(SparePart_Home, Search_Part_Page, Part_Details_page). The other 7 frames are
mapped by name only; review them before building from them.
Status: neither design is accepted as-is. Build the hybrid below.

## 1. Verdict
- **Figma = better blueprint** (information structure, data per item, flows).
  Visually it is a generic marketplace: pale-blue tint, rounded cards, teal/navy
  buttons, schematic placeholders. Its palette does NOT match the project tokens.
  Layer names such as "Container" and "Section - MAIN HERO SECTION" suggest it
  was imported from HTML, not drawn by hand; faculty may ask who designed it.
- **Current Astantra Home = better visual system** (palette, mono specs, ruled
  table, emergency band) but worse structure: too long, duplicated, still full of
  unsupported claims. It still reads as AI-generated.
- **Hybrid** = Figma's structure and data patterns + our tokens and ruled style +
  the signature layer (SVG schematic, process rail, subtle motion).

## 2. Defects in the current Home (continue numbering from Design Review 01)
- **G16 Too long (about 11 blocks, budget is 5).** Faculty already said "too much".
- **G17 Duplicate content.** "Featured Urgent Replacements" cards and the
  "Regional Inventory" table show the same 4 parts from the same stockist.
  Keep the table, delete the cards.
- **G18 New unsupported claims.** "100% GSTIN Verified Stockists", "50 km
  Regional Dispatch Radius", "Live Stock", "Physical Stock Audited", "Physical
  Shelf Storage Audit". Remove or label "Sample data". Every row names one
  supplier, which contradicts "network".
- **G19 Internal text leaking into the UI:** "LocalDB Relational Ledger -
  ASTANTRA MCA Prototype". Replace with "Sample data".
- **G20 Cards everywhere** (7 categories, 3 steps, 4 products, supplier card, 2 CTA
  panels). Use a ruled category index, a process rail, one table.
- **G21 Edges misaligned again.** Nav and footer are wider than the page content.
  One `.container` for everything.
- **G22 Trust row under the search bar collides** (text runs into the next icon).
  Fix spacing or delete the row (it repeats the hero).
- **G23 Tiny mono text** (about 10-11px) for eyebrows, chips, stage tags.
  Minimum 12px; mono only for data.
- **G24 Jargon copy** ("Operational Architecture", "Standardized Engineering
  Catalog", "actuation assemblies"). Write like a buyer talks:
  "Find a bearing, motor or valve near you."
- **G25 Four conversion blocks at the bottom** (supplier CTA, join network,
  emergency band, footer). One two-column closing block (Factories | Suppliers)
  plus the emergency band.
- **G26 Same two stock photos on several pages.** Use one real photo or none.
- **G27 No focal moment or signature.** Use the engineering schematic idea from
  Figma's Part Details (dashed circles with ID/OD dimensions) as the hero visual,
  redrawn as clean inline SVG.
- **Brand note:** the name Astantra is still pending its say-it-aloud, IP India and
  domain checks. Keep the brand text and logo path in ONE place (Site.Master or a
  single constant) so a rename costs minutes, not days.

## 3. What to take from Figma, adapt, or leave
**Take (adapt to our tokens):**
- Hero search panel: search + category + location + two actions.
- Breadcrumbs, results count, sort, active-filter chips, pagination (Parts page).
- Faceted filter sidebar with collapsible groups (Parts page).
- Part detail structure: schematic, price + stock block, spec table, "same part
  from other suppliers" comparison table, similar parts.
- Data per item: SKU, supplier, price, stock state, location, last updated.
- Real local specificity: named industrial zones (Metoda, Shapar-Veraval, Aji
  in Rajkot appear to be real; confirm) instead of vague "regional".
- "Supplier contact visible after login" rule (honest, matches auth).
- Factories | Suppliers toggle for How It Works.

**Leave out (until real data/backend exists):**
- RFQ List / cart counter and "Add to RFQ List" (needs session/backend: Phase 2).
- Ratings, reviews, "99.2% on-time", "4.8 (92 verified)".
- "Verified via ERP sync", "barcoded/holographic verification".
- Distance in km and radius filter (unless the schema has coordinates).
- Fake counts ("210+ vendors", "350+ factories", "840+ parts").
- Real OEM brand names as sample stock (SKF, Crompton, Gates, Yuken) unless the
  parts truly exist in the data; sample data should be neutral.
- Pale-blue tint, dual header band, teal buttons, "[SCHEMATIC: ...]" boxes,
  leftover "[TAB 2: WIREFRAME]" labels, newsletter.

## 4. Data feasibility rule
Before building any Figma element, tag it:
- **REAL:** the field exists in the database schema (read `Database/` only).
- **SAMPLE:** not in the schema; show only with a visible "Sample data" label.
- **LATER:** needs backend/schema; omit now, list in PHASE_CHECKLIST.md.
Likely REAL: part number, name, category, supplier name/city, verification
status, stock quantity. Likely LATER: distance, ratings, RFQ cart, brand and
price facets, "updated x ago". Confirm against the actual schema.

## 5. Hybrid Home recipe (5 sections)
1. **Hero:** plain headline + search panel (Figma pattern) + inline SVG
   schematic with animated callouts. No stats row, no stock photo.
2. **Category index:** ruled two-column list (counts only if real). No cards.
3. **Process rail:** 3 steps on one line that draws on scroll (Search & compare,
   Request quotes, Order & fit).
4. **Parts ledger:** the existing table, labeled "Sample data". Delete the 4 cards.
5. **Closing:** emergency band (orange, only here) + one Factories | Suppliers
   block. Footer simplified.

## 6. Figma frame -> repo page map
| Figma frame | Repo target | Action |
|---|---|---|
| SparePart_Home | Default.aspx | Hybrid recipe above |
| Search_Part_Page | Public/Parts.aspx | Filter sidebar + ruled result rows |
| Part_Details_page | NEW Public/PartDetails.aspx | Needs team approval (new page, data binding = code-behind); UI-only with Sample data first, real binding in Phase 2 |
| All_Categoried_Page | Public/Parts.aspx (category index) | Merge, do not add a page |
| How_it_works_factories_page + _suppliers_page | Public/HowItWorks.aspx | One page with a Factories/Suppliers toggle |
| For_Supplier_Main_Page + details | Supplier marketing/registration | Review frames first; Phase 3 |
| About_Us_Page | Public/WhyUs.aspx | Review; keep only true claims |
| Contact_Us_page | NEW | Decide if needed; low priority |

## 7. How to implement Figma pieces in ASPX (repeatable method)
1. Pick ONE Figma node. Write a small spec: purpose, fields, states (default,
   hover, empty, error), data tag (REAL/SAMPLE/LATER).
2. Do NOT paste Figma-generated code into .aspx. Use it only for measurements
   (spacing, sizes, text styles). Rebuild by hand with our tokens and classes.
3. Map colors and type with the token table (Figma blue/teal/pale-blue ->
   --blue / --navy / --bg; Inter -> Plex Sans; schematic labels -> Plex Mono).
4. Write markup with a class per component (`.ledger`, `.filter-group`,
   `.chip`), then bind it to the EXISTING control (Repeater/GridView) without
   changing IDs or events.
5. Test per rule 05; record in VIVA_NOTES.md what the component does and why.
6. Run the anti-ai-ui-audit skill before moving to the next node.

## 8. Prompts

### Prompt D — agent: hybrid Home
Read AGENTS.md, all rules, DESIGN_REVIEW_01.md and DESIGN_REVIEW_02_HYBRID.md.
Run /inspect-and-plan for Default.aspx using section 5 of the hybrid review and
resolving G16-G27. Preserve every ID and event. Delete duplicate sections only in
markup. Tag every data item REAL/SAMPLE/LATER and label SAMPLE items visibly. Do
not touch backend files. Wait for approval, then implement, run
/review-and-explain and /pre-commit-check.

### Prompt E — agent: Parts page from Figma
Same reading list. Inspect Public/Parts.aspx and its code-behind (read only). List
which Figma Search_Part_Page filters map to existing controls and data (REAL) and
which do not (LATER). Build the filter sidebar, active chips, result count and
pagination UI using only REAL filters; show ruled result rows instead of a card
grid. Never rename IDs or change event handlers. Report what was and was not tested.

### Prompt F — ChatGPT (paste-based)
Use Prompt A from REDESIGN_PROMPTS.md, then add: "Reference: Figma frame <name>
(attach screenshot). Reproduce only its structure and data fields, never its
colors or fonts; use our tokens. Tag each field REAL/SAMPLE/LATER and ask me when
unsure. Return only changed files with comments and a plain-language explanation."
