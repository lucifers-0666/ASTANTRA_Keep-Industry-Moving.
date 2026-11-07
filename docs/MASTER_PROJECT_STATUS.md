# ASTANTRA Platform — Master Project Status & Inventory

**Last Updated:** November 7, 2026  
**Active Development Branch:** `feature/admin-completion`  
**Base Truth Branch:** `main`  
**Platform Architecture:** Three-Tier ASP.NET Web Forms (.NET Framework 4.8, C# 7.3)  
**Database Catalog:** SQL Server LocalDB (`IndustrialSparePartDB`) with Parameterized ADO.NET  
**Total Physical ASPX Pages:** **38 Pages**

---

## 1. Executive Status Dashboard

| Project Phase | Portal / Module | Target Pages | Implementation Status | Audit & Test Status | Next Actions |
|:---|:---|:---:|:---:|:---:|:---|
| **Phase 1** | **Public Visitor Portal** | 7 | **100% Complete** | **Audited & Verified** | Public browsing ready |
| **Phase 2** | **Auth & Multi-Role Onboarding** | 4 | **100% Functional** | **PBKDF2 Hardened** | Expand MFA / Email Verify |
| **Phase 3** | **Factory Buyer Portal** | 6 | **Scaffolded (Baseline)** | **Pending Redesign** | **NEXT IMMEDIATE FOCUS** |
| **Phase 4** | **Supplier Operations Hub** | 4 | **Scaffolded (Baseline)** | **Pending Redesign** | Follows Phase 3 |
| **Phase 5** | **Field Technician Portal** | 2 | **Scaffolded (Baseline)** | **Pending Redesign** | Follows Phase 4 |
| **Phase 6** | **Administrator Governance Console** | 15 | **100% Complete** | **15/15 Pages Passed (HTTP 200)** | Fully hardened & ready |
| **Phase 7** | **Final Integration & Viva Preparation** | - | **In Progress** | **Docs Created** | Viva presentation package |

---

## 2. Master 38-Page Inventory

The repository contains exactly **38 physical `.aspx` files**. All files have verified code-behind (`.aspx.cs`), designer mappings (`.aspx.designer.cs`), and master page inheritance.

### A. Public Visitor Portal (7 Pages) — Phase 1: Complete
| File Path | Master Page | Access Role | Functional Purpose |
|:---|:---|:---|:---|
| `Default.aspx` | `~/MasterPages/Site.Master` | Public | Primary platform landing page with industrial search & telemetry |
| `Public/Parts.aspx` | `~/MasterPages/Site.Master` | Public | Master spare parts catalog with keyword and category filtering |
| `Public/Suppliers.aspx` | `~/MasterPages/Site.Master` | Public | Industrial supplier directory with location & verification badges |
| `Public/Technicians.aspx` | `~/MasterPages/Site.Master` | Public | Certified service engineer network with skill filters |
| `Public/HowItWorks.aspx` | `~/MasterPages/Site.Master` | Public | Step-by-step procurement, quotation, and emergency workflow guide |
| `Public/WhyUs.aspx` | `~/MasterPages/Site.Master` | Public | Enterprise value proposition, SLA uptime guarantees, and compliance |
| `Public/Emergency.aspx` | `~/MasterPages/Site.Master` | Public / Role Check | Rapid industrial machine breakdown SOS intake and dispatch desk |

### B. Account & Authentication (4 Pages) — Phase 2: Active & Hardened
| File Path | Master Page | Access Role | Functional Purpose |
|:---|:---|:---|:---|
| `Account/Login.aspx` | `~/MasterPages/Site.Master` | Anonymous | Secure credentials login with PBKDF2 hash verification & role routing |
| `Account/Register.aspx` | `~/MasterPages/Site.Master` | Anonymous | Multi-role registration (Factory, Supplier, Technician) with validation |
| `Account/Logout.aspx` | None (Headless) | Authenticated | Destroys session, issues auth cookie expiration, logs `AUTH_LOGOUT` |
| `Account/AccessDenied.aspx` | `~/MasterPages/Site.Master` | Authenticated | 403 Forbidden guidance with role-based return navigation |

### C. Administrator Governance Console (15 Pages) — Phase 6: Complete & Hardened
| File Path | Master Page | Access Role | Functional Purpose |
|:---|:---|:---|:---|
| `Admin/Dashboard.aspx` | `~/MasterPages/Admin.Master` | Administrator | Executive command dashboard with live telemetry, breakdown alerts, and roster |
| `Admin/Users/ManageUsers.aspx` | `~/MasterPages/Admin.Master` | Administrator | Multi-role user directory, atomic registration modal, access toggling, deletion |
| `Admin/Factories/ManageFactories.aspx` | `~/MasterPages/Admin.Master` | Administrator | Industrial plant buyer management, facility details edit, onboarding modal |
| `Admin/Suppliers/Verification.aspx` | `~/MasterPages/Admin.Master` | Administrator | Supplier compliance dossier review, GSTIN verification, approval/rejection |
| `Admin/Technicians/ManageTechnicians.aspx` | `~/MasterPages/Admin.Master` | Administrator | Field technician roster, certification audits, hourly rates, duty availability |
| `Admin/Categories/ManageCategories.aspx` | `~/MasterPages/Admin.Master` | Administrator | Component taxonomy, category CRUD, industrial machinery model registry |
| `Admin/SpareParts/ManageParts.aspx` | `~/MasterPages/Admin.Master` | Administrator | Master spare parts catalog, technical specifications, OEM mappings |
| `Admin/Orders/Oversight.aspx` | `~/MasterPages/Admin.Master` | Administrator | Emergency SOS breakdown triage, RFQ quotation monitoring, order waybills |
| `Admin/Audit/AuditLogs.aspx` | `~/MasterPages/Admin.Master` | Administrator | Immutable platform audit trail, auth surveillance, actor delta inspection |
| `Admin/Profile.aspx` | `~/MasterPages/Admin.Master` | Administrator | Superadmin credentials management, magic-byte avatar upload & sanitization |
| `Admin/RBAC/Roles.aspx` | `~/MasterPages/Admin.Master` | Administrator | Dynamic role clearance management, granular permission granting/revocation |
| `Admin/Security/LoginSecurity.aspx` | `~/MasterPages/Admin.Master` | Administrator | Real-time auth event monitoring, failed login tracking, cryptographic status |
| `Admin/System/DataIntegrity.aspx` | `~/MasterPages/Admin.Master` | Administrator | Database diagnostics, orphaned account detection, one-click integrity reconciliation |
| `Admin/System/SystemHealth.aspx` | `~/MasterPages/Admin.Master` | Administrator | Live database query latency benchmark (ms), memory usage, connection telemetry |
| `Admin/Settings/PlatformSettings.aspx` | `~/MasterPages/Admin.Master` | Administrator | Global emergency broadcast radius, maintenance mode, system thresholds |

### D. Factory Buyer Portal (6 Pages) — Phase 3: Next Development Target
| File Path | Master Page | Access Role | Functional Purpose |
|:---|:---|:---|:---|
| `Factory/Dashboard.aspx` | `~/MasterPages/Factory.Master` | Factory | Plant overview, machine fleet status, active breakdowns, pending POs |
| `Factory/SpareParts/Search.aspx` | `~/MasterPages/Factory.Master` | Factory | Catalog search, part compatibility checking, RFQ request creation |
| `Factory/Quotations/MyRequests.aspx` | `~/MasterPages/Factory.Master` | Factory | Overview of requested quotations, quotation status, supplier bids |
| `Factory/Quotations/Compare.aspx` | `~/MasterPages/Factory.Master` | Factory | Side-by-side bid comparison (unit price, delivery SLA, warranty) |
| `Factory/Orders/MyOrders.aspx` | `~/MasterPages/Factory.Master` | Factory | Purchase order history, shipment dispatch tracking, receipt confirmation |
| `Factory/Technicians/ServiceRequests.aspx` | `~/MasterPages/Factory.Master` | Factory | Emergency technician booking, on-site service tracking, job sign-off |

### E. Supplier Operations Hub (4 Pages) — Phase 4
| File Path | Master Page | Access Role | Functional Purpose |
|:---|:---|:---|:---|
| `Supplier/Dashboard.aspx` | `~/MasterPages/Supplier.Master` | Supplier | Supplier overview, sales GMV, stock alerts, verification banner |
| `Supplier/Inventory/ManageParts.aspx` | `~/MasterPages/Supplier.Master` | Supplier | Stock inventory management, unit pricing, lead time, stock levels |
| `Supplier/Quotations/IncomingRequests.aspx` | `~/MasterPages/Supplier.Master` | Supplier | Incoming RFQs, quotation submission modal, competitive pricing |
| `Supplier/Orders/ManageOrders.aspx` | `~/MasterPages/Supplier.Master` | Supplier | Purchase orders received, waybill updates, fulfillment status |

### F. Service Technician Portal (2 Pages) — Phase 5
| File Path | Master Page | Access Role | Functional Purpose |
|:---|:---|:---|:---|
| `Technician/Dashboard.aspx` | `~/MasterPages/Technician.Master` | Technician | Engineer portal, active duty toggle, accepted repairs, job radius |
| `Technician/Requests/AssignedJobs.aspx` | `~/MasterPages/Technician.Master` | Technician | Assigned breakdown dispatches, site GPS coordinates, job completion |

---

## 3. Database Schema Architecture (21 Tables)

The database catalog `IndustrialSparePartDB` includes 21 tables created across 3 structured migrations:

1. `Roles` (4 seeded system roles: Administrator, Factory, Supplier, Technician)
2. `Users` (Core authentication entity with PBKDF2 hashes and salt)
3. `AuditLogs` (System-wide immutable audit trail)
4. `SystemSettings` (Platform governance configuration)
5. `Factories` (Plant buyer profile and corporate credentials)
6. `Suppliers` (Vendor profile with GSTIN, rating, and verification state)
7. `Technicians` (Service engineer profile with rate and duty availability)
8. `Categories` (Spare part equipment taxonomy)
9. `MachineryModels` (Industrial machine specifications and manufacturers)
10. `SpareParts` (Global master parts catalog)
11. `SupplierInventory` (Vendor stock levels, lead times, and unit pricing)
12. `RFQs` (Request for Quotations published by factories)
13. `RFQItems` (Line items for RFQ requisitions)
14. `Quotations` (Supplier price bids submitted against RFQs)
15. `QuotationItems` (Itemized bid pricing and availability)
16. `Orders` (Formal purchase orders generated upon quote acceptance)
17. `OrderItems` (Purchased spare part quantities and unit amounts)
18. `EmergencyBreakdowns` (High-priority machine stoppage incident tickets)
19. `TechnicianJobs` (Service engineer job allocations and resolution tracking)
20. `Permissions` (*Migration 03*: 18 granular access clearance keys)
21. `RolePermissions` (*Migration 03*: Junction table assigning permissions to roles)

---

## 4. Academic Rigor & Viva Explanation Architecture

For examination defense, the codebase demonstrates:
1. **Three-Tier Separation:** Strict layering between ASPX presentation controls, typed Business Logic services, and parameterized ADO.NET data access.
2. **ACID Transactions:** Atomic user + profile registration avoiding orphan records via `SqlTransaction`.
3. **Defense Against Top Vulnerabilities (OWASP Top 10):**
   - **SQL Injection:** Parameterized queries across all 21 tables.
   - **Weak Password Storage:** Upgraded from single-round SHA-256 to PBKDF2 (HMAC-SHA256, 10,000 iterations, 128-bit salt).
   - **Broken Access Control:** Server-side RBAC validation in `BasePage.cs` with dynamic clearance checks.
   - **Malicious Uploads:** Magic-byte inspection and server-side image re-encoding.
   - **Privilege Escalation:** Admin approval workflows required before vendor bidding or emergency dispatch.
