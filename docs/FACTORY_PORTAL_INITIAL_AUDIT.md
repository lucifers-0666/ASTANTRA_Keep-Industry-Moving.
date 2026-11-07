# ASTANTRA — Factory Buyer Portal Initial Architecture & Security Audit

**Document Reference:** `docs/FACTORY_PORTAL_INITIAL_AUDIT.md`  
**Audit Date:** November 7, 2026  
**Auditor:** ASTANTRA Systems & Security Engineering Group  
**Active Working Branch:** `feature/factory-portal-completion`  
**Base Target Commit:** `8de5f15` (on `feature/admin-analytics-dashboard`)  
**Portal Scope:** Factory Buyer Workspace (`Factory/`)  

---

## 1. Executive Summary

This initial audit assesses the current state of the Factory Buyer Portal within ASTANTRA (Industrial Spare Parts Procurement & Emergency Maintenance Platform). The Factory portal provides the commercial requisition interface where plant purchasing managers browse industrial spares, publish Requests for Quotation (RFQs), evaluate supplier price proposals, award purchase orders, log emergency machinery breakdown tickets, and schedule certified service engineers.

The existing implementation consists of **6 baseline ASPX pages** using a top-navigation layout (`MasterPages/Factory.Master`). While basic database connectivity via ADO.NET exists, the audit revealed several critical architecture and data-isolation defects, incomplete transactional workflows, unvalidated identity lookups, and the complete absence of equipment asset management, order detail inspection, and plant profile configuration.

---

## 2. Inventory of Existing Factory Pages

| File Path | Master Page | Code-Behind (Lines) | Current Status | Primary Vulnerability / Defect |
|:---|:---|:---:|:---:|:---|
| `Factory/Dashboard.aspx` | `~/MasterPages/Factory.Master` | 239 | Partial | `ResolveFactoryId` lacks robust fallback; no Chart.js visual telemetry; emergency tickets not scoped by factory. |
| `Factory/SpareParts/Search.aspx` | `~/MasterPages/Factory.Master` | 124 | Partial | Single-part RFQ creation only; lacks supplier lead-time comparison; unhandled missing factory profile. |
| `Factory/Quotations/MyRequests.aspx` | `~/MasterPages/Factory.Master` | 54 | Baseline | Raw GridView without pagination, search, or status pills; directly assumes `SessionHelper.UserId.Value`. |
| `Factory/Quotations/Compare.aspx` | `~/MasterPages/Factory.Master` | 92 | Defective | `acceptBidTransaction` updates quote status but **never inserts into `OrderItems`**; no concurrency guard. |
| `Factory/Orders/MyOrders.aspx` | `~/MasterPages/Factory.Master` | 49 | Baseline | High-level table only; clicking an order does nothing (no link to itemized invoice, PO, or tracking). |
| `Factory/Technicians/ServiceRequests.aspx` | `~/MasterPages/Factory.Master` | 94 | Partial | Lacks server-side technician eligibility verification; cannot filter by city/specialization dynamically. |

---

## 3. Master Page & Styling Audit (`MasterPages/Factory.Master`)

1. **Layout Paradigm Mismatch:**
   - `MasterPages/Admin.Master` utilizes an enterprise-grade dark sidebar with high-density navigation, brand telemetry, and smooth micro-animations.
   - `MasterPages/Factory.Master` uses an archaic top-bar navigation that does not scale well on mobile or medium desktop viewports.
2. **Missing Active Navigation Indication:**
   - Links in `Factory.Master` are static `<a href="..." class="site-nav-link">` elements without active-route awareness.
3. **No Responsive Drawer:**
   - Mobile users on factory shop-floor tablets or smartphones cannot access navigation links cleanly when viewport width drops below 768px.
4. **Identity & Role Display:**
   - Displays `SessionHelper.FullName` but lacks plant facility information, city, or status badge.

---

## 4. Backend Logic & Security Analysis

### 4.1 Factory Identity Resolution (`Factory/Dashboard.aspx.cs`)
- **Finding:** The page defines a local `ResolveFactoryId(int? userId)` method, whereas other pages (`MyOrders.aspx.cs`, `Search.aspx.cs`, `Compare.aspx.cs`) call `_userLogic.resolveFactoryId(SessionHelper.UserId.Value)` directly without null checks.
- **Risk:** If a logged-in user has their session expire or lacks a matching record in `Factories`, all secondary pages crash with unhandled `InvalidOperationException`.
- **Remediation:** Introduce a centralized `FactoryBasePage : BasePage` that securely resolves `CurrentFactoryId` on `OnInit`. If identity fails, the user is safely redirected with an actionable error.

### 4.2 Concurrency & Quotation Acceptance Defect (`QuotationLogic.cs`)
- **Finding:** In `acceptBidTransaction()`:
  ```csharp
  // Updates quote to 'Accepted' and RFQ to 'Closed', then inserts into Orders:
  INSERT INTO Orders (OrderNumber, FactoryId, SupplierId, TotalAmount, OrderStatus, IsEmergency, OrderDate) ...
  ```
  **Critical Defect:** It **NEVER** inserts the purchased spare part into `OrderItems`! The generated order is completely empty of line items.
- **Concurrency Defect:** The method does not check if the RFQ is already 'Closed' inside the transaction (`WHERE Status = 'Pending' OR Status = 'Quoted'`). Concurrent double-clicks generate duplicate purchase orders.
- **Remediation:** Upgrade `acceptBidTransaction` to atomically insert the item into `OrderItems` and return the newly generated `OrderId` and `OrderNumber`.

### 4.3 Cross-Tenant Emergency Ticket Isolation (`EmergencyRequests`)
- **Finding:** In `Factory/Dashboard.aspx.cs`, `LoadEmergencyRequests()` historically called a query that lacked factory scoping. While `selectOpenEmergenciesByFactory(factoryId)` was recently introduced, `Public/Emergency.aspx` and other parts of the platform need verified tenant scoping.

### 4.4 Service Request Technician Validation (`ServiceLogic.cs`)
- **Finding:** `insertServiceRequest()` does not verify whether `TechnicianId` refers to an active, verified technician who is marked `IsAvailable = 1`. A malicious user could forge a postback to book an inactive technician.
- **Remediation:** Enforce server-side eligibility check prior to scheduling.

---

## 5. Database Schema & Required Migrations

### 5.1 The Equipment Asset Gap: Shared Catalog vs. Factory Assets
- In `IndustrialSparePartDB`, the `Machines` table stores master equipment models (e.g., `CNC Lathe Machine X200`, `Hydraulic Stamping Press 500T`).
- **Deficiency:** A factory buyer owns specific physical machines on their plant floor with unique serial numbers, internal asset tags (e.g., `MCH-PLT1-CNC-04`), installation dates, and maintenance locations.
- **Migration 04:** Create `FactoryMachines` table:
  - `FactoryMachineId` (PK, INT IDENTITY)
  - `FactoryId` (FK to `Factories`)
  - `MachineId` (FK to `Machines`)
  - `AssetTag` (NVARCHAR(50), NOT NULL)
  - `SerialNumber` (NVARCHAR(100))
  - `Department` (NVARCHAR(100))
  - `InstalledDate` (DATE)
  - `Status` (VARCHAR(20) - 'Operational', 'Under Maintenance', 'Offline')
  - `Notes` (NVARCHAR(MAX))
  - `CreatedAt` & `UpdatedAt` (DATETIME)

---

## 6. Missing Pages Required for Full Phase 3 Scope

1. **`Factory/Machines/MyMachinery.aspx`**:
   - Management register for factory-owned machinery assets.
   - Add/edit physical machine assets, view asset tags, filter by operational status.
2. **`Factory/Orders/OrderDetails.aspx`**:
   - Deep inspection of awarded purchase order: itemized parts, quantity, unit price, courier tracking number, supplier contact, and printable A4 purchase order voucher.
3. **`Factory/Profile/PlantProfile.aspx`**:
   - Factory company profile management: company name, industry type, registered plant address, GSTIN, primary contact person, contact phone, and delivery notes.

---

## 7. Action Plan & Execution Phasing

- [x] **Phase 0:** Codebase audit & documentation (`FACTORY_PORTAL_INITIAL_AUDIT.md`).
- [ ] **Phase 1:** Apply SQL Migration `04_Factory_Portal_Enhancements.sql` (`FactoryMachines` table, `ContactPhone` column).
- [ ] **Phase 2:** Build unified `FactoryBasePage` and harden `QuotationLogic`, `OrderLogic`, `ServiceLogic`.
- [ ] **Phase 3:** Redesign `MasterPages/Factory.Master` with modern industrial aesthetic and active navigation.
- [ ] **Phase 4:** Overhaul existing 6 pages (`Dashboard`, `Search`, `MyRequests`, `Compare`, `MyOrders`, `ServiceRequests`).
- [ ] **Phase 5:** Build 3 new pages (`MyMachinery.aspx`, `OrderDetails.aspx`, `PlantProfile.aspx`).
- [ ] **Phase 6:** Multi-account data isolation & end-to-end verification.
- [ ] **Phase 7:** Compile with MSBuild, verify HTTP 200, take screenshots, commit locally (no push).
