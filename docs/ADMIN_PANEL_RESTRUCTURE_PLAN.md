# ASTANTRA — Project Status, Directory Restructuring & Admin Panel Redesign Blueprint

**Project:** ASTANTRA — Keep Industry Moving  
**Technology:** ASP.NET Web Forms (.NET Framework 4.8, C# 7.3), Parameterized ADO.NET (Three-Tier Architecture), SQL Server LocalDB  
**Lead / Coordinator:** Zaid Amreliya  
**Date:** November 2026  

---

## 1. Executive Status & Remaining Work Analysis

### How Much Is Done vs. What Remains

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                                PROJECT COMPLETION: 75%                                 │
├───────────────────────────────────┬────────────────────────────────────────────────────┤
│ COMPLETED (75%)                   │ REMAINING (25%)                                    │
│ • Database Schema (15 Tables)     │ • Complete Admin Panel Redesign (High-Density UI)  │
│ • Three-Tier Logic Layer (8 Logic)│ • Admin Full DB Control (Add/Edit/Delete/Inspect)  │
│ • Auth & RBAC Security System     │ • Audit Logs & System Activity Table               │
│ • Public Portal (7 Pages)         │ • Normalized Order Items Table                     │
│ • Factory Buyer Workflows         │ • Directory Restructuring (Clean Unused/Duplicates)│
│ • Supplier & Technician Workflows │ • Final Live Integration & End-to-End User Testing │
└───────────────────────────────────┴────────────────────────────────────────────────────┘
```

### Git Branch & Collaborator Audit
- **Remote Branches Checked:** `origin/main`, `origin/zaid/changes`, `origin/jay/changes`, `origin/uday/changes`.
- **Sync Status:** All developer branches are fully merged into `main`. Neither `origin/jay/changes` nor `origin/uday/changes` have any unmerged commits ahead of `main`.
- **Working Tree:** `main` is completely clean and synchronized with GitHub.

---

## 2. Directory & File Organization Cleanup Plan

Currently, several files and duplicate folders are scattered across the workspace. We will organize them into an authoritative, clean layout:

```
E:\ASP.NET MCA\
├── Account\                         # Authentication & Profile Management
│   ├── Login.aspx, Register.aspx, Logout.aspx, AccessDenied.aspx
├── Admin\                           # Administrator Governance Console (REDESIGNED)
│   ├── Dashboard.aspx               # Executive Command Center & Platform KPIs
│   ├── Users\ManageUsers.aspx       # Complete User Management & RBAC CRUD
│   ├── Factories\ManageFactories.aspx# Factory Buyer Directory & Plant Details
│   ├── Suppliers\Verification.aspx  # Due Diligence, GSTIN Audit & Inventory Oversight
│   ├── Technicians\ManageTechnicians.aspx # Field Technician Roster & Availability
│   ├── Categories\ManageCategories.aspx # Taxonomy & Machine Model Two-Pane Registry
│   ├── SpareParts\ManageParts.aspx  # Master Catalog CRUD & Technical Specs
│   ├── Orders\Oversight.aspx        # Commercial RFQs, Consignments & Emergency SOS
│   └── Audit\AuditLogs.aspx         # Security & Admin Audit Trail
├── App_Code\                        # Three-Tier Architecture Core (NO INLINE SQL)
│   ├── Constants\RoleConstants.cs
│   ├── Database\DbFactory.cs
│   ├── Helpers\ (BasePage.cs, PasswordHasher.cs, SessionHelper.cs)
│   ├── Logic\                       # Professor's ADO.NET Logic Classes
│   │   ├── BaseLogic.cs (getcon())
│   │   ├── UserLogic.cs, PartLogic.cs, InventoryLogic.cs, QuotationLogic.cs
│   │   ├── OrderLogic.cs, ServiceLogic.cs, AdminLogic.cs, AuditLogic.cs
│   │   └── FactoryLogic.cs
│   └── Models\
├── Content\                         # Master Front-End Assets (Single Source of Truth)
│   ├── css\                         # Tokens, components, shell, and animations
│   │   ├── tokens.css, site-shell.css, site.css, admin.css, animations.css
│   ├── js\ (site.js, site-shell.js, admin.js)
│   └── images\ (brand logos, equipment schematics, hero assets)
├── Database\                        # Authoritative SQL Scripts
│   ├── Tables\
│   │   ├── 01_CreateTables.sql      # Core 15 Tables
│   │   └── 02_EnterpriseTables.sql  # AuditLogs, OrderItems, SystemSettings
│   └── Seed\02_SeedData.sql
├── docs\                            # Consolidated Project Documentation
│   ├── brand-guide.md, design-system.md, project-definition.md, project-structure.md
│   ├── PHASE_CHECKLIST.md, VIVA_NOTES.md, AI_USAGE_LOG.md, DECISIONS.md
│   └── PROFESSORS_BACKEND_METHOD.md, BACKEND_THREE_TIER_AUDIT_PLAN.md
├── Factory\                         # Industrial Buyer Portal (RFQs, Orders, Services)
├── MasterPages\                     # Site.Master, Admin.Master, Factory.Master, etc.
├── Public\                          # Public Catalog, Suppliers, Technicians, SOS
├── Supplier\                        # Supplier Inventory, RFQ Bidding, Dispatch Orders
├── Technician\                      # Technician Field Calls & Diagnostic Logs
└── IndustrialSparePartPortal.csproj # MSBuild Project Configuration
```

---

## 3. Database Schema Completion (All Required Tables)

The system currently has 15 core tables. To provide **full administrative control, commercial auditing, and regulatory compliance**, we establish 4 additional enterprise tables:

### New Tables to Add:
1. **`AuditLogs`** — Captures all admin and user mutations:
   - `LogId`, `UserId`, `ActionType` (Create, Update, Delete, Verify, StatusChange), `TargetEntity` (User, Part, Supplier, Order), `EntityId`, `OldValue`, `NewValue`, `IpAddress`, `CreatedAt`.
2. **`OrderItems`** — Normalized line-item breakdown for purchase orders:
   - `OrderItemId`, `OrderId`, `PartId`, `Quantity`, `UnitPrice`, `TotalPrice`, `CreatedAt`.
3. **`SupplierCertificates` / `VerificationDocuments`** — Tracks uploaded compliance certificates:
   - `DocumentId`, `SupplierId`, `DocumentType` (GSTIN_Cert, Trade_License, ISO_9001), `FilePath`, `VerificationStatus`, `VerifiedByAdminId`, `VerifiedAt`.
4. **`SystemSettings`** — Platform-wide configuration:
   - `SettingKey`, `SettingValue`, `Description`, `LastUpdatedBy`.

---

## 4. Admin Panel Complete UI/UX Redesign

### Critique of Current Design (From User's Screenshots)
Based on the screenshots provided:
- **Low Data Density & Stretched View**: On 1080p/1440p displays, tables stretch across 1900px with 3 columns, leaving massive empty voids between data cells.
- **Inadequate Typography & Contrast**: Text sizes are tiny, gray text is unreadable, and tables lack crisp baseline rules.
- **Lack of Interactive Operations**: Current pages only offer a single toggle button ("Deactivate" or "Reject"). There is no way to:
  - Add a user or factory directly from the admin panel.
  - Edit user names, emails, phones, or change passwords.
  - Delete records safely.
  - Inspect full supplier business documents and contact information.
  - Search or filter tables dynamically by keyword, role, or date.
- **Stacked Massive Forms**: In `ManageCategories.aspx`, huge form blocks span the entire screen above tables, pushing data below the fold.

### Redesigned Admin Standards & Features
1. **Industrial Command Layout (`Content/css/admin.css` & `MasterPages/Admin.Master`)**:
   - Distinct, authoritative dark sidebar (`#0F172A`) with ASTANTRA Brand Emblem, crisp navigation badges, and active route markers.
   - Professional breadcrumb bar and sticky action header with live platform status indicators.
   - Max-width content boundaries (`max-w-7xl` centered) to eliminate stretched white space.
2. **Rich High-Density Data Tables**:
   - Search bar + Multi-filter toolbar (Status, Role, Category) above every grid.
   - Sortable columns with tabular monospace numerals for IDs, dates, and amounts.
   - Row action buttons: **View / Inspect Drawer**, **Edit Modal**, **Status Toggle**, and **Delete Confirmation**.
3. **Modal & Drawer Workflows**:
   - "Add New User" / "Add New Part" opens a clean, well-spaced dialog modal instead of cluttering the page with giant static forms.
   - Supplier verification includes an **Inspection Drawer** displaying GSTIN, trade registration, contact details, and warehouse inventory count before approving or rejecting.
4. **Full Administrative CRUD Coverage**:
   - **Users**: Create, Edit, Deactivate/Activate, Delete.
   - **Factories**: Create Factory Profile, Edit Plant Details, View RFQ history.
   - **Suppliers**: Verify/Reject, View Inventory, Audit pricing.
   - **Categories & Machines**: Compact 2-column card layout with Add/Edit/Delete in place.
   - **Spare Parts**: Full search by part number/name, Add Part modal, Edit specs, Delete part.
   - **Orders & Emergencies**: Audit consignment status, update emergency resolution, filter by urgency.

---

## 5. Complete Admin Page Roster (Finalized)

| # | Page File Path | Primary Functionality | Admin Control Capabilities |
|---|---|---|---|
| **1** | `Admin/Dashboard.aspx` | Executive Command Console | Live KPI telemetry, Emergency SOS feed, Verification queue, System metrics |
| **2** | `Admin/Users/ManageUsers.aspx` | Platform User Directory & RBAC | Search, Filter by Role, Add User, Edit User, Toggle Active, Delete |
| **3** | `Admin/Factories/ManageFactories.aspx` | Industrial Plants & Buyers | Add Factory, Edit Plant Info, View Procurement Volume, Filter by City |
| **4** | `Admin/Suppliers/Verification.aspx` | Due Diligence & Vendor Hub | Review Pending GSTIN/Trade Lic, Approve, Reject with remarks, View Inventory |
| **5** | `Admin/Technicians/ManageTechnicians.aspx` | Service Technician Roster | Hourly Rates, Skill Summary, Duty Toggle, Verification status |
| **6** | `Admin/Categories/ManageCategories.aspx` | Equipment Taxonomy & Machinery | Compact Two-Pane Layout: Category CRUD + Machine Model CRUD |
| **7** | `Admin/SpareParts/ManageParts.aspx` | Master Spare-Parts Catalog | Search & Filter, Add New Part Modal, Edit Specs/UOM, Delete Part |
| **8** | `Admin/Orders/Oversight.aspx` | Commercial Orders & SOS Monitor | Multi-tab view: Emergency SOS Alerts, Open RFQs, Consignment Waybills |
| **9** | `Admin/Audit/AuditLogs.aspx` | Governance Audit Trail | Complete historical mutation log (Admin actions, IP, timestamps) |

