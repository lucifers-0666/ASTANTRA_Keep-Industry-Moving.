# ASTANTRA Platform — Master Project Status & Inventory

**Last Updated:** November 7, 2026  
**Active Development Branch:** `feature/factory-portal-completion`  
**Base Truth Branch:** `main`  
**Platform Architecture:** Three-Tier ASP.NET Web Forms (.NET Framework 4.8, C# 7.3)  
**Database Catalog:** SQL Server LocalDB (`IndustrialSparePartDB`) with Parameterized ADO.NET  
**Total Physical ASPX Pages:** **41 Pages**

---

## 1. Executive Status Dashboard

| Project Phase | Portal / Module | Target Pages | Implementation Status | Audit & Test Status | Next Actions |
|:---|:---|:---:|:---:|:---:|:---|
| **Phase 1** | **Public Visitor Portal** | 7 | **100% Complete** | **Audited & Verified** | Public browsing ready |
| **Phase 2** | **Auth & Multi-Role Onboarding** | 4 | **100% Functional** | **PBKDF2 Hardened** | Expand MFA / Email Verify |
| **Phase 3** | **Factory Buyer Portal** | 9 | **100% Complete** | **9/9 Pages Passed (HTTP 200)** | Verified & multi-tenant tested |
| **Phase 4** | **Supplier Operations Hub** | 4 | **Scaffolded (Baseline)** | **Pending Redesign** | **NEXT IMMEDIATE FOCUS** |
| **Phase 5** | **Field Technician Portal** | 2 | **Scaffolded (Baseline)** | **Pending Redesign** | Follows Phase 4 |
| **Phase 6** | **Administrator Governance Console** | 15 | **100% Complete** | **15/15 Pages Passed (HTTP 200)** | Fully hardened & ready |
| **Phase 7** | **Final Integration & Viva Preparation** | - | **In Progress** | **Docs Created** | Viva presentation package |

---

## 2. Master 41-Page Inventory

The repository contains exactly **41 physical `.aspx` files**. All files have verified code-behind (`.aspx.cs`), designer mappings (`.aspx.designer.cs`), and master page inheritance.

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

### D. Factory Buyer Portal (9 Pages) — Phase 3: 100% Complete & Hardened
| File Path | Master Page | Access Role | Functional Purpose |
|:---|:---|:---|:---|
| `Factory/Dashboard.aspx` | `~/MasterPages/Factory.Master` | Factory | Plant command center, 5 KPI metrics, 4 Chart.js charts, recent orders, emergencies |
| `Factory/SpareParts/Search.aspx` | `~/MasterPages/Factory.Master` | Factory | Catalog search, machine model compatibility, modal RFQ creation |
| `Factory/Quotations/MyRequests.aspx` | `~/MasterPages/Factory.Master` | Factory | Requisitions ledger, supplier bid counts, comparison routing |
| `Factory/Quotations/Compare.aspx` | `~/MasterPages/Factory.Master` | Factory | Side-by-side commercial bid comparison, atomic order placement transaction |
| `Factory/Orders/MyOrders.aspx` | `~/MasterPages/Factory.Master` | Factory | Purchase order history, fulfillment status filter, link to invoice inspection |
| `Factory/Orders/OrderDetails.aspx` | `~/MasterPages/Factory.Master` | Factory | Itemized purchase order, B2B tax invoice, waybill tracker, printable A4 sheet |
| `Factory/Machines/MyMachinery.aspx` | `~/MasterPages/Factory.Master` | Factory | Plant equipment fleet register, asset tags, operational status, breakdown stats |
| `Factory/Technicians/ServiceRequests.aspx` | `~/MasterPages/Factory.Master` | Factory | Field engineer booking, duty availability check, maintenance history |
| `Factory/Profile/PlantProfile.aspx` | `~/MasterPages/Factory.Master` | Factory | Legal entity master, verified GSTIN, registered plant gates, 24/7 SOS phone |

### E. Supplier Operations Hub (4 Pages) — Phase 4: Next Focus
| File Path | Master Page | Access Role | Functional Purpose |
|:---|:---|:---|:---|
| `Supplier/Dashboard.aspx` | `~/MasterPages/Supplier.Master` | Supplier | Revenue telemetry, pending RFQs, inventory status, fulfillment alerts |
| `Supplier/Inventory/ManageParts.aspx` | `~/MasterPages/Supplier.Master` | Supplier | Catalog inventory listing, pricing updates, stock levels, part specifications |
| `Supplier/Quotations/IncomingRequests.aspx` | `~/MasterPages/Supplier.Master` | Supplier | RFQ review, commercial bid drafting (unit price, delivery SLA, warranty) |
| `Supplier/Orders/ManageOrders.aspx` | `~/MasterPages/Supplier.Master` | Supplier | Received purchase orders, status updates (Shipped/Delivered), waybill entry |

### F. Service Technician Portal (2 Pages) — Phase 5
| File Path | Master Page | Access Role | Functional Purpose |
|:---|:---|:---|:---|
| `Technician/Dashboard.aspx` | `~/MasterPages/Technician.Master` | Technician | Field engineer command center, active emergency triage, earnings |
| `Technician/Requests/AssignedJobs.aspx` | `~/MasterPages/Technician.Master` | Technician | Dispatched maintenance tickets, site navigation, status updates |

---

## 3. Technology Stack & Constraints Checklist

- [x] **Framework**: ASP.NET Web Forms (.NET Framework 4.8)
- [x] **Language**: C# 7.3 (with strict C# 5 compatibility in `App_Code/`)
- [x] **Database**: SQL Server LocalDB (`IndustrialSparePartDB`) with parameterized ADO.NET
- [x] **Data Isolation**: Role-based access control + server-resolved `FactoryBasePage`
- [x] **Atomic Transactions**: `QuotationLogic.acceptBidTransaction` simultaneously creates `Orders` and itemized `OrderItems`
- [x] **Zero Mock Data**: 100% of telemetry, cards, charts, and grids bound to live SQL data
