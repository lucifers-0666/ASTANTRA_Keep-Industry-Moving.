# ASTANTRA Administrator Console — Functional Audit Matrix

**Project:** ASTANTRA (Industrial Spare Parts Procurement & Emergency Maintenance Platform)  
**Scope:** Administrator Governance Portal (`Admin/`) — All 15 Functional Modules  
**Stack:** ASP.NET Web Forms, C# 7.3, .NET Framework 4.8, Parameterized ADO.NET, SQL Server LocalDB (`IndustrialSparePartDB`)  
**Audit Date:** November 7, 2026  
**Status:** PASS — Verified Functional & Integration Complete  

---

## 1. Executive Summary

This document presents the complete control-by-control, page-by-page functional inventory and execution audit across all 15 administrative pages of the ASTANTRA Administrator Console. Every interactive element—buttons, textboxes, dropdowns, modal dialogs, status toggles, and data tables—has been inspected, wired to parameterized three-tier backend logic, and validated against SQL Server LocalDB.

---

## 2. Page-by-Page Interactive Control Inventory

### Page 1: Command Dashboard (`Admin/Dashboard.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `lblTotalUsers` | HtmlGenericControl | View live total user count | System calculates active user count | `AdminLogic.getExecutiveKpis` | `Users` | Displays real integer count of active accounts | PASS |
| `lblVerifiedSuppliers` | HtmlGenericControl | View verified vendor count | `VerificationStatus = 'Verified'` | `AdminLogic.getExecutiveKpis` | `Suppliers` | Displays verified stocking vendors count | PASS |
| `lblActiveFactories` | HtmlGenericControl | View active manufacturing plants | Plant accounts registered | `AdminLogic.getExecutiveKpis` | `Factories` | Displays registered factories count | PASS |
| `lblActiveTechnicians` | HtmlGenericControl | View available technicians | `IsAvailable = 1` | `AdminLogic.getExecutiveKpis` | `Technicians` | Displays ready-for-dispatch engineers | PASS |
| `lblActiveEmergency` | HtmlGenericControl | View emergency machine breakdown tickets | `Status = 'Open'` | `AdminLogic.getExecutiveKpis` | `EmergencyRequests` | Real-time open SOS tickets count | PASS |
| `lblOpenRfqs` | HtmlGenericControl | View pending commercial RFQs | `Status = 'Pending'` | `AdminLogic.getExecutiveKpis` | `QuotationRequests` | Open bids awaiting response count | PASS |
| `lblTotalOrders` | HtmlGenericControl | View purchase consignment orders | Orders created in platform | `AdminLogic.getExecutiveKpis` | `Orders` | Total orders count | PASS |
| `lblTotalGmv` | HtmlGenericControl | View platform procurement volume | Sum of confirmed orders | `AdminLogic.getExecutiveKpis` | `Orders` | Tabular formatted GMV in INR (`₹`) | PASS |
| `gvEmergencies` | GridView | Live stream of critical breakdown alerts | Displays latest SOS tickets | `AdminLogic.selectOpenEmergencies` | `EmergencyRequests`, `Factories` | Factory, machine, priority, city, status | PASS |
| `gvUsers` | GridView | Stream of recently registered accounts | Top 8 registered accounts | `UserLogic.selectAllUsers` | `Users`, `Roles` | Name, email, assigned role, joined date | PASS |
| `pnlAlert` | Panel | Error / warning feedback | Dismissible banner | `btnCloseAlert_Click` | N/A | Human-readable diagnostic alert | PASS |

---

### Page 2: User Directory & Identity Provisioning (`Admin/Users/ManageUsers.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `txtSearch` | TextBox | Search keyword by name, email, phone | Sanitized parameter | `btnSearch_Click` / `UserLogic.searchUsers` | `Users` | Filtered list of platform accounts | PASS |
| `ddlRoleFilter` | DropDownList | Filter accounts by RBAC role | 1=Admin, 2=Factory, 3=Supplier, 4=Tech | `FilterChanged` / `UserLogic.searchUsers` | `Users`, `Roles` | Filtered accounts matching role | PASS |
| `ddlStatusFilter` | DropDownList | Filter accounts by Active/Suspended | Boolean active flag | `FilterChanged` / `UserLogic.searchUsers` | `Users` | Filtered accounts matching status | PASS |
| `btnSegmentAll` to `btnSegmentAdmins` | LinkButtons | Quick role tab switcher | Updates role filter dropdown | `btnSegment_Click` | `Users`, `Roles` | Filtered view with count badge | PASS |
| `btnOpenAddModal` | Button | Open multi-role registration dialog | Clears fields & opens modal | `btnOpenAddModal_Click` | N/A | Modal dialog with dynamic role inputs | PASS |
| `ddlAddRole` | DropDownList | Select role for new user | 1=Admin, 2=Factory, 3=Supplier, 4=Tech | `toggleRoleProfileFields()` client JS | N/A | Toggles role profile sections dynamically | PASS |
| `btnSubmitAddUser` | Button | Submit user and role profile | Atomic transaction, valid email & fields | `UserLogic.registerUserWithProfileAtomic` | `Users`, `Factories`, `Suppliers`, `Technicians` | Single SQL transaction provisions both user & entity profile | PASS |
| `gvUsers` RowCommand `ToggleActive` | LinkButton | Toggle account active/suspended | Superadmin self-deactivation guard | `UserLogic.updateUserStatus` | `Users`, `AuditLogs` | Toggles account status & logs audit | PASS |
| `gvUsers` RowCommand `EditUser` | LinkButton | Open edit modal for user | Loads user record by ID | `hdnEditUserId` populates modal | `Users` | Edit modal displays existing values | PASS |
| `btnSubmitEditUser` | Button | Save updated name, email, role, password | Valid email, optional password reset >=6 chars | `UserLogic.updateUser`, `UserLogic.resetUserPasswordByAdmin` | `Users`, `AuditLogs` | Account updated, PBKDF2 hash rotated if password supplied | PASS |
| `gvUsers` RowCommand `DeleteUser` | LinkButton | Delete account | Superadmin guard; audit preserved | `UserLogic.deleteUser` | `Users`, `AuditLogs` | Foreign key decoupled from audit logs; user removed | PASS |

---

### Page 3: Industrial Plant Buyers (`Admin/Factories/ManageFactories.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `txtSearch` | TextBox | Search factory by name, contact, GSTIN | Parameterized search | `LoadFactories` / `AdminLogic.selectAllFactories` | `Factories`, `Users` | Filtered plant roster | PASS |
| `txtCityFilter` | TextBox | Filter by plant municipality | Parameterized city query | `LoadFactories` / `AdminLogic.selectAllFactories` | `Factories` | Filtered city plants | PASS |
| `btnOpenAddModal` | Button | Open factory registration dialog | Clears fields & displays modal | `btnOpenAddModal_Click` | N/A | Registration modal displayed | PASS |
| `btnSubmitAddFactory` | Button | Create manufacturing facility | Required fields, valid email | `AdminLogic.insertNewFactory` | `Users`, `Factories`, `AuditLogs` | Factory user & plant record created | PASS |
| `gvFactories` RowCommand `EditFactory` | LinkButton | Open edit modal | Loads factory record | `hdnEditFactoryId` populates modal | `Factories` | Edit modal with address/GSTIN | PASS |
| `btnSubmitEditFactory` | Button | Save edited plant details | Required company, contact, city | `AdminLogic.updateFactory` | `Factories`, `AuditLogs` | Plant record updated | PASS |
| `gvFactories` RowCommand `DeleteFactory` | LinkButton | Delete manufacturing plant | Deletes factory & associated user | `AdminLogic.deleteFactory` | `Factories`, `Users`, `AuditLogs` | Plant deleted, audit log created | PASS |

---

### Page 4: Supplier Due Diligence & KYC (`Admin/Suppliers/Verification.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `ddlStatusFilter` | DropDownList | Filter by Pending, Verified, Rejected | Status filter | `FilterChanged` / `AdminLogic.selectPendingSuppliers` | `Suppliers`, `Users` | Filtered supplier list | PASS |
| `txtSearch` | TextBox | Search vendor by name, GSTIN, city | In-memory DataView filter | `btnSearch_Click` | `Suppliers` | Filtered search matches | PASS |
| `gvSuppliers` RowCommand `InspectSupplier` | LinkButton | Open compliance dossier modal | Inspects GSTIN, trade reg, contact | `hdnInspectSupplierId` populates dossier | `Suppliers`, `Users` | Complete audit dossier modal | PASS |
| `btnApproveDossier` | Button | Approve vendor application | Sets `VerificationStatus='Verified'`, `IsVerified=1` | `AdminLogic.verifySupplier` | `Suppliers`, `Users`, `AuditLogs` | Supplier verified, bidding rights granted | PASS |
| `btnRejectDossier` | Button | Reject vendor application | Sets `VerificationStatus='Rejected'`, `IsVerified=0` | `AdminLogic.verifySupplier` | `Suppliers`, `Users`, `AuditLogs` | Supplier rejected, bidding blocked | PASS |

---

### Page 5: Field Service Technicians (`Admin/Technicians/ManageTechnicians.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `txtSearch` | TextBox | Search technician by name, skills, city | Parameterized search | `LoadTechnicians` / `AdminLogic.selectAllTechniciansDetailed` | `Technicians`, `Users` | Filtered technician roster | PASS |
| `ddlStatusFilter` | DropDownList | Filter by Available, Unavailable, Verified | Status filter | `FilterChanged` / `AdminLogic.selectAllTechniciansDetailed` | `Technicians` | Filtered technician roster | PASS |
| `btnOpenAddModal` | Button | Open technician registration dialog | Clears fields & opens modal | `btnOpenAddModal_Click` | N/A | Add technician modal displayed | PASS |
| `btnSubmitAddTech` | Button | Register field service technician | Required name, email, skills, rate | `AdminLogic.insertNewTechnician` | `Users`, `Technicians`, `AuditLogs` | Technician user and roster profile created | PASS |
| `gvTechnicians` RowCommand `EditTech` | LinkButton | Open edit modal | Loads skills, hourly rate, address | `hdnEditTechId` populates modal | `Technicians` | Edit technician modal | PASS |
| `btnSubmitEditTech` | Button | Save updated technician details | Valid rate and experience | `AdminLogic.updateTechnicianDetails` | `Technicians`, `AuditLogs` | Updated technician record | PASS |
| `gvTechnicians` RowCommand `ToggleDuty` | LinkButton | Toggle duty status (Available / Off-Duty) | Flips `IsAvailable` boolean | `AdminLogic.updateTechnicianDetails` | `Technicians`, `AuditLogs` | Toggled duty state & audit log | PASS |

---

### Page 6: Taxonomy & Machinery Profiles (`Admin/Categories/ManageCategories.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `btnOpenAddCategoryModal` | Button | Open add category modal | Clears category modal fields | `btnOpenAddCategoryModal_Click` | N/A | Add category modal | PASS |
| `btnSaveCategory` | Button | Create or update component category | Required category name | `PartLogic.insertCategory` / `updateCategory` | `Categories`, `AuditLogs` | Category created/updated | PASS |
| `gvCategories` RowCommand `EditCategory` | LinkButton | Edit category modal | Loads category by ID | `hdnCategoryId` populates modal | `Categories` | Category edit modal | PASS |
| `gvCategories` RowCommand `DeleteCategory` | LinkButton | Delete category | Blocked if parts mapped | `PartLogic.deleteCategory` | `Categories`, `AuditLogs` | Category removed if unreferenced | PASS |
| `btnOpenAddMachineModal` | Button | Open add machine model modal | Clears machine modal fields | `btnOpenAddMachineModal_Click` | N/A | Add machine modal | PASS |
| `btnSaveMachine` | Button | Create or update machine model | Required machine name | `PartLogic.insertMachine` / `updateMachine` | `Machines`, `AuditLogs` | Machine profile saved | PASS |
| `gvMachines` RowCommand `EditMachine` | LinkButton | Edit machine model modal | Loads machine by ID | `hdnMachineId` populates modal | `Machines` | Machine edit modal | PASS |
| `gvMachines` RowCommand `DeleteMachine` | LinkButton | Delete machine model | Blocked if parts mapped | `PartLogic.deleteMachine` | `Machines`, `AuditLogs` | Machine removed if unreferenced | PASS |

---

### Page 7: Master Spare Parts Catalog (`Admin/SpareParts/ManageParts.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `txtSearch` | TextBox | Search by part number or part name | Parameterized search | `btnSearch_Click` / `PartLogic.selectCatalog` | `SpareParts` | Filtered catalog table | PASS |
| `ddlFilterCategory` | DropDownList | Filter catalog by component category | Category ID match | `FilterChanged` / `PartLogic.selectCatalog` | `SpareParts`, `Categories` | Filtered parts table | PASS |
| `ddlFilterMachine` | DropDownList | Filter catalog by compatible machinery | Machine ID match | `FilterChanged` / `PartLogic.selectCatalog` | `SpareParts`, `Machines` | Filtered parts table | PASS |
| `btnOpenAddModal` | Button | Open new part registration modal | Clears part form fields | `btnOpenAddModal_Click` | N/A | Part registration modal | PASS |
| `btnSavePart` | Button | Create or update spare part | Required part number & name | `PartLogic.insertPart` / `updatePart` | `SpareParts`, `AuditLogs` | Part record persisted | PASS |
| `gvParts` RowCommand `EditPart` | LinkButton | Edit part specifications modal | Loads part details by ID | `PartLogic.selectPartById` | `SpareParts` | Part edit modal | PASS |
| `gvParts` RowCommand `DeletePart` | LinkButton | Delete spare part from catalog | Blocked if active orders/quotes | `PartLogic.deletePart` | `SpareParts`, `AuditLogs` | Part removed if unreferenced | PASS |

---

### Page 8: Procurement & SOS Oversight (`Admin/Orders/Oversight.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `gvEmergency` RowCommand `TriageSos` | LinkButton | Open SOS breakdown triage modal | Loads emergency ticket by ID | `hdnSosRequestId` populates modal | `EmergencyRequests` | Triage dialog with priority & plant | PASS |
| `btnSaveSosStatus` | Button | Update emergency ticket status | Open / Dispatched / Resolved / Closed | `AdminLogic.updateEmergencyStatus` | `EmergencyRequests`, `AuditLogs` | Status updated & logged to audit | PASS |
| `gvQuotations` | GridView | Monitor commercial RFQ quotations | Displays active RFQs & bids | `AdminLogic.selectAllQuotationsDetailed` | `QuotationRequests`, `QuotationResponses` | RFQs with target price & bid count | PASS |
| `gvOrders` RowCommand `EditOrder` | LinkButton | Open purchase order modal | Loads order consignment details | `hdnOrderId` populates modal | `Orders` | Order status and waybill editor | PASS |
| `btnSaveOrderStatus` | Button | Update order status and tracking waybill | Status: In Production / Shipped / Delivered | `AdminLogic.updateOrderStatusByAdmin` | `Orders`, `AuditLogs` | Order status & waybill updated | PASS |

---

### Page 9: Platform Audit Trail (`Admin/Audit/AuditLogs.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `ddlActionFilter` | DropDownList | Filter logs by mutation action type | `ActionType` match | `FilterChanged` / `AuditLogic.selectAuditLogs` | `AuditLogs` | Filtered audit events | PASS |
| `ddlEntityFilter` | DropDownList | Filter logs by target entity table | `TargetEntity` match | `FilterChanged` / `AuditLogic.selectAuditLogs` | `AuditLogs` | Filtered audit events | PASS |
| `ddlTopCount` | DropDownList | Select result window (50, 100, 250, 500) | Integer row limit | `FilterChanged` / `AuditLogic.selectAuditLogs` | `AuditLogs` | Bounded log entries | PASS |
| `btnReset` | LinkButton | Reset filter criteria | Clears filters | `btnReset_Click` | `AuditLogs` | Default top 100 audit logs | PASS |
| `gvAuditLogs` | GridView | Display immutable log records | Read-only presentation | `AuditLogic.selectAuditLogs` | `AuditLogs`, `Users`, `Roles` | Actor, Action, Entity, Time, IP, Values | PASS |

---

### Page 10: Administrator Profile & Credentials (`Admin/Profile.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `btnSaveAvatarDirect` | Button | Save cropped profile avatar image | Magic byte verification, server decode & re-encode | `UserLogic.updateUserProfileImage` | `Users`, `AuditLogs` | Portrait saved, sanitized, and updated in sidebar | PASS |
| `btnRemoveAvatar` | Button | Remove custom portrait | Resets to default initials | `UserLogic.updateUserProfileImage` | `Users`, `AuditLogs` | Portrait reset to standard badge | PASS |
| `btnSaveProfile` | Button | Update admin name, email, phone | Required full name & email | `UserLogic.updateUserProfile` | `Users`, `AuditLogs` | Profile credentials updated | PASS |
| `btnChangePassword` | Button | Rotate admin security password | Current password verified; new >= 6 chars; confirm match | `UserLogic.changeUserPassword` | `Users`, `AuditLogs` | Password hashed with PBKDF2 (10,000 iter) | PASS |

---

### Page 11: RBAC Roles & Clearances (`Admin/RBAC/Roles.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `gvRoles` RowCommand `InspectRole` | LinkButton | Select security role for clearance management | Loads role permissions | `LoadPermissionsForRole` | `Roles`, `Permissions`, `RolePermissions` | Permission grid refreshed for selected role | PASS |
| `gvPermissions` RowCommand `TogglePerm` | LinkButton | Grant or revoke granular permission | Updates role-permission mapping | `AdminLogic.toggleRolePermission` | `RolePermissions`, `AuditLogs` | Permission granted/revoked live; logged to audit | PASS |

---

### Page 12: Authentication & Session Stream (`Admin/Security/LoginSecurity.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `btnRefresh` | LinkButton | Refresh live security event stream | Queries latest 50 security events | `AdminLogic.selectSecurityEvents` | `AuditLogs`, `Users`, `Roles` | Real-time sign-in, failed attempts, and logouts | PASS |
| `gvSecurityLogs` | GridView | Surveillance of auth telemetry | ActionType LIKE '%AUTH%', '%LOGIN%', etc. | `AdminLogic.selectSecurityEvents` | `AuditLogs` | Live stream with IP, actor, timestamp | PASS |

---

### Page 13: Database Referential Diagnostics (`Admin/System/DataIntegrity.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `btnRunAudit` | Button | Execute referential integrity diagnostics | Scans orphaned users, pending KYC, emergencies | `AdminLogic.runDataIntegrityAudit` | All 19 tables | Health indicators and table row counts | PASS |
| `btnRepairIntegrity` | Button | Reconcile orphaned profiles and flags | Reconciles orphaned accounts atomically | `AdminLogic.repairDataIntegrity` | `Users`, `Factories`, `Suppliers`, `Technicians` | Discrepancies reconciled safely | PASS |

---

### Page 14: System Health & Engine Telemetry (`Admin/System/SystemHealth.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `btnTestDb` | Button | Test database engine connectivity & latency | Measures stopwatch roundtrip latency | `AdminLogic.getSystemHealthMetrics` | `sys.tables`, `sys.partitions` | Live measured latency (ms), table & row counts | PASS |
| Telemetry Indicators | HtmlControls | Read-only hardware & runtime telemetry | System metrics | `LoadHealthTelemetry` | System, SQL Server | SQL version, CLR version, Machine name | PASS |

---

### Page 15: Platform Operational Settings (`Admin/Settings/PlatformSettings.aspx`)
| Control ID | Type | User Action / Input | Validation / Business Rule | Backend Event / Method | Database Table(s) | Expected Output | Verification Status |
|---|---|---|---|---|---|---|---|
| `gvSettings` RowCommand `EditSetting` | LinkButton | Open setting editor modal | Loads setting key, value, description | `hdnEditSettingKey` populates modal | `SystemSettings` | Modal dialog with setting value editor | PASS |
| `btnSaveSetting` | Button | Update platform operational setting | Validates value (radius: 5-1000km, booleans) | `AdminLogic.updateSystemSetting` | `SystemSettings`, `AuditLogs` | Setting persisted, validated & audited | PASS |

---

## 3. Defect Remediation Summary

1. **Password Hashing:** Upgraded from legacy SHA-256 to PBKDF2 (HMAC-SHA256, 10,000 iterations) with constant-time verification and seamless backward compatibility.
2. **Hardcoded Fallbacks:** Removed all hardcoded administrator ID fallbacks (`SessionHelper.UserId ?? 1`). Replaced with strict session authentication checks.
3. **Avatar Security:** Implemented magic byte raster validation and server-side image decoding/re-encoding using `Bitmap` to sanitize metadata and strip embedded payloads.
4. **Atomic Provisioning:** Implemented `registerUserWithProfileAtomic` inside `UserLogic.cs` to create accounts and role-specific profiles in a single `SqlTransaction`.
5. **Audit Trail Preservation:** Decoupled `AuditLogs.UserId` and `SystemSettings.LastUpdatedBy` to `NULL` prior to account deletion, permanently preserving historical audit records.
6. **Authentication Logging:** Added live event generation for `AUTH_LOGIN_SUCCESS`, `AUTH_LOGIN_FAILED`, `AUTH_LOGOUT`, and `AUTH_ACCESS_DENIED`.
7. **Granular RBAC:** Added `Permissions` and `RolePermissions` tables with interactive clearance management on `Admin/RBAC/Roles.aspx`.
8. **Setting Validation:** Enforced value-range and type constraints in `AdminLogic.updateSystemSetting`.
9. **Latency Telemetry:** Replaced static status strings with real-time `Stopwatch` latency measurement in `Admin/System/SystemHealth.aspx`.
10. **Error Handling:** Replaced empty catch blocks with user-facing dismissible alert panels.
