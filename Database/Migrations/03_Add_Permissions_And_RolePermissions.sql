-- ============================================================================
-- ASTANTRA Industrial Procurement Portal - Database Migration 03
-- Purpose: Add Permissions and RolePermissions tables for granular RBAC
-- ============================================================================

USE [IndustrialSparePartDB];
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Permissions')
BEGIN
    CREATE TABLE Permissions (
        PermissionId INT IDENTITY(1,1) PRIMARY KEY,
        PermissionKey VARCHAR(80) NOT NULL UNIQUE,
        Module VARCHAR(50) NOT NULL,
        DisplayName NVARCHAR(100) NOT NULL,
        Description NVARCHAR(255) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
    PRINT 'Created Permissions table';
END
ELSE
BEGIN
    PRINT 'Permissions table already exists';
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'RolePermissions')
BEGIN
    CREATE TABLE RolePermissions (
        RoleId INT NOT NULL,
        PermissionId INT NOT NULL,
        GrantedAt DATETIME NOT NULL DEFAULT GETDATE(),
        GrantedBy INT NULL,
        CONSTRAINT PK_RolePermissions PRIMARY KEY (RoleId, PermissionId),
        CONSTRAINT FK_RolePermissions_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId) ON DELETE CASCADE,
        CONSTRAINT FK_RolePermissions_Permissions FOREIGN KEY (PermissionId) REFERENCES Permissions(PermissionId) ON DELETE CASCADE
    );
    PRINT 'Created RolePermissions table';
END
ELSE
BEGIN
    PRINT 'RolePermissions table already exists';
END
GO

-- Seed Standard Platform Permissions
MERGE INTO Permissions AS target
USING (VALUES
    ('admin.dashboard.view', 'Governance', 'View Executive Dashboard', 'Access high-level telemetry and executive KPI counters'),
    ('admin.users.manage', 'User Management', 'Manage Platform Users', 'Register, edit, activate, deactivate and reset passwords for accounts'),
    ('admin.factories.manage', 'Industrial Plants', 'Manage Factory Registry', 'Maintain manufacturing facilities and buyer entity profiles'),
    ('admin.suppliers.verify', 'Compliance', 'Verify Suppliers & GSTIN', 'Inspect compliance dossiers, approve or reject supplier applications'),
    ('admin.technicians.manage', 'Field Services', 'Manage Service Technicians', 'Manage certified industrial field service engineers and hourly rates'),
    ('admin.catalog.manage', 'Catalog Architecture', 'Manage Parts & Taxonomy', 'Maintain machine categories, machinery profiles, and master parts catalog'),
    ('admin.orders.oversight', 'Procurement', 'Procurement & SOS Oversight', 'Monitor purchase orders, RFQs, and triage emergency breakdown dispatches'),
    ('admin.audit.view', 'Security Governance', 'Inspect Audit Trail', 'Review immutable system logs, forensic event traces, and administrative actions'),
    ('admin.security.manage', 'Security Governance', 'Manage Authentication & Sessions', 'Monitor security events, active sessions, and password policies'),
    ('admin.settings.manage', 'System Governance', 'Configure Platform Settings', 'Modify global operational configuration and feature flags'),
    ('factory.rfq.create', 'Factory Portal', 'Issue RFQ Quotations', 'Create and publish requests for quotation to stocking vendors'),
    ('factory.emergency.report', 'Factory Portal', 'Report Emergency SOS', 'Dispatch critical emergency machinery breakdown alerts'),
    ('factory.orders.manage', 'Factory Portal', 'Purchase Orders', 'Confirm quotations, issue purchase orders, and monitor waybills'),
    ('supplier.inventory.manage', 'Supplier Hub', 'Manage Stock Inventory', 'Publish stock inventory listings, lead times, and unit pricing'),
    ('supplier.bids.submit', 'Supplier Hub', 'Submit Quotation Bids', 'Respond to open RFQs with commercial quotations and delivery estimates'),
    ('supplier.orders.fulfill', 'Supplier Hub', 'Fulfill Consignments', 'Accept purchase orders, update dispatch waybills, and generate invoices'),
    ('technician.jobs.accept', 'Technician Portal', 'Accept Service Calls', 'Receive breakdown tickets, manage maintenance schedule, and log resolutions'),
    ('technician.duty.toggle', 'Technician Portal', 'Manage Duty Availability', 'Toggle active dispatch status and update operational travel radiuses')
) AS source (PermissionKey, Module, DisplayName, Description)
ON target.PermissionKey = source.PermissionKey
WHEN NOT MATCHED THEN
    INSERT (PermissionKey, Module, DisplayName, Description, CreatedAt)
    VALUES (source.PermissionKey, source.Module, source.DisplayName, source.Description, GETDATE());
GO

-- Grant Permissions to Administrator (RoleId = 1: Full Access)
INSERT INTO RolePermissions (RoleId, PermissionId, GrantedAt, GrantedBy)
SELECT 1, p.PermissionId, GETDATE(), 1
FROM Permissions p
WHERE NOT EXISTS (SELECT 1 FROM RolePermissions rp WHERE rp.RoleId = 1 AND rp.PermissionId = p.PermissionId);
GO

-- Grant Permissions to Factory (RoleId = 2)
INSERT INTO RolePermissions (RoleId, PermissionId, GrantedAt, GrantedBy)
SELECT 2, p.PermissionId, GETDATE(), 1
FROM Permissions p
WHERE p.PermissionKey IN ('factory.rfq.create', 'factory.emergency.report', 'factory.orders.manage')
  AND NOT EXISTS (SELECT 1 FROM RolePermissions rp WHERE rp.RoleId = 2 AND rp.PermissionId = p.PermissionId);
GO

-- Grant Permissions to Supplier (RoleId = 3)
INSERT INTO RolePermissions (RoleId, PermissionId, GrantedAt, GrantedBy)
SELECT 3, p.PermissionId, GETDATE(), 1
FROM Permissions p
WHERE p.PermissionKey IN ('supplier.inventory.manage', 'supplier.bids.submit', 'supplier.orders.fulfill')
  AND NOT EXISTS (SELECT 1 FROM RolePermissions rp WHERE rp.RoleId = 3 AND rp.PermissionId = p.PermissionId);
GO

-- Grant Permissions to Technician (RoleId = 4)
INSERT INTO RolePermissions (RoleId, PermissionId, GrantedAt, GrantedBy)
SELECT 4, p.PermissionId, GETDATE(), 1
FROM Permissions p
WHERE p.PermissionKey IN ('technician.jobs.accept', 'technician.duty.toggle')
  AND NOT EXISTS (SELECT 1 FROM RolePermissions rp WHERE rp.RoleId = 4 AND rp.PermissionId = p.PermissionId);
GO

PRINT 'Granular permissions and role mappings seeded successfully.';
GO

