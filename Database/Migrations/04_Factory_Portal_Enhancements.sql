-- ============================================================================
-- ASTANTRA Platform — Migration 04: Factory Buyer Portal Enhancements
-- Description: Creates FactoryMachines asset registry, adds ContactPhone to Factories,
--              links EmergencyRequests to factory equipment, and seeds multi-tenant data.
-- ============================================================================

USE [IndustrialSparePartDB];
GO

-- 1. Create FactoryMachines table for individual plant floor assets
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FactoryMachines')
BEGIN
    CREATE TABLE [dbo].[FactoryMachines] (
        [FactoryMachineId] INT IDENTITY(1,1) NOT NULL,
        [FactoryId] INT NOT NULL,
        [MachineId] INT NOT NULL,
        [AssetTag] NVARCHAR(50) NOT NULL,
        [SerialNumber] NVARCHAR(100) NULL,
        [Department] NVARCHAR(100) NULL,
        [InstalledDate] DATE NULL,
        [Status] VARCHAR(20) NOT NULL DEFAULT 'Operational', -- 'Operational', 'Under Maintenance', 'Offline', 'Decommissioned'
        [Notes] NVARCHAR(MAX) NULL,
        [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
        [UpdatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_FactoryMachines] PRIMARY KEY CLUSTERED ([FactoryMachineId] ASC),
        CONSTRAINT [FK_FactoryMachines_Factories] FOREIGN KEY ([FactoryId]) REFERENCES [dbo].[Factories] ([FactoryId]) ON DELETE CASCADE,
        CONSTRAINT [FK_FactoryMachines_Machines] FOREIGN KEY ([MachineId]) REFERENCES [dbo].[Machines] ([MachineId]),
        CONSTRAINT [UQ_FactoryMachines_Factory_AssetTag] UNIQUE ([FactoryId], [AssetTag])
    );

    CREATE NONCLUSTERED INDEX [IX_FactoryMachines_FactoryId] ON [dbo].[FactoryMachines] ([FactoryId]);
    CREATE NONCLUSTERED INDEX [IX_FactoryMachines_MachineId] ON [dbo].[FactoryMachines] ([MachineId]);
    CREATE NONCLUSTERED INDEX [IX_FactoryMachines_Status] ON [dbo].[FactoryMachines] ([Status]);

    PRINT 'Table FactoryMachines created successfully.';
END
ELSE
BEGIN
    PRINT 'Table FactoryMachines already exists.';
END
GO

-- 2. Add ContactPhone to Factories table if missing
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.Factories') AND name = 'ContactPhone'
)
BEGIN
    ALTER TABLE [dbo].[Factories] ADD [ContactPhone] VARCHAR(20) NULL;
    PRINT 'Column ContactPhone added to Factories table.';
END
GO

-- 3. Add FactoryMachineId to EmergencyRequests table if missing
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.EmergencyRequests') AND name = 'FactoryMachineId'
)
BEGIN
    ALTER TABLE [dbo].[EmergencyRequests] ADD [FactoryMachineId] INT NULL;
    ALTER TABLE [dbo].[EmergencyRequests] ADD CONSTRAINT [FK_EmergencyRequests_FactoryMachines] 
        FOREIGN KEY ([FactoryMachineId]) REFERENCES [dbo].[FactoryMachines] ([FactoryMachineId]);
    PRINT 'Column FactoryMachineId added to EmergencyRequests table.';
END
GO

-- 4. Seed initial equipment fleet for Factory 1 (Gujarat Heavy Machinery Works)
IF EXISTS (SELECT 1 FROM [dbo].[Factories] WHERE [FactoryId] = 1)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[FactoryMachines] WHERE [FactoryId] = 1 AND [AssetTag] = 'GHM-CNC-001')
    BEGIN
        INSERT INTO [dbo].[FactoryMachines] ([FactoryId], [MachineId], [AssetTag], [SerialNumber], [Department], [InstalledDate], [Status], [Notes])
        VALUES (1, 1, 'GHM-CNC-001', 'SN-X200-88412', 'Precision Lathe Bay 1', '2023-04-15', 'Operational', 'Primary shaft turning center. Routine coolant flush scheduled monthly.');
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[FactoryMachines] WHERE [FactoryId] = 1 AND [AssetTag] = 'GHM-PRS-002')
    BEGIN
        INSERT INTO [dbo].[FactoryMachines] ([FactoryId], [MachineId], [AssetTag], [SerialNumber], [Department], [InstalledDate], [Status], [Notes])
        VALUES (1, 2, 'GHM-PRS-002', 'SN-SP500-44910', 'Heavy Stamping Line A', '2022-09-20', 'Operational', '500-ton hydraulic press for automotive sheet stamping.');
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[FactoryMachines] WHERE [FactoryId] = 1 AND [AssetTag] = 'GHM-CMP-003')
    BEGIN
        INSERT INTO [dbo].[FactoryMachines] ([FactoryId], [MachineId], [AssetTag], [SerialNumber], [Department], [InstalledDate], [Status], [Notes])
        VALUES (1, 3, 'GHM-CMP-003', 'SN-AC75-10294', 'Central Powerhouse', '2024-01-10', 'Operational', 'Screw air compressor supplying 8 bar clean compressed air to whole plant.');
    END

    UPDATE [dbo].[Factories]
    SET [ContactPhone] = '+91 98251 44520'
    WHERE [FactoryId] = 1 AND [ContactPhone] IS NULL;

    PRINT 'Initial machinery seeded for Factory 1.';
END
GO

-- 5. Seed second Factory account for verified multi-tenant data isolation testing
-- Factory 2: Baroda Precision Forging Works Ltd (User: factory2@baroda-forge.com / Factory@123)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Email] = 'factory2@baroda-forge.com')
BEGIN
    DECLARE @FactoryRoleId INT = (SELECT [RoleId] FROM [dbo].[Roles] WHERE [RoleName] = 'Factory');
    DECLARE @NewUserId INT;

    INSERT INTO [dbo].[Users] ([RoleId], [Email], [PasswordHash], [Salt], [FullName], [PhoneNumber], [IsActive], [IsVerified], [CreatedAt])
    VALUES (
        @FactoryRoleId, 
        'factory2@baroda-forge.com', 
        'PBKDF2$10000$IHe435gkO5Jt7tm4RSGkjsir1FtvdWNFJoV5PC3EY+8=', 
        'c2FsdDRmYWN0b3J5MmFjYw==', 
        'Baroda Precision Forging Works', 
        '+91 98250 12345', 
        1, 
        1, 
        GETDATE()
    );
    SET @NewUserId = SCOPE_IDENTITY();

    INSERT INTO [dbo].[Factories] ([UserId], [CompanyName], [IndustryType], [Address], [City], [State], [Pincode], [Gstin], [ContactPerson], [ContactPhone], [CreatedAt])
    VALUES (
        @NewUserId,
        'Baroda Precision Forging Works Ltd',
        'Automotive & Heavy Forging',
        'Plot 42, GIDC Industrial Estate, Makarpura',
        'Vadodara',
        'Gujarat',
        '390010',
        '24AAACB9988G1Z5',
        'Rajesh Patel (Plant Head)',
        '+91 98250 12345',
        GETDATE()
    );

    DECLARE @NewFactoryId INT = SCOPE_IDENTITY();

    -- Seed machinery assets for Factory 2
    INSERT INTO [dbo].[FactoryMachines] ([FactoryId], [MachineId], [AssetTag], [SerialNumber], [Department], [InstalledDate], [Status], [Notes])
    VALUES 
        (@NewFactoryId, 1, 'BPF-CNC-001', 'SN-X200-99104', 'Machining Division', '2023-11-01', 'Operational', 'CNC lathe for forged gear blanks.'),
        (@NewFactoryId, 2, 'BPF-PRS-002', 'SN-SP500-77312', 'Forge Press Shop 2', '2021-06-18', 'Operational', 'Primary hot-forging press.');

    -- Seed an independent RFQ for Factory 2 to verify data isolation
    INSERT INTO [dbo].[QuotationRequests] ([FactoryId], [PartId], [Quantity], [TargetPrice], [RequiredByDate], [Status], [Remarks], [CreatedAt])
    VALUES (@NewFactoryId, 1, 4, 32000.00, DATEADD(DAY, 14, GETDATE()), 'Pending', 'Confidential RFQ for Baroda Forge plant expansion.', GETDATE());

    PRINT 'Factory 2 created with ID: ' + CAST(@NewFactoryId AS VARCHAR(10));
END
ELSE
BEGIN
    PRINT 'Factory 2 already exists.';
END
GO
