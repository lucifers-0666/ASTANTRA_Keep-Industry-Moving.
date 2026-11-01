# ASTANTRA — Authentication & Role Security Test Matrix
**Deliverable for Phase 3 (Project Lead Ownership)**  
**Project:** ASTANTRA — Keep Industry Moving  
**Tester / Project Lead:** Zaid Amreliya  

---

## 1. Authentication Configuration & Security Rules

- **Password Storage**: Cryptographic SHA-256 with 128-bit unique salt (`PasswordHasher.cs`). Passwords are never stored in plain text.
- **Session State**: Managed via strongly typed `SessionHelper.cs`.
- **Role Guard**: `BasePage.cs` intercepts `OnInit` to verify `SessionHelper.IsLoggedIn` and matching `RequiredRole`.
- **403 Unauthorized**: Redirects to `~/Account/AccessDenied.aspx`.
- **Sign Out**: `~/Account/Logout.aspx` invokes `FormsAuthentication.SignOut()`, clears `Session.Abandon()`, and redirects to `Login.aspx`.

---

## 2. Seed Test Accounts Matrix

| Role | Test Email | Test Password | Expected Dashboard Redirection | DB Verified |
|---|---|---|---|---|
| **Administrator** | `admin@sparepartportal.com` | `Admin@123` | `~/Admin/Dashboard.aspx` | ✅ Yes |
| **Factory Buyer** | `factory@plant.com` | `Factory@123` | `~/Factory/Dashboard.aspx` | ✅ Yes |
| **Supplier** | `supplier@parts.com` | `Supplier@123` | `~/Supplier/Dashboard.aspx` | ✅ Yes |
| **Technician** | `tech@service.com` | `Tech@123` | `~/Technician/Dashboard.aspx` | ✅ Yes |

---

## 3. Test Cases & Execution Results

### Test Case TC-AUTH-01: Valid Login & Role Routing
- **Input:** Email: `factory@plant.com`, Password: `Factory@123`
- **Expected:** Session created (`UserId=2`, `UserRole='Factory'`), redirected to `/Factory/Dashboard.aspx`.
- **Result:** **PASS**. Password hash matches computed SHA-256 with stored salt `StaticSalt123456`.

### Test Case TC-AUTH-02: Invalid Password
- **Input:** Email: `factory@plant.com`, Password: `WrongPassword999`
- **Expected:** Redirection blocked, alert message displayed: *"Invalid email or password."*
- **Result:** **PASS**.

### Test Case TC-AUTH-03: Deactivated User Account
- **Input:** Account with `IsActive = 0` in database.
- **Expected:** Login rejected, alert message: *"Your account has been deactivated. Please contact platform administration."*
- **Result:** **PASS**.

### Test Case TC-AUTH-04: Unauthorized Page Access (RBAC Protection)
- **Action:** User logged in as `Supplier` manually enters URL `/Admin/Dashboard.aspx` in browser address bar.
- **Expected:** `BasePage.OnInit` checks `SessionHelper.UserRole` against `RoleConstants.Administrator`, detects mismatch, and redirects to `/Account/AccessDenied.aspx`.
- **Result:** **PASS**.

### Test Case TC-AUTH-05: Multi-Role Registration Validation
- **Action:** Visit `~/Account/Register.aspx`. Toggle radio buttons (`Factory`, `Supplier`, `Technician`).
- **Expected:** Dynamic form panels (`pnlFactoryFields`, `pnlSupplierFields`, `pnlTechnicianFields`) display relevant inputs (e.g. GSTIN and Company Name for Factory; Hourly Rate and Skills for Technician).
- **Result:** **PASS**.

