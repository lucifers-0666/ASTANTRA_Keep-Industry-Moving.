# ASTANTRA — Factory Buyer Workspace: Security & Tenant Isolation Audit

**Phase**: Phase 3 (Factory Buyer Portal Completion)  
**Security Level**: Enterprise B2B Governance  
**Audit Status**: Verified & Passed (100%)  

---

## 1. Threat Model & Security Posture

In a multi-tenant B2B industrial procurement network, cross-tenant data leakage or quotation tampering poses extreme risks:
- Competitor factories might snoop on confidential RFQs, pricing discounts, or breakdown frequency.
- Malicious users might accept unauthorized bids, view sensitive tax GSTIN records, or tamper with shipping coordinates.

---

## 2. Security Controls & Architectural Verification

### 2.1 Server-Side Identity Resolution (`FactoryBasePage`)
- **Vulnerability Mitigated**: Insecure Direct Object References (IDOR), Parameter Tampering.
- **Implementation**: The base page for all factory views (`FactoryBasePage.cs`) extracts `SessionHelper.UserId` from the encrypted, signed ASP.NET session state. It queries `Factories.FactoryId` based strictly on `UserId`.
- **Finding**: Zero client-supplied factory identifiers are trusted. Any attempt to supply `?factoryId=X` in query strings or hidden inputs is ignored.

### 2.2 RFQ Commercial Bid Protection (`Compare.aspx`)
- **Vulnerability Mitigated**: Unauthorized Price Snooping / Cross-Tenant Bid Acceptance.
- **Implementation**:
  ```csharp
  DataRow rfq = _quotationLogic.getRfqById(rfqId, CurrentFactoryId);
  if (rfq == null) {
      Response.Redirect("~/Factory/Quotations/MyRequests.aspx", true);
      return;
  }
  ```
- **Test Evidence**: When Factory 2 (`factory2@baroda-forge.com`) requested `Compare.aspx?rfqId=1` (owned by Factory 1), the page immediately returned an empty bid set or redirected, preventing access to vendor bid matrices.

### 2.3 Purchase Order Confidentiality (`OrderDetails.aspx`)
- **Vulnerability Mitigated**: Cross-Tenant Purchase Order & B2B Tax Invoice Disclosure.
- **Implementation**:
  ```csharp
  DataRow order = _orderLogic.selectOrderDetailsByFactory(orderId, CurrentFactoryId);
  if (order == null) {
      pnlNotFound.Visible = true;
      pnlOrderInvoice.Visible = false;
      return;
  }
  ```
- **Test Evidence**: When Factory 2 requested `OrderDetails.aspx?orderId=1`, the system rendered the generic `Purchase Order Not Found or Access Restricted` view, leaking zero supplier details or pricing amounts.

### 2.4 Machinery Asset Access Control (`MyMachinery.aspx`)
- **Vulnerability Mitigated**: Industrial Espionage & Asset Fleet Snooping.
- **Implementation**: `FactoryMachineLogic.selectMachinesByFactory(CurrentFactoryId)` and `deleteMachine(id, CurrentFactoryId)`.
- **Test Evidence**: Factory 1 asset `GHM-CNC-001` was completely invisible to Factory 2, which only observed its own registered fleet `BPF-CNC-001`.

### 2.5 Field Service Technician Dispatch Hardening
- **Vulnerability Mitigated**: Booking Deactivated or Fraudulent Technicians.
- **Implementation**: `ServiceLogic.insertServiceRequest` executes a server-side check ensuring the technician is active (`IsActive = 1`) and available (`IsAvailable = 1`) before logging the ticket.

---

## 3. Automated Security Test Results Matrix

| Test ID | Objective | Input / Action | Expected Result | Status |
|---|---|---|---|---|
| **SEC-T01** | Cross-tenant order inspection | Factory 2 queries `OrderDetails.aspx?orderId=1` | Access restricted panel; no invoice data | **PASSED** |
| **SEC-T02** | Cross-tenant RFQ bid inspection | Factory 2 queries `Compare.aspx?rfqId=1` | Empty bid list / redirect; zero competitor prices | **PASSED** |
| **SEC-T03** | Fleet asset isolation | Factory 1 & 2 query `MyMachinery.aspx` | Each factory sees only its own assets | **PASSED** |
| **SEC-T04** | Profile isolation | Factory 1 & 2 query `PlantProfile.aspx` | Each factory sees only its own GSTIN/address | **PASSED** |
| **SEC-T05** | Unauthorized role access | Unauthenticated / Supplier user queries `/Factory/*` | Redirected to `Login.aspx` or `AccessDenied.aspx` | **PASSED** |
