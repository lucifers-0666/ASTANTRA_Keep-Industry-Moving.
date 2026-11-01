# ASTANTRA — Comprehensive Repository & Page Inventory Audit
**Deliverable for Phase 0**  
**Project:** ASTANTRA — Keep Industry Moving  
**Target Environment:** ASP.NET Web Forms, .NET Framework 4.8, C# 7.3, SQL Server LocalDB  
**Auditor / Project Lead:** Zaid Amreliya  

---

## 1. Executive Summary

As required by the Project Lead Development Guide, an exhaustive physical audit of all `.aspx` files, `.aspx.cs` code-behind files, database schemas, tables, seed data, repositories, and stylesheets was conducted.

- **Total Target Inventory**: 32 pages across 6 functional areas.
- **Existing Physical Pages**: 15 pages in project tree (7 Public, 4 Authentication, 1 Factory, 1 Supplier, 1 Technician, 1 Admin).
- **Database Status**: Fully initialized and verified on `(localdb)\MSSQLLocalDB` with database `IndustrialSparePartDB`. All 15 relational tables exist with foreign keys and seed records.
- **Compilation Health**: MSBuild succeeds cleanly with **0 Warnings, 0 Errors**.

---

## 2. Complete 32-Page Status Inventory

### A. Public Pages (Owned by Uday) — 7 Pages

| # | Page Name | Physical File | Code-Behind (`.cs`) | Designer (`.designer.cs`) | Current Status | Notes |
|---|---|---|---|---|---|---|
| 01 | Home | `Default.aspx` | Present | Present | **Working** | Ruled engineering layout, bearing schematic selector, verified seed categories. |
| 02 | Parts Catalog | `Public/Parts.aspx` | Present | Present | **Working** | Client search & filter demo cards, responsive layout. |
| 03 | Suppliers Directory | `Public/Suppliers.aspx` | Present | Present | **Working** | Supplier cards, ISO/GSTIN badges, contact modal. |
| 04 | Technicians Directory | `Public/Technicians.aspx` | Present | Present | **Working** | Verified technician profiles, hourly rates, duty chips. |
| 05 | How It Works | `Public/HowItWorks.aspx` | Present | Present | **Working** | 3-phase industrial procurement lifecycle explanation. |
| 06 | Why ASTANTRA | `Public/WhyUs.aspx` | Present | Present | **Working** | Industrial procurement benchmark comparison table. |
| 07 | Emergency Desk | `Public/Emergency.aspx` | Present | Present | **Working** | Breakdown reporting form with client-side field validation. |

### B. Authentication Pages (Owned by Zaid) — 4 Pages

| # | Page Name | Physical File | Code-Behind (`.cs`) | Designer (`.designer.cs`) | Current Status | Notes |
|---|---|---|---|---|---|---|
| 08 | Login | `Account/Login.aspx` | Present | Present | **Working** | Full parameterized ADO.NET auth, SHA-256 + salt verification, role redirection. |
| 09 | Register | `Account/Register.aspx` | Present | Present | **Working** | Multi-role registration with dynamic radio-button toggle for Factory, Supplier, Technician. |
| 10 | Logout | `Account/Logout.aspx` | Present | Present | **Working** | `FormsAuthentication.SignOut()`, clears `SessionHelper`, redirects to Login. |
| 11 | Access Denied | `Account/AccessDenied.aspx` | Present | Present | **Working** | Displays HTTP 403 unauthorized notification with back-navigation. |

### C. Factory Buyer Panel (Owned by Zaid) — 6 Pages

| # | Page Name | Physical File | Code-Behind (`.cs`) | Designer (`.designer.cs`) | Current Status | Notes |
|---|---|---|---|---|---|---|
| 12 | Factory Dashboard | `Factory/Dashboard.aspx` | Present | Present | **Working** | KPIs, plant profile resolution, pending RFQ summary, quick breakdown launcher. |
| 13 | Spare Parts Search | `Factory/SpareParts/Search.aspx` | To Scaffold | To Scaffold | **Partial** | Search catalog across verified suppliers, filter by category/machine, click "Request RFQ". |
| 14 | My Requests | `Factory/Quotations/MyRequests.aspx` | To Scaffold | To Scaffold | **Partial** | GridView of issued RFQs (`QuotationRequests`), status pills (Pending, Quoted, Closed). |
| 15 | Quotation Comparison | `Factory/Quotations/Compare.aspx` | To Scaffold | To Scaffold | **Partial** | Side-by-side comparison of supplier bids from `QuotationResponses`, Accept Bid action. |
| 16 | My Orders | `Factory/Orders/MyOrders.aspx` | To Scaffold | To Scaffold | **Partial** | Tracks placed orders from `Orders` table, shipping status, tracking numbers. |
| 17 | Service Requests | `Factory/Technicians/ServiceRequests.aspx` | To Scaffold | To Scaffold | **Partial** | Logs and books technician maintenance visits from `ServiceRequests`. |

### D. Spare-Part Supplier Hub (Owned by Jay) — 5 Pages

| # | Page Name | Physical File | Code-Behind (`.cs`) | Designer (`.designer.cs`) | Current Status | Notes |
|---|---|---|---|---|---|---|
| 18 | Supplier Dashboard | `Supplier/Dashboard.aspx` | Present | Present | **Working** | Metric KPIs shell, stock warning indicators. |
| 19 | Inventory Management | `Supplier/Inventory/ManageParts.aspx` | Empty Dir | Empty Dir | **Not started** | Add/edit stock quantity, unit price, lead time in `SupplierInventory`. |
| 20 | Incoming RFQs | `Supplier/Quotations/IncomingRequests.aspx` | Empty Dir | Empty Dir | **Not started** | View factory RFQ requests matching supplier parts. |
| 21 | Submit Quotation | `Supplier/Quotations/SubmitQuotation.aspx` | Empty Dir | Empty Dir | **Not started** | Bid form: offered unit price, delivery days, notes into `QuotationResponses`. |
| 22 | Manage Orders | `Supplier/Orders/ManageOrders.aspx` | Empty Dir | Empty Dir | **Not started** | View orders, update status: Placed $\to$ Dispatched (tracking #) $\to$ Delivered. |

### E. Field Technician Portal (Owned by Jay / Approval) — 4 Pages

| # | Page Name | Physical File | Code-Behind (`.cs`) | Designer (`.designer.cs`) | Current Status | Notes |
|---|---|---|---|---|---|---|
| 23 | Technician Dashboard | `Technician/Dashboard.aspx` | Present | Present | **Working** | Availability toggle (`On Duty` / `Off Duty`), active jobs shell. |
| 24 | Assigned Jobs | `Technician/Requests/AssignedJobs.aspx` | Empty Dir | Empty Dir | **Not started** | GridView of maintenance requests dispatched to technician. |
| 25 | Job Details | `Technician/Requests/JobDetails.aspx` | Empty Dir | Empty Dir | **Not started** | Machine model, factory address, contact person, reported symptoms. |
| 26 | Update Status | `Technician/Services/UpdateStatus.aspx` | Empty Dir | Empty Dir | **Not started** | Status updates: Accepted $\to$ En Route $\to$ In Progress $\to$ Completed. |

### F. Administrator Governance Portal (Owned by Zaid) — 6 Pages

| # | Page Name | Physical File | Code-Behind (`.cs`) | Designer (`.designer.cs`) | Current Status | Notes |
|---|---|---|---|---|---|---|
| 27 | Admin Dashboard | `Admin/Dashboard.aspx` | Present | Present | **Working** | High-level user counts, system status cards. |
| 28 | Manage Users | `Admin/Users/ManageUsers.aspx` | To Scaffold | To Scaffold | **Partial** | GridView of all users, filter by role, activate/deactivate account toggle. |
| 29 | Supplier & Tech Audit | `Admin/Suppliers/Verification.aspx` | To Scaffold | To Scaffold | **Partial** | Audit pending GSTIN/trade licenses; click "Approve" or "Reject". |
| 30 | Manage Categories | `Admin/Categories/ManageCategories.aspx` | To Scaffold | To Scaffold | **Partial** | CRUD for industrial categories (`Categories`) and machinery (`Machines`). |
| 31 | Spare Parts Catalog | `Admin/SpareParts/ManageParts.aspx` | To Scaffold | To Scaffold | **Partial** | Master parts catalog management (`SpareParts` table). |
| 32 | Requests & Orders Oversight | `Admin/Orders/Oversight.aspx` | To Scaffold | To Scaffold | **Partial** | System-wide monitoring of RFQs, emergency alerts, and fulfillment status. |

---

## 3. Database Architecture & Table Audit

The database `IndustrialSparePartDB` is hosted on `(localdb)\MSSQLLocalDB`.

### Verified Table Schema (15 Tables)

1. **`Roles`** (4 rows: Administrator, Factory, Supplier, Technician)
2. **`Users`** (4 verified seed accounts with SHA-256 salted hashes)
3. **`Factories`** (Industrial buyer profiles linked to `Users.UserId`)
4. **`Suppliers`** (Vendor profiles with GSTIN, business reg #, rating, verification status)
5. **`Technicians`** (Technician profiles with skills, hourly rate, duty availability)
6. **`Categories`** (5 seed categories: Hydraulics, Motors, Bearings, Electrical, Pumps)
7. **`Machines`** (3 seed machines: CNC Lathe X200, Hydraulic Press 500T, Compressor 75HP)
8. **`SpareParts`** (Master catalog: PartNumber, PartName, TechnicalSpecs, CategoryId, MachineId)
9. **`SupplierInventory`** (Supplier stock count, unit price, lead time)
10. **`QuotationRequests`** (Factory RFQs: PartId, Quantity, TargetPrice, Status)
11. **`QuotationResponses`** (Supplier bids: OfferedUnitPrice, OfferedLeadTimeDays, Status)
12. **`EmergencyRequests`** (Critical breakdown dispatch: MachineName, PriorityLevel, Status)
13. **`Orders`** (Procurement orders: OrderNumber, TotalAmount, OrderStatus, TrackingNumber)
14. **`ServiceRequests`** (Technician repair tickets: ServiceType, IssueDescription, ServiceStatus)
15. **`Notifications`** (System alerts: UserId, Title, Message, IsRead)

### Verified Seed Accounts

| Role | Email | Password | PasswordHash (Salt: `StaticSalt123456`) |
|---|---|---|---|
| **Administrator** | `admin@sparepartportal.com` | `Admin@123` | `ZRxnNHMRXLLPHq96WRumxNbeBZwLf6Sw2M/syZoWzhs=` |
| **Factory Buyer** | `factory@plant.com` | `Factory@123` | `bJkasqzP4gLL0dqTBhTwSktP+zh9WbSWn+QyeVQsxmw=` |
| **Supplier** | `supplier@parts.com` | `Supplier@123` | `xQZeP3mSkPH8AIOH6HvEJ6DHx9O7lcPxnGuaSG+oM6Y=` |
| **Technician** | `tech@service.com` | `Tech@123` | `MGFLkeeDtoDaTeAmavrsrK8ol/k1TRrKTDCbqVpoUgo=` |

---

## 4. Shared Infrastructure Audit

- **Master Pages**:
  - `MasterPages/Site.Master`: Public layout with responsive header, active navigation sync, and engineering footer.
  - `MasterPages/Factory.Master`: Factory console shell with quick links to Dashboard, Parts, Emergency, and Logout.
  - `MasterPages/Supplier.Master`: Supplier hub layout with inventory and quote tabs.
  - `MasterPages/Technician.Master`: Field technician layout with duty status chip.
  - `MasterPages/Admin.Master`: Admin dark sidebar layout with navigation to governance modules.
- **Data Access Layer**:
  - `App_Code/Database/DbFactory.cs`: Static connection provider and ADO.NET command execution helper (`ExecuteQuery`, `ExecuteNonQuery`, `ExecuteScalar`, `ExecuteSingleRow`).
  - `App_Code/Helpers/PasswordHasher.cs`: SHA-256 with cryptographic salt generator.
  - `App_Code/Helpers/SessionHelper.cs`: Strongly typed session wrapper (`UserId`, `UserRole`, `FullName`, `IsVerified`, `IsLoggedIn`).
  - `App_Code/Helpers/BasePage.cs`: Page-level security check (`RequiredRole` and authentication redirection).
- **Styles & Scripts**:
  - `Content/css/tokens.css`: Core design system variables (colors, borders, fonts).
  - `Content/css/site-shell.css`: Industrial styling for headers, buttons, cards, data tables, and badges.
  - `Content/css/site.css`: Compiled Tailwind utility classes.
  - `Content/js/site-shell.js`: Navigation sync, sticky header, mobile drawer.

