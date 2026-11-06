-- ============================================================================
-- ASTANTRA — Migration 01: Add Address Column to Technicians Table
-- Root Cause: AdminLogic.cs, UserLogic.cs, and ManageTechnicians.aspx reference
-- t.Address, but 01_CreateTables.sql omitted Address from Technicians definition.
-- ============================================================================

USE IndustrialSparePartDB;
GO

IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Technicians' AND COLUMN_NAME = 'Address'
)
BEGIN
    ALTER TABLE Technicians ADD Address NVARCHAR(255) NULL;
    PRINT 'SUCCESS: Column Address (NVARCHAR(255) NULL) added to Technicians table.';
END
ELSE
BEGIN
    PRINT 'INFO: Column Address already exists on Technicians table.';
END
GO
