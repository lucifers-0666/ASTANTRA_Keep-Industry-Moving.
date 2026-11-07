# ASTANTRA Administrator Console — Backend & Database Audit

**Project:** ASTANTRA (Industrial Spare Parts Procurement Platform)  
**Database:** `IndustrialSparePartDB` on SQL Server LocalDB  
**Architecture:** Three-Tier Architecture (Presentation: `.aspx`, Code-Behind: `.aspx.cs`, Logic: `App_Code/Logic/*.cs`)  
**Audit Date:** November 7, 2026  
**Status:** FULL COMPLIANCE  

---

## 1. Relational Database Schema Overview

The database contains 21 normalized tables (19 baseline tables + 2 RBAC migration tables):

| Table Name | Primary Key | Foreign Keys | Nullability & Constraints | Purpose |
|---|---|---|---|---|
| `Users` | `UserId` (PK, Identity) | `RoleId` -> `Roles(RoleId)` | `Email` UNIQUE, `PasswordHash` NOT NULL, `Salt` NOT NULL | Authentication credentials & profile root |
| `Roles` | `RoleId` (PK, Identity) | None | `RoleName` UNIQUE NOT NULL | Core RBAC role classifications |
| `Permissions` | `PermissionId` (PK, Identity) | None | `PermissionKey` UNIQUE NOT NULL, `Module` NOT NULL | Granular feature authorization clearances |
| `RolePermissions` | Composite (`RoleId`, `PermissionId`) | `RoleId` -> `Roles`, `PermissionId` -> `Permissions` | `CASCADE` on delete | Maps granular clearances to platform roles |
| `Factories` | `FactoryId` (PK, Identity) | `UserId` -> `Users(UserId)` (CASCADE) | `CompanyName` NOT NULL, `Gstin` VARCHAR(20) | Industrial manufacturing buyers & plant registry |
| `Suppliers` | `SupplierId` (PK, Identity) | `UserId` -> `Users(UserId)` (CASCADE) | `CompanyName` NOT NULL, `Gstin` VARCHAR(20) | Stocking vendors, trade licenses, KYC |
| `Technicians` | `TechnicianId` (PK, Identity) | `UserId` -> `Users(UserId)` (CASCADE) | `SkillSummary` NOT NULL, `HourlyRate` DECIMAL | Certified service engineers & maintenance specialists |
| `Categories` | `CategoryId` (PK, Identity) | None | `CategoryName` UNIQUE NOT NULL | Taxonomy categories for machine spare parts |
| `Machines` | `MachineId` (PK, Identity) | None | `MachineName` NOT NULL, `ModelNumber` VARCHAR(50) | Industrial equipment models & profiles |
| `SpareParts` | `PartId` (PK, Identity) | `CategoryId` -> `Categories`, `MachineId` -> `Machines` | `PartNumber` UNIQUE NOT NULL | Master spare parts catalog specifications |
| `EmergencyRequests` | `EmergencyRequestId` (PK, Identity) | `FactoryId` -> `Factories`, `PartId` -> `SpareParts` | `Status` VARCHAR(20) NOT NULL | SOS critical machine breakdown dispatches |
| `QuotationRequests` | `RfqId` (PK, Identity) | `FactoryId` -> `Factories`, `PartId` -> `SpareParts` | `Quantity` INT NOT NULL | Requests for quotation broadcast by buyers |
| `QuotationResponses` | `ResponseId` (PK, Identity) | `RfqId` -> `QuotationRequests`, `SupplierId` -> `Suppliers` | `UnitPrice` DECIMAL, `Status` VARCHAR(20) | Commercial quotation bids submitted by vendors |
| `Orders` | `OrderId` (PK, Identity) | `FactoryId` -> `Factories`, `SupplierId` -> `Suppliers`, `RfqId` -> `QuotationRequests` | `OrderNumber` UNIQUE NOT NULL | Purchase orders, escrow tracking, fulfillment |
| `OrderItems` | `OrderItemId` (PK, Identity) | `OrderId` -> `Orders`, `PartId` -> `SpareParts` | `Quantity` INT NOT NULL, `UnitPrice` DECIMAL | Itemized order lines |
| `ServiceRequests` | `RequestId` (PK, Identity) | `FactoryId` -> `Factories`, `TechnicianId` -> `Technicians` | `Status` VARCHAR(20) NOT NULL | Scheduled maintenance service calls |
| `SupplierInventory` | `InventoryId` (PK, Identity) | `SupplierId` -> `Suppliers`, `PartId` -> `SpareParts` | `StockQuantity` INT NOT NULL | Live stock listings and component lead times |
| `SupplierCertificates` | `CertificateId` (PK, Identity) | `SupplierId` -> `Suppliers`, `VerifiedByUserId` -> `Users` | `CertificateType` VARCHAR(50) | ISO, CE, OEM authorized vendor compliance documents |
| `AuditLogs` | `LogId` (PK, Identity) | `UserId` -> `Users(UserId)` (Preserved on delete) | `ActionType` NOT NULL, `CreatedAt` DEFAULT GETDATE() | Immutable administrative audit and security event trail |
| `SystemSettings` | `SettingKey` (PK, VARCHAR(50)) | `LastUpdatedBy` -> `Users(UserId)` | `SettingValue` NVARCHAR(MAX) | Operational parameters, SOS broadcast radiuses, flags |
| `Notifications` | `NotificationId` (PK, Identity) | `UserId` -> `Users(UserId)` | `Title` NOT NULL, `IsRead` BIT DEFAULT 0 | Alert dispatches and workflow notifications |

---

## 2. Page-to-Method-to-Table Mapping Matrix

| Administrator Page (`.aspx`) | Code-Behind File (`.aspx.cs`) | Logic Class & Method | Database Tables Accessed | Operation Type | Parameterized? | Transactional? |
|---|---|---|---|---|---|---|
| `Admin/Dashboard.aspx` | `Dashboard.aspx.cs` | `AdminLogic.getExecutiveKpis` | `Users`, `Suppliers`, `Factories`, `Technicians`, `EmergencyRequests`, `QuotationRequests`, `Orders` | SELECT (Aggregates) | Yes | Read-Only |
| `Admin/Dashboard.aspx` | `Dashboard.aspx.cs` | `AdminLogic.selectOpenEmergencies` | `EmergencyRequests`, `Factories` | SELECT | Yes | Read-Only |
| `Admin/Dashboard.aspx` | `Dashboard.aspx.cs` | `UserLogic.selectAllUsers` | `Users`, `Roles` | SELECT | Yes | Read-Only |
| `Admin/Users/ManageUsers.aspx` | `ManageUsers.aspx.cs` | `UserLogic.searchUsers` | `Users`, `Roles`, `Factories`, `Suppliers`, `Technicians` | SELECT | Yes | Read-Only |
| `Admin/Users/ManageUsers.aspx` | `ManageUsers.aspx.cs` | `UserLogic.registerUserWithProfileAtomic` | `Users`, `Factories`, `Suppliers`, `Technicians` | INSERT | Yes | **Yes (SqlTransaction)** |
| `Admin/Users/ManageUsers.aspx` | `ManageUsers.aspx.cs` | `UserLogic.updateUser` | `Users` | UPDATE | Yes | No |
| `Admin/Users/ManageUsers.aspx` | `ManageUsers.aspx.cs` | `UserLogic.updateUserStatus` | `Users` | UPDATE | Yes | No |
| `Admin/Users/ManageUsers.aspx` | `ManageUsers.aspx.cs` | `UserLogic.resetUserPasswordByAdmin` | `Users` | UPDATE | Yes | No |
| `Admin/Users/ManageUsers.aspx` | `ManageUsers.aspx.cs` | `UserLogic.deleteUser` | `Notifications`, `AuditLogs`, `SystemSettings`, `Users` | DELETE / UPDATE | Yes | **Yes (SqlTransaction)** |
| `Admin/Factories/ManageFactories.aspx` | `ManageFactories.aspx.cs` | `AdminLogic.selectAllFactories` | `Factories`, `Users`, `QuotationRequests`, `Orders` | SELECT | Yes | Read-Only |
| `Admin/Factories/ManageFactories.aspx` | `ManageFactories.aspx.cs` | `AdminLogic.insertNewFactory` | `Users`, `Factories` | INSERT | Yes | **Yes (SqlTransaction)** |
| `Admin/Factories/ManageFactories.aspx` | `ManageFactories.aspx.cs` | `AdminLogic.updateFactory` | `Factories` | UPDATE | Yes | No |
| `Admin/Factories/ManageFactories.aspx` | `ManageFactories.aspx.cs` | `AdminLogic.deleteFactory` | `Factories`, `Users` | DELETE | Yes | **Yes (SqlTransaction)** |
| `Admin/Suppliers/Verification.aspx` | `Verification.aspx.cs` | `AdminLogic.selectPendingSuppliers` | `Suppliers`, `Users` | SELECT | Yes | Read-Only |
| `Admin/Suppliers/Verification.aspx` | `Verification.aspx.cs` | `AdminLogic.verifySupplier` | `Suppliers`, `Users` | UPDATE | Yes | **Yes (SqlTransaction)** |
| `Admin/Technicians/ManageTechnicians.aspx` | `ManageTechnicians.aspx.cs` | `AdminLogic.selectAllTechniciansDetailed` | `Technicians`, `Users`, `ServiceRequests` | SELECT | Yes | Read-Only |
| `Admin/Technicians/ManageTechnicians.aspx` | `ManageTechnicians.aspx.cs` | `AdminLogic.insertNewTechnician` | `Users`, `Technicians` | INSERT | Yes | **Yes (SqlTransaction)** |
| `Admin/Technicians/ManageTechnicians.aspx` | `ManageTechnicians.aspx.cs` | `AdminLogic.updateTechnicianDetails` | `Technicians` | UPDATE | Yes | No |
| `Admin/Categories/ManageCategories.aspx` | `ManageCategories.aspx.cs` | `PartLogic.selectCategories`, `selectMachines` | `Categories`, `Machines` | SELECT | Yes | Read-Only |
| `Admin/Categories/ManageCategories.aspx` | `ManageCategories.aspx.cs` | `PartLogic.insertCategory`, `updateCategory`, `deleteCategory` | `Categories` | INSERT / UPDATE / DELETE | Yes | No |
| `Admin/Categories/ManageCategories.aspx` | `ManageCategories.aspx.cs` | `PartLogic.insertMachine`, `updateMachine`, `deleteMachine` | `Machines` | INSERT / UPDATE / DELETE | Yes | No |
| `Admin/SpareParts/ManageParts.aspx` | `ManageParts.aspx.cs` | `PartLogic.selectCatalog`, `selectPartById` | `SpareParts`, `Categories`, `Machines` | SELECT | Yes | Read-Only |
| `Admin/SpareParts/ManageParts.aspx` | `ManageParts.aspx.cs` | `PartLogic.insertPart`, `updatePart`, `deletePart` | `SpareParts` | INSERT / UPDATE / DELETE | Yes | No |
| `Admin/Orders/Oversight.aspx` | `Oversight.aspx.cs` | `AdminLogic.selectAllEmergenciesDetailed`, `updateEmergencyStatus` | `EmergencyRequests`, `Factories`, `Users`, `SpareParts` | SELECT / UPDATE | Yes | No |
| `Admin/Orders/Oversight.aspx` | `Oversight.aspx.cs` | `AdminLogic.selectAllQuotationsDetailed` | `QuotationRequests`, `Factories`, `SpareParts`, `QuotationResponses` | SELECT | Yes | Read-Only |
| `Admin/Orders/Oversight.aspx` | `Oversight.aspx.cs` | `OrderLogic.selectAllOrders`, `AdminLogic.updateOrderStatusByAdmin` | `Orders`, `Factories`, `Suppliers` | SELECT / UPDATE | Yes | No |
| `Admin/Audit/AuditLogs.aspx` | `AuditLogs.aspx.cs` | `AuditLogic.selectAuditLogs` | `AuditLogs`, `Users`, `Roles` | SELECT | Yes | Read-Only |
| `Admin/Profile.aspx` | `Profile.aspx.cs` | `UserLogic.getUserById`, `updateUserProfile`, `changeUserPassword`, `updateUserProfileImage` | `Users` | SELECT / UPDATE | Yes | No |
| `Admin/RBAC/Roles.aspx` | `Roles.aspx.cs` | `AdminLogic.selectAllRoles`, `selectPermissionsForRole`, `toggleRolePermission` | `Roles`, `Permissions`, `RolePermissions`, `Users` | SELECT / INSERT / DELETE | Yes | No |
| `Admin/Security/LoginSecurity.aspx` | `LoginSecurity.aspx.cs` | `AdminLogic.selectSecurityEvents` | `AuditLogs`, `Users`, `Roles` | SELECT | Yes | Read-Only |
| `Admin/System/DataIntegrity.aspx` | `DataIntegrity.aspx.cs` | `AdminLogic.runDataIntegrityAudit`, `repairDataIntegrity` | All 21 Tables | SELECT / INSERT / UPDATE | Yes | **Yes (SqlTransaction)** |
| `Admin/System/SystemHealth.aspx` | `SystemHealth.aspx.cs` | `AdminLogic.getSystemHealthMetrics` | `sys.tables`, `sys.partitions` | SELECT | Yes | Read-Only |
| `Admin/Settings/PlatformSettings.aspx` | `PlatformSettings.aspx.cs` | `AdminLogic.selectAllSystemSettings`, `updateSystemSetting` | `SystemSettings` | SELECT / UPDATE | Yes | No |

---

## 3. Database Migration History

The database migrations are stored sequentially under `Database/Migrations/`:

1. `01_Add_Technicians_Address.sql`: Added missing `Address NVARCHAR(255) NULL` column to `Technicians` table and updated baseline schema scripts.
2. `02_Add_Users_ProfileImage.sql`: Added `ProfileImage NVARCHAR(350) NULL` column to `Users` table to support administrator profile portrait uploads.
3. `03_Add_Permissions_And_RolePermissions.sql`: Added `Permissions` table, `RolePermissions` junction table with cascading foreign keys, and seeded 18 platform RBAC permissions.
