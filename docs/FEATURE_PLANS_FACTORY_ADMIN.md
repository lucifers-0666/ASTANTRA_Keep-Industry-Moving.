# ASTANTRA — Feature Planning Blueprints (Factory Buyer & Administrator)
**Deliverable for Project Lead Development (Section 5 & 6)**  
**Project:** ASTANTRA — Keep Industry Moving  
**Lead Developer:** Zaid Amreliya  

This guide provides the exact database tables, columns, expected inputs, queries, validation rules, permissions, and test cases for each page owned by the Project Lead. Use these specifications to write and defend your backend code using the professor's taught ADO.NET method.

---

## 1. Factory Buyer Panel (6 Pages)

### Page FB-01: `Factory/Dashboard.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Factory` (`BasePage.RequiredRole = RoleConstants.Factory`)
- **Tables & Columns Involved:**
  - `Factories` (`FactoryId`, `UserId`, `CompanyName`, `City`, `State`)
  - `QuotationRequests` (`RfqId`, `FactoryId`, `Status`, `CreatedAt`)
  - `Orders` (`OrderId`, `FactoryId`, `TotalAmount`, `OrderStatus`)
  - `EmergencyRequests` (`EmergencyRequestId`, `FactoryId`, `MachineName`, `PriorityLevel`, `Status`)
- **Key Operations:**
  1. `SELECT FactoryId FROM Factories WHERE UserId = @UserId`
  2. Aggregated count queries for KPI cards:
     - `SELECT COUNT(*) FROM QuotationRequests WHERE FactoryId = @FactoryId AND Status = 'Pending'`
     - `SELECT COUNT(*) FROM Orders WHERE FactoryId = @FactoryId AND OrderStatus IN ('Placed', 'Processing', 'Shipped')`
     - `SELECT COUNT(*) FROM EmergencyRequests WHERE FactoryId = @FactoryId AND Status = 'Open'`
- **Test Strategy:** Sign in as `factory@plant.com`. Verify plant name displays "Gujarat Heavy Machinery Works", KPIs render real numeric counts, and emergency alert notices render if query string contains `?msg=emergency_submitted`.

---

### Page FB-02: `Factory/SpareParts/Search.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Factory`
- **Tables & Columns Involved:**
  - `Categories` (`CategoryId`, `CategoryName`, `IsActive`)
  - `Machines` (`MachineId`, `MachineName`)
  - `SpareParts` (`PartId`, `CategoryId`, `MachineId`, `PartNumber`, `PartName`, `TechnicalSpecs`, `UnitOfMeasure`)
  - `QuotationRequests` (`FactoryId`, `PartId`, `Quantity`, `TargetPrice`, `RequiredByDate`, `Status`, `Remarks`, `CreatedAt`)
- **Inputs & Controls:**
  - `txtKeyword` (TextBox - Part # or name)
  - `ddlCategory` (DropDownList - Filter by category)
  - `ddlMachine` (DropDownList - Filter by compatible machine)
  - `txtModalQuantity` (TextBox - Number $\ge 1$)
  - `txtModalTargetPrice` (TextBox - Optional decimal)
  - `txtModalRequiredDate` (TextBox - Date)
  - `txtModalRemarks` (TextBox - Delivery notes)
- **Validation & Error Cases:**
  - `Quantity` must be a positive integer ($> 0$).
  - Target price, if entered, must be a valid positive decimal.
  - If database insert fails, show red error alert and log exception.
- **SQL Execution:**
  - Filter: Parameterized `SELECT ... FROM SpareParts p INNER JOIN Categories c ... WHERE (p.PartNumber LIKE @Keyword OR ...)`
  - RFQ Insert: Parameterized `INSERT INTO QuotationRequests ...; SELECT SCOPE_IDENTITY();`

---

### Page FB-03: `Factory/Quotations/MyRequests.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Factory`
- **Tables & Columns Involved:**
  - `QuotationRequests` (`RfqId`, `FactoryId`, `PartId`, `Quantity`, `TargetPrice`, `Status`, `CreatedAt`)
  - `SpareParts` (`PartNumber`, `PartName`)
  - `QuotationResponses` (`ResponseId`, `RfqId`, `Status`)
- **Key Operations:**
  - `SELECT q.RfqId, q.Quantity, q.TargetPrice, q.Status, q.CreatedAt, p.PartNumber, p.PartName, (SELECT COUNT(*) FROM QuotationResponses r WHERE r.RfqId = q.RfqId) AS BidCount FROM QuotationRequests q INNER JOIN SpareParts p ON q.PartId = p.PartId WHERE q.FactoryId = @FactoryId ORDER BY q.CreatedAt DESC`
  - Filter by `Status` dropdown (`Pending`, `Quoted`, `Accepted`, `Closed`).
  - RowCommand `CompareBids`: Redirects to `Compare.aspx?rfqId={RfqId}`.

---

### Page FB-04: `Factory/Quotations/Compare.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Factory`
- **Tables & Columns Involved:**
  - `QuotationRequests` (`RfqId`, `FactoryId`, `Status`)
  - `QuotationResponses` (`ResponseId`, `RfqId`, `SupplierId`, `OfferedUnitPrice`, `OfferedLeadTimeDays`, `Status`, `Comments`)
  - `Suppliers` (`SupplierId`, `CompanyName`, `City`, `Rating`)
  - `Orders` (`OrderId`, `OrderNumber`, `FactoryId`, `SupplierId`, `TotalAmount`, `OrderStatus`, `IsEmergency`, `OrderDate`)
- **Transaction Workflow (`SqlTransaction`):**
  1. `UPDATE QuotationResponses SET Status = 'Accepted' WHERE ResponseId = @ResponseId`
  2. `UPDATE QuotationResponses SET Status = 'Rejected' WHERE RfqId = @RfqId AND ResponseId <> @ResponseId`
  3. `UPDATE QuotationRequests SET Status = 'Closed' WHERE RfqId = @RfqId`
  4. `INSERT INTO Orders (OrderNumber, FactoryId, SupplierId, TotalAmount, OrderStatus, IsEmergency, OrderDate) VALUES (@OrderNumber, @FactoryId, @SupplierId, @TotalAmount, 'Placed', 0, GETDATE())`
- **Test Strategy:** Open with query string `?rfqId=1`. View supplier bid prices. Click "Accept Bid & Order". Verify database transaction commits all 4 updates atomically and redirects to `MyOrders.aspx?accepted=true`.

---

### Page FB-05: `Factory/Orders/MyOrders.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Factory`
- **Tables & Columns Involved:**
  - `Orders` (`OrderId`, `OrderNumber`, `FactoryId`, `SupplierId`, `TotalAmount`, `OrderStatus`, `IsEmergency`, `TrackingNumber`, `OrderDate`)
  - `Suppliers` (`CompanyName`, `City`)
- **Key Operations:**
  - `SELECT o.OrderId, o.OrderNumber, o.TotalAmount, o.OrderStatus, o.IsEmergency, o.TrackingNumber, o.OrderDate, s.CompanyName AS SupplierCompany, s.City FROM Orders o INNER JOIN Suppliers s ON o.SupplierId = s.SupplierId WHERE o.FactoryId = @FactoryId ORDER BY o.OrderDate DESC`
  - Status filter: `Placed`, `Processing`, `Shipped`, `Delivered`.

---

### Page FB-06: `Factory/Technicians/ServiceRequests.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Factory`
- **Tables & Columns Involved:**
  - `Technicians` (`TechnicianId`, `UserId`, `SkillSummary`, `HourlyRate`, `City`, `IsAvailable`)
  - `Users` (`FullName`, `PhoneNumber`)
  - `ServiceRequests` (`ServiceRequestId`, `FactoryId`, `TechnicianId`, `ServiceType`, `IssueDescription`, `ScheduledDate`, `ServiceStatus`, `CreatedAt`)
- **Inputs & Controls:**
  - `ddlTechnicians` (Available technicians populated via ADO.NET)
  - `ddlServiceType` (Emergency Repair, Part Installation, Preventative)
  - `txtScheduledDate` (Date)
  - `txtIssueDescription` (MultiLine TextBox)
- **Key Operation:**
  - `INSERT INTO ServiceRequests (FactoryId, TechnicianId, ServiceType, IssueDescription, ScheduledDate, ServiceStatus, CreatedAt) VALUES (@FactoryId, @TechnicianId, @ServiceType, @IssueDescription, @ScheduledDate, 'Requested', GETDATE())`

---

## 2. Administrator Governance Panel (6 Pages)

### Page AD-01: `Admin/Dashboard.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Administrator` (`BasePage.RequiredRole = RoleConstants.Administrator`)
- **Tables Involved:** `Users`, `Suppliers`, `Factories`, `EmergencyRequests`, `Orders`
- **Key Operations:** High-level platform statistics and user audit counts.

---

### Page AD-02: `Admin/Users/ManageUsers.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Administrator`
- **Tables & Columns Involved:**
  - `Users` (`UserId`, `RoleId`, `Email`, `FullName`, `PhoneNumber`, `IsActive`, `IsVerified`, `CreatedAt`, `UpdatedAt`)
  - `Roles` (`RoleId`, `RoleName`)
- **Key Operation:**
  - `UPDATE Users SET IsActive = @IsActive, UpdatedAt = GETDATE() WHERE UserId = @UserId`
- **Governance Safety Check:** Prevent the logged-in administrator from deactivating their own superadmin account (`userId != SessionHelper.UserId.Value`).

---

### Page AD-03: `Admin/Suppliers/Verification.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Administrator`
- **Tables & Columns Involved:**
  - `Suppliers` (`SupplierId`, `UserId`, `CompanyName`, `BusinessRegistrationNo`, `Gstin`, `City`, `VerificationStatus`)
  - `Users` (`UserId`, `IsVerified`)
- **Key Transaction:**
  - Approve: Set `Suppliers.VerificationStatus = 'Verified'` AND `Users.IsVerified = 1`.
  - Reject: Set `Suppliers.VerificationStatus = 'Rejected'` AND `Users.IsVerified = 0`.

---

### Page AD-04: `Admin/Categories/ManageCategories.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Administrator`
- **Tables & Columns Involved:**
  - `Categories` (`CategoryId`, `CategoryName`, `Description`, `IconClass`, `IsActive`)
  - `Machines` (`MachineId`, `MachineName`, `ModelNumber`, `Manufacturer`)
- **Key Operations:**
  - Category Insert: `INSERT INTO Categories (CategoryName, Description, IconClass, IsActive) VALUES (@Name, @Desc, @Icon, 1)`
  - Machine Insert: `INSERT INTO Machines (MachineName, ModelNumber, Manufacturer) VALUES (@Name, @Model, @Mfg)`

---

### Page AD-05: `Admin/SpareParts/ManageParts.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Administrator`
- **Tables & Columns Involved:**
  - `SpareParts` (`PartId`, `CategoryId`, `MachineId`, `PartNumber`, `PartName`, `TechnicalSpecs`, `UnitOfMeasure`, `CreatedAt`)
- **Key Operation:**
  - Insert: `INSERT INTO SpareParts (CategoryId, MachineId, PartNumber, PartName, TechnicalSpecs, UnitOfMeasure, CreatedAt) VALUES (@CategoryId, @MachineId, @PartNumber, @PartName, @TechnicalSpecs, @UnitOfMeasure, GETDATE())`

---

### Page AD-06: `Admin/Orders/Oversight.aspx`
- **Owner:** Zaid Amreliya
- **Role:** `Administrator`
- **Tables & Columns Involved:**
  - `EmergencyRequests` (`EmergencyRequestId`, `FactoryId`, `MachineName`, `PriorityLevel`, `LocationCity`, `Status`, `CreatedAt`)
  - `Orders` (`OrderId`, `OrderNumber`, `FactoryId`, `SupplierId`, `TotalAmount`, `OrderStatus`, `TrackingNumber`, `OrderDate`)
- **Key Operations:** System-wide visibility across all plant emergencies and regional procurement dispatches.

