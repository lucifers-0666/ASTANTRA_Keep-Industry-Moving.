# ASTANTRA — Backend Architecture Audit & Three-Tier Refactoring Plan
**Target Standard:** Final-Year MCA Academic Viva & Professor's Three-Tier Method  
**Lead / Coordinator:** Zaid Amreliya  
**Mode:** AUDIT & PLANNING ONLY (No backend code modified)  

---

## 1. Analysis of Professor's Reference Project (`3T_MCA` / `_3tira`)

An inspection of the reference implementation (`E:\Asp.net\PB_PR\3tira\3tira\`) was conducted across:
- **Presentation Layer**: `emplyoee.aspx`
- **Code-Behind Layer**: `emplyoee.aspx.cs`
- **Database / Logic Layer**: `Class1.cs`
- **Configuration**: `Web.config`

### Architecture & Mechanisms of the Reference Project:
1. **Connection Initialization (`getcon()`)**:
   - In `Web.config`: `<connectionStrings><add name="db" connectionString="..."/></connectionStrings>`
   - In `Class1.cs`:
     ```csharp
     string s = ConfigurationManager.ConnectionStrings["db"].ConnectionString;
     SqlConnection con;
     SqlCommand cmd;
     DataSet ds;
     SqlDataAdapter da;

     public SqlConnection getcon()
     {
         con = new SqlConnection(s);
         con.Open();
         return con;
     }
     ```
2. **Page Interaction (`emplyoee.aspx.cs`)**:
   - The code-behind creates a single instance: `Class1 cs = new Class1();`
   - In `Page_Load`: Calls `cs.getcon()` via a helper `startcon()`, then on `!IsPostBack` binds GridView:
     ```csharp
     void fillgrid()
     {
         startcon();
         GridView1.DataSource = cs.select();
         GridView1.DataBind();
     }
     ```
3. **Data Operations & ViewState State-Tracking**:
   - **Insert / Update**: Form uses a single button `btnsav`. When `btnsav.Text == "save"`, it invokes `cs.insert(...)`. When in update mode (`btnsav.Text == "update"`), it invokes `cs.update(Convert.ToInt32(ViewState["id"]), ...)`.
   - **RowCommand Routing**: The GridView handles `OnRowCommand="GridView1_RowCommand"`:
     - `cmd_edt`: Reads `e.CommandArgument`, sets `ViewState["id"] = id`, changes `btnsav.Text = "update"`, calls `cs.Selectid(id)` and populates form controls from `ds.Tables[0].Rows[0]`.
     - `cmd_dlt`: Calls `cs.delete(id)` and immediately re-binds with `fillgrid()`.

### Academic Strengths of the Professor's Approach:
- **Zero Magic / Highly Explainable**: No complex ORMs, reflection, or IoC containers. Every step (Button Click $\to$ Event Handler $\to$ Logic Method $\to$ SQL Command $\to$ GridView DataBind) is transparent and easy to trace in viva.
- **Direct Dataset Binding**: GridViews and Repeaters consume raw `DataSet` / `DataTable` directly without needing DTO conversions.

### Critical Safety Vulnerabilities in the Raw Reference (To Be Corrected):
1. **SQL Injection**: The reference uses string concatenation (`"where Email='" + eml + "'"`). In ASTANTRA, we must retain the professor's exact method signatures (`insert`, `select`, etc.) but use **parameterized `SqlCommand`** (`cmd.Parameters.AddWithValue` or `cmd.Parameters.Add`).
2. **Connection Leaks**: `con.Open()` is called repeatedly without `con.Close()`, quickly exhausting the database connection pool. In ASTANTRA, each logic method must close the connection (`con.Close()` or `using (con)`).

---

## 2. Report A: Existing Architecture Report

### Current ASTANTRA Architecture:
ASTANTRA currently suffers from **architectural fragmentation**:

```
[CURRENT HYBRID STATE]
├── 1. Account / Auth Module:
│    └── Uses an enterprise Repository pattern:
│         IUserRepository -> UserRepository -> DbFactory (Static) -> SQL Server
│         IAuthService -> AuthService -> SessionHelper
│
├── 2. Factory & Admin Pages:
│    └── Embeds raw ADO.NET SQL queries directly inside .aspx.cs event handlers!
│         Factory/Dashboard.aspx.cs -> DbFactory.ExecuteQuery("SELECT ...")
│         Admin/Users/ManageUsers.aspx.cs -> DbFactory.ExecuteNonQuery("UPDATE ...")
│
└── 3. Public Pages:
     └── Direct inline SQL queries with in-memory fallback mock lists.
```

### Why This Needs Refactoring to the Professor's Method:
1. **Viva Defense Friction**: Having `IUserRepository`, `IAuthService`, and dependency inversion interfaces is often questioned by examiners who expect the standard MCA syllabus Three-Tier Architecture (`Presentation -> Code-Behind -> Logic Class`).
2. **Scattered Database Queries**: SQL statements are duplicated across code-behind files. A change in column names requires editing dozens of `.aspx.cs` files rather than one central logic class.
3. **No Separation of Concerns**: Page code-behind files are doing UI formatting, parameter extraction, and direct SQL execution all in the same event handlers.

---

## 3. Report B: Complete Page-to-Database Mapping

| # | Page Path | Role | Existing Code-Behind Mechanism | Existing Logic Class | Database Tables Involved | Required Database Operations | Status |
|---|---|---|---|---|---|---|---|
| **01** | `Default.aspx` | Public | None (Static HTML/CSS) | None | `Categories`, `SpareParts` | `SELECT` top categories & parts count | Working |
| **02** | `Public/Parts.aspx` | Public | Inline SQL via `DbFactory` + Mock Fallback | None | `SpareParts`, `Categories`, `Machines`, `SupplierInventory` | `SELECT` with search keywords and category filters | Working |
| **03** | `Public/Suppliers.aspx` | Public | Inline SQL via `DbFactory` + Mock Fallback | None | `Suppliers`, `Users` | `SELECT` verified suppliers by city | Working |
| **04** | `Public/Technicians.aspx` | Public | Inline SQL via `DbFactory` + Mock Fallback | None | `Technicians`, `Users` | `SELECT` available technicians by skill/city | Working |
| **05** | `Public/Emergency.aspx` | Public | Form validation, redirects to Auth/Dashboard | None | `EmergencyRequests` (Indirect) | Validation & navigation routing | Working |
| **06** | `Public/HowItWorks.aspx` | Public | Static view rendering | None | None | None | Working |
| **07** | `Public/WhyUs.aspx` | Public | Static view rendering | None | None | None | Working |
| **08** | `Account/Login.aspx` | All | Calls `AuthService.Login()` | `AuthService`, `UserRepository` | `Users`, `Roles` | `SELECT` by email, verify password hash | Working |
| **09** | `Account/Register.aspx` | All | Calls `AuthService.Register*()` | `AuthService`, `UserRepository` | `Users`, `Factories`, `Suppliers`, `Technicians` | `INSERT` user + role profile record | Working |
| **10** | `Account/Logout.aspx` | All | Clears `SessionHelper` & FormsAuth | None | None | Session teardown | Working |
| **11** | `Account/AccessDenied.aspx`| All | Static HTTP 403 error display | None | None | None | Working |
| **12** | `Factory/Dashboard.aspx` | Factory | Direct SQL queries in `LoadDashboard` | None | `Factories`, `QuotationRequests`, `Orders`, `EmergencyRequests` | `SELECT` factory ID, aggregate KPI counts | Working |
| **13** | `Factory/SpareParts/Search.aspx` | Factory | Direct SQL queries in `LoadParts`, `btnSubmitModalRfq` | None | `SpareParts`, `Categories`, `Machines`, `QuotationRequests` | `SELECT` catalog filter, `INSERT` into `QuotationRequests` | Working |
| **14** | `Factory/Quotations/MyRequests.aspx` | Factory | Direct SQL in `LoadRequests` | None | `QuotationRequests`, `SpareParts`, `QuotationResponses` | `SELECT` RFQs with bid counts, status filter | Working |
| **15** | `Factory/Quotations/Compare.aspx` | Factory | Direct SQL `SqlTransaction` in `gvBids_RowCommand` | None | `QuotationRequests`, `QuotationResponses`, `Suppliers`, `Orders` | `SELECT` bids, `UPDATE` RFQ/bid status, `INSERT` into `Orders` | Working |
| **16** | `Factory/Orders/MyOrders.aspx` | Factory | Direct SQL in `LoadOrders` | None | `Orders`, `Suppliers` | `SELECT` orders with tracking #, status filter | Working |
| **17** | `Factory/Technicians/ServiceRequests.aspx` | Factory | Direct SQL in `LoadServices`, `btnSubmitServiceRequest` | None | `Technicians`, `Users`, `ServiceRequests` | `SELECT` available technicians, `INSERT` service ticket | Working |
| **18** | `Supplier/Dashboard.aspx` | Supplier | Session display only | None | `SupplierInventory`, `QuotationRequests`, `Orders` | `SELECT` pending RFQs count, low stock count | Working (UI) |
| **19** | `Supplier/Inventory/ManageParts.aspx` | Supplier | Not implemented | None | `SupplierInventory`, `SpareParts`, `Categories` | `SELECT`, `INSERT`, `UPDATE`, `DELETE` inventory items | Not started |
| **20** | `Supplier/Quotations/IncomingRequests.aspx` | Supplier | Not implemented | None | `QuotationRequests`, `SpareParts`, `Factories` | `SELECT` open RFQs matching supplier category | Not started |
| **21** | `Supplier/Quotations/SubmitQuotation.aspx` | Supplier | Not implemented | None | `QuotationResponses`, `QuotationRequests` | `INSERT` quotation bid (unit price, lead time) | Not started |
| **22** | `Supplier/Orders/ManageOrders.aspx` | Supplier | Not implemented | None | `Orders`, `Factories` | `SELECT` orders, `UPDATE` order status & tracking # | Not started |
| **23** | `Technician/Dashboard.aspx` | Technician | Session display only | None | `ServiceRequests`, `Technicians` | `SELECT` assigned jobs count, `UPDATE` duty status | Working (UI) |
| **24** | `Technician/Requests/AssignedJobs.aspx` | Technician | Not implemented | None | `ServiceRequests`, `Factories` | `SELECT` jobs assigned to technician | Not started |
| **25** | `Technician/Requests/JobDetails.aspx` | Technician | Not implemented | None | `ServiceRequests`, `Factories`, `Machines` | `SELECT` single job by ID with factory address | Not started |
| **26** | `Technician/Services/UpdateStatus.aspx`| Technician | Not implemented | None | `ServiceRequests` | `UPDATE` service status (`Accepted`, `Completed`) | Not started |
| **27** | `Admin/Dashboard.aspx` | Admin | Calls `_userRepository.GetAllUsersWithRoles()` | `UserRepository` | `Users`, `Roles`, `Orders`, `EmergencyRequests` | `SELECT` total counts across system | Working |
| **28** | `Admin/Users/ManageUsers.aspx` | Admin | Direct SQL `UPDATE Users SET IsActive` | None | `Users`, `Roles` | `SELECT` all users, `UPDATE` `IsActive` flag | Working |
| **29** | `Admin/Suppliers/Verification.aspx` | Admin | Direct SQL `SqlTransaction` approve/reject | None | `Suppliers`, `Users` | `SELECT` pending vendors, `UPDATE` verification status | Working |
| **30** | `Admin/Categories/ManageCategories.aspx` | Admin | Direct SQL `INSERT Categories` / `Machines` | None | `Categories`, `Machines` | `SELECT`, `INSERT` category & machine records | Working |
| **31** | `Admin/SpareParts/ManageParts.aspx` | Admin | Direct SQL `INSERT SpareParts` | None | `SpareParts`, `Categories`, `Machines` | `SELECT`, `INSERT` master spare parts | Working |
| **32** | `Admin/Orders/Oversight.aspx` | Admin | Direct SQL queries in `LoadOversightData` | None | `EmergencyRequests`, `Orders`, `Factories`, `Suppliers` | `SELECT` open breakdown alerts and orders log | Working |

---

## 4. Report C: Three-Tier Mapping (Proposed Logic Classes)

To avoid class explosion while maintaining clear separation of responsibilities, the 15 database tables are mapped into **7 Clean, High-Cohesion Logic Classes** located in `App_Code/Logic/`:

| Proposed Logic Class | Responsibility | Related Pages | Database Tables Used | Existing Methods to Extract | Missing Methods to Implement |
|---|---|---|---|---|---|
| **`UserLogic.cs`** | User authentication, profile creation, password hash check, and account status toggling. | `Login.aspx`, `Register.aspx`, `ManageUsers.aspx`, `Dashboard.aspx` | `Users`, `Roles`, `Factories`, `Suppliers`, `Technicians` | `GetUserByEmail`, `CreateUser`, `CreateFactoryProfile`, `GetAllUsersWithRoles` | `login(email, pwd)`, `updateActiveStatus(id, isActive)`, `getUserById(id)` |
| **`PartLogic.cs`** | Master spare-parts catalog search, categories, and compatible machinery models. | `Parts.aspx` (Public), `Search.aspx` (Factory), `ManageParts.aspx`, `ManageCategories.aspx` | `SpareParts`, `Categories`, `Machines` | Extracted from `Parts.aspx.cs`, `Search.aspx.cs`, `ManageParts.aspx.cs` | `selectCatalog(keyword, catId, macId)`, `selectCategories()`, `selectMachines()`, `insertPart(...)`, `insertCategory(...)`, `insertMachine(...)` |
| **`InventoryLogic.cs`** | Supplier stock quantity, unit prices, lead times, and availability states. | `ManageParts.aspx` (Supplier), `Parts.aspx`, `Search.aspx` | `SupplierInventory`, `SpareParts` | None (New for Jay's Supplier workflow) | `selectBySupplier(supplierId)`, `insertInventory(...)`, `updateStock(...)`, `deleteInventory(id)` |
| **`QuotationLogic.cs`** | Buyer RFQs issuance, supplier bid submissions, and side-by-side quote comparisons. | `MyRequests.aspx`, `Compare.aspx`, `IncomingRequests.aspx`, `SubmitQuotation.aspx` | `QuotationRequests`, `QuotationResponses`, `SpareParts`, `Suppliers` | Extracted from `MyRequests.aspx.cs`, `Compare.aspx.cs` | `insertRfq(...)`, `selectRfqsByFactory(factoryId, status)`, `selectBidsByRfq(rfqId)`, `insertBid(...)`, `acceptBidTransaction(...)` |
| **`OrderLogic.cs`** | Purchase order tracking, supplier dispatch updates, and admin order oversight. | `MyOrders.aspx`, `ManageOrders.aspx`, `Oversight.aspx` | `Orders`, `Factories`, `Suppliers` | Extracted from `MyOrders.aspx.cs`, `Oversight.aspx.cs` | `selectOrdersByFactory(factoryId, status)`, `selectOrdersBySupplier(supplierId)`, `updateOrderStatus(orderId, status, trackingNo)`, `selectSystemOrders()` |
| **`ServiceLogic.cs`** | Field technician bookings, breakdown service requests, and maintenance logs. | `ServiceRequests.aspx` (Factory), `AssignedJobs.aspx`, `JobDetails.aspx`, `UpdateStatus.aspx` | `ServiceRequests`, `Technicians`, `Users`, `Factories` | Extracted from `ServiceRequests.aspx.cs` | `insertServiceRequest(...)`, `selectRequestsByFactory(factoryId)`, `selectAssignedJobs(technicianId)`, `selectJobById(id)`, `updateJobStatus(...)` |
| **`AdminLogic.cs`** | Platform-level governance, supplier GSTIN verification, emergency breakdown triage, and KPI stats. | `Admin/Dashboard.aspx`, `Verification.aspx`, `Oversight.aspx` | `Suppliers`, `Users`, `EmergencyRequests`, `Orders`, `Factories` | Extracted from `Verification.aspx.cs`, `Oversight.aspx.cs` | `selectPendingSuppliers(status)`, `verifySupplier(supplierId, userId, isApproved)`, `selectOpenEmergencies()`, `getSystemKpis()` |

---

## 5. Report D: Problems & Risks in Existing Code

| # | File Path | Method / Code Area | Problem | Why It Matters | Recommended Correction | Priority |
|---|---|---|---|---|---|---|
| 01 | `Factory/SpareParts/Search.aspx.cs` | `btnSubmitModalRfq_Click` | SQL query is hardcoded inside page event handler. | Violates Three-Tier architecture; cannot be reused by mobile or other pages. | Move `INSERT INTO QuotationRequests` into `QuotationLogic.insertRfq(...)`. | **High** |
| 02 | `Factory/Quotations/Compare.aspx.cs` | `ExecuteAcceptTransaction` | Multi-table SQL transaction logic is embedded in page code-behind. | If page fails during postback, transaction handling is mixed with presentation logic. | Move `ExecuteAcceptTransaction` into `QuotationLogic.acceptBid(...)`. | **High** |
| 03 | `Admin/Users/ManageUsers.aspx.cs` | `gvUsers_RowCommand` | Inline `UPDATE Users SET IsActive` in `.aspx.cs`. | Tight coupling of SQL to Web Forms GridView event. | Move to `UserLogic.updateStatus(userId, isActive)`. | **Medium** |
| 04 | `Admin/Suppliers/Verification.aspx.cs` | `gvSuppliers_RowCommand` | Inline `SqlTransaction` updating `Suppliers` and `Users` inside code-behind. | Page should only pass `supplierId` and `isApproved` to a logic class. | Move to `AdminLogic.verifySupplier(...)`. | **High** |
| 05 | `App_Code/Repositories/` & `App_Code/Services/` | Entire folder | Repository Pattern / Interface abstraction conflicts with professor's three-tier requirement. | Faculty examiner will question why enterprise patterns were used instead of the taught Three-Tier class structure. | Consolidate `UserRepository.cs` into `UserLogic.cs` following the `getcon()` / method pattern. | **High** |
| 06 | `Public/Parts.aspx.cs` | `LoadCatalog` | Inline SQL with `SqlParameter` list construction in `.aspx.cs`. | 100 lines of query building cluttering the page event. | Move catalog filtering to `PartLogic.selectCatalog(...)`. | **Medium** |
| 07 | `Factory/Technicians/ServiceRequests.aspx.cs` | `LoadTechniciansDropdown` | Direct SQL query inside dropdown loader. | Clutters presentation event. | Move to `ServiceLogic.selectAvailableTechnicians()`. | **Medium** |

---

## 6. Report E: Refactoring Plan

### 1. Existing Logic That Should Be Retained:
- **`PasswordHasher.cs`**: Cryptographic SHA-256 with 128-bit salt generation. Essential for college security compliance (passwords never stored in plain text).
- **`SessionHelper.cs`**: Strongly typed wrapper for `Session["UserId"]`, `Session["UserRole"]`, `Session["FullName"]`. Very clean and easy to explain.
- **`BasePage.cs`**: Enforces `RequiredRole` in `OnInit`. Prevents unauthorized URL manipulation without duplicating code in every page.
- **`RoleConstants.cs`**: String constants for roles (`Administrator`, `Factory`, `Supplier`, `Technician`).

### 2. Existing Logic That Needs Correction:
- Replace raw string-concatenated SQL queries in any reference code with parameterized `SqlCommand` (`@ParameterName`).
- Ensure all logic methods close connection via `con.Close()` or `using (con)`.

### 3. Logic That Should Be Moved Into Separate Logic Classes:
- Move database interaction out of `Factory/*.aspx.cs`, `Admin/*.aspx.cs`, and `Public/*.aspx.cs` into:
  - `UserLogic.cs`
  - `PartLogic.cs`
  - `QuotationLogic.cs`
  - `OrderLogic.cs`
  - `ServiceLogic.cs`
  - `AdminLogic.cs`

### 4. Missing Operations That You Need to Implement:
- Supplier inventory operations (`insertInventory`, `updateStock`) in `InventoryLogic.cs`.
- Technician job update operations (`updateServiceStatus`) in `ServiceLogic.cs`.

### 5. Logic That Should Remain in Code-Behind:
- `Page_Load` check for `!IsPostBack`.
- Control data binding: `GridView.DataSource = logic.select(); GridView.DataBind();`.
- Form clearing helpers (`txtPart.Text = "";`).
- Extracting values from server controls (`txtQuantity.Text`, `ddlCategory.SelectedValue`).
- Setting alert panel visibility (`pnlAlert.Visible = true; lblAlertMessage.Text = "Saved";`).

### 6. Logic That Does Not Need Database Connection:
- `Account/Logout.aspx.cs`: Session abandonment and FormsAuthentication sign-out.
- `Account/AccessDenied.aspx.cs`: Static error navigation.
- `Public/HowItWorks.aspx.cs`, `Public/WhyUs.aspx.cs`: Static view rendering.

---

## 7. Report F: Implementation Order

Follow this exact dependency-aware sequence when writing your backend code:

```
Step 1: Base Database Connection (App_Code/Logic/BaseLogic.cs or central getcon())
   │
Step 2: UserLogic.cs (Authentication, Registration, User Status)
   │
Step 3: PartLogic.cs (Categories, Machinery, Master Parts Search)
   │
Step 4: QuotationLogic.cs (Factory RFQ Generation & Bid Comparison)
   │
Step 5: OrderLogic.cs (Purchase Order Creation & Fulfillment Tracking)
   │
Step 6: ServiceLogic.cs (Technician Booking & Service Tickets)
   │
Step 7: AdminLogic.cs (Supplier GSTIN Verification & System Oversight)
   │
Step 8: Supplier & Technician Panels (Jay's Inventory & Job Handling)
```

---

## 8. Report G: Testing Checklist

| Operation | Valid Input Test | Invalid Input Test | Missing Record Test | DB Failure Test | Permission Test | Expected Viva Result |
|---|---|---|---|---|---|---|
| **User Login** | Correct email and password | Wrong password | Non-existent email | Stop LocalDB service | Logged out user accessing `/Factory/` | Shows proper error message; valid user redirects to matching role dashboard. |
| **Catalog Filter** | Keyword "Bearing" with Category "Bearings" | Special characters `''--` (SQL injection attempt) | Search for nonexistent part "XYZ-999" | Bad connection string | Public visitor vs Factory buyer | EmptyDataTemplate renders gracefully; SQL parameters neutralize injection attempt. |
| **Submit RFQ** | Qty = 5, Target Price = 2500, valid date | Qty = -1 or "abc" | Inactive PartId | DB connection timeout | Unauthorized role submitting RFQ | Validator blocks negative qty; valid insert returns generated `RFQ-XXXXX`. |
| **Accept Bid** | Click "Accept" on valid submitted bid | Accepting an already closed RFQ | Bid ID that was deleted | Transaction rollback scenario | Factory accepting another factory's RFQ | `SqlTransaction` commits: response accepted, others rejected, order created atomically. |
| **Verify Supplier** | Click "Approve" on pending vendor | Invalid supplier ID | Supplier record deleted by another user | Foreign key failure | Non-admin user accessing `/Admin/Verification.aspx` | Sets `VerificationStatus = 'Verified'` and `Users.IsVerified = 1`. Access denied for non-admins. |
| **Toggle Active** | Admin clicking "Deactivate" on Factory user | Admin deactivating own account | Invalid user ID | SQL deadlock | Non-admin user invoking event | Admin blocked from deactivating self; other accounts toggle cleanly. |

---

## 9. Next Steps for Stage 2 & 3

1. Review this audit report.
2. When you are ready to begin **Stage 3 (Implementation)**, pick **Step 1 & Step 2 (`UserLogic.cs` and consolidating `UserRepository.cs`)**.
3. I will give you the exact method signatures, SQL queries, and parameters to write in your own hands!

