# Prompt — Redesign the Home page as "Hybrid v1"

Use for Antigravity (repo access) or ChatGPT (paste files; see the note at the end).
Attach: the current Home screenshot, Figma screenshots, and docs/DESIGN_REVIEW_01.md
and docs/DESIGN_REVIEW_02_HYBRID.md.

## Rule 01 amendment (paste into .agents/rules/01-project-guardrails.md first)
Backend work is allowed from now on ONLY through a written "Backend Proposal"
(item, why it is needed, files touched, DB change yes/no, risk, rollback). The agent
must wait for the team's approval of each item. Never touch authentication,
Account/, web.config or existing schema without a separate explicit approval.
Frontend comes first; the page must look and behave correctly with sample data.

---
# THE PROMPT (copy from here)

You are a senior product designer and ASP.NET Web Forms front-end developer.
Redesign Default.aspx (the Home page) of ASTANTRA (an industrial spare-parts
procurement portal for Gujarat) as a HYBRID of two references, and add a small
set of genuinely modern, functional interactions. Do not copy either reference.

## References
1. Figma file key LRfkXDBx14b2M9Nv3T0xYz
   https://www.figma.com/design/LRfkXDBx14b2M9Nv3T0xYz/SparePartFinder?node-id=0-1
   Frames: Home 38:839, Search_Part_Page 53:847, Part_Details_page 53:1692.
   Use it for STRUCTURE and DATA PATTERNS only (search panel with category and
   location, ruled data per item, supplier comparison, breadcrumbs, facets). If a
   Figma tool is connected, use screenshots/metadata for measurements. Never paste
   Figma-generated code into .aspx.
2. The attached screenshot of the current Home page (what to fix).
3. docs/DESIGN_REVIEW_01.md (G1-G15) and DESIGN_REVIEW_02_HYBRID.md (G16-G27).

## Non-negotiables
- Keep ASP.NET Web Forms. No React/Vue, no animation or UI libraries, no WebGL.
- Keep every runat="server" control ID, event and Eval() expression. Style via
  class names. One <form runat="server">.
- Palette is locked to the project tokens (bg #F1F3F5, surface #FFFFFF, text
  #111827, text-2 #5F6B7A, border #D9DEE5, blue #1769E0, navy #101C2C/#0B1422,
  orange #E87519 emergency only, green #18865B). Do NOT use Figma's pale-blue
  tint or teal. Fonts: Archivo (headings), IBM Plex Sans (body, buttons),
  IBM Plex Mono (part numbers, specs, prices, lead times, status only).
- No fake claims. Remove: "100% GSTIN verified", "50 km radius", "Live Stock",
  "Physical Stock Audited", stat rows, and any "AI" label (there is no AI feature).
  Tag every data item REAL (in the schema), SAMPLE (visibly labeled "Sample data")
  or LATER (omit). Read Database/ for the schema; do not edit it.
- Code must be beginner-readable with plain-English comments; add a VIVA_NOTES.md
  entry per technique. Brand text and logo path live in ONE place.
- Backend: propose only via a Backend Proposal (see Rule 01 amendment). Do not
  implement backend items until I approve each one.

## Page structure (5 sections, one .container, aligned edges)
1. HERO + SEARCH. Plain headline in buyer language (for example "Find a bearing,
   motor or valve near you."), one supporting line, the search panel (input +
   category select + location select + Search button + secondary "Emergency
   breakdown" link). Right side: an original inline SVG engineering schematic (see
   M2). No stats row, no stock photo.
2. CATEGORY INDEX. Ruled two-column list, not cards. Counts only if REAL.
3. PROCESS RAIL. Three steps on one line: Search and compare, Request quotes,
   Order and fit.
4. PARTS LEDGER. Keep the existing table, labeled "Sample data" if not live.
   DELETE the duplicate "Featured Urgent Replacements" cards.
5. CLOSING. Navy emergency band (the only orange button on the page) plus one
   segmented block "For factories | For suppliers". Simplified footer.
Delete: trust row, supplier hubs section with photo, the two extra CTA panels.

## Modern kit (build exactly these, nothing more)
M1 Command-style search: Ctrl+K and "/" focus the input (show a small key hint),
   animated focus ring, suggestion chips. Typeahead dropdown = LATER (Backend
   Proposal). Fully keyboard accessible.
M2 Hero schematic: original inline SVG (under 6 KB) of a bearing face view with
   dashed circles and dimension lines (ID, OD, width) in Plex Mono. Lines draw
   once on load (stroke-dashoffset, under 1.2 s); hovering or focusing a callout
   highlights its dimension line. Caption: "Illustrative drawing".
M3 Sticky header: height shrinks 72 to 56 px after 40 px scroll with a hairline;
   the active-link underline slides between links (transform). Mobile: a sticky
   bottom bar with Search and Emergency.
M4 Category rows: on hover/focus the row tints, the arrow moves 4 px, and spec
   chips fade in (opacity, no layout shift).
M5 Process rail: the line fills as the section enters view (scaleX); nodes light
   up in sequence (120 ms stagger). Vertical on mobile.
M6 Ledger rows: sticky header row, status dot plus text, hover highlight, and an
   expandable row (button, aria-expanded) showing a small "same part, other
   suppliers" table (SAMPLE). Animate with grid-template-rows 0fr to 1fr.
   On mobile, rows stack.
M7 Segmented control (For factories | For suppliers): sliding indicator, swaps
   two panels, correct ARIA tab roles.
M8 Headline reveal: one line-by-line reveal under 600 ms, once. No looping text.
M9 Cross-page fade via @view-transition { navigation: auto; } as an optional
   enhancement.
M10 Scroll reveals via ONE IntersectionObserver in site.js (fade plus 12 px rise,
    once, stagger up to 4 items).

Excluded on purpose (do not add): glassmorphism/liquid glass, neumorphism,
gradients, neon/vibrant palettes, maximalism, collage, retrofuturism, gamification,
3D/AR/WebGL, voice, cursor effects, dark-mode toggle, fake "AI" assistants,
passkeys/biometrics.

## Motion and performance rules
- Animate only transform and opacity (plus SVG stroke offset). Never
  transition: all. Tokens: --ease-out cubic-bezier(.2,.7,.2,1); 150 ms hover,
  250 ms UI, 500-700 ms reveals; nothing above 800 ms.
- Elements are visible if JS fails (hidden state only under a "js" class).
- prefers-reduced-motion: disable all animation and show final states.
- Budget: site.js plain and commented (aim under 4 KB), no libraries, images sized
  with width/height and lazy-loaded, at most 3 font families with display=swap.
  Report any Lighthouse run you actually performed.

## Accessibility
Contrast 4.5:1, visible focus-visible rings, 44 px touch targets, labels on inputs,
correct roles for tabs and accordion, no information conveyed by color alone.

## Process
1. Run /inspect-and-plan. List the controls, IDs and events in Default.aspx and
   its code-behind (read only), the CSS in use, and a REAL/SAMPLE/LATER table for
   every data item. Include a Backend Proposal table (may be empty). STOP for
   my approval.
2. Implement: tokens.css, base.css, components.css, animations.css,
   public/home.css, site.js, Site.Master edits, Default.aspx markup.
3. Run the anti-ai-ui-audit skill, fix failures, then /review-and-explain and
   /pre-commit-check.
4. Final report: files changed, what was and was NOT tested, and a list of at least
   5 deliberate differences from the Figma Home and 5 from the current page, so I
   can show the design is a hybrid and not a copy.

## If you are ChatGPT (no repo access)
Ask me to paste Site.Master, Default.aspx, Default.aspx.cs (for reading only) and
the CSS files first. Return only changed files in full, each with a header comment,
a plain-language explanation of every technique, a likely faculty question with a
short answer, and what you did not test.
