# Page Inventory and Implementation Status

## Page count must be verified
The authoritative total is **15 physical `.aspx` pages**, verified by repository audit on branch `zaid/changes`. Do not infer page count from menu items or screenshots.

Audit all `.aspx` files, code-behind files, master pages, project inclusion, access rules, navigation and data access. Distinguish physical ASPX pages from routes, links, modals, user controls and static assets. Do not delete suspected obsolete pages without approval.

- Total physical `.aspx` pages: **15**
- Public pages: **7** (`Default.aspx`, `Public/Parts.aspx`, `Public/Suppliers.aspx`, `Public/Technicians.aspx`, `Public/HowItWorks.aspx`, `Public/WhyUs.aspx`, `Public/Emergency.aspx`)
- Account/auth pages: **4** (`Account/Login.aspx`, `Account/Register.aspx`, `Account/Logout.aspx`, `Account/AccessDenied.aspx`)
- Supplier pages: **1** (`Supplier/Dashboard.aspx`)
- Factory/buyer pages: **1** (`Factory/Dashboard.aspx`)
- Technician/service pages: **1** (`Technician/Dashboard.aspx`)
- Admin/utility pages: **1** (`Admin/Dashboard.aspx`)

| File path | Purpose | Master page | Access/role | Data/service | UI status | Functional status | Owner | Notes |
|---|---|---|---|---|---|---|---|---|
| `Default.aspx` | Home page & procurement portal overview with search bar | `~/MasterPages/Site.Master` | Public (Anonymous) | Redirect to `Public/Parts.aspx` | Complete | Functional | Jay / Zaid | Primary landing page with search query redirection |
| `Public/Parts.aspx` | Industrial spare parts catalog with search and category filtering | `~/MasterPages/Site.Master` | Public (Anonymous) | `DatabaseHelper.ExecuteQuery` (parameterized SQL) | Complete | Functional | Jay | Includes category dropdown & keyword search |
| `Public/Suppliers.aspx` | Industrial supplier directory with location and verification filters | `~/MasterPages/Site.Master` | Public (Anonymous) | `DatabaseHelper.ExecuteQuery` (parameterized SQL) | Complete | Functional | Jay | Directory listing with verification badges |
| `Public/Technicians.aspx` | Field technician network directory with skill and city filters | `~/MasterPages/Site.Master` | Public (Anonymous) | `DatabaseHelper.ExecuteQuery` (parameterized SQL) | Complete | Functional | Jay | Directory listing with skill specialization filtering |
| `Public/HowItWorks.aspx` | Explains 4-step procurement workflow for buyers and suppliers | `~/MasterPages/Site.Master` | Public (Anonymous) | None (static editorial) | Complete | Functional | Uday | Informational workflow guide |
| `Public/WhyUs.aspx` | Value propositions, verified network, and uptime differentiators | `~/MasterPages/Site.Master` | Public (Anonymous) | None (static editorial) | Complete | Functional | Uday | Informational comparison guide |
| `Public/Emergency.aspx` | Emergency breakdown sourcing desk and rapid dispatch intake | `~/MasterPages/Site.Master` | Public view / Factory dispatch | Session state check & role redirect | Complete | Functional | Zaid | Redirects authenticated Factory to dashboard with flag; prompts others to authenticate |
| `Account/Login.aspx` | User sign-in with email, password, and return URL handling | `~/MasterPages/Site.Master` | Anonymous | `IAuthService.Login` via `AuthService` | Complete | Functional | Zaid | Validates credentials, issues FormsAuth cookie, redirects by role |
| `Account/Register.aspx` | Multi-role registration (Factory, Supplier, Technician) | `~/MasterPages/Site.Master` | Anonymous | `IAuthService.Register*` via `AuthService` | Complete | Functional | Zaid | Multi-role registration with transactional profile creation |
| `Account/Logout.aspx` | Session invalidation and auth cookie clearance | None (headless) | Authenticated | `SessionHelper.Logout()` | N/A (headless) | Functional | Zaid | Abandons session and redirects to `Login.aspx?logout=true` |
| `Account/AccessDenied.aspx` | Authorization failure and 403 error guidance | `~/MasterPages/Site.Master` | All users | `SessionHelper` (role check) | Complete | Functional | Zaid | Shows dynamic return button based on session role |
| `Factory/Dashboard.aspx` | Factory buyer dashboard for orders, RFQs, and dispatches | `~/MasterPages/Factory.Master` | Role: `Factory` (`BasePage`) | Session profile data (`SessionHelper`) | Complete | Functional | Zaid / Jay | Enforces `Factory` role via `BasePage` and `Factory.Master` |
| `Supplier/Dashboard.aspx` | Supplier operations dashboard for inventory and incoming orders | `~/MasterPages/Supplier.Master` | Role: `Supplier` (`BasePage`) | Session profile data (`SessionHelper`) | Complete | Functional | Jay / Zaid | Enforces `Supplier` role, displays verification warning banner if unverified |
| `Technician/Dashboard.aspx` | Field technician dashboard for service calls and availability | `~/MasterPages/Technician.Master` | Role: `Technician` (`BasePage`) | Session profile data (`SessionHelper`) | Complete | Functional | Jay / Uday | Enforces `Technician` role via `BasePage` and `Technician.Master` |
| `Admin/Dashboard.aspx` | System governance dashboard and user administration | `~/MasterPages/Admin.Master` | Role: `Administrator` | `IUserRepository.GetAllUsersWithRoles()` | Complete | Functional | Zaid | Enforces `Administrator` role via `Admin.Master`, renders users `GridView` |

Run from the repo root in PowerShell:

```powershell
Get-ChildItem -Recurse -Filter *.aspx |
  Where-Object { $_.FullName -notmatch '\\(bin|obj|\.git)\\' } |
  Select-Object -ExpandProperty FullName

(Get-ChildItem -Recurse -Filter *.aspx |
  Where-Object { $_.FullName -notmatch '\\(bin|obj|\.git)\\' }).Count
```

A file existing does not prove it is reachable or functional. Verify the `.sln`, `.csproj`, `Web.config`, master pages and code-behind.
