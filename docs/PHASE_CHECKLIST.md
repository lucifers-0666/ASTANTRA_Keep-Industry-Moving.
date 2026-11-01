# ASTANTRA — Master Phase & Development Checklist

**Project:** ASTANTRA — Keep Industry Moving  
**Stack:** ASP.NET Web Forms (.NET Framework 4.8, C# 7.3), Parameterized ADO.NET (Three-Tier Architecture), SQL Server LocalDB  
**Lead / Coordinator:** Zaid Amreliya  
**Architecture Method:** College Professor's Three-Tier Database Connectivity (`BaseLogic.cs` / `*Logic.cs` $\to$ `.aspx.cs` $\to$ `.aspx`)  

---

## 1. Page Inventory & Three-Tier Implementation Matrix

| # | Panel | Page Path | Code-Behind Tier | Logic Class Tier | Three-Tier Status |
|---|---|---|---|---|---|
| **01** | Public | `Default.aspx` | `Default.aspx.cs` | UI Navigation / Stat Display | **Completed** |
| **02** | Public | `Public/Parts.aspx` | `Public/Parts.aspx.cs` | `PartLogic.selectCatalog()` | **Completed** |
| **03** | Public | `Public/Suppliers.aspx` | `Public/Suppliers.aspx.cs` | `AdminLogic.selectPublicSuppliers()` | **Completed** |
| **04** | Public | `Public/Technicians.aspx` | `Public/Technicians.aspx.cs` | `ServiceLogic.selectAvailableTechnicians()` | **Completed** |
| **05** | Public | `Public/HowItWorks.aspx` | `Public/HowItWorks.aspx.cs` | Explanatory UI | **Completed** |
| **06** | Public | `Public/WhyUs.aspx` | `Public/WhyUs.aspx.cs` | Explanatory UI | **Completed** |
| **07** | Public | `Public/Emergency.aspx` | `Public/Emergency.aspx.cs` | `AdminLogic.insertEmergencyRequest()` | **Completed** |
| **08** | Auth | `Account/Login.aspx` | `Account/Login.aspx.cs` | `UserLogic.authenticateUser()` | **Completed** |
| **09** | Auth | `Account/Register.aspx` | `Account/Register.aspx.cs` | `UserLogic.insertUser()` + Profiles | **Completed** |
| **10** | Auth | `Account/Logout.aspx` | `Account/Logout.aspx.cs` | Session Teardown & Redirect | **Completed** |
| **11** | Auth | `Account/AccessDenied.aspx` | `Account/AccessDenied.aspx.cs` | Security Guard & Back Links | **Completed** |
| **12** | Factory | `Factory/Dashboard.aspx` | `Factory/Dashboard.aspx.cs` | `QuotationLogic.getFactoryDashboardMetrics()` | **Completed** |
| **13** | Factory | `Factory/SpareParts/Search.aspx` | `Factory/SpareParts/Search.aspx.cs` | `PartLogic.selectCatalog()`, `insertRfq()` | **Completed** |
| **14** | Factory | `Factory/Quotations/MyRequests.aspx` | `Factory/Quotations/MyRequests.aspx.cs` | `QuotationLogic.selectRfqsByFactory()` | **Completed** |
| **15** | Factory | `Factory/Quotations/Compare.aspx` | `Factory/Quotations/Compare.aspx.cs` | `QuotationLogic.acceptBidTransaction()` | **Completed** |
| **16** | Factory | `Factory/Orders/MyOrders.aspx` | `Factory/Orders/MyOrders.aspx.cs` | `OrderLogic.selectOrdersByFactory()` | **Completed** |
| **17** | Factory | `Factory/Technicians/ServiceRequests.aspx` | `Factory/Technicians/ServiceRequests.aspx.cs` | `ServiceLogic.selectRequestsByFactory()`, `insert()` | **Completed** |
| **18** | Supplier | `Supplier/Dashboard.aspx` | `Supplier/Dashboard.aspx.cs` | `InventoryLogic.getSupplierDashboardMetrics()` | **Completed** |
| **19** | Supplier | `Supplier/Inventory/ManageParts.aspx` | `Supplier/Inventory/ManageParts.aspx.cs` | `InventoryLogic.selectBySupplier()`, `insertInventory()` | **Completed** |
| **20** | Supplier | `Supplier/Quotations/IncomingRequests.aspx` | `Supplier/Quotations/IncomingRequests.aspx.cs` | `QuotationLogic.selectOpenRfqsForSupplier()`, `insertBid()` | **Completed** |
| **21** | Supplier | `Supplier/Orders/ManageOrders.aspx` | `Supplier/Orders/ManageOrders.aspx.cs` | `OrderLogic.selectOrdersBySupplier()`, `updateOrderStatus()` | **Completed** |
| **22** | Technician | `Technician/Dashboard.aspx` | `Technician/Dashboard.aspx.cs` | `ServiceLogic.getTechnicianDashboardMetrics()`, `updateTechnicianDutyStatus()` | **Completed** |
| **23** | Technician | `Technician/Requests/AssignedJobs.aspx` | `Technician/Requests/AssignedJobs.aspx.cs` | `ServiceLogic.selectAssignedJobs()`, `updateServiceStatus()` | **Completed** |
| **24** | Admin | `Admin/Dashboard.aspx` | `Admin/Dashboard.aspx.cs` | `AdminLogic.getSystemMetrics()` | **Completed** |
| **25** | Admin | `Admin/Users/ManageUsers.aspx` | `Admin/Users/ManageUsers.aspx.cs` | `UserLogic.selectAllUsers()`, `updateUserStatus()` | **Completed** |
| **26** | Admin | `Admin/Suppliers/Verification.aspx` | `Admin/Suppliers/Verification.aspx.cs` | `AdminLogic.selectPendingSuppliers()`, `verifySupplier()` | **Completed** |
| **27** | Admin | `Admin/Categories/ManageCategories.aspx` | `Admin/Categories/ManageCategories.aspx.cs` | `PartLogic.selectCategories()`, `insertCategory()`, `insertMachine()` | **Completed** |
| **28** | Admin | `Admin/SpareParts/ManageParts.aspx` | `Admin/SpareParts/ManageParts.aspx.cs` | `PartLogic.selectAllParts()`, `insertPart()` | **Completed** |
| **29** | Admin | `Admin/Orders/Oversight.aspx` | `Admin/Orders/Oversight.aspx.cs` | `AdminLogic.selectOpenEmergencies()`, `OrderLogic.selectAllOrders()` | **Completed** |

---

## 2. Three-Tier Logic Layer Manifest (`App_Code/Logic/`)

1. **`BaseLogic.cs`**: Connection string management and professor's `getcon()` implementation.
2. **`UserLogic.cs`**: User authentication, password verification, registration, profile creation, status toggles, user listing, role ID resolution.
3. **`PartLogic.cs`**: Parts catalog search, category/machine filters, category management, machine registration, master part addition.
4. **`InventoryLogic.cs`**: Supplier warehouse inventory retrieval, stock quantity & unit price insertion/updates, inventory item deletion, supplier metrics.
5. **`QuotationLogic.cs`**: RFQ issuance, RFQ listing, incoming supplier RFQs, bid submission, quotation comparison, atomic bid acceptance (`SqlTransaction`).
6. **`OrderLogic.cs`**: Factory orders tracking, supplier fulfillment orders, waybill tracking number updates, system-wide order audit.
7. **`ServiceLogic.cs`**: Technician availability catalog, service request dispatch, assigned jobs, diagnosis recording, duty status toggle.
8. **`AdminLogic.cs`**: Supplier verification transaction (`SqlTransaction`), public supplier listings, SOS emergency alerts, executive dashboard metrics.

---

## 3. Build & Compilation Status

- **Compiler**: Visual Studio Roslyn MSBuild (`C# 7.3`, `.NET Framework 4.8`)
- **Compilation Output**: **Build succeeded, 0 Warning(s), 0 Error(s)**
- **Code-Behind Inline SQL Audit**: **0 inline queries** across all `.aspx.cs` files in the repository.
