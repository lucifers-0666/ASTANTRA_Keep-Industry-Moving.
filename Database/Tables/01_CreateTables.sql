-- ============================================================================
-- Industrial Spare-Part Finder & Emergency Procurement Portal
-- Database Schema Script (SQL Server)
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'IndustrialSparePartDB')
BEGIN
    CREATE DATABASE IndustrialSparePartDB;
END
GO

USE IndustrialSparePartDB;
GO

-- 1. ROLES TABLE
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Roles')
BEGIN
    CREATE TABLE Roles (
        RoleId INT IDENTITY(1,1) PRIMARY KEY,
        RoleName VARCHAR(50) NOT NULL UNIQUE,
        Description NVARCHAR(255) NULL
    );
END
GO

-- 2. USERS TABLE
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        UserId INT IDENTITY(1,1) PRIMARY KEY,
        RoleId INT NOT NULL FOREIGN KEY REFERENCES Roles(RoleId),
        Email VARCHAR(100) NOT NULL UNIQUE,
        PasswordHash VARCHAR(255) NOT NULL,
        Salt VARCHAR(100) NOT NULL,
        FullName NVARCHAR(100) NOT NULL,
        PhoneNumber VARCHAR(20) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        IsVerified BIT NOT NULL DEFAULT 0,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedAt DATETIME NULL
    );
    CREATE INDEX IX_Users_Email ON Users(Email);
END
GO

-- 3. FACTORIES (INDUSTRIAL BUYERS)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Factories')
BEGIN
    CREATE TABLE Factories (
        FactoryId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Users(UserId) ON DELETE CASCADE,
        CompanyName NVARCHAR(150) NOT NULL,
        IndustryType NVARCHAR(100) NULL,
        Address NVARCHAR(255) NULL,
        City NVARCHAR(50) NULL,
        State NVARCHAR(50) NULL,
        Pincode VARCHAR(10) NULL,
        Gstin VARCHAR(20) NULL,
        ContactPerson NVARCHAR(100) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 4. SUPPLIERS
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Suppliers')
BEGIN
    CREATE TABLE Suppliers (
        SupplierId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Users(UserId) ON DELETE CASCADE,
        CompanyName NVARCHAR(150) NOT NULL,
        BusinessRegistrationNo VARCHAR(50) NULL,
        Gstin VARCHAR(20) NULL,
        Address NVARCHAR(255) NULL,
        City NVARCHAR(50) NULL,
        State NVARCHAR(50) NULL,
        Pincode VARCHAR(10) NULL,
        VerificationStatus VARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Verified, Rejected
        Rating DECIMAL(3,2) NOT NULL DEFAULT 0.00,
        DocumentPath NVARCHAR(255) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 5. TECHNICIANS
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Technicians')
BEGIN
    CREATE TABLE Technicians (
        TechnicianId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Users(UserId) ON DELETE CASCADE,
        SkillSummary NVARCHAR(255) NULL,
        ExperienceYears INT NOT NULL DEFAULT 0,
        HourlyRate DECIMAL(10,2) NOT NULL DEFAULT 0.00,
        Address NVARCHAR(255) NULL,
        City NVARCHAR(50) NULL,
        State NVARCHAR(50) NULL,
        Pincode VARCHAR(10) NULL,
        IsAvailable BIT NOT NULL DEFAULT 1,
        VerificationStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
        DocumentPath NVARCHAR(255) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 6. SPARE-PART CATEGORIES
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categories')
BEGIN
    CREATE TABLE Categories (
        CategoryId INT IDENTITY(1,1) PRIMARY KEY,
        CategoryName NVARCHAR(100) NOT NULL UNIQUE,
        Description NVARCHAR(255) NULL,
        IconClass VARCHAR(50) NULL DEFAULT 'fa-cogs',
        IsActive BIT NOT NULL DEFAULT 1
    );
END
GO

-- 7. MACHINES
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Machines')
BEGIN
    CREATE TABLE Machines (
        MachineId INT IDENTITY(1,1) PRIMARY KEY,
        MachineName NVARCHAR(150) NOT NULL,
        ModelNumber NVARCHAR(100) NULL,
        Manufacturer NVARCHAR(100) NULL,
        Description NVARCHAR(MAX) NULL
    );
END
GO

-- 8. SPARE PARTS CATALOG
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SpareParts')
BEGIN
    CREATE TABLE SpareParts (
        PartId INT IDENTITY(1,1) PRIMARY KEY,
        CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryId),
        MachineId INT NULL FOREIGN KEY REFERENCES Machines(MachineId),
        PartNumber VARCHAR(100) NOT NULL UNIQUE,
        PartName NVARCHAR(150) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        TechnicalSpecs NVARCHAR(MAX) NULL,
        UnitOfMeasure NVARCHAR(20) DEFAULT 'Piece',
        ImageUrl NVARCHAR(255) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
    CREATE INDEX IX_SpareParts_PartNumber ON SpareParts(PartNumber);
END
GO

-- 9. SUPPLIER INVENTORY
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierInventory')
BEGIN
    CREATE TABLE SupplierInventory (
        InventoryId INT IDENTITY(1,1) PRIMARY KEY,
        SupplierId INT NOT NULL FOREIGN KEY REFERENCES Suppliers(SupplierId),
        PartId INT NOT NULL FOREIGN KEY REFERENCES SpareParts(PartId),
        UnitPrice DECIMAL(12,2) NOT NULL,
        StockQuantity INT NOT NULL DEFAULT 0,
        AvailabilityStatus VARCHAR(20) NOT NULL DEFAULT 'InStock', -- InStock, OutOfStock, PreOrder
        LeadTimeDays INT NOT NULL DEFAULT 1,
        LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT UQ_Supplier_Part UNIQUE(SupplierId, PartId)
    );
END
GO

-- 10. QUOTATION REQUESTS (RFQ)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'QuotationRequests')
BEGIN
    CREATE TABLE QuotationRequests (
        RfqId INT IDENTITY(1,1) PRIMARY KEY,
        FactoryId INT NOT NULL FOREIGN KEY REFERENCES Factories(FactoryId),
        PartId INT NOT NULL FOREIGN KEY REFERENCES SpareParts(PartId),
        Quantity INT NOT NULL,
        TargetPrice DECIMAL(12,2) NULL,
        RequiredByDate DATE NULL,
        Status VARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Quoted, Accepted, Closed
        Remarks NVARCHAR(MAX) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 11. QUOTATION RESPONSES
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'QuotationResponses')
BEGIN
    CREATE TABLE QuotationResponses (
        ResponseId INT IDENTITY(1,1) PRIMARY KEY,
        RfqId INT NOT NULL FOREIGN KEY REFERENCES QuotationRequests(RfqId),
        SupplierId INT NOT NULL FOREIGN KEY REFERENCES Suppliers(SupplierId),
        OfferedUnitPrice DECIMAL(12,2) NOT NULL,
        OfferedLeadTimeDays INT NOT NULL,
        ValidityDate DATE NULL,
        Status VARCHAR(20) NOT NULL DEFAULT 'Submitted', -- Submitted, Accepted, Rejected
        Comments NVARCHAR(MAX) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 12. EMERGENCY BREAKDOWN REQUESTS
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmergencyRequests')
BEGIN
    CREATE TABLE EmergencyRequests (
        EmergencyRequestId INT IDENTITY(1,1) PRIMARY KEY,
        FactoryId INT NOT NULL FOREIGN KEY REFERENCES Factories(FactoryId),
        PartId INT NULL FOREIGN KEY REFERENCES SpareParts(PartId),
        MachineName NVARCHAR(150) NOT NULL,
        BreakdownDescription NVARCHAR(MAX) NOT NULL,
        PriorityLevel VARCHAR(20) NOT NULL DEFAULT 'Critical', -- High, Critical, Immediate
        LocationCity NVARCHAR(50) NOT NULL,
        Status VARCHAR(20) NOT NULL DEFAULT 'Open', -- Open, Dispatched, Resolved, Closed
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 13. ORDERS & PROCUREMENT TRACKING
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
BEGIN
    CREATE TABLE Orders (
        OrderId INT IDENTITY(1,1) PRIMARY KEY,
        OrderNumber VARCHAR(50) NOT NULL UNIQUE,
        FactoryId INT NOT NULL FOREIGN KEY REFERENCES Factories(FactoryId),
        SupplierId INT NOT NULL FOREIGN KEY REFERENCES Suppliers(SupplierId),
        TotalAmount DECIMAL(12,2) NOT NULL,
        OrderStatus VARCHAR(30) NOT NULL DEFAULT 'Placed', -- Placed, Processing, Shipped, Delivered, Cancelled
        IsEmergency BIT NOT NULL DEFAULT 0,
        ShippingAddress NVARCHAR(MAX) NULL,
        TrackingNumber VARCHAR(100) NULL,
        OrderDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 14. SERVICE REQUESTS (TECHNICIANS)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceRequests')
BEGIN
    CREATE TABLE ServiceRequests (
        ServiceRequestId INT IDENTITY(1,1) PRIMARY KEY,
        FactoryId INT NOT NULL FOREIGN KEY REFERENCES Factories(FactoryId),
        TechnicianId INT NOT NULL FOREIGN KEY REFERENCES Technicians(TechnicianId),
        ServiceType NVARCHAR(100) NOT NULL,
        IssueDescription NVARCHAR(MAX) NOT NULL,
        ScheduledDate DATETIME NOT NULL,
        ServiceStatus VARCHAR(20) NOT NULL DEFAULT 'Requested', -- Requested, Accepted, Completed, Cancelled
        Notes NVARCHAR(MAX) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- 15. NOTIFICATIONS
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Notifications')
BEGIN
    CREATE TABLE Notifications (
        NotificationId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
        Title NVARCHAR(150) NOT NULL,
        Message NVARCHAR(MAX) NOT NULL,
        IsRead BIT NOT NULL DEFAULT 0,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO
