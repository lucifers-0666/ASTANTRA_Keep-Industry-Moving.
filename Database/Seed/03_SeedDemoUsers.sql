-- ============================================================================
-- Seed Demo Accounts for Factory, Supplier, and Technician
-- ============================================================================

USE IndustrialSparePartDB;
GO

-- 1. FACTORY BUYER (Password: Factory@123)
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'factory@plant.com')
BEGIN
    INSERT INTO Users (RoleId, Email, PasswordHash, Salt, FullName, PhoneNumber, IsActive, IsVerified, CreatedAt)
    VALUES (2, 'factory@plant.com', 'bJkasqzP4gLL0dqTBhTwSktP+zh9WbSWn+QyeVQsxmw=', 'StaticSalt123456', 'Gujarat Heavy Machinery Works', '+91 9825012345', 1, 1, GETDATE());
    
    DECLARE @fid INT = SCOPE_IDENTITY();
    
    INSERT INTO Factories (UserId, CompanyName, IndustryType, Address, City, State, Pincode, Gstin, ContactPerson)
    VALUES (@fid, 'Gujarat Heavy Machinery Works Pvt Ltd', 'Automotive & Heavy Forging', 'Plot 42, GIDC Phase II, Aji Industrial Area', 'Rajkot', 'Gujarat', '360002', '24AAACG1234F1Z5', 'Rajesh Patel');
    
    PRINT 'Factory Buyer seeded successfully.';
END
GO

-- 2. SPARE-PART SUPPLIER (Password: Supplier@123)
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'supplier@parts.com')
BEGIN
    INSERT INTO Users (RoleId, Email, PasswordHash, Salt, FullName, PhoneNumber, IsActive, IsVerified, CreatedAt)
    VALUES (3, 'supplier@parts.com', 'xQZeP3mSkPH8AIOH6HvEJ6DHx9O7lcPxnGuaSG+oM6Y=', 'StaticSalt123456', 'Apex Industrial Spares & Bearings', '+91 9879054321', 1, 1, GETDATE());
    
    DECLARE @sid INT = SCOPE_IDENTITY();
    
    INSERT INTO Suppliers (UserId, CompanyName, BusinessRegistrationNo, Gstin, Address, City, State, Pincode, VerificationStatus, Rating)
    VALUES (@sid, 'Apex Industrial Spares & Bearings Co.', 'REG-GJ-2022-8871', '24AABCA5678B1Z2', 'G-12, Naroda Industrial Estate', 'Ahmedabad', 'Gujarat', '380015', 'Verified', 4.85);
    
    PRINT 'Supplier seeded successfully.';
END
GO

-- 3. FIELD SERVICE TECHNICIAN (Password: Tech@123)
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'tech@service.com')
BEGIN
    INSERT INTO Users (RoleId, Email, PasswordHash, Salt, FullName, PhoneNumber, IsActive, IsVerified, CreatedAt)
    VALUES (4, 'tech@service.com', 'MGFLkeeDtoDaTeAmavrsrK8ol/k1TRrKTDCbqVpoUgo=', 'StaticSalt123456', 'Vikram Sharma', '+91 9898011223', 1, 1, GETDATE());
    
    DECLARE @tid INT = SCOPE_IDENTITY();
    
    INSERT INTO Technicians (UserId, SkillSummary, ExperienceYears, HourlyRate, City, State, Pincode, IsAvailable, VerificationStatus)
    VALUES (@tid, 'Hydraulic Systems, CNC Spindle Alignment, PLC Troubleshooting', 8, 850.00, 'Vadodara', 'Gujarat', '390001', 1, 'Verified');
    
    PRINT 'Technician seeded successfully.';
END
GO

