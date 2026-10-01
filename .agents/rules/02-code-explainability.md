# 02 — Code Explainability & Academic Integrity

Every line of C#, HTML, CSS, and JavaScript in SPAREFINDER must be simple and clean enough for an MCA student to confidently explain to university examiners during a viva voce.

---

## 1. Writing Style & Complexity Limits

- **C#**: Simple, procedural, and object-oriented C# 7.3. Direct parameterized ADO.NET (`SqlConnection`, `SqlCommand`, `SqlDataReader`). No complex reflection, dynamic types, or convoluted LINQ chains.
- **Frontend JavaScript**: Vanilla ES6+ without frameworks (no React, Angular, Vue), build pipelines, or transpilers. Small, well-named functions (under 30 lines).
- **CSS**: Clean, semantic CSS utilizing CSS Custom Properties (design tokens) and established Tailwind utility patterns. No obscure browser hacks without inline explanation.
- **Naming Conventions**: Use clear, descriptive identifiers (`searchQueryInput`, `revealOnScrollObserver`) rather than cryptic abbreviations (`sqi`, `ros`).
- **No Unexplained Bloat**: Avoid dumping large blocks (>40 lines) of complex third-party code. Split into modular, digestible components.

---

## 2. Mandatory File Header Comments

Every newly created stylesheet, script, or component must begin with an explanatory header block:

```css
/* ==========================================================================
   File: Content/css/components.css
   Purpose: Reusable industrial UI components (buttons, badges, ledger rows).
   Used By: Public pages via MasterPages/Site.Master.
   Architecture: Semantic BEM-style classes powered by tokens.css variables.
   ========================================================================== */
```

Comments should explain the **WHY** and the architectural rationale, not merely state what the syntax obvious does.

---

## 3. Viva Preparation & Documentation Requirements

For every non-trivial technical pattern (e.g., `IntersectionObserver` scroll reveals, SVG stroke drawing, CSS custom properties fallback, `@view-transition`, parameterized ADO.NET commands), an entry must be recorded in [`docs/VIVA_NOTES.md`](file:///E:/ASP.NET%20MCA/docs/VIVA_NOTES.md):
- **What it does**: 1 concise sentence.
- **Why we chose it**: Comparison against rejected alternatives.
- **How it works**: 3–5 lines of plain-English explanation without jargon.
- **Where it lives**: Exact file path and selector/function name.
- **Likely examiner question & model answer**: Direct preparation for viva queries.

---

## 4. Dependencies & Framework Restrictions

- **Permitted**:
  - ASP.NET Web Forms standard controls on .NET Framework 4.8.
  - Microsoft SQL Server LocalDB with native ADO.NET.
  - Tailwind CSS (compiled locally) and custom CSS tokens.
  - Standard Google Fonts (Archivo, IBM Plex Sans, IBM Plex Mono).
  - Inline SVG line art.
- **Forbidden**:
  - Heavy animation runtimes (GSAP, Framer Motion).
  - External CDNs or script injectors without offline fallbacks.
  - New npm build pipelines or JS frameworks.

---

## 5. Academic AI Transparency

- Transparently record all significant AI-assisted generation in [`docs/AI_USAGE_LOG.md`](file:///E:/ASP.NET%20MCA/docs/AI_USAGE_LOG.md).
- Before accepting or committing code, the responsible student must be able to answer:
  1. *What does this specific block do?*
  2. *Why is it implemented this way?*
  3. *What breaks if this block is removed?*

