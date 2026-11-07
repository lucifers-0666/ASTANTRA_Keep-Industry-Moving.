using System;
using System.Data;
using System.Data.SqlClient;
using IndustrialSparePartPortal.App_Code.Helpers;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for Platform Governance, Supplier Due Diligence, and Emergency SOS Monitoring.
    /// </summary>
    public class AdminLogic : BaseLogic
    {
        public DataSet selectPendingSuppliers(string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT s.SupplierId, s.UserId, s.CompanyName, s.BusinessRegistrationNo, s.Gstin,
                           s.City, s.State, s.VerificationStatus, s.Rating,
                           u.FullName AS ContactName, u.Email, u.PhoneNumber
                    FROM Suppliers s
                    INNER JOIN Users u ON s.UserId = u.UserId";

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    sql += " WHERE s.VerificationStatus = @Status";
                }

                sql += " ORDER BY s.SupplierId DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (!string.IsNullOrEmpty(statusFilter))
                    {
                        cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 20) { Value = statusFilter });
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet selectPublicSuppliers(string search = null, string city = null, string verification = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT s.SupplierId, s.CompanyName, s.City, s.State, s.Gstin, s.Rating,
                           s.VerificationStatus,
                           u.PhoneNumber, u.Email,
                           (SELECT COUNT(*) FROM SupplierInventory si WHERE si.SupplierId = s.SupplierId) AS ActiveInventoryCount
                    FROM Suppliers s
                    INNER JOIN Users u ON s.UserId = u.UserId
                    WHERE u.IsActive = 1";

                var paramList = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (s.CompanyName LIKE @Search OR s.City LIKE @Search OR s.Gstin LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 100) { Value = "%" + search + "%" });
                }

                if (!string.IsNullOrEmpty(city))
                {
                    sql += " AND s.City = @City";
                    paramList.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = city });
                }

                if (!string.IsNullOrEmpty(verification))
                {
                    sql += " AND s.VerificationStatus = @Verification";
                    paramList.Add(new SqlParameter("@Verification", SqlDbType.VarChar, 20) { Value = verification });
                }

                sql += " ORDER BY s.Rating DESC, s.CompanyName ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (paramList.Count > 0)
                    {
                        cmd.Parameters.AddRange(paramList.ToArray());
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public bool verifySupplier(int supplierId, int userId, bool isApproved)
        {
            using (SqlConnection con = getcon())
            {
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string status = isApproved ? "Verified" : "Rejected";

                        string sqlSupplier = "UPDATE Suppliers SET VerificationStatus = @Status WHERE SupplierId = @SupplierId";
                        using (SqlCommand cmd = new SqlCommand(sqlSupplier, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 20) { Value = status });
                            cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                            cmd.ExecuteNonQuery();
                        }

                        string sqlUser = "UPDATE Users SET IsVerified = @IsVerified WHERE UserId = @UserId";
                        using (SqlCommand cmd = new SqlCommand(sqlUser, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@IsVerified", SqlDbType.Bit) { Value = isApproved ? 1 : 0 });
                            cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                        return true;
                    }
                    catch
                    {
                        tx.Rollback();
                        return false;
                    }
                }
            }
        }

        public int insertEmergencyRequest(int factoryId, int? partId, string machineName, string breakdownDescription, string priorityLevel, string locationCity)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO EmergencyRequests (FactoryId, PartId, MachineName, BreakdownDescription, PriorityLevel, LocationCity, Status, CreatedAt)
                    VALUES (@FactoryId, @PartId, @MachineName, @BreakdownDescription, @PriorityLevel, @LocationCity, 'Open', GETDATE());
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = (object)partId ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@MachineName", SqlDbType.NVarChar, 150) { Value = machineName });
                    cmd.Parameters.Add(new SqlParameter("@BreakdownDescription", SqlDbType.NVarChar, -1) { Value = breakdownDescription });
                    cmd.Parameters.Add(new SqlParameter("@PriorityLevel", SqlDbType.VarChar, 20) { Value = priorityLevel ?? "Critical" });
                    cmd.Parameters.Add(new SqlParameter("@LocationCity", SqlDbType.NVarChar, 50) { Value = locationCity ?? "Gujarat" });

                    object res = cmd.ExecuteScalar();
                    return Convert.ToInt32(res);
                }
            }
        }

        public DataSet selectOpenEmergencies()
        {
            return selectOpenEmergenciesForAdmin();
        }

        public DataSet selectOpenEmergenciesForAdmin()
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT e.EmergencyRequestId, e.MachineName, e.PriorityLevel, e.LocationCity, e.Status, e.CreatedAt,
                           f.CompanyName AS FactoryCompany
                    FROM EmergencyRequests e
                    INNER JOIN Factories f ON e.FactoryId = f.FactoryId
                    WHERE e.Status NOT IN ('Resolved', 'Closed')
                    ORDER BY e.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet selectOpenEmergenciesByFactory(int factoryId)
        {
            if (factoryId <= 0)
            {
                throw new ArgumentException("A valid positive factoryId is required for tenant-isolated emergency retrieval.", "factoryId");
            }

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT e.EmergencyRequestId, e.MachineName, e.PriorityLevel, e.LocationCity, e.Status, e.CreatedAt,
                           f.CompanyName AS FactoryCompany
                    FROM EmergencyRequests e
                    INNER JOIN Factories f ON e.FactoryId = f.FactoryId
                    WHERE e.FactoryId = @FactoryId
                      AND e.Status NOT IN ('Resolved', 'Closed')
                    ORDER BY e.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet getSystemMetrics()
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        (SELECT COUNT(*) FROM Users WHERE IsActive = 1) AS TotalActiveUsers,
                        (SELECT COUNT(*) FROM Factories) AS TotalFactories,
                        (SELECT COUNT(*) FROM Suppliers WHERE VerificationStatus = 'Verified') AS VerifiedSuppliers,
                        (SELECT COUNT(*) FROM Technicians WHERE IsAvailable = 1) AS ActiveTechnicians,
                        (SELECT COUNT(*) FROM QuotationRequests WHERE Status = 'Pending') AS PendingRfqs,
                        (SELECT COUNT(*) FROM Orders) AS TotalOrders,
                        (SELECT COUNT(*) FROM EmergencyRequests WHERE Status = 'Open') AS OpenEmergencies";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public void getExecutiveKpis(out int totalUsers, out int verifiedSuppliers, out int activeFactories, out int activeTechnicians, out int openEmergencies, out int pendingRfqs, out int totalOrders, out decimal totalGmv)
        {
            totalUsers = 0;
            verifiedSuppliers = 0;
            activeFactories = 0;
            activeTechnicians = 0;
            openEmergencies = 0;
            pendingRfqs = 0;
            totalOrders = 0;
            totalGmv = 0.00m;

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        (SELECT COUNT(*) FROM Users WHERE IsActive = 1) AS TotalUsers,
                        (SELECT COUNT(*) FROM Suppliers WHERE VerificationStatus = 'Verified') AS VerifiedSuppliers,
                        (SELECT COUNT(*) FROM Factories) AS ActiveFactories,
                        (SELECT COUNT(*) FROM Technicians WHERE IsAvailable = 1) AS ActiveTechnicians,
                        (SELECT COUNT(*) FROM EmergencyRequests WHERE Status = 'Open') AS OpenEmergencies,
                        (SELECT COUNT(*) FROM QuotationRequests WHERE Status = 'Pending') AS PendingRfqs,
                        (SELECT COUNT(*) FROM Orders) AS TotalOrders,
                        (SELECT ISNULL(SUM(TotalAmount), 0.00) FROM Orders) AS TotalGmv";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            totalUsers = rdr["TotalUsers"] != DBNull.Value ? Convert.ToInt32(rdr["TotalUsers"]) : 0;
                            verifiedSuppliers = rdr["VerifiedSuppliers"] != DBNull.Value ? Convert.ToInt32(rdr["VerifiedSuppliers"]) : 0;
                            activeFactories = rdr["ActiveFactories"] != DBNull.Value ? Convert.ToInt32(rdr["ActiveFactories"]) : 0;
                            activeTechnicians = rdr["ActiveTechnicians"] != DBNull.Value ? Convert.ToInt32(rdr["ActiveTechnicians"]) : 0;
                            openEmergencies = rdr["OpenEmergencies"] != DBNull.Value ? Convert.ToInt32(rdr["OpenEmergencies"]) : 0;
                            pendingRfqs = rdr["PendingRfqs"] != DBNull.Value ? Convert.ToInt32(rdr["PendingRfqs"]) : 0;
                            totalOrders = rdr["TotalOrders"] != DBNull.Value ? Convert.ToInt32(rdr["TotalOrders"]) : 0;
                            totalGmv = rdr["TotalGmv"] != DBNull.Value ? Convert.ToDecimal(rdr["TotalGmv"]) : 0.00m;
                        }
                    }
                }
            }
        }

        public DataSet selectAllFactories(string search = null, string city = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT f.FactoryId, f.UserId, f.CompanyName, f.IndustryType, f.Address, f.City, f.State, f.Pincode, f.Gstin, f.ContactPerson, f.CreatedAt,
                           u.Email, u.PhoneNumber, u.IsActive,
                           (SELECT COUNT(*) FROM QuotationRequests qr WHERE qr.FactoryId = f.FactoryId) AS TotalRfqs,
                           (SELECT COUNT(*) FROM Orders o WHERE o.FactoryId = f.FactoryId) AS TotalOrders
                    FROM Factories f
                    INNER JOIN Users u ON f.UserId = u.UserId
                    WHERE (1 = 1)";

                var paramList = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (f.CompanyName LIKE @Search OR f.ContactPerson LIKE @Search OR f.Gstin LIKE @Search OR u.Email LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 100) { Value = "%" + search.Trim() + "%" });
                }

                if (!string.IsNullOrEmpty(city))
                {
                    sql += " AND f.City = @City";
                    paramList.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = city });
                }

                sql += " ORDER BY f.FactoryId ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (paramList.Count > 0)
                    {
                        cmd.Parameters.AddRange(paramList.ToArray());
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public bool updateFactory(int factoryId, string companyName, string industryType, string address, string city, string state, string pincode, string gstin, string contactPerson)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE Factories 
                    SET CompanyName = @CompanyName, 
                        IndustryType = @IndustryType, 
                        Address = @Address, 
                        City = @City, 
                        State = @State, 
                        Pincode = @Pincode, 
                        Gstin = @Gstin, 
                        ContactPerson = @ContactPerson
                    WHERE FactoryId = @FactoryId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@CompanyName", SqlDbType.NVarChar, 150) { Value = companyName });
                    cmd.Parameters.Add(new SqlParameter("@IndustryType", SqlDbType.NVarChar, 100) { Value = (object)industryType ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = (object)address ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = (object)city ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = (object)state ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = (object)pincode ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Gstin", SqlDbType.VarChar, 20) { Value = (object)gstin ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@ContactPerson", SqlDbType.NVarChar, 100) { Value = (object)contactPerson ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool deleteFactory(int factoryId)
        {
            using (SqlConnection con = getcon())
            {
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        int userId = 0;
                        string sqlUser = "SELECT UserId FROM Factories WHERE FactoryId = @FactoryId";
                        using (SqlCommand cmd = new SqlCommand(sqlUser, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                            object res = cmd.ExecuteScalar();
                            if (res != null && res != DBNull.Value) userId = Convert.ToInt32(res);
                        }

                        string sqlDel = "DELETE FROM Factories WHERE FactoryId = @FactoryId";
                        using (SqlCommand cmd = new SqlCommand(sqlDel, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                            cmd.ExecuteNonQuery();
                        }

                        if (userId > 0)
                        {
                            string sqlDelUser = "DELETE FROM Users WHERE UserId = @UserId";
                            using (SqlCommand cmd = new SqlCommand(sqlDelUser, con, tx))
                            {
                                cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                                cmd.ExecuteNonQuery();
                            }
                        }

                        tx.Commit();
                        return true;
                    }
                    catch
                    {
                        tx.Rollback();
                        return false;
                    }
                }
            }
        }

        public DataSet selectAllTechniciansDetailed(string search = null, string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT t.TechnicianId, t.UserId, t.SkillSummary, t.ExperienceYears, t.HourlyRate, t.Address, t.City, t.State, t.Pincode,
                           t.IsAvailable, t.VerificationStatus, t.CreatedAt,
                           u.FullName, u.Email, u.PhoneNumber, u.IsActive,
                           (SELECT COUNT(*) FROM ServiceRequests sr WHERE sr.TechnicianId = t.TechnicianId) AS TotalJobs
                    FROM Technicians t
                    INNER JOIN Users u ON t.UserId = u.UserId
                    WHERE (1 = 1)";

                var paramList = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (u.FullName LIKE @Search OR u.Email LIKE @Search OR t.SkillSummary LIKE @Search OR t.City LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 100) { Value = "%" + search.Trim() + "%" });
                }

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    if (statusFilter == "Available")
                        sql += " AND t.IsAvailable = 1";
                    else if (statusFilter == "Unavailable")
                        sql += " AND t.IsAvailable = 0";
                    else if (statusFilter == "Verified")
                        sql += " AND t.VerificationStatus = 'Verified'";
                    else if (statusFilter == "Pending")
                        sql += " AND t.VerificationStatus = 'Pending'";
                }

                sql += " ORDER BY t.TechnicianId ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (paramList.Count > 0)
                    {
                        cmd.Parameters.AddRange(paramList.ToArray());
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public bool updateTechnicianDetails(int technicianId, string skillSummary, int experienceYears, decimal hourlyRate, string address, string city, string state, string pincode, bool isAvailable, string verificationStatus)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE Technicians 
                    SET SkillSummary = @SkillSummary, 
                        ExperienceYears = @ExperienceYears, 
                        HourlyRate = @HourlyRate, 
                        Address = @Address, 
                        City = @City, 
                        State = @State, 
                        Pincode = @Pincode, 
                        IsAvailable = @IsAvailable, 
                        VerificationStatus = @VerificationStatus
                    WHERE TechnicianId = @TechnicianId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@SkillSummary", SqlDbType.NVarChar, 255) { Value = (object)skillSummary ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@ExperienceYears", SqlDbType.Int) { Value = experienceYears });
                    cmd.Parameters.Add(new SqlParameter("@HourlyRate", SqlDbType.Decimal) { Value = hourlyRate });
                    cmd.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = (object)address ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = (object)city ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = (object)state ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = (object)pincode ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@IsAvailable", SqlDbType.Bit) { Value = isAvailable });
                    cmd.Parameters.Add(new SqlParameter("@VerificationStatus", SqlDbType.VarChar, 20) { Value = verificationStatus });
                    cmd.Parameters.Add(new SqlParameter("@TechnicianId", SqlDbType.Int) { Value = technicianId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public int insertNewFactory(string companyName, string industryType, string email, string phone, string plainPassword, string contactPerson, string address, string city, string state, string pincode, string gstin)
        {
            using (SqlConnection con = getcon())
            {
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string salt = PasswordHasher.GenerateSalt();
                        string hash = PasswordHasher.HashPassword(plainPassword, salt);

                        string sqlUser = @"
                            INSERT INTO Users (RoleId, Email, PasswordHash, Salt, FullName, PhoneNumber, IsActive, IsVerified, CreatedAt)
                            VALUES (2, @Email, @PasswordHash, @Salt, @FullName, @PhoneNumber, 1, 1, GETDATE());
                            SELECT SCOPE_IDENTITY();";

                        int userId = 0;
                        using (SqlCommand cmd = new SqlCommand(sqlUser, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email });
                            cmd.Parameters.Add(new SqlParameter("@PasswordHash", SqlDbType.VarChar, 255) { Value = hash });
                            cmd.Parameters.Add(new SqlParameter("@Salt", SqlDbType.VarChar, 100) { Value = salt });
                            cmd.Parameters.Add(new SqlParameter("@FullName", SqlDbType.NVarChar, 100) { Value = companyName });
                            cmd.Parameters.Add(new SqlParameter("@PhoneNumber", SqlDbType.VarChar, 20) { Value = (object)phone ?? DBNull.Value });
                            userId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        string sqlFactory = @"
                            INSERT INTO Factories (UserId, CompanyName, IndustryType, Address, City, State, Pincode, Gstin, ContactPerson, CreatedAt)
                            VALUES (@UserId, @CompanyName, @IndustryType, @Address, @City, @State, @Pincode, @Gstin, @ContactPerson, GETDATE());
                            SELECT SCOPE_IDENTITY();";

                        int factoryId = 0;
                        using (SqlCommand cmd = new SqlCommand(sqlFactory, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                            cmd.Parameters.Add(new SqlParameter("@CompanyName", SqlDbType.NVarChar, 150) { Value = companyName });
                            cmd.Parameters.Add(new SqlParameter("@IndustryType", SqlDbType.NVarChar, 100) { Value = (object)industryType ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = (object)address ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = (object)city ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = (object)state ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = (object)pincode ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@Gstin", SqlDbType.VarChar, 20) { Value = (object)gstin ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@ContactPerson", SqlDbType.NVarChar, 100) { Value = (object)contactPerson ?? DBNull.Value });
                            factoryId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        tx.Commit();
                        return factoryId;
                    }
                    catch
                    {
                        tx.Rollback();
                        return 0;
                    }
                }
            }
        }

        public int insertNewTechnician(string fullName, string email, string phone, string plainPassword, string skillSummary, int experienceYears, decimal hourlyRate, string address, string city, string state, string pincode)
        {
            using (SqlConnection con = getcon())
            {
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string salt = PasswordHasher.GenerateSalt();
                        string hash = PasswordHasher.HashPassword(plainPassword, salt);

                        string sqlUser = @"
                            INSERT INTO Users (RoleId, Email, PasswordHash, Salt, FullName, PhoneNumber, IsActive, IsVerified, CreatedAt)
                            VALUES (4, @Email, @PasswordHash, @Salt, @FullName, @PhoneNumber, 1, 1, GETDATE());
                            SELECT SCOPE_IDENTITY();";

                        int userId = 0;
                        using (SqlCommand cmd = new SqlCommand(sqlUser, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email });
                            cmd.Parameters.Add(new SqlParameter("@PasswordHash", SqlDbType.VarChar, 255) { Value = hash });
                            cmd.Parameters.Add(new SqlParameter("@Salt", SqlDbType.VarChar, 100) { Value = salt });
                            cmd.Parameters.Add(new SqlParameter("@FullName", SqlDbType.NVarChar, 100) { Value = fullName });
                            cmd.Parameters.Add(new SqlParameter("@PhoneNumber", SqlDbType.VarChar, 20) { Value = (object)phone ?? DBNull.Value });
                            userId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        string sqlTech = @"
                            INSERT INTO Technicians (UserId, SkillSummary, ExperienceYears, HourlyRate, Address, City, State, Pincode, IsAvailable, VerificationStatus, CreatedAt)
                            VALUES (@UserId, @SkillSummary, @ExperienceYears, @HourlyRate, @Address, @City, @State, @Pincode, 1, 'Verified', GETDATE());
                            SELECT SCOPE_IDENTITY();";

                        int techId = 0;
                        using (SqlCommand cmd = new SqlCommand(sqlTech, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                            cmd.Parameters.Add(new SqlParameter("@SkillSummary", SqlDbType.NVarChar, 255) { Value = (object)skillSummary ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@ExperienceYears", SqlDbType.Int) { Value = experienceYears });
                            cmd.Parameters.Add(new SqlParameter("@HourlyRate", SqlDbType.Decimal) { Value = hourlyRate });
                            cmd.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = (object)address ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = (object)city ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = (object)state ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = (object)pincode ?? DBNull.Value });
                            techId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        tx.Commit();
                        return techId;
                    }
                    catch
                    {
                        tx.Rollback();
                        return 0;
                    }
                }
            }
        }

        public DataSet selectAllEmergenciesDetailed(string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT e.EmergencyRequestId, e.MachineName, e.BreakdownDescription, e.PriorityLevel, 
                           e.LocationCity, e.Status, e.CreatedAt,
                           f.CompanyName AS FactoryCompany, f.ContactPerson,
                           u.PhoneNumber, u.Email,
                           p.PartNumber, p.PartName
                    FROM EmergencyRequests e
                    INNER JOIN Factories f ON e.FactoryId = f.FactoryId
                    INNER JOIN Users u ON f.UserId = u.UserId
                    LEFT JOIN SpareParts p ON e.PartId = p.PartId
                    WHERE (1 = 1)";

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    sql += " AND e.Status = @Status";
                }

                sql += " ORDER BY e.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (!string.IsNullOrEmpty(statusFilter))
                    {
                        cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 20) { Value = statusFilter });
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public bool updateEmergencyStatus(int emergencyRequestId, string newStatus)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "UPDATE EmergencyRequests SET Status = @Status WHERE EmergencyRequestId = @Id";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 20) { Value = newStatus });
                    cmd.Parameters.Add(new SqlParameter("@Id", SqlDbType.Int) { Value = emergencyRequestId });
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public DataSet selectAllQuotationsDetailed(string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT qr.RfqId, qr.Quantity, qr.TargetPrice, qr.RequiredByDate, qr.Status, qr.CreatedAt, qr.Remarks,
                           f.CompanyName AS FactoryCompany, f.City AS FactoryCity,
                           p.PartNumber, p.PartName,
                           (SELECT COUNT(*) FROM QuotationResponses r WHERE r.RfqId = qr.RfqId) AS ResponseCount
                    FROM QuotationRequests qr
                    INNER JOIN Factories f ON qr.FactoryId = f.FactoryId
                    INNER JOIN SpareParts p ON qr.PartId = p.PartId
                    WHERE (1 = 1)";

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    sql += " AND qr.Status = @Status";
                }

                sql += " ORDER BY qr.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (!string.IsNullOrEmpty(statusFilter))
                    {
                        cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 20) { Value = statusFilter });
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public bool updateOrderStatusByAdmin(int orderId, string newStatus, string trackingNumber)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE Orders 
                    SET OrderStatus = @OrderStatus, 
                        TrackingNumber = CASE WHEN @TrackingNumber IS NOT NULL AND @TrackingNumber <> '' THEN @TrackingNumber ELSE TrackingNumber END
                    WHERE OrderId = @OrderId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@OrderStatus", SqlDbType.VarChar, 30) { Value = newStatus });
                    cmd.Parameters.Add(new SqlParameter("@TrackingNumber", SqlDbType.VarChar, 100) { 
                        Value = string.IsNullOrEmpty(trackingNumber) ? (object)DBNull.Value : trackingNumber 
                    });
                    cmd.Parameters.Add(new SqlParameter("@OrderId", SqlDbType.Int) { Value = orderId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        // =========================================================================
        // ENTERPRISE GOVERNANCE MODULE METHODS (RBAC, SECURITY, SYSTEM, INTEGRITY)
        // =========================================================================

        public DataSet selectAllRoles()
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT r.RoleId, r.RoleName, r.Description,
                           (SELECT COUNT(*) FROM Users u WHERE u.RoleId = r.RoleId) AS UserCount,
                           (SELECT COUNT(*) FROM Users u WHERE u.RoleId = r.RoleId AND u.IsActive = 1) AS ActiveCount
                    FROM Roles r
                    ORDER BY r.RoleId ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet selectSecurityEvents(int topCount = 50)
        {
            using (SqlConnection con = getcon())
            {
                string sql = string.Format(@"
                    SELECT TOP {0} a.LogId, a.UserId, a.ActionType, a.TargetEntity, a.EntityId, a.OldValue, a.NewValue, a.IpAddress, a.CreatedAt,
                           ISNULL(u.FullName, 'System Service') AS ActorName,
                           ISNULL(u.Email, 'system@local') AS ActorEmail,
                           ISNULL(r.RoleName, 'SYSTEM') AS ActorRole
                    FROM AuditLogs a
                    LEFT JOIN Users u ON a.UserId = u.UserId
                    LEFT JOIN Roles r ON u.RoleId = r.RoleId
                    WHERE a.ActionType LIKE '%LOGIN%' 
                       OR a.ActionType LIKE '%AUTH%' 
                       OR a.ActionType LIKE '%PASSWORD%' 
                       OR a.ActionType LIKE '%SECURITY%'
                       OR a.ActionType LIKE '%TOGGLE%'
                       OR a.ActionType LIKE '%DELETE%'
                    ORDER BY a.CreatedAt DESC", topCount);

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet runDataIntegrityAudit(out int orphanedUsers, out int unverifiedSuppliers, out int pendingEmergencies, out int totalAuditRecords)
        {
            orphanedUsers = 0;
            unverifiedSuppliers = 0;
            pendingEmergencies = 0;
            totalAuditRecords = 0;

            using (SqlConnection con = getcon())
            {
                // Diagnostic metrics
                string sqlCounts = @"
                    SELECT 
                        (SELECT COUNT(*) FROM Users u 
                         WHERE u.RoleId = 2 AND NOT EXISTS (SELECT 1 FROM Factories f WHERE f.UserId = u.UserId)
                            OR u.RoleId = 3 AND NOT EXISTS (SELECT 1 FROM Suppliers s WHERE s.UserId = u.UserId)
                            OR u.RoleId = 4 AND NOT EXISTS (SELECT 1 FROM Technicians t WHERE t.UserId = u.UserId)) AS OrphanedUsers,
                        (SELECT COUNT(*) FROM Suppliers WHERE VerificationStatus = 'Pending') AS UnverifiedSuppliers,
                        (SELECT COUNT(*) FROM EmergencyRequests WHERE Status = 'Reported' OR Status = 'Dispatched') AS PendingEmergencies,
                        (SELECT COUNT(*) FROM AuditLogs) AS TotalAuditRecords";

                using (SqlCommand cmd = new SqlCommand(sqlCounts, con))
                {
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            orphanedUsers = Convert.ToInt32(rdr["OrphanedUsers"]);
                            unverifiedSuppliers = Convert.ToInt32(rdr["UnverifiedSuppliers"]);
                            pendingEmergencies = Convert.ToInt32(rdr["PendingEmergencies"]);
                            totalAuditRecords = Convert.ToInt32(rdr["TotalAuditRecords"]);
                        }
                    }
                }

                // Table row counts & health
                string sqlTables = @"
                    SELECT t.name AS TableName, p.rows AS RecordCount,
                           (SELECT COUNT(*) FROM sys.foreign_keys fk WHERE fk.parent_object_id = t.object_id) AS ForeignKeyCount
                    FROM sys.tables t
                    INNER JOIN sys.partitions p ON t.object_id = p.object_id AND p.index_id IN (0, 1)
                    WHERE t.is_ms_shipped = 0
                    ORDER BY p.rows DESC, t.name ASC";

                using (SqlCommand cmd = new SqlCommand(sqlTables, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public void getSystemHealthMetrics(out string sqlVersion, out int totalTables, out int totalDbRows, out bool isOperational)
        {
            long latency;
            getSystemHealthMetrics(out sqlVersion, out totalTables, out totalDbRows, out isOperational, out latency);
        }

        public void getSystemHealthMetrics(out string sqlVersion, out int totalTables, out int totalDbRows, out bool isOperational, out long latencyMs)
        {
            sqlVersion = ".NET Framework 4.8 / SQL Server LocalDB";
            totalTables = 0;
            totalDbRows = 0;
            isOperational = false;
            latencyMs = 0;

            var sw = System.Diagnostics.Stopwatch.StartNew();

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        @@VERSION AS SqlVersion,
                        (SELECT COUNT(*) FROM sys.tables WHERE is_ms_shipped = 0) AS TotalTables,
                        (SELECT ISNULL(SUM(p.rows), 0) FROM sys.partitions p 
                         INNER JOIN sys.tables t ON p.object_id = t.object_id 
                         WHERE p.index_id IN (0, 1) AND t.is_ms_shipped = 0) AS TotalDbRows";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            string rawVer = rdr["SqlVersion"].ToString();
                            sqlVersion = rawVer.Contains("-") ? rawVer.Substring(0, rawVer.IndexOf("-")).Trim() : rawVer;
                            totalTables = Convert.ToInt32(rdr["TotalTables"]);
                            totalDbRows = Convert.ToInt32(rdr["TotalDbRows"]);
                            isOperational = true;
                        }
                    }
                }
            }

            sw.Stop();
            latencyMs = sw.ElapsedMilliseconds;
        }

        public DataSet selectAllPermissions()
        {
            using (SqlConnection con = getcon())
            {
                string sql = "SELECT PermissionId, PermissionKey, Module, DisplayName, Description FROM Permissions ORDER BY Module ASC, PermissionKey ASC";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet selectPermissionsForRole(int roleId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT p.PermissionId, p.PermissionKey, p.Module, p.DisplayName, p.Description,
                           CASE WHEN rp.PermissionId IS NOT NULL THEN 1 ELSE 0 END AS IsGranted
                    FROM Permissions p
                    LEFT JOIN RolePermissions rp ON p.PermissionId = rp.PermissionId AND rp.RoleId = @RoleId
                    ORDER BY p.Module ASC, p.DisplayName ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@RoleId", SqlDbType.Int) { Value = roleId });
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public bool toggleRolePermission(int roleId, int permissionId, bool grant, int adminUserId)
        {
            using (SqlConnection con = getcon())
            {
                string sql;
                if (grant)
                {
                    sql = @"
                        IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleId = @RoleId AND PermissionId = @PermissionId)
                        BEGIN
                            INSERT INTO RolePermissions (RoleId, PermissionId, GrantedAt, GrantedBy)
                            VALUES (@RoleId, @PermissionId, GETDATE(), @AdminId)
                        END";
                }
                else
                {
                    sql = "DELETE FROM RolePermissions WHERE RoleId = @RoleId AND PermissionId = @PermissionId";
                }

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@RoleId", SqlDbType.Int) { Value = roleId });
                    cmd.Parameters.Add(new SqlParameter("@PermissionId", SqlDbType.Int) { Value = permissionId });
                    cmd.Parameters.Add(new SqlParameter("@AdminId", SqlDbType.Int) { Value = adminUserId });
                    cmd.ExecuteNonQuery();
                    return true;
                }
            }
        }

        public bool hasRolePermission(int roleId, string permissionKey)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT COUNT(*) FROM RolePermissions rp
                    INNER JOIN Permissions p ON rp.PermissionId = p.PermissionId
                    WHERE rp.RoleId = @RoleId AND p.PermissionKey = @Key";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@RoleId", SqlDbType.Int) { Value = roleId });
                    cmd.Parameters.Add(new SqlParameter("@Key", SqlDbType.VarChar, 80) { Value = permissionKey });
                    int cnt = Convert.ToInt32(cmd.ExecuteScalar());
                    return cnt > 0;
                }
            }
        }

        public DataSet selectAllSystemSettings()
        {
            using (SqlConnection con = getcon())
            {
                string sql = "SELECT SettingKey, SettingValue, Category, Description, UpdatedAt FROM SystemSettings ORDER BY Category ASC, SettingKey ASC";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public bool updateSystemSetting(string settingKey, string settingValue, int adminUserId)
        {
            string err;
            return updateSystemSetting(settingKey, settingValue, adminUserId, out err);
        }

        public bool updateSystemSetting(string settingKey, string settingValue, int adminUserId, out string errorMessage)
        {
            errorMessage = string.Empty;

            if (string.IsNullOrWhiteSpace(settingKey))
            {
                errorMessage = "Setting key cannot be empty.";
                return false;
            }

            // Validation rules per setting
            if (string.Equals(settingKey, "EmergencyBroadcastRadiusKm", StringComparison.OrdinalIgnoreCase))
            {
                int radius;
                if (!int.TryParse(settingValue, out radius) || radius < 5 || radius > 1000)
                {
                    errorMessage = "Emergency Broadcast Radius must be an integer between 5 and 1000 km.";
                    return false;
                }
            }
            else if (string.Equals(settingKey, "PlatformMaintenanceMode", StringComparison.OrdinalIgnoreCase) ||
                     string.Equals(settingKey, "SupplierVerificationMandatory", StringComparison.OrdinalIgnoreCase))
            {
                if (!string.Equals(settingValue, "True", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(settingValue, "False", StringComparison.OrdinalIgnoreCase))
                {
                    errorMessage = "Boolean configuration must be 'True' or 'False'.";
                    return false;
                }
            }

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE SystemSettings 
                    SET SettingValue = @SettingValue, 
                        LastUpdatedBy = @UserId, 
                        UpdatedAt = GETDATE() 
                    WHERE SettingKey = @SettingKey";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@SettingValue", SqlDbType.NVarChar, -1) { Value = settingValue.Trim() });
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = adminUserId });
                    cmd.Parameters.Add(new SqlParameter("@SettingKey", SqlDbType.VarChar, 50) { Value = settingKey });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool repairDataIntegrity(out int repairedCount, out string repairSummary)
        {
            repairedCount = 0;
            repairSummary = string.Empty;

            using (SqlConnection con = getcon())
            {
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        // 1. Repair orphaned Factory users
                        string sqlFixFactories = @"
                            INSERT INTO Factories (UserId, CompanyName, IndustryType, Address, City, State, Pincode, Gstin, ContactPerson, CreatedAt)
                            SELECT u.UserId, u.FullName, 'Industrial Plant', 'Registered Plant Premises', 'Gujarat', 'Gujarat', '380001', '24AAAAA0000A1Z5', u.FullName, GETDATE()
                            FROM Users u
                            WHERE u.RoleId = 2 AND NOT EXISTS (SELECT 1 FROM Factories f WHERE f.UserId = u.UserId)";
                        using (SqlCommand cmd = new SqlCommand(sqlFixFactories, con, tx))
                        {
                            repairedCount += cmd.ExecuteNonQuery();
                        }

                        // 2. Repair orphaned Supplier users
                        string sqlFixSuppliers = @"
                            INSERT INTO Suppliers (UserId, CompanyName, BusinessRegistrationNo, Gstin, Address, City, State, Pincode, VerificationStatus, Rating, CreatedAt)
                            SELECT u.UserId, u.FullName, 'REG-' + CAST(u.UserId AS VARCHAR), '24AABCS0000A1Z1', 'Stocking Hub Premises', 'Gujarat', 'Gujarat', '380001', 'Pending', 4.50, GETDATE()
                            FROM Users u
                            WHERE u.RoleId = 3 AND NOT EXISTS (SELECT 1 FROM Suppliers s WHERE s.UserId = u.UserId)";
                        using (SqlCommand cmd = new SqlCommand(sqlFixSuppliers, con, tx))
                        {
                            repairedCount += cmd.ExecuteNonQuery();
                        }

                        // 3. Repair orphaned Technician users
                        string sqlFixTechs = @"
                            INSERT INTO Technicians (UserId, SkillSummary, ExperienceYears, HourlyRate, Address, City, State, Pincode, IsAvailable, VerificationStatus, CreatedAt)
                            SELECT u.UserId, 'Certified Field Specialist', 3, 650.00, 'Regional Service Depot', 'Gujarat', 'Gujarat', '380001', 1, 'Verified', GETDATE()
                            FROM Users u
                            WHERE u.RoleId = 4 AND NOT EXISTS (SELECT 1 FROM Technicians t WHERE t.UserId = u.UserId)";
                        using (SqlCommand cmd = new SqlCommand(sqlFixTechs, con, tx))
                        {
                            repairedCount += cmd.ExecuteNonQuery();
                        }

                        // 4. Synchronize inconsistent verification flags between Users and Suppliers
                        string sqlSyncVer = @"
                            UPDATE u
                            SET u.IsVerified = 1
                            FROM Users u
                            INNER JOIN Suppliers s ON u.UserId = s.UserId
                            WHERE s.VerificationStatus = 'Verified' AND u.IsVerified = 0";
                        using (SqlCommand cmd = new SqlCommand(sqlSyncVer, con, tx))
                        {
                            repairedCount += cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                        repairSummary = string.Format("Integrity reconciliation completed. {0} entities/consistency points aligned.", repairedCount);
                        return true;
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        repairSummary = "Integrity repair error: " + ex.Message;
                        return false;
                    }
                }
            }
        }
    }
}
