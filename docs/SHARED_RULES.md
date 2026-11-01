# ASTANTRA — Shared Architecture & Team Development Rules
**Deliverable for Phase 1**  
**Project:** ASTANTRA — Keep Industry Moving  
**Lead / Coordinator:** Zaid Amreliya  

---

## 1. Team Ownership & Responsibilities

| Contributor | Primary Ownership | Secondary / Coordination |
|---|---|---|
| **Zaid Amreliya (Lead)** | Authentication (`/Account`), Factory Buyer Panel (`/Factory`), Administrator Panel (`/Admin`), Database Schema Coordination, Final Integration | Code reviews, merge approvals, build integrity |
| **Jay** | Spare-Part Supplier Hub (`/Supplier`), Field Technician Portal (`/Technician`) | Supplier inventory schema coordination |
| **Uday** | Public Visitor Pages (`/Public`, `Default.aspx`), Responsive CSS/UI, Documentation & Screenshots | Anti-AI design audit compliance |

---

## 2. Role-Based Access Control (RBAC) & Master Page Mapping

Every secured page must inherit from `IndustrialSparePartPortal.App_Code.Helpers.BasePage` and set `RequiredRole` in its constructor:

```csharp
public partial class MyPage : BasePage
{
    public MyPage()
    {
        RequiredRole = RoleConstants.Factory; // "Factory", "Supplier", "Technician", or "Administrator"
    }
}
```

| Role Name in DB | Master Page | Default Dashboard URL | Access Permissions |
|---|---|---|---|
| `Factory` | `~/MasterPages/Factory.Master` | `~/Factory/Dashboard.aspx` | Can search parts, issue RFQs, accept quotes, place orders, book technicians, log breakdowns. |
| `Supplier` | `~/MasterPages/Supplier.Master` | `~/Supplier/Dashboard.aspx` | Can manage own inventory, view relevant RFQs, submit quotes, update order dispatch status. |
| `Technician` | `~/MasterPages/Technician.Master` | `~/Technician/Dashboard.aspx` | Can toggle duty status, view assigned maintenance jobs, update service progress. |
| `Administrator` | `~/MasterPages/Admin.Master` | `~/Admin/Dashboard.aspx` | Full platform governance, user activation, GSTIN verification, category/part catalog CRUD. |

---

## 3. Web Forms Control Naming Conventions

To keep code maintainable, transparent, and easy to explain in an MCA viva exam, follow standard Hungarian-style prefix naming for server controls (`runat="server"`):

| Control Type | Prefix | Example |
|---|---|---|
| `asp:TextBox` | `txt` | `txtPartNumber`, `txtQuantity`, `txtEmail` |
| `asp:DropDownList` | `ddl` | `ddlCategory`, `ddlMachine`, `ddlPriority` |
| `asp:Button` / `asp:LinkButton` | `btn` | `btnSubmitRfq`, `btnAcceptBid`, `btnSearch` |
| `asp:GridView` | `gv` | `gvQuotations`, `gvOrders`, `gvUsers` |
| `asp:Repeater` | `rpt` | `rptPartsCatalog`, `rptSupplierList` |
| `asp:Label` / `asp:Literal` | `lbl` / `lit` | `lblStatus`, `litAlertMessage` |
| `asp:Panel` | `pnl` | `pnlRfqModal`, `pnlAlertNotice` |
| `asp:CheckBox` / `asp:RadioButton` | `chk` / `rdo` | `chkIsEmergency`, `rdoFactory` |

> **Critical Rule:** Never rename existing control IDs in `.aspx` without checking `.aspx.cs` and `.designer.cs`. Renaming controls without syncing causes build breakage.

---

## 4. ADO.NET Database Connection & Security Rules

All database communication **must** use the centralized connection helper `DbFactory.cs`.

- **Connection String Key:** `IndustrialSparePartDB` in `Web.config`.
- **Target Instance:** `(localdb)\MSSQLLocalDB`.
- **Zero Inline SQL Concatenation:** Every dynamic parameter **must** use `SqlParameter` with explicit `SqlDbType` and length.
- **Connection Lifecycle:** Always wrap connections and commands in C# `using` blocks to prevent unmanaged connection leaks.
- **Transactions:** Any multi-step operation (e.g., Accepting an RFQ quotation that also creates an `Orders` record) must be wrapped in a `SqlTransaction`.

---

## 5. Git Branching & Merge Protocol

1. **Branch Naming**:
   - `lead/feature-name` (Zaid - Auth, Factory, Admin)
   - `supplier/feature-name` (Jay - Supplier & Technician)
   - `public/feature-name` (Uday - Public & Styling)
2. **Main Branch Protection**:
   - Do not push untested code directly to `main`.
   - Every merge must pass local compilation (`MSBuild.exe IndustrialSparePartPortal.csproj /t:Build`) with **0 warnings and 0 errors**.
3. **Database Migrations**:
   - Do not alter `01_CreateTables.sql` destructively.
   - Any new column or index must be submitted as an incremental migration script (`Database/Migrations/XX_Description.sql`) coordinated through the Project Lead.

