# Project Progress & Phase Checklist

*Rule: Tick items only after they have been thoroughly implemented, inspected, and verified.*

---

## Phase 1 — Public Visitor Experience (FRONTEND ONLY) [CURRENT PHASE]

### Foundation & Assets
- [ ] Shared tokens created (`Content/css/tokens.css`)
- [ ] Base typography and resets (`Content/css/base.css`)
- [ ] Component patterns (`Content/css/components.css`)
- [ ] Lightweight utility script (`Content/js/site.js`)
- [ ] Public master page shell (`MasterPages/Site.Master`) with responsive header, sticky nav, and footer

### Public Pages
- [ ] `Default.aspx` (Max 5 sections: Hero search, Process rail, Breakdown band, Directory preview, Closing CTA)
- [ ] `Public/Parts.aspx` (Catalog search, filters, quote request preview)
- [ ] `Public/Suppliers.aspx` (Verified vendor directory, location distance, capability badges)
- [ ] `Public/Technicians.aspx` (Certified technician listings, hourly rates, duty toggle)
- [ ] `Public/HowItWorks.aspx` (3-phase procurement lifecycle)
- [ ] `Public/WhyUs.aspx` (Benchmark comparison matrix)
- [ ] `Public/Emergency.aspx` (Breakdown dispatch interface, clearly marked demo submission)

### Quality & Standards
- [ ] `anti-ai-ui-audit` checklist passed for every modified page
- [ ] Responsive layouts verified at 360px, 768px, and 1280px+
- [ ] `@media (prefers-reduced-motion: reduce)` verified
- [ ] Server control IDs and postbacks 100% preserved
- [ ] MSBuild compiles with 0 errors and 0 warnings
- [ ] `docs/VIVA_NOTES.md` and `docs/AI_USAGE_LOG.md` updated

---

## Phase 2 — Authentication & Multi-Role Onboarding
- [ ] `Account/Login.aspx` (Two-column layout, accessible inputs, role-based redirect verification)
- [ ] `Account/Register.aspx` (Multi-role selection, client-side validation, password hasher check)
- [ ] `Account/Logout.aspx` (Session teardown verification)
- [ ] `Account/AccessDenied.aspx` (Clear security messaging)

---

## Phase 3 — Factory Buyer Portal (`Factory/`)
- [ ] Factory Dashboard (`Factory/Dashboard.aspx`)
- [ ] RFQ creation, management, and supplier bid comparison
- [ ] Emergency breakdown order dispatch tracking
- [ ] Technician booking logs

---

## Phase 4 — Spare-Part Supplier Hub (`Supplier/`)
- [ ] Supplier Dashboard (`Supplier/Dashboard.aspx`)
- [ ] Inventory catalog, stock levels, and price updating
- [ ] RFQ bid submission and order fulfillment

---

## Phase 5 — Field Technician Portal (`Technician/`)
- [ ] Technician Dashboard (`Technician/Dashboard.aspx`)
- [ ] Real-time duty availability toggle (`On Duty` / `Off Duty`)
- [ ] Service dispatch job logs and maintenance history

---

## Phase 6 — Administrator Governance Portal (`Admin/`)
- [ ] Admin Analytics Dashboard (`Admin/Dashboard.aspx`)
- [ ] Supplier GSTIN auditing and approval pipeline
- [ ] Technician skill certification verification
- [ ] User role governance and dispute handling

---

## Phase 7 — System Integration, Testing & Viva Defense
- [ ] End-to-end integration testing across all four user roles
- [ ] Edge-case validation and error-handling audit
- [ ] Complete project documentation and viva slide deck
- [ ] Team viva rehearsal using `docs/VIVA_NOTES.md`

