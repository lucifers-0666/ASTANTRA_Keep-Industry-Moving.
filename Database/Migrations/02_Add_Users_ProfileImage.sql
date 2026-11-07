-- ============================================================================
-- ASTANTRA — Migration 02: Add ProfileImage Column to Users Table
-- Supports custom profile avatar uploads, cropping, and dynamic display across
-- Admin, Factory, Supplier, and Technician portals.
-- ============================================================================

USE IndustrialSparePartDB;
GO

IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'ProfileImage'
)
BEGIN
    ALTER TABLE Users ADD ProfileImage NVARCHAR(350) NULL;
    PRINT 'SUCCESS: Column ProfileImage (NVARCHAR(350) NULL) added to Users table.';
END
ELSE
BEGIN
    PRINT 'INFO: Column ProfileImage already exists on Users table.';
END
GO

