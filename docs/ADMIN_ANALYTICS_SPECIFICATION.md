# ASTANTRA Platform — Administrator Analytics & Telemetry Specification

**Document Version:** 1.0.0  
**Target Environment:** ASP.NET Web Forms (.NET Framework 4.8, C# 7.3)  
**Database Catalog:** SQL Server LocalDB (`IndustrialSparePartDB`)  
**Data Access Layer:** Parameterized ADO.NET (`AdminAnalyticsLogic.cs`)  
**Visualization Engine:** Chart.js 4.4.4 (UMD Bundle, Local Pinned: `Content/lib/chartjs/chart.umd.min.js`)

---

## 1. Executive Analytics Architecture

The ASTANTRA Administrator Dashboard is powered by a dedicated three-tier data analytics service (`App_Code/Logic/AdminAnalyticsLogic.cs`). This layer computes real-time operational aggregates directly from relational SQL tables, enforcing parameterized date boundaries without fabricating synthetic records.

```
┌─────────────────────────────────────────────────────────────┐
│                 Presentation Tier (ASPX)                    │
│   Admin/Dashboard.aspx & Code-Behind (Dashboard.aspx.cs)    │
│  - Filter Pills (7d, 30d, 90d, All Time)                    │
│  - Chart.js Canvas Renderers & Accessible Data Tables       │
└──────────────────────────────▲──────────────────────────────┘
                               │ Strongly-Typed DTO / JSON Serialization
┌──────────────────────────────┴──────────────────────────────┐
│                  Business Analytics Layer                   │
│             App_Code/Logic/AdminAnalyticsLogic.cs           │
│  - Parameterized aggregation methods                        │
│  - Explicit financial metrics separation                    │
│  - SLA latency calculations                                 │
└──────────────────────────────▲──────────────────────────────┘
                               │ Parameterized ADO.NET (SqlCommand)
┌──────────────────────────────┴──────────────────────────────┐
│                     Relational Database                     │
│         SQL Server LocalDB (IndustrialSparePartDB)          │
│  - Orders, OrderItems, RFQs, Quotations, EmergencyRequests │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. KPI Definitions & Accounting Rules

To prevent misleading vanity statistics, financial and operational metrics follow strict accounting definitions:

### A. Gross Order Value (GMV)
- **Definition:** Total monetary commitment contracted across all non-cancelled purchase orders in the selected timeframe.
- **SQL Formula:**
  $$\text{Gross Order Value} = \sum_{\text{Orders}} \text{TotalAmount} \quad \text{WHERE} \quad \text{OrderStatus} \neq \text{'Cancelled'}$$
- **Rationale:** Captures pipeline transaction commitments while excluding voided/cancelled contracts.

### B. Realized Revenue (Completed Turnover)
- **Definition:** Actual realized platform volume strictly for completed/delivered orders.
- **SQL Formula:**
  $$\text{Realized Revenue} = \sum_{\text{Orders}} \text{TotalAmount} \quad \text{WHERE} \quad \text{OrderStatus} = \text{'Delivered'}$$
- **Rationale:** Pending or in-transit consignments are not counted as earned platform revenue until delivery is verified. Cancelled orders are strictly excluded ($0.00$).

### C. RFQ Conversion Rate
- **Definition:** The percentage of commercial RFQs published by factories that successfully received and accepted supplier quotation bids.
- **Formula:**
  $$\text{Conversion Rate} = \left( \frac{\text{Count of RFQs with Accepted Bid}}{\text{Total RFQs Created in Timeframe}} \right) \times 100\%$$
- **Precision:** Formatted to 1 decimal place (e.g. `25.0%`).

### D. Delayed Orders (SLA Breach Risk)
- **Definition:** Open purchase orders (`Pending`, `Processing`, or `Dispatched`) exceeding a 3-day fulfillment threshold from creation date.
- **SQL Condition:**
  $$\text{OrderStatus} \in (\text{'Pending'}, \text{'Processing'}, \text{'Dispatched'}) \quad \text{AND} \quad \text{DATEDIFF}(\text{day}, \text{OrderDate}, \text{GETDATE}()) > 3$$

---

## 3. Data Methods in `AdminAnalyticsLogic.cs`

| # | Method Signature | Primary Data Source | Grouping / Aggregation | Output Type |
|:---:|:---|:---|:---|:---|
| 1 | `getExecutiveMetrics(...)` | `Users`, `Suppliers`, `Factories`, `Technicians`, `EmergencyRequests`, `Orders`, `QuotationRequests` | Scalar subqueries | `out` parameters |
| 2 | `getOrderCountsByStatus(start, end)` | `Orders` | `GROUP BY OrderStatus` | `DataTable` |
| 3 | `getOrderVolumeAndValueOverTime(start, end)` | `Orders` | `GROUP BY CONVERT(varchar(10), OrderDate, 120)` | `DataTable` |
| 4 | `getUserRegistrationsOverTime(start, end)` | `Users` | `GROUP BY CONVERT(varchar(10), CreatedAt, 120)` | `DataTable` |
| 5 | `getUserDistributionByRole()` | `Roles` $\bowtie$ `Users` | `GROUP BY r.RoleId, r.RoleName` | `DataTable` |
| 6 | `getRfqConversionFunnel(start, end)` | `QuotationRequests` $\bowtie$ `QuotationResponses` $\bowtie$ `Orders` | 4-Stage Pipeline Funnel | `DataTable` |
| 7 | `getEmergenciesByPriorityAndStatus(start, end)` | `EmergencyRequests` | `GROUP BY PriorityLevel, Status` | `DataTable` |
| 8 | `getSupplierActivityAndInventoryCoverage()` | `Suppliers` $\bowtie$ `SupplierInventory` | `GROUP BY s.SupplierId, s.CompanyName` | `DataTable` |
| 9 | `getSparePartsByCategory()` | `Categories` $\bowtie$ `SpareParts` $\bowtie$ `SupplierInventory` | `GROUP BY c.CategoryId, c.CategoryName` | `DataTable` |
| 10 | `getDelayedAndPendingOrders(start, end)` | `Orders` $\bowtie$ `Factories` $\bowtie$ `Suppliers` | Open orders sorted by `DaysPending DESC` | `DataTable` |
| 11 | `getCriticalOperationalAlerts()` | `EmergencyRequests` $\cup$ `Suppliers` | Critical SOS + Unverified Suppliers | `DataTable` |

---

## 4. Visualizations & Chart.js Implementation

### Library Details
- **Engine:** Chart.js 4.4.4 UMD
- **Location:** `Content/lib/chartjs/chart.umd.min.js` (205 KB, Local Pinned Asset)
- **Serialization:** Safe server-to-client delivery using `System.Web.Script.Serialization.JavaScriptSerializer` via `<asp:HiddenField ID="hdnChartData">`. No SQL queries in clientside scripts or HTML.

### Chart Grid Specifications

1. **Procurement & Transaction Activity (Dual-Axis Combination Chart):**
   - Left Axis (Linear): Gross Value (₹) & Realized Revenue (₹) as smoothed lines (`#10B981` / `#059669`).
   - Right Axis (Linear): Order Volume Counts as vertical bar chart (`#1769E0`).
   - Fallback: HTML table in `<details>` disclosure summary for accessibility and screen readers.

2. **Order Status Distribution (Horizontal Bar Chart):**
   - Stages: Pending (`#F59E0B`), Processing (`#6366F1`), Dispatched (`#06B6D4`), Delivered (`#10B981`), Cancelled (`#EF4444`).

3. **Ecosystem Role Share (Doughnut Chart):**
   - Cutout: 65% with center summary.
   - Slices: Factory (`#059669`), Supplier (`#0891B2`), Technician (`#475569`), Administrator (`#1769E0`).

4. **Emergency Priority Breakdown (Bar Chart):**
   - Severity Bands: Critical (`#DC2626`), High (`#EA580C`), Medium (`#F59E0B`), Low (`#3B82F6`).

5. **Commercial RFQ Conversion Funnel (Horizontal Stage Chart):**
   - Stages: 1. RFQs Created $\rightarrow$ 2. Bids Received $\rightarrow$ 3. Quotes Accepted $\rightarrow$ 4. Orders Placed.
   - Tooltip: Computes percentage conversion from top-of-funnel requisitions.

### PostBack & DOM Lifecycle
- **Clean Instance Destruction:** Before rendering new canvas charts, existing instances are closed via `chartInstances[key].destroy()` to eliminate memory leaks.
- **Partial PostBack Compatibility:** Listens to `Sys.WebForms.PageRequestManager.getInstance().add_endRequest(...)` for asynchronous update triggers.

---

## 5. Assessment of Phase 6 Additional Modules

### 1. Admin Notification Center
- **Status:** Database table `Notifications` already exists in `IndustrialSparePartDB`.
- **Existing Coverage:** High-priority alerts are actively surfaced on `Admin/Dashboard.aspx` via `rptOperationalAlerts`.
- **Architecture Plan:** When authorized, a dedicated `Admin/System/Notifications.aspx` view will provide broadcast dispatch across roles and individual notification mark-as-read tracking.

### 2. Reports & Analytics Export
- **Status:** Dashboard currently generates real-time telemetry with accessible table fallbacks.
- **Architecture Plan:** Dedicated CSV/Excel export handlers (`ExportCsv.ashx`) utilizing `AdminAnalyticsLogic` datasets for downloadable audit documentation.

### 3. Advanced Access Management (RBAC)
- **Status:** **Fully Implemented & Operational**.
- **Coverage:** `Admin/RBAC/Roles.aspx` provides dynamic clearance assignment across 18 granular permissions (Migration 03). `BasePage.cs` intercepts requests and enforces server-side role clearances.

### 4. Backup & Recovery
- **Status:** Database integrity audit and reconciliation implemented in `Admin/System/DataIntegrity.aspx`.
- **Architecture Plan:** In a LocalDB environment, scripted backup procedures (`BACKUP DATABASE IndustrialSparePartDB TO DISK = ...`) should be managed via automated administrative batch scripts rather than raw web interface execution for security isolation.

