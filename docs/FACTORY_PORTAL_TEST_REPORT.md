# ASTANTRA — Factory Buyer Workspace: Test Report

**Phase**: Phase 3 (Factory Buyer Portal Completion)  
**Date**: November 2026  
**Test Suite**: Automated Multi-Tenant Suite & Playwright Browser Visual QA  
**Result**: 100% Pass Rate (9/9 Pages, Multi-Tenant Data Isolation, Playwright Verification)  

---

## 1. Test Scope & Environments

- **Application Server**: IIS Express (Port 51234)
- **Framework**: .NET Framework 4.8 / ASP.NET Web Forms
- **Database**: SQL Server LocalDB (`IndustrialSparePartDB`)
- **Automated Test Harness**: Standard Python `urllib` multi-tenant integration script (`scratch/test_factory_portal.py`)
- **Visual QA Engine**: Playwright MCP with real browser rendering

---

## 2. Test Execution Summary

### 2.1 Factory 1 (`factory@plant.com` / Gujarat Heavy Machinery Works Pvt Ltd)
| Route | Page Name | HTTP Code | Key Data Assertions | Status |
|---|---|---|---|---|
| `/Factory/Dashboard.aspx` | Command Center | **200 OK** | 5 KPI metrics, 4 Chart.js charts, recent orders | **PASSED** |
| `/Factory/SpareParts/Search.aspx` | Catalog Search | **200 OK** | Machine model filter, parts catalog, RFQ modal | **PASSED** |
| `/Factory/Quotations/MyRequests.aspx` | RFQ Ledger | **200 OK** | RFQ requisition list, supplier bid count | **PASSED** |
| `/Factory/Quotations/Compare.aspx?rfqId=1` | Bid Comparison | **200 OK** | Multi-vendor bids, pricing matrix, atomic order placement | **PASSED** |
| `/Factory/Orders/MyOrders.aspx` | Orders Log | **200 OK** | Order ORD-2026-0041, tracking status | **PASSED** |
| `/Factory/Orders/OrderDetails.aspx?orderId=1` | PO & Invoice | **200 OK** | Tax invoice, itemized parts, consignee GSTIN, print sheet | **PASSED** |
| `/Factory/Machines/MyMachinery.aspx` | Plant Machinery | **200 OK** | Fleet count 3, GHM-CNC-001, GHM-PRS-002, GHM-CMP-003 | **PASSED** |
| `/Factory/Technicians/ServiceRequests.aspx` | Field Engineers | **200 OK** | Technician dropdown, booking modal, ticket log | **PASSED** |
| `/Factory/Profile/PlantProfile.aspx` | Plant Profile | **200 OK** | Gujarat Heavy Machinery profile, Rajkot address | **PASSED** |

### 2.2 Factory 2 (`factory2@baroda-forge.com` / Baroda Precision Forging Works Ltd)
| Route | Page Name | HTTP Code | Key Data Assertions | Status |
|---|---|---|---|---|
| `/Factory/Dashboard.aspx` | Command Center | **200 OK** | Tenant badge FID-003, Baroda Precision identity | **PASSED** |
| `/Factory/Machines/MyMachinery.aspx` | Plant Machinery | **200 OK** | Fleet count 2, BPF-CNC-001, BPF-PRS-002; zero GHM machines | **PASSED** |
| `/Factory/Profile/PlantProfile.aspx` | Plant Profile | **200 OK** | Baroda Precision profile, Vadodara address; zero GHM profile | **PASSED** |
| `/Factory/Orders/OrderDetails.aspx?orderId=1` | Cross-Tenant PO | **200 OK** | "Purchase Order Not Found or Access Restricted" displayed | **PASSED** |
| `/Factory/Quotations/Compare.aspx?rfqId=1` | Cross-Tenant RFQ | **200 OK** | Zero competitor bids displayed / empty state | **PASSED** |

---

## 3. Visual QA & Multi-Breakpoint Inspection (Playwright)

Screenshots captured and visually verified:
1. `factory_dashboard.png`: Clean executive telemetry header, 5 KPI cards with status accents, 4 Chart.js charts with real SQL aggregates and honest empty states, quick action buttons, recent orders ledger.
2. `factory_machinery.png`: Modern asset fleet registry, KPI summary cards (Operational, Maintenance, Offline), asset tag badges (`GHM-CNC-001`), add asset modal with master machine model dropdown.
3. `factory_order_details.png`: Professional B2B tax invoice layout, consignee and supplier GSTIN blocks, itemized Bill of Materials with unit and total prices, waybill tracker card, printable A4 stylesheet.
4. `factory_plant_profile.png`: Clean corporate identity form, GSTIN verification field, 24/7 breakdown phone dispatch input, registered delivery address, tenant telemetry badge.

---

## 4. Conclusion
Phase 3 (Factory Buyer Portal) satisfies all architectural, functional, security, and design system requirements. Zero mock data is utilized; all operations execute against live SQL Server LocalDB database with strict tenant isolation.
