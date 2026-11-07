# ASTANTRA — Factory Buyer Workspace: Functional Specification

**Phase**: Phase 3 (Factory Buyer Portal Completion)  
**Author**: Antigravity Principal Engineering Agent  
**Date**: November 2026  
**Target Audience**: MCA Viva Examiners, System Architects, B2B Procurement Operations  

---

## 1. Executive Summary & Domain Scope

In ASTANTRA, manufacturing plants operate continuous production lines where mechanical breakdowns, hydraulic seal failures, and CNC spindle outages cause catastrophic assembly downtime. 

The **Factory Buyer Workspace** provides plant procurement directors, shop floor supervisors, and maintenance managers with a unified, tenant-isolated operational portal to:
1. **Source Spare Parts & Dispatch Commercial RFQs**: Search verified multi-vendor catalogs and request competitive price quotations.
2. **Execute Commercial Bid Comparisons**: Review vendor bids side-by-side (quoted unit price, delivery lead time, warranty terms) and accept quotes through an atomic SQL transaction that simultaneously creates purchase orders and itemized line items.
3. **Inspect Purchase Orders & B2B Invoices**: Access itemized purchase orders with GST calculations, registered consignment delivery coordinates, courier waybill tracking, and A4 printable sheets.
4. **Manage Plant Machinery Fleets**: Register shop-floor machinery assets (CNC mills, hydraulic presses, compressors) with department assignments, serial numbers, and live operational statuses.
5. **Book Field Maintenance Technicians**: Dispatch certified specialist engineers for breakdown repair, machine overhaul, and parts installation.
6. **Maintain Plant Facility Master Records**: Manage corporate GSTIN, legal registration, physical gates, and 24/7 emergency dispatch telephone numbers.

---

## 2. Information Architecture & Navigation

The Factory Buyer Workspace comprises 9 integrated Web Forms pages governed by `MasterPages/Factory.Master` and `App_Code/Helpers/FactoryBasePage.cs`:

| # | Route | Purpose | Key Server Controls & Tables |
|---|---|---|---|
| 1 | `Factory/Dashboard.aspx` | Command Telemetry Center | 5 KPI metrics, 4 Chart.js telemetry charts, quick RFQ modal, recent PO ledger, active emergencies. |
| 2 | `Factory/SpareParts/Search.aspx` | Multi-Vendor Parts Catalog | Category/machine model filter, search bar, RFQ creation modal with server-side validation. |
| 3 | `Factory/Quotations/MyRequests.aspx` | RFQ Requisition Ledger | Status filter (`Pending`, `Quoted`, `Closed`), multi-vendor bid count badges, routing to bid comparison. |
| 4 | `Factory/Quotations/Compare.aspx` | Commercial Bid Evaluation | RFQ specification summary, side-by-side supplier bidding cards, atomic quote acceptance button. |
| 5 | `Factory/Orders/MyOrders.aspx` | Purchase Order Logbook | Status filter (`All`, `Pending`, `Shipped`, `Delivered`), total amount formatting, direct link to invoice. |
| 6 | `Factory/Orders/OrderDetails.aspx` | Itemized PO & Tax Invoice | B2B tax invoice view, buyer/supplier GSTIN cards, `OrderItems` table, waybill tracking, `@media print` A4. |
| 7 | `Factory/Machines/MyMachinery.aspx` | Plant Machinery Fleet | Fleet KPI metrics, status filters, machinery asset register, add/edit asset modal with master machine binding. |
| 8 | `Factory/Technicians/ServiceRequests.aspx` | Field Engineer Dispatch | Verified technician selector, service category dropdown, visit date picker, status tracker. |
| 9 | `Factory/Profile/PlantProfile.aspx` | Plant Profile & Tax Master | Legal entity name, GSTIN, primary procurement officer, 24/7 emergency phone, physical delivery address. |

---

## 3. Workflow Specifications

### 3.1 RFQ to Purchase Order Atomic Conversion Workflow
1. Factory buyer searches catalog or creates RFQ from `Search.aspx` or `Dashboard.aspx`.
2. RFQ status defaults to `Pending`.
3. Suppliers submit bids via the Supplier Portal (`QuotationLogic.insertQuotationBid`). RFQ status transitions to `Quoted`.
4. Buyer reviews bids on `Compare.aspx`.
5. Upon clicking **"Accept Bid & Place Order"**, `QuotationLogic.acceptBidTransaction`:
   - Validates that RFQ belongs strictly to the authenticated `FactoryId`.
   - Validates that RFQ status is `Pending` or `Quoted`.
   - Atomically within an ADO.NET SQL transaction:
     - Sets winning quote status to `Accepted`.
     - Rejects all competing quotes on that RFQ (`Status = 'Rejected'`).
     - Closes RFQ (`Status = 'Closed'`).
     - Inserts record into `Orders` (`OrderStatus = 'Pending'`, `OrderNumber = 'PO-{D5}'`).
     - Inserts line item into `OrderItems` (`PartId`, `Quantity`, `UnitPrice`, `TotalPrice`).
6. Buyer is redirected to `OrderDetails.aspx?orderId={newOrderId}&created=true`.

### 3.2 Machinery Asset Registration & Emergency Tagging
1. Buyer navigates to `Factory/Machines/MyMachinery.aspx`.
2. Registers plant equipment (e.g. `GHM-CNC-001`, Mazak VTC-800, CNC Bay 1).
3. System verifies asset tag uniqueness per factory (`UQ_FactoryMachines_Factory_AssetTag`).
4. Breakdown counts reflect real-time occurrences from `EmergencyRequests` table.

---

## 4. Multi-Tenant Architectural Enforcement

1. **`FactoryBasePage`**:
   - All factory code-behind files derive from `FactoryBasePage`.
   - In `OnInit`, verifies session authentication and role (`RoleConstants.Factory`).
   - Resolves `CurrentFactoryId` securely using `SessionHelper.UserId`.
   - Any query string, hidden field, or user input attempting to provide a different `factoryId` is completely ignored.
2. **Database Scoping**:
   - Every read query includes `WHERE FactoryId = @FactoryId`.
   - Every write/update query includes `WHERE ... AND FactoryId = @FactoryId`.
   - Cross-tenant requests to `OrderDetails.aspx` or `Compare.aspx` return clean 404 / access restricted states without leaking metadata.
