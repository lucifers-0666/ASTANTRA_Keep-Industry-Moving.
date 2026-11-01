# Redesign Prompts

Use Prompt A in ChatGPT, Prompt B in the coding agent (Antigravity).
Prompt C is the reusable template for every new page in Phases 2-5.
Attach `docs/DESIGN_REVIEW_01.md` and the page screenshots to A and B.

---
## Prompt A — ChatGPT (paste-based; it cannot see the repo)

You are a senior product designer and front-end developer. Work on an existing
ASP.NET Web Forms project called SPAREFINDER (a B2B industrial spare-parts
procurement portal for Gujarat, India). It is an MCA college project. Faculty
said the UI looks AI-generated and too complicated.

HARD RULES
- Frontend only: HTML (.aspx/.master markup), CSS, small plain JavaScript.
- Never change C#, SQL, web.config, or database logic. Keep every runat="server"
  control, its ID, and its event attributes. Keep all <%# Eval(...) %> expressions.
- No React/Vue/Angular, no animation libraries, no new frameworks.
- Allowed fonts: Archivo (headings), IBM Plex Sans (body, buttons), IBM Plex
  Mono (part numbers, specs, prices, lead times, status codes ONLY).
- Palette only through CSS variables: bg #F1F3F5, surface #FFFFFF, text #111827,
  text-2 #5F6B7A, border #D9DEE5, blue #1769E0, navy #101C2C, dark navy #0B1422,
  emergency orange #E87519 (emergency only), green #18865B.
- Radius 2-4px, 1px hairlines, no gradients, no glassmorphism, no emoji icons.
- Motion: only transform/opacity, IntersectionObserver reveals, SVG line
  drawing, prefers-reduced-motion respected, no scroll-jacking.
- All code must be beginner-readable with plain-English comments, because the
  students must explain every line to faculty.
- Never invent statistics, ratings, SLAs, testimonials, or "verified" claims.
  Anything not backed by real data is labeled "Sample data".

DESIGN DIRECTION
"Datasheet / engineering drawing": ruled tables, mono part numbers, one clear
action per page, calm and precise. It must be recognizable as an industrial
procurement tool and not as a generic startup template.

THE PROBLEMS TO FIX (see the attached DESIGN_REVIEW_01.md, items G1-G15):
equal-card grids, a repeated page-header template, misaligned left edges,
fake claims, stock/AI-looking photos, tiny text, mono overuse, repeated
emergency bands, orange misuse, and single-card layouts with empty space.

HOW TO WORK
1. I will paste one page at a time (.aspx + code-behind for READING + CSS).
2. First reply with: what exists, the list of server-control IDs/events that
   must be preserved, and your plan. Wait for my "go".
3. Then return only the changed files, complete, each with a header comment.
4. After the code, add: (a) a plain-language "how it works" for each CSS/JS
   technique, (b) a likely faculty question with a short answer, (c) a list of
   what you did NOT test.
5. If something needs a backend change, stop and tell me instead of doing it.

Start with the shared foundation: tokens.css, base.css, components.css,
site.js, and the Site.Master nav/footer. Ask me to paste what you need.

---
## Prompt B — Coding agent (Antigravity)

Read AGENTS.md and every file in .agents/rules/. Then read
docs/DESIGN_REVIEW_01.md and docs/DESIGN_SYSTEM.md. This is Phase 1, frontend
only.

Goal: build "Design v2" by resolving G1-G15 for all seven public pages.

Order of work (one commit per item, wait for my approval after each plan):
1. Run /inspect-and-plan for the shared foundation: tokens.css, base.css,
   components.css, animations.css, site.js, Site.Master (single .container,
   simplified nav and footer, one button style). Preserve all IDs and events.
2. Home -> 5 sections (hero search, sourcing rail, sample-data ledger,
   emergency band, closing action).
3. Parts, Suppliers, Technicians -> ruled-table/ledger layouts with proper
   low-result and empty states.
4. How It Works, Why Us, Emergency per the "Per-page fixes" section.
5. Run the anti-ai-ui-audit skill on every page and fix failures.

Constraints: do not touch Database/, App_Code/, Account/, web.config or any
*.aspx.cs file. Do not invent content; label demo data "Sample data". Do not add
dependencies. After each page run /review-and-explain, update
docs/VIVA_NOTES.md and docs/AI_USAGE_LOG.md, and report what you actually
tested and what you did not.

---
## Prompt C — Reusable template for every new page (Phases 2-5)

Create <page name> for the <role> portal. Read AGENTS.md, the rules, and the
"Portal design principles" in docs/DESIGN_REVIEW_01.md first. Run
/inspect-and-plan and wait for approval. Use existing tokens and components;
list any new component you need before adding it. Use a sidebar + top bar
layout, ruled tables, status chips with fixed meanings, and an empty state for
every list. No hero, no eyebrow labels, no marketing copy, no fake data.
Backend work only if the team has authorized it for this phase in writing;
otherwise build the UI against the existing controls and report the gaps.
Finish with /review-and-explain and /pre-commit-check.
