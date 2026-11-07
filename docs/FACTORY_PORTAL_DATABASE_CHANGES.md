# ASTANTRA — Factory Buyer Workspace: Database Schema Migrations & Integrity

**Phase**: Phase 3 (Factory Buyer Portal Completion)  
**Migration File**: `Database/Migrations/04_Factory_Portal_Enhancements.sql`  
**Database**: SQL Server LocalDB (`IndustrialSparePartDB`)  

---

## 1. Migration Overview

To support machinery fleet management, physical consignment delivery verification, 24/7 breakdown phone dispatch, and multi-tenant test suites, migration `04_Factory_Portal_Enhancements.sql` was executed.

---

## 2. DDL Modifications

### 2.1 Creation of `FactoryMachines` Table
Stores physical machinery units owned by individual manufacturing plants.

```sql
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FactoryMachines')
BEGIN
    CREATE TABLE FactoryMachines (
        FactoryMachineId INT IDENTITY(1,1) PRIMARY KEY,
        FactoryId INT NOT NULL,
        MachineId INT NOT NULL,
        AssetTag NVARCHAR(50) NOT NULL,
        SerialNumber NVARCHAR(100) NULL,
        Department NVARCHAR(100) NULL,
        InstalledDate DATE NULL,
        Status VARCHAR(20) NOT NULL DEFAULT 'Operational',
        Notes NVARCHAR(MAX) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_FactoryMachines_Factories FOREIGN KEY (FactoryId) REFERENCES Factories(FactoryId) ON DELETE CASCADE,
        CONSTRAINT FK_FactoryMachines_Machines FOREIGN KEY (MachineId) REFERENCES Machines(MachineId),
        CONSTRAINT UQ_FactoryMachines_Factory_AssetTag UNIQUE (FactoryId, AssetTag)
    );

    CREATE NONCLUSTERED INDEX IX_FactoryMachines_FactoryId ON FactoryMachines(FactoryId);
    CREATE NONCLUSTERED INDEX IX_FactoryMachines_Status ON FactoryMachines(Status);
END;
```

### 2.2 Schema Alterations
- **`Factories` Table**: Added `ContactPhone VARCHAR(20) NULL` for 24/7 emergency dispatch communications.
- **`EmergencyRequests` Table**: Added `FactoryMachineId INT NULL` with foreign key reference `FK_EmergencyRequests_FactoryMachines` to link breakdown tickets directly to physical assets.

---

## 3. Data Integrity & Consistency Rules

1. **Foreign Key Cascades**:
   - `FK_FactoryMachines_Factories`: Set to `ON DELETE CASCADE` so factory account deletions cleanly remove plant equipment assets.
   - `FK_FactoryMachines_Machines`: Restrict deletion of master machine specifications if linked plant equipment exists.
2. **Unique Constraints**:
   - `UQ_FactoryMachines_Factory_AssetTag`: Guarantees asset tags are unique per factory, preventing internal duplicate tags while allowing different factories to utilize their own tagging conventions.
3. **Audit Trails**:
   - `CreatedAt` and `UpdatedAt` timestamps tracked on all equipment records.
4. **Order Items Atomic Population**:
   - `QuotationLogic.acceptBidTransaction` ensures that whenever an RFQ bid is accepted, both `Orders` and `OrderItems` records are inserted atomically within an ADO.NET SQL transaction, resolving previous empty order items anomalies.
