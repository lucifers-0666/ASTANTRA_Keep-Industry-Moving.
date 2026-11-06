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
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT e.EmergencyRequestId, e.MachineName, e.PriorityLevel, e.LocationCity, e.Status, e.CreatedAt,
                           f.CompanyName AS FactoryCompany
                    FROM EmergencyRequests e
                    INNER JOIN Factories f ON e.FactoryId = f.FactoryId
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
    }
}
