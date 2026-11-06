-- ============================================================================
-- Industrial Spare-Part Finder & Emergency Procurement Portal
-- Enterprise Database Schema Extension (Audit, OrderItems, Due Diligence, Settings)
-- ============================================================================

USE IndustrialSparePartDB;
GO

-- 16. AUDIT LOGS TABLE
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AuditLogs')
BEGIN
    CREATE TABLE AuditLogs (
        LogId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NULL FOREIGN KEY REFERENCES Users(UserId),
        ActionType VARCHAR(50) NOT NULL, -- CREATE, UPDATE, DELETE, VERIFY, STATUS_CHANGE, LOGIN, OVERRIDE
        TargetEntity VARCHAR(50) NOT NULL, -- User, Factory, Supplier, Technician, Part, Category, Machine, Order, RFQ
        EntityId INT NULL,
        OldValue NVARCHAR(MAX) NULL,
        NewValue NVARCHAR(MAX) NULL,
        IpAddress VARCHAR(50) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
    CREATE INDEX IX_AuditLogs_Target ON AuditLogs(TargetEntity, EntityId);
    CREATE INDEX IX_AuditLogs_CreatedAt ON AuditLogs(CreatedAt DESC);
END
GO

-- 17. ORDER ITEMS TABLE (Normalized Order Line Items)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderItems')
BEGIN
    CREATE TABLE OrderItems (
        OrderItemId INT IDENTITY(1,1) PRIMARY KEY,
        OrderId INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderId) ON DELETE CASCADE,
        PartId INT NOT NULL FOREIGN KEY REFERENCES SpareParts(PartId),
        Quantity INT NOT NULL DEFAULT 1,
        UnitPrice DECIMAL(12,2) NOT NULL,
        TotalPrice AS (Quantity * UnitPrice) PERSISTED,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
    CREATE INDEX IX_OrderItems_OrderId ON OrderItems(OrderId);
END
GO

-- 18. SUPPLIER CERTIFICATES TABLE (Due Diligence & Compliance)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierCertificates')
BEGIN
    CREATE TABLE SupplierCertificates (
        CertificateId INT IDENTITY(1,1) PRIMARY KEY,
        SupplierId INT NOT NULL FOREIGN KEY REFERENCES Suppliers(SupplierId) ON DELETE CASCADE,
        CertificateType VARCHAR(50) NOT NULL, -- GSTIN_Certificate, MSME_Udyam, Trade_License, ISO_9001
        CertificateNumber VARCHAR(100) NULL,
        DocumentUrl NVARCHAR(255) NULL,
        VerificationStatus VARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Verified, Rejected
        AdminRemarks NVARCHAR(255) NULL,
        VerifiedByUserId INT NULL FOREIGN KEY REFERENCES Users(UserId),
        VerifiedAt DATETIME NULL,
        UploadedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
    CREATE INDEX IX_SupplierCertificates_SupplierId ON SupplierCertificates(SupplierId);
END
GO

-- 19. SYSTEM SETTINGS TABLE (Platform Configurations)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SystemSettings')
BEGIN
    CREATE TABLE SystemSettings (
        SettingKey VARCHAR(50) PRIMARY KEY,
        SettingValue NVARCHAR(MAX) NOT NULL,
        Category VARCHAR(50) NOT NULL DEFAULT 'General',
        Description NVARCHAR(255) NULL,
        LastUpdatedBy INT NULL FOREIGN KEY REFERENCES Users(UserId),
        UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- Seed Default System Settings
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE SettingKey = 'PlatformMaintenanceMode')
    INSERT INTO SystemSettings (SettingKey, SettingValue, Category, Description) VALUES ('PlatformMaintenanceMode', 'False', 'System', 'Toggle maintenance outage mode');

IF NOT EXISTS (SELECT * FROM SystemSettings WHERE SettingKey = 'EmergencyBroadcastRadiusKm')
    INSERT INTO SystemSettings (SettingKey, SettingValue, Category, Description) VALUES ('EmergencyBroadcastRadiusKm', '100', 'Emergency', 'Maximum regional broadcast radius for machine breakdown SOS');

IF NOT EXISTS (SELECT * FROM SystemSettings WHERE SettingKey = 'SupplierVerificationMandatory')
    INSERT INTO SystemSettings (SettingKey, SettingValue, Category, Description) VALUES ('SupplierVerificationMandatory', 'True', 'Security', 'Require admin verification before supplier can submit quotation bids');
GO
