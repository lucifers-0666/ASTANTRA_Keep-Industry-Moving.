# ASTANTRA — Enterprise Admin Console Redesign, Functional Improvements & Security Audit Report

## 1. Project & Task Executive Overview

- **Project:** ASTANTRA — Industrial Spare Parts Procurement & Emergency Maintenance Platform
- **Technology Stack (Locked):** ASP.NET Web Forms, C# 7.3, .NET Framework 4.8, Parameterized ADO.NET, SQL Server LocalDB (`IndustrialSparePartDB`).
- **Target Audience:** Multi-tenant industrial ecosystem (Factory Buyers, Stocking Suppliers, Field Technicians, Superadministrators).
- **Academic Context:** MCA Final Year Project (requires strict academic explainability, three-tier architecture compliance, and no unapproved third-party runtime dependencies).

---

## 2. Inspected Codebase Files & Inventory

### Presentation Layer (`.aspx`)
1. `MasterPages/Admin.Master` — Master shell, sidebar navigation, top header, breadcrumb, profile footbar.
2. `Admin/Dashboard.aspx` — Executive command dashboard, 8 high-density telemetry KPI cards, emergency breakdown grid, user roster.
3. `Admin/Profile.aspx` — Administrator identity profile, contact info update, password rotation (SHA-256 + salt).
4. `Admin/Users/ManageUsers.aspx` — User directory with 5-segment role telemetry switchers and reusable filter toolbar.
5. `Admin/Factories/ManageFactories.aspx` — Industrial manufacturing plant buyer registry and contact liaison oversight.
6. `Admin/Suppliers/Verification.aspx` — Stocking vendor compliance, GSTIN inspection, and verification dossiers.
7. `Admin/Technicians/ManageTechnicians.aspx` — Field service engineers, competencies, billing rates, and duty availability.
8. `Admin/Categories/ManageCategories.aspx` — Component classification taxonomy and compatible machine registry.
9. `Admin/SpareParts/ManageParts.aspx` — Global master spare parts catalog with OEM part numbers and specifications.
10. `Admin/Orders/Oversight.aspx` — Tri-section oversight: Emergency SOS breakdown triage, RFQ negotiation bids, and purchase consignments.
11. `Admin/Audit/AuditLogs.aspx` — Tamper-evident immutable transaction log tracking all administrative mutations.

### New Enterprise Modules Implemented
12. `Admin/RBAC/Roles.aspx` — Centralized Role-Based Access Control matrix and privilege clearance documentation.
13. `Admin/Security/LoginSecurity.aspx` — Authentication event stream, session cookie security parameters, and credential rotation logging.
14. `Admin/System/DataIntegrity.aspx` — Referential integrity scanner, orphaned account diagnostics, and table row distribution telemetry.
15. `Admin/System/SystemHealth.aspx` — Live database engine ping, LocalDB heartbeat, and runtime CLR environment telemetry.
16. `Admin/Settings/PlatformSettings.aspx` — Dynamic platform parameter administration backed by the `SystemSettings` database table.

### Business & Data Logic Layer (`App_Code/Logic/`)
17. `App_Code/Logic/BaseLogic.cs` — Professor-pattern database connectivity (`getcon()`).
18. `App_Code/Logic/AdminLogic.cs` — Executive metrics, supplier verification, plant buyer registration, technician administration, RBAC, integrity audits, system health, and system settings management.
19. `App_Code/Logic/UserLogic.cs` — User account CRUD, role segmentation queries, password rotation, profile updates.
20. `App_Code/Logic/AuditLogic.cs` — Structured transaction logging with actor, IP, timestamp, old value, and new value.

### Database Scripts & Schemas (`Database/`)
21. `Database/Tables/01_CreateTables.sql` — Core normalized tables (Users, Roles, Factories, Suppliers, Technicians, Categories, Machines, SpareParts, Quotations, Orders).
22. `Database/Tables/02_EnterpriseTables.sql` — Enterprise extension tables (AuditLogs, OrderItems, SupplierCertificates, SystemSettings).
23. `Database/Migrations/01_Add_Technicians_Address.sql` — Schema migration adding missing `Address` column to `Technicians`.

---

## 3. Database Schema Audit & Resolution of Existing Errors

### Bug Discovered: Invalid column name 'Address'
- **Root Cause:** In `Database/Tables/01_CreateTables.sql`, table `Technicians` was created with `City`, `State`, and `Pincode`, but omitted `Address`. However, `AdminLogic.cs` (lines 385, 441, 554), `UserLogic.cs` (line 141), and `ManageTechnicians.aspx` (lines 72, 212, 274) were all written expecting `Address NVARCHAR(255) NULL`. When `ManageTechnicians.aspx` executed its data binding, SQL Server threw `Invalid column name 'Address'`.
- **Resolution:**
  1. Executed database migration on LocalDB:
     ```sql
     ALTER TABLE Technicians ADD Address NVARCHAR(255) NULL;
     ```
  2. Documented migration in `Database/Migrations/01_Add_Technicians_Address.sql`.
  3. Updated `Database/Tables/01_CreateTables.sql` to include `Address NVARCHAR(255) NULL` for fresh environment deployments.
  4. Verified via Playwright live browser inspection: `ManageTechnicians.aspx` now loads and renders the technician record with 0 errors.

---

## 4. UI/UX Design System & Layout Improvements

### Palette Standardization (Matching Spec & Enterprise Reference)
- **Primary Navigation:** `#101B30` (Authoritative dark navy)
- **Secondary Navy:** `#17243A` (Hover and grouping headers)
- **Primary Action:** `#1769E0` (Industrial action blue)
- **Main Background:** `#F5F7FA` (Clean industrial canvas)
- **Card Surface:** `#FFFFFF` with `#DCE3EC` crisp structural borders
- **Accent Highlighting:** `#38BDF8` (Sky blue active route indicator)

### Eliminated White Gap & Decongested Sidebar
- Removed `site-shell.css` from `Admin.Master` (which was causing an unwanted 68px top white gap designed for the public site).
- Expanded sidebar to `w-72` (288px) and structured into **8 distinct functional groups**:
  1. `EXECUTIVE`: Command Dashboard
  2. `IDENTITY & ACCESS`: User Directory, Roles & Permissions, Login & Session Security
  3. `BUSINESS DIRECTORY`: Industrial Plant Buyers, Suppliers & Verification, Service Technicians
  4. `CATALOG & MACHINERY`: Categories & Machines, Master Parts Catalog
  5. `PROCUREMENT & OPS`: Orders & Emergency SOS
  6. `GOVERNANCE & SYSTEM`: Platform Audit Trail, Data Integrity Suite, System Health
  7. `ADMINISTRATION`: Platform Settings, Administrator Profile
- Active route highlighting auto-detects URL and applies `.admin-nav-item--active`.

### Reusable Search & Filter Toolbar (`.admin-toolbar`)
- Replaced mismatched, vertically stacking Tailwind classes with dedicated CSS rules:
  - `.admin-toolbar`: Flexible horizontal bar with crisp borders and subtle shadow.
  - `.admin-search-box`: Search input with absolute-positioned magnifying glass icon (never overlapping text).
  - `.admin-filter-group`: Inline select dropdowns and aligned Action/Reset buttons.
- Applied across all management pages: `ManageUsers.aspx`, `ManageFactories.aspx`, `Verification.aspx`, `ManageTechnicians.aspx`, `ManageParts.aspx`, `AuditLogs.aspx`.

### Role Segmentation Grid (`.admin-segment-grid`)
- Formatted the 5 role telemetry switchers on `ManageUsers.aspx` into a dedicated 5-column responsive grid (`.admin-segment-card`) with role-specific left border colors and real database counts.

---

## 5. Security Assessment & Hardening

1. **Password Storage:** SHA-256 with unique 32-byte cryptographic salt per account (`PasswordHasher.cs`).
2. **Session Cookies:** `HttpOnly` flag enabled to prevent cross-site scripting (XSS) cookie theft.
3. **Role Enforcement:** Server-side `BasePage.RequiredRole = RoleConstants.Administrator` on all admin pages (cannot be bypassed by URL tampering or UI inspection).
4. **SQL Injection Defense:** 100% of ADO.NET database operations in `AdminLogic.cs`, `UserLogic.cs`, and `AuditLogic.cs` use strongly typed `SqlParameter` objects; zero string concatenation in SQL queries.
5. **Audit Trail Protection:** `AuditLogs` table enforces tamper-evident tracking (Actor, Action, Target Entity, Record ID, Old Value, New Value, IP Address, Timestamp). Administrative users have no UI controls to edit or delete audit logs.

---

## 6. Functional & Browser Verification Results

| Page / Feature | Viewport Tested | Result | Verification Notes |
| :--- | :--- | :--- | :--- |
| `Admin/Dashboard.aspx` | 1440x900 | **PASS** | 8 KPI cards display real counts (Users: 4, Suppliers: 1, Plants: 1, Techs: 1, GMV: ₹85,000). |
| `Admin/Users/ManageUsers.aspx` | 1440x900 | **PASS** | 5-column role switchers work; horizontal filter toolbar properly aligned; real user data bound. |
| `Admin/RBAC/Roles.aspx` | 1440x900 | **PASS** | 4 system roles rendered with real user counts and full privilege matrix. |
| `Admin/Security/LoginSecurity.aspx` | 1440x900 | **PASS** | Security parameters card and live authentication stream rendered without errors. |
| `Admin/System/DataIntegrity.aspx` | 1440x900 | **PASS** | Diagnostic metrics display 0 orphaned accounts; live table row breakdown for all 19 entities. |
| `Admin/System/SystemHealth.aspx` | 1440x900 | **PASS** | Heartbeat test succeeds; displays SQL Server 2025 LocalDB status and CLR specifications. |
| `Admin/Settings/PlatformSettings.aspx` | 1440x900 | **PASS** | Reads 3 live records from `SystemSettings` table; modal allows parameter updates. |
| `Admin/Profile.aspx` | 1440x900 | **PASS** | Platform Administrator identity, contact update form, and password change controls render cleanly. |
| `Admin/Technicians/ManageTechnicians.aspx` | 1440x900 | **PASS** | Address column schema bug resolved; technician record loads with competencies and rate. |
| `Admin/Suppliers/Verification.aspx` | 1440x900 | **PASS** | Verified supplier record displays GSTIN and due diligence inspection options. |
| `Admin/Categories/ManageCategories.aspx` | 1440x900 | **PASS** | 5 part categories and 3 machine models display cleanly in dual tables. |
| `Admin/Audit/AuditLogs.aspx` | 1440x900 | **PASS** | Real-time audit event stream displays timestamps, actors, and mutation payloads. |
| MSBuild Compilation | Console | **PASS** | `IndustrialSparePartPortal -> bin\IndustrialSparePartPortal.dll` with 0 errors and 0 warnings. |
