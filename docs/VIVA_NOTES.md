# Viva Notes

One entry per page and per non-trivial technique. Written in the team's own
words after reading the code. If you cannot fill an entry, you do not yet
understand the code: ask, simplify, or remove it.

## Entry template
### <Page or technique>
- **Goal (user problem it solves):**
- **What it does:**
- **Why we chose it (and what we rejected):**
- **How it works (3-5 lines):**
- **Where it lives (file, selector/function):**
- **What would break if removed:**
- **Likely faculty question and answer:**
- **Owner who can explain it:**

## Standing questions to prepare
1. Why does this not look like a generic template? (type, ruled layout, mono specs, fewer sections)
2. Why no React or animation library? (existing Web Forms stack, speed, simplicity)
3. How do scroll reveals work? (IntersectionObserver adds a class; CSS does the motion)
4. How did you keep the backend unchanged? (class-only edits; IDs and events preserved)
5. How did you make it fast? (transform/opacity only, few fonts, lazy images, tiny JS)
6. What did AI do, and what did you do? (see AI_USAGE_LOG.md)
7. What is still incomplete in the project? (answer honestly from PHASE_CHECKLIST.md)

---

## Hybrid v1 Homepage Redesign (Default.aspx)

### U1: Sample bearing-chip schematic update
- **Goal (user problem it solves):** Lets a buyer see that the illustrative drawing corresponds to the selected sample bearing size.
- **What it does:** The 6205, 6208, and 6210-2RS chips update the three dimension labels and apply a small scale change to the SVG bearing geometry.
- **Why we chose it (and what we rejected):** We used attributes already present on the links and simple DOM updates instead of a chart library or a second drawing engine.
- **How it works (3-5 lines):** Each chip stores its sample ID, OD, and width in `data-*` attributes. `updateSchematic` reads them, changes the SVG text nodes, and sets one CSS custom property. CSS transitions only transform and opacity; the reduced-motion rule makes the final drawing appear immediately.
- **Where it lives (file, selector/function):** `Default.aspx`, `Content/js/site.js` (`updateSchematic`), `Content/css/public/home.css` (`.bearing-geometry`).
- **What would break if removed:** The search chips would still populate the search input, but the drawing would remain on the default 6210-2RS values.
- **Likely faculty question and answer:** *Q: Why use data attributes?* *A: They keep small display values in the related HTML control, so no backend or database code is required for sample interactions.*
- **Owner who can explain it:** Zaid

### U2: One-time hero headline reveal
- **Goal (user problem it solves):** Gives the primary search task a calm initial emphasis without distracting repeated animation.
- **What it does:** Moves the hero headline and supporting sentence upward by a few pixels as each becomes visible once on page load.
- **Why we chose it (and what we rejected):** CSS keyframes are smaller and easier to explain than a JavaScript animation package; no looping text is used.
- **How it works (3-5 lines):** `.headline-reveal` and `.subheadline-reveal` use the same opacity and transform keyframe with a short stagger. The reduced-motion media query replaces the animation with the final visible state.
- **Where it lives (file, selector/function):** `Content/css/animations.css` (`headlineReveal`, `.headline-reveal`).
- **What would break if removed:** Only the introductory motion is lost; all copy remains visible and usable.
- **Likely faculty question and answer:** *Q: Does the animation hide content from assistive technology?* *A: No. It changes visual opacity only and the DOM content is present from initial load.*
- **Owner who can explain it:** Zaid

### U3: Sample-ledger filters
- **Goal (user problem it solves):** Lets a buyer focus the clearly labeled sample rows on stock availability or same-day dispatch.
- **What it does:** Filters rows locally and shows an empty-state message when no sample row matches.
- **Why we chose it (and what we rejected):** This is a small prototype-only interaction, so it avoids a server request and leaves existing search and postback controls unchanged.
- **How it works (3-5 lines):** Each main ledger row has a `data-stock` value. A click toggles `hidden` on that row and its associated comparison row, updates `aria-pressed`, and counts visible rows for the empty state.
- **Where it lives (file, selector/function):** `Default.aspx`, `Content/js/site.js` (ledger-filter listener), `Content/css/public/home.css` (`.ledger-filter`).
- **What would break if removed:** The table still displays all sample rows, but users cannot narrow the visible examples.
- **Likely faculty question and answer:** *Q: Why not filter in SQL?* *A: This data is explicitly sample markup in Phase 1, and a client-side filter avoids changing protected backend code.*
- **Owner who can explain it:** Zaid

### Technique 1: Inline SVG Engineering Schematic (M2)
- **Goal (user problem it solves):** Replaces generic stock photos with an authentic engineering visual of an industrial bearing, demonstrating precision tolerances without adding asset weight.
- **What it does:** Renders a clean deep-groove ball bearing drawing (< 6 KB) with pitch circle, inner bore, outer diameter, and dimension callouts. Lines draw once on load using SVG `stroke-dashoffset`. Hovering callouts highlights dimension lines.
- **Why we chose it (and what we rejected):** Chose handcrafted inline SVG over canvas/WebGL or stock photography because it is resolution-independent, lightweight, accessible, and explainable in C#/HTML viva.
- **How it works (3-5 lines):** Uses SVG `<circle>`, `<line>`, `<polygon>`, and `<text>` elements. `stroke-dasharray` and `stroke-dashoffset` in `animations.css` animate stroke drawing from full offset to 0 within 1.1s. JavaScript listener adds `.is-active` class to dimension line `<g>` element when hovered.
- **Where it lives:** `Default.aspx` (inline SVG), `Content/css/animations.css` (`.schematic-draw`), `Content/js/site.js`.
- **What would break if removed:** The hero right column would be empty or require heavy external image downloads.
- **Likely faculty question and answer:** *Q: How does the stroke draw animation work without an animation library?* *A: By setting stroke-dasharray equal to the perimeter and animating stroke-dashoffset from that length to zero using pure CSS keyframes.*
- **Owner who can explain it:** Zaid

### Technique 2: CSS Grid 0fr -> 1fr Accordion Expansion (M6)
- **Goal (user problem it solves):** Allows comparing alternative regional suppliers directly within the parts table without page navigation or modal popups.
- **What it does:** Expands a sub-ledger drawer smoothly when the user clicks "Compare".
- **Why we chose it (and what we rejected):** Rejected `max-height` transitions because `max-height` requires guessing a pixel ceiling, causing stutter and lagging easing. CSS `grid-template-rows: 0fr -> 1fr` calculates exact natural height smoothly.
- **How it works (3-5 lines):** The wrapper has `display: grid; grid-template-rows: 0fr; transition: grid-template-rows 250ms var(--ease-out);`. When `.is-open` is toggled, `grid-template-rows: 1fr` smoothly expands the inner container having `overflow: hidden; min-height: 0;`.
- **Where it lives:** `Content/css/animations.css` (`.ledger-expandable-wrapper`), `Default.aspx`, `Content/js/site.js`.
- **What would break if removed:** Clicking "Compare" would either instantly jump open or fail to reveal secondary supplier records.
- **Likely faculty question and answer:** *Q: Why is CSS Grid preferred over max-height for accordion animation?* *A: CSS Grid 0fr to 1fr animates to the exact content height dynamically without guessing max-height values, avoiding lag or visual timing distortion.*
- **Owner who can explain it:** Zaid

### Technique 3: Single Centralized IntersectionObserver (M5 & M10)
- **Goal (user problem it solves):** Restrained scroll-triggered reveals for process rail line fill and section entry without lag or CPU-heavy scroll event listeners.
- **What it does:** Observes `.reveal-on-scroll` elements and `.process-rail-wrap`, adding `.is-revealed` and `.is-in-view` when 12% of the element enters the viewport. Immediately unobserves to run once only.
- **Why we chose it (and what we rejected):** Rejected `window.addEventListener('scroll')` with bounding rect calculations which causes scroll jank, layout thrashing, and high battery consumption.
- **How it works (3-5 lines):** `new IntersectionObserver(callback, { threshold: 0.12 })` receives threshold intersection events from the browser's compositor thread asynchronously. Callback adds active classes and calls `obs.unobserve(entry.target)`.
- **Where it lives:** `Content/js/site.js`, `Content/css/animations.css`.
- **What would break if removed:** Elements would remain visible statically if JS fails (because hidden state is scoped under `.js` class), ensuring graceful fallback.
- **Likely faculty question and answer:** *Q: What is the performance advantage of IntersectionObserver over a scroll event listener?* *A: IntersectionObserver is handled asynchronously by the browser off the main rendering loop, avoiding layout thrashing and forced synchronous reflows.*
- **Owner who can explain it:** Zaid

---

## Three-Tier Backend Architecture (College Professor's Method)

### T1: Three-Tier Architecture Separation
- **Goal (user problem it solves):** Separates presentation, event orchestration, and database operations into distinct layers for maintainability, security, and viva explainability.
- **What it does:** 
  1. Presentation Tier (`.aspx`): Declarative UI controls (`asp:GridView`, `asp:Button`, `asp:TextBox`, `asp:DropDownList`).
  2. Code-Behind Tier (`.aspx.cs`): Event handlers (`Page_Load`, `btn_Click`, `gv_RowCommand`), input validation, UI binding, session guards via `BasePage`.
  3. Logic Tier (`App_Code/Logic/*Logic.cs`): `getcon()` connection creation, SQL command execution, parameter mapping, returning `DataSet` / `DataTable` / scalar values.
- **Why we chose it (and what we rejected):** The college professor requires the simple 3-tier method using raw ADO.NET (`getcon()`, `insert()`, `update()`, `delete()`, `select()`). We rejected Entity Framework, Dapper, Repository/Unit of Work, and ASP.NET Core to ensure 100% viva alignment.
- **How it works (3-5 lines):**
  - Code-behind instantiates a logic class (e.g. `UserLogic _userLogic = new UserLogic()`).
  - Calls a method passing validated primitives (e.g. `_userLogic.selectAllUsers(role)`).
  - Logic class calls `getcon()` to obtain an open `SqlConnection`, executes a parameterized `SqlCommand`, fills a `DataSet`, and disposes the connection via `using`.
  - Code-behind sets `gv.DataSource = ds.Tables[0]; gv.DataBind();`.
- **Where it lives:** `App_Code/Logic/` (`BaseLogic.cs`, `UserLogic.cs`, `PartLogic.cs`, `InventoryLogic.cs`, `QuotationLogic.cs`, `OrderLogic.cs`, `ServiceLogic.cs`, `AdminLogic.cs`).
- **Likely faculty question and answer:**
  - *Q: Why is there no SQL query in the .aspx.cs files?*
  - *A: According to the 3-tier architecture, presentation logic must never know about SQL syntax or table definitions. All database operations are encapsulated inside the Logic Tier classes, making the code testable and easy to maintain.*
- **Owner who can explain it:** Zaid

### T2: Safe Parameterized ADO.NET & SQL Injection Prevention
- **Goal (user problem it solves):** Prevents SQL Injection attacks and handles `NULL` values properly in database operations.
- **What it does:** Every query in the logic layer uses `@ParameterName` placeholders with explicit `SqlDbType` or `AddWithValue`, completely avoiding string concatenation (`"WHERE user = '" + txt + "'"`).
- **Why we chose it:** Security requirement and core viva exam checkpoint.
- **How it works:**
  `cmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email });`
  SQL Server treats the parameter strictly as literal data, never executable SQL commands.
- **Likely faculty question and answer:**
  - *Q: How does parameterization protect against SQL injection?*
  - *A: Parameters are sent separately from the SQL statement text. The database engine compiles the query execution plan first, and then binds parameter values purely as data literals. Even if a user enters `' OR 1=1 --`, it is treated as a string literal and cannot alter query logic.*
- **Owner who can explain it:** Zaid

### T3: Atomic Commercial Transactions (Quotation Acceptance & Supplier Verification)
- **Goal (user problem it solves):** Prevents partial database updates during multi-step commercial operations (e.g., accepting a bid must simultaneously generate an order and mark competing bids as rejected).
- **What it does:** Uses `SqlTransaction` inside `QuotationLogic.acceptBidTransaction` and `AdminLogic.verifySupplier`.
- **Why we chose it:** Without transactions, a server failure or constraint error between step 1 and step 2 would leave the database in an inconsistent state (e.g. bid accepted without an order record).
- **How it works:**
  ```csharp
  using (SqlConnection con = getcon()) {
      using (SqlTransaction tx = con.BeginTransaction()) {
          try {
              // 1. Update winning bid to 'Accepted'
              // 2. Reject other bids for this RFQ
              // 3. Update RFQ to 'Closed'
              // 4. Create Order in Orders table
              tx.Commit();
          } catch {
              tx.Rollback();
              throw;
          }
      }
  }
  ```
- **Likely faculty question and answer:**
  - *Q: What are the ACID properties in this transaction?*
  - *A: Atomicity ensures all 4 updates succeed or none do (via Rollback). Consistency keeps foreign keys valid. Isolation locks modified records from concurrent reads. Durability guarantees committed changes persist on disk.*
- **Owner who can explain it:** Zaid
