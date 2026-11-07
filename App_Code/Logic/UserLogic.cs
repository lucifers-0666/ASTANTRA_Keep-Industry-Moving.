using IndustrialSparePartPortal.App_Code.Helpers;
using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for User Authentication, Profiles, and Governance.
    /// </summary>
    public class UserLogic : BaseLogic
    {
        public DataSet getUserByEmail(string email)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT u.UserId, u.RoleId, r.RoleName, u.Email, u.PasswordHash, u.Salt, 
                           u.FullName, u.PhoneNumber, u.IsActive, u.IsVerified, u.CreatedAt, u.ProfileImage
                    FROM Users u
                    INNER JOIN Roles r ON u.RoleId = r.RoleId
                    WHERE u.Email = @Email";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email });
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet getUserById(int userId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT u.UserId, u.RoleId, r.RoleName, u.Email, u.PasswordHash, u.Salt, 
                           u.FullName, u.PhoneNumber, u.IsActive, u.IsVerified, u.CreatedAt, u.ProfileImage
                    FROM Users u
                    INNER JOIN Roles r ON u.RoleId = r.RoleId
                    WHERE u.UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public int insertUser(int roleId, string email, string passwordHash, string salt, string fullName, string phoneNumber, bool isActive, bool isVerified)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO Users (RoleId, Email, PasswordHash, Salt, FullName, PhoneNumber, IsActive, IsVerified, CreatedAt)
                    VALUES (@RoleId, @Email, @PasswordHash, @Salt, @FullName, @PhoneNumber, @IsActive, @IsVerified, GETDATE());
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@RoleId", SqlDbType.Int) { Value = roleId });
                    cmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email });
                    cmd.Parameters.Add(new SqlParameter("@PasswordHash", SqlDbType.VarChar, 255) { Value = passwordHash });
                    cmd.Parameters.Add(new SqlParameter("@Salt", SqlDbType.VarChar, 100) { Value = salt });
                    cmd.Parameters.Add(new SqlParameter("@FullName", SqlDbType.NVarChar, 100) { Value = fullName });
                    cmd.Parameters.Add(new SqlParameter("@PhoneNumber", SqlDbType.VarChar, 20) { Value = (object)phoneNumber ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive });
                    cmd.Parameters.Add(new SqlParameter("@IsVerified", SqlDbType.Bit) { Value = isVerified });

                    object result = cmd.ExecuteScalar();
                    return Convert.ToInt32(result);
                }
            }
        }

        public bool insertFactoryProfile(int userId, string companyName, string industryType, string address, string city, string state, string pincode, string gstin, string contactPerson)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO Factories (UserId, CompanyName, IndustryType, Address, City, State, Pincode, Gstin, ContactPerson, CreatedAt)
                    VALUES (@UserId, @CompanyName, @IndustryType, @Address, @City, @State, @Pincode, @Gstin, @ContactPerson, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(sql, con))
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

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool insertSupplierProfile(int userId, string companyName, string businessRegNo, string gstin, string address, string city, string state, string pincode)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO Suppliers (UserId, CompanyName, BusinessRegistrationNo, Gstin, Address, City, State, Pincode, VerificationStatus, Rating, CreatedAt)
                    VALUES (@UserId, @CompanyName, @BusinessRegistrationNo, @Gstin, @Address, @City, @State, @Pincode, 'Pending', 0.00, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                    cmd.Parameters.Add(new SqlParameter("@CompanyName", SqlDbType.NVarChar, 150) { Value = companyName });
                    cmd.Parameters.Add(new SqlParameter("@BusinessRegistrationNo", SqlDbType.VarChar, 50) { Value = (object)businessRegNo ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Gstin", SqlDbType.VarChar, 20) { Value = (object)gstin ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = (object)address ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = (object)city ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = (object)state ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = (object)pincode ?? DBNull.Value });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool insertTechnicianProfile(int userId, string skillSummary, int experienceYears, decimal hourlyRate, string address, string city, string state, string pincode)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO Technicians (UserId, SkillSummary, ExperienceYears, HourlyRate, Address, City, State, Pincode, IsAvailable, VerificationStatus, CreatedAt)
                    VALUES (@UserId, @SkillSummary, @ExperienceYears, @HourlyRate, @Address, @City, @State, @Pincode, 1, 'Pending', GETDATE())";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                    cmd.Parameters.Add(new SqlParameter("@SkillSummary", SqlDbType.NVarChar, 255) { Value = (object)skillSummary ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@ExperienceYears", SqlDbType.Int) { Value = experienceYears });
                    cmd.Parameters.Add(new SqlParameter("@HourlyRate", SqlDbType.Decimal) { Value = hourlyRate });
                    cmd.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = (object)address ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = (object)city ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = (object)state ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = (object)pincode ?? DBNull.Value });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public DataSet selectAllUsers(string roleFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT u.UserId, u.Email, u.FullName, u.PhoneNumber, u.IsActive, u.IsVerified, u.CreatedAt,
                           r.RoleName
                    FROM Users u
                    INNER JOIN Roles r ON u.RoleId = r.RoleId";

                if (!string.IsNullOrEmpty(roleFilter))
                {
                    sql += " WHERE r.RoleName = @RoleName";
                }

                sql += " ORDER BY u.UserId ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (!string.IsNullOrEmpty(roleFilter))
                    {
                        cmd.Parameters.Add(new SqlParameter("@RoleName", SqlDbType.VarChar, 50) { Value = roleFilter });
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

        public DataSet selectRecentUsers(int topCount = 8)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT TOP (@TopCount) u.UserId, u.Email, u.FullName, u.PhoneNumber, u.IsActive, u.IsVerified, u.CreatedAt,
                           r.RoleName
                    FROM Users u
                    INNER JOIN Roles r ON u.RoleId = r.RoleId
                    ORDER BY u.CreatedAt DESC, u.UserId DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@TopCount", SqlDbType.Int) { Value = topCount > 0 ? topCount : 8 });
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public bool updateUserStatus(int userId, bool isActive)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "UPDATE Users SET IsActive = @IsActive, UpdatedAt = GETDATE() WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive });
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public int resolveFactoryId(int userId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "SELECT FactoryId FROM Factories WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                    object res = cmd.ExecuteScalar();
                    return (res != null && res != DBNull.Value) ? Convert.ToInt32(res) : 0;
                }
            }
        }

        public int resolveSupplierId(int userId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "SELECT SupplierId FROM Suppliers WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                    object res = cmd.ExecuteScalar();
                    return (res != null && res != DBNull.Value) ? Convert.ToInt32(res) : 0;
                }
            }
        }

        public int resolveTechnicianId(int userId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "SELECT TechnicianId FROM Technicians WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                    object res = cmd.ExecuteScalar();
                    return (res != null && res != DBNull.Value) ? Convert.ToInt32(res) : 0;
                }
            }
        }

        public bool authenticateUser(string email, string password, out string errorMessage, out int userId, out string roleName, out string fullName, out bool isVerified)
        {
            userId = 0;
            roleName = string.Empty;
            fullName = string.Empty;
            isVerified = false;
            errorMessage = string.Empty;

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                errorMessage = "Email and password are required.";
                return false;
            }

            DataSet ds = getUserByEmail(email.Trim());
            if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
            {
                errorMessage = "Invalid email or password.";
                return false;
            }

            DataRow row = ds.Tables[0].Rows[0];
            bool isActive = Convert.ToBoolean(row["IsActive"]);
            int targetUserId = Convert.ToInt32(row["UserId"]);

            if (!isActive)
            {
                errorMessage = "Your account has been deactivated. Please contact platform administration.";
                LogAuthEvent(targetUserId, "AUTH_LOGIN_DEACTIVATED", email, errorMessage);
                return false;
            }

            string storedHash = row["PasswordHash"].ToString();
            string storedSalt = row["Salt"].ToString();

            if (!PasswordHasher.VerifyPassword(password, storedHash, storedSalt))
            {
                errorMessage = "Invalid email or password.";
                LogAuthEvent(targetUserId, "AUTH_LOGIN_FAILED", email, "Invalid password attempt");
                return false;
            }

            userId = targetUserId;
            roleName = row["RoleName"].ToString();
            fullName = row["FullName"].ToString();
            isVerified = Convert.ToBoolean(row["IsVerified"]);

            // Set session variables directly using SessionHelper
            SessionHelper.UserId = userId;
            SessionHelper.UserRole = roleName;
            SessionHelper.UserEmail = email;
            SessionHelper.FullName = fullName;
            SessionHelper.IsVerified = isVerified;

            LogAuthEvent(userId, "AUTH_LOGIN_SUCCESS", email, string.Format("Signed in successfully as {0}", roleName));

            return true;
        }

        private void LogAuthEvent(int? userId, string actionType, string email, string details)
        {
            try
            {
                string ip = "127.0.0.1";
                if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Request != null)
                {
                    ip = System.Web.HttpContext.Current.Request.UserHostAddress ?? "127.0.0.1";
                }
                var audit = new AuditLogic();
                audit.logAction(userId, actionType, "Users", userId, null, string.Format("{0}: {1}", email, details), ip);
            }
            catch
            {
                // Non-fatal telemetry logging
            }
        }

        public DataSet searchUsers(string searchKeyword = null, string roleFilter = null, string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT u.UserId, u.Email, u.FullName, u.PhoneNumber, u.IsActive, u.IsVerified, u.CreatedAt,
                           r.RoleId, r.RoleName,
                           CASE 
                               WHEN r.RoleName = 'Factory' THEN (SELECT CompanyName FROM Factories WHERE UserId = u.UserId)
                               WHEN r.RoleName = 'Supplier' THEN (SELECT CompanyName FROM Suppliers WHERE UserId = u.UserId)
                               WHEN r.RoleName = 'Technician' THEN (SELECT SkillSummary FROM Technicians WHERE UserId = u.UserId)
                               ELSE 'Platform Administration'
                           END AS EntityDetail
                    FROM Users u
                    INNER JOIN Roles r ON u.RoleId = r.RoleId
                    WHERE (1 = 1)";

                var paramList = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(searchKeyword))
                {
                    sql += " AND (u.FullName LIKE @Search OR u.Email LIKE @Search OR u.PhoneNumber LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 100) { Value = "%" + searchKeyword.Trim() + "%" });
                }

                if (!string.IsNullOrEmpty(roleFilter))
                {
                    sql += " AND r.RoleName = @RoleName";
                    paramList.Add(new SqlParameter("@RoleName", SqlDbType.VarChar, 50) { Value = roleFilter });
                }

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    if (statusFilter == "Active")
                    {
                        sql += " AND u.IsActive = 1";
                    }
                    else if (statusFilter == "Inactive")
                    {
                        sql += " AND u.IsActive = 0";
                    }
                    else if (statusFilter == "Verified")
                    {
                        sql += " AND u.IsVerified = 1";
                    }
                    else if (statusFilter == "Unverified")
                    {
                        sql += " AND u.IsVerified = 0";
                    }
                }

                sql += " ORDER BY u.UserId ASC";

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

        public bool updateUser(int userId, string fullName, string email, string phoneNumber, int roleId, bool isActive, bool isVerified)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE Users 
                    SET FullName = @FullName, 
                        Email = @Email, 
                        PhoneNumber = @PhoneNumber, 
                        RoleId = @RoleId, 
                        IsActive = @IsActive, 
                        IsVerified = @IsVerified, 
                        UpdatedAt = GETDATE()
                    WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FullName", SqlDbType.NVarChar, 100) { Value = fullName });
                    cmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email });
                    cmd.Parameters.Add(new SqlParameter("@PhoneNumber", SqlDbType.VarChar, 20) { Value = (object)phoneNumber ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@RoleId", SqlDbType.Int) { Value = roleId });
                    cmd.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive });
                    cmd.Parameters.Add(new SqlParameter("@IsVerified", SqlDbType.Bit) { Value = isVerified });
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool deleteUser(int userId)
        {
            using (SqlConnection con = getcon())
            {
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        // Clean up ephemeral notifications safely
                        string sqlDelTokens = "DELETE FROM Notifications WHERE UserId = @UserId";
                        using (SqlCommand cmd = new SqlCommand(sqlDelTokens, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                            cmd.ExecuteNonQuery();
                        }

                        // PRESERVE AUDIT TRAIL: Decouple user reference without destroying historical audit log records
                        string sqlPreserveAudit = "UPDATE AuditLogs SET UserId = NULL WHERE UserId = @UserId";
                        using (SqlCommand cmd = new SqlCommand(sqlPreserveAudit, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                            cmd.ExecuteNonQuery();
                        }

                        // Decouple system settings last-updated reference if any
                        string sqlPreserveSettings = "UPDATE SystemSettings SET LastUpdatedBy = NULL WHERE LastUpdatedBy = @UserId";
                        using (SqlCommand cmd = new SqlCommand(sqlPreserveSettings, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                            cmd.ExecuteNonQuery();
                        }

                        // Foreign keys to Factories, Suppliers, Technicians CASCADE on delete of Users
                        string sqlDelUser = "DELETE FROM Users WHERE UserId = @UserId";
                        using (SqlCommand cmd = new SqlCommand(sqlDelUser, con, tx))
                        {
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

        /// <summary>
        /// Atomically creates a platform user account and their role-specific business profile inside a single SQL transaction.
        /// Validates email uniqueness and business fields, using PBKDF2 cryptography.
        /// </summary>
        public bool registerUserWithProfileAtomic(
            int roleId,
            string fullName,
            string email,
            string phone,
            string plainPassword,
            bool isActive,
            bool isVerified,
            // Factory profile details
            string factoryCompany,
            string factoryIndustry,
            string factoryGstin,
            string factoryAddress,
            string factoryCity,
            string factoryState,
            string factoryPincode,
            string factoryContact,
            // Supplier profile details
            string supplierCompany,
            string supplierRegNo,
            string supplierGstin,
            string supplierAddress,
            string supplierCity,
            string supplierState,
            string supplierPincode,
            // Technician profile details
            string techSkills,
            int techExpYears,
            decimal techHourlyRate,
            string techAddress,
            string techCity,
            string techState,
            string techPincode,
            bool techIsAvailable,
            out int newUserId,
            out string errorMessage)
        {
            newUserId = 0;
            errorMessage = string.Empty;

            if (string.IsNullOrWhiteSpace(fullName))
            {
                errorMessage = "Full Name / Contact Person is required.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(email) || !email.Contains("@"))
            {
                errorMessage = "A valid Email Address is required.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(plainPassword) || plainPassword.Length < 6)
            {
                errorMessage = "Initial password must contain at least 6 characters.";
                return false;
            }

            using (SqlConnection con = getcon())
            {
                // 1. Check for email uniqueness before starting transaction
                string checkSql = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                using (SqlCommand checkCmd = new SqlCommand(checkSql, con))
                {
                    checkCmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email.Trim() });
                    int existing = Convert.ToInt32(checkCmd.ExecuteScalar());
                    if (existing > 0)
                    {
                        errorMessage = string.Format("An account with email '{0}' already exists in the system.", email);
                        return false;
                    }
                }

                // 2. Execute atomic user and role profile creation
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string salt = PasswordHasher.GenerateSalt();
                        string hash = PasswordHasher.HashPassword(plainPassword, salt);

                        string sqlUser = @"
                            INSERT INTO Users (RoleId, Email, PasswordHash, Salt, FullName, PhoneNumber, IsActive, IsVerified, CreatedAt)
                            VALUES (@RoleId, @Email, @PasswordHash, @Salt, @FullName, @PhoneNumber, @IsActive, @IsVerified, GETDATE());
                            SELECT SCOPE_IDENTITY();";

                        using (SqlCommand cmdUser = new SqlCommand(sqlUser, con, tx))
                        {
                            cmdUser.Parameters.Add(new SqlParameter("@RoleId", SqlDbType.Int) { Value = roleId });
                            cmdUser.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email.Trim() });
                            cmdUser.Parameters.Add(new SqlParameter("@PasswordHash", SqlDbType.VarChar, 255) { Value = hash });
                            cmdUser.Parameters.Add(new SqlParameter("@Salt", SqlDbType.VarChar, 100) { Value = salt });
                            cmdUser.Parameters.Add(new SqlParameter("@FullName", SqlDbType.NVarChar, 100) { Value = fullName.Trim() });
                            cmdUser.Parameters.Add(new SqlParameter("@PhoneNumber", SqlDbType.VarChar, 20) { Value = string.IsNullOrWhiteSpace(phone) ? (object)DBNull.Value : phone.Trim() });
                            cmdUser.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive });
                            cmdUser.Parameters.Add(new SqlParameter("@IsVerified", SqlDbType.Bit) { Value = isVerified });

                            object res = cmdUser.ExecuteScalar();
                            newUserId = Convert.ToInt32(res);
                        }

                        // Insert Role Profile
                        if (roleId == 2) // Factory
                        {
                            string comp = !string.IsNullOrWhiteSpace(factoryCompany) ? factoryCompany.Trim() : fullName.Trim();
                            string cont = !string.IsNullOrWhiteSpace(factoryContact) ? factoryContact.Trim() : fullName.Trim();

                            string sqlFactory = @"
                                INSERT INTO Factories (UserId, CompanyName, IndustryType, Address, City, State, Pincode, Gstin, ContactPerson, CreatedAt)
                                VALUES (@UserId, @CompanyName, @IndustryType, @Address, @City, @State, @Pincode, @Gstin, @ContactPerson, GETDATE())";

                            using (SqlCommand cmdFact = new SqlCommand(sqlFactory, con, tx))
                            {
                                cmdFact.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = newUserId });
                                cmdFact.Parameters.Add(new SqlParameter("@CompanyName", SqlDbType.NVarChar, 150) { Value = comp });
                                cmdFact.Parameters.Add(new SqlParameter("@IndustryType", SqlDbType.NVarChar, 100) { Value = string.IsNullOrWhiteSpace(factoryIndustry) ? (object)DBNull.Value : factoryIndustry.Trim() });
                                cmdFact.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = string.IsNullOrWhiteSpace(factoryAddress) ? (object)DBNull.Value : factoryAddress.Trim() });
                                cmdFact.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = string.IsNullOrWhiteSpace(factoryCity) ? (object)DBNull.Value : factoryCity.Trim() });
                                cmdFact.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = string.IsNullOrWhiteSpace(factoryState) ? (object)DBNull.Value : factoryState.Trim() });
                                cmdFact.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = string.IsNullOrWhiteSpace(factoryPincode) ? (object)DBNull.Value : factoryPincode.Trim() });
                                cmdFact.Parameters.Add(new SqlParameter("@Gstin", SqlDbType.VarChar, 20) { Value = string.IsNullOrWhiteSpace(factoryGstin) ? (object)DBNull.Value : factoryGstin.Trim() });
                                cmdFact.Parameters.Add(new SqlParameter("@ContactPerson", SqlDbType.NVarChar, 100) { Value = cont });
                                cmdFact.ExecuteNonQuery();
                            }
                        }
                        else if (roleId == 3) // Supplier
                        {
                            string comp = !string.IsNullOrWhiteSpace(supplierCompany) ? supplierCompany.Trim() : fullName.Trim();
                            string verStatus = isVerified ? "Verified" : "Pending";

                            string sqlSupplier = @"
                                INSERT INTO Suppliers (UserId, CompanyName, BusinessRegistrationNo, Gstin, Address, City, State, Pincode, VerificationStatus, Rating, CreatedAt)
                                VALUES (@UserId, @CompanyName, @BusinessRegistrationNo, @Gstin, @Address, @City, @State, @Pincode, @VerificationStatus, 4.50, GETDATE())";

                            using (SqlCommand cmdSupp = new SqlCommand(sqlSupplier, con, tx))
                            {
                                cmdSupp.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = newUserId });
                                cmdSupp.Parameters.Add(new SqlParameter("@CompanyName", SqlDbType.NVarChar, 150) { Value = comp });
                                cmdSupp.Parameters.Add(new SqlParameter("@BusinessRegistrationNo", SqlDbType.VarChar, 50) { Value = string.IsNullOrWhiteSpace(supplierRegNo) ? (object)DBNull.Value : supplierRegNo.Trim() });
                                cmdSupp.Parameters.Add(new SqlParameter("@Gstin", SqlDbType.VarChar, 20) { Value = string.IsNullOrWhiteSpace(supplierGstin) ? (object)DBNull.Value : supplierGstin.Trim() });
                                cmdSupp.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = string.IsNullOrWhiteSpace(supplierAddress) ? (object)DBNull.Value : supplierAddress.Trim() });
                                cmdSupp.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = string.IsNullOrWhiteSpace(supplierCity) ? (object)DBNull.Value : supplierCity.Trim() });
                                cmdSupp.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = string.IsNullOrWhiteSpace(supplierState) ? (object)DBNull.Value : supplierState.Trim() });
                                cmdSupp.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = string.IsNullOrWhiteSpace(supplierPincode) ? (object)DBNull.Value : supplierPincode.Trim() });
                                cmdSupp.Parameters.Add(new SqlParameter("@VerificationStatus", SqlDbType.VarChar, 20) { Value = verStatus });
                                cmdSupp.ExecuteNonQuery();
                            }
                        }
                        else if (roleId == 4) // Technician
                        {
                            string skills = !string.IsNullOrWhiteSpace(techSkills) ? techSkills.Trim() : "Industrial Machinery Maintenance";
                            string verStatus = isVerified ? "Verified" : "Pending";

                            string sqlTech = @"
                                INSERT INTO Technicians (UserId, SkillSummary, ExperienceYears, HourlyRate, Address, City, State, Pincode, IsAvailable, VerificationStatus, CreatedAt)
                                VALUES (@UserId, @SkillSummary, @ExperienceYears, @HourlyRate, @Address, @City, @State, @Pincode, @IsAvailable, @VerificationStatus, GETDATE())";

                            using (SqlCommand cmdTech = new SqlCommand(sqlTech, con, tx))
                            {
                                cmdTech.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = newUserId });
                                cmdTech.Parameters.Add(new SqlParameter("@SkillSummary", SqlDbType.NVarChar, 255) { Value = skills });
                                cmdTech.Parameters.Add(new SqlParameter("@ExperienceYears", SqlDbType.Int) { Value = techExpYears > 0 ? techExpYears : 1 });
                                cmdTech.Parameters.Add(new SqlParameter("@HourlyRate", SqlDbType.Decimal) { Value = techHourlyRate > 0 ? techHourlyRate : 500.00m });
                                cmdTech.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = string.IsNullOrWhiteSpace(techAddress) ? (object)DBNull.Value : techAddress.Trim() });
                                cmdTech.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = string.IsNullOrWhiteSpace(techCity) ? (object)DBNull.Value : techCity.Trim() });
                                cmdTech.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = string.IsNullOrWhiteSpace(techState) ? (object)DBNull.Value : techState.Trim() });
                                cmdTech.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = string.IsNullOrWhiteSpace(techPincode) ? (object)DBNull.Value : techPincode.Trim() });
                                cmdTech.Parameters.Add(new SqlParameter("@IsAvailable", SqlDbType.Bit) { Value = techIsAvailable });
                                cmdTech.Parameters.Add(new SqlParameter("@VerificationStatus", SqlDbType.VarChar, 20) { Value = verStatus });
                                cmdTech.ExecuteNonQuery();
                            }
                        }

                        tx.Commit();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        errorMessage = "Transaction aborted: " + ex.Message;
                        return false;
                    }
                }
            }
        }

        public int insertNewUser(string fullName, string email, string phone, string plainPassword, int roleId, bool isActive, bool isVerified)
        {
            string salt = PasswordHasher.GenerateSalt();
            string hash = PasswordHasher.HashPassword(plainPassword, salt);
            return insertUser(roleId, email, hash, salt, fullName, phone, isActive, isVerified);
        }

        public DataSet selectAllRoles()
        {
            using (SqlConnection con = getcon())
            {
                string sql = "SELECT RoleId, RoleName FROM Roles ORDER BY RoleId ASC";
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

        public bool updateUserProfile(int userId, string fullName, string email, string phone)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE Users 
                    SET FullName = @FullName, 
                        Email = @Email, 
                        PhoneNumber = @PhoneNumber, 
                        UpdatedAt = GETDATE()
                    WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FullName", SqlDbType.NVarChar, 100) { Value = fullName });
                    cmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email });
                    cmd.Parameters.Add(new SqlParameter("@PhoneNumber", SqlDbType.VarChar, 20) { Value = (object)phone ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool updateUserProfileImage(int userId, string profileImagePath)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE Users 
                    SET ProfileImage = @ProfileImage, 
                        UpdatedAt = GETDATE()
                    WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@ProfileImage", SqlDbType.NVarChar, 350) { Value = (object)profileImagePath ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool changeUserPassword(int userId, string oldPassword, string newPassword, out string errorMessage)
        {
            errorMessage = string.Empty;

            if (string.IsNullOrWhiteSpace(newPassword) || newPassword.Length < 6)
            {
                errorMessage = "New password must be at least 6 characters long.";
                return false;
            }

            DataSet ds = getUserById(userId);
            if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
            {
                errorMessage = "User account not found.";
                return false;
            }

            DataRow row = ds.Tables[0].Rows[0];
            string storedHash = row["PasswordHash"].ToString();
            string storedSalt = row["Salt"].ToString();

            if (!PasswordHasher.VerifyPassword(oldPassword, storedHash, storedSalt))
            {
                errorMessage = "Current password verification failed. Please check your password.";
                return false;
            }

            string newSalt = PasswordHasher.GenerateSalt();
            string newHash = PasswordHasher.HashPassword(newPassword, newSalt);

            using (SqlConnection con = getcon())
            {
                string sql = "UPDATE Users SET PasswordHash = @PasswordHash, Salt = @Salt, UpdatedAt = GETDATE() WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@PasswordHash", SqlDbType.VarChar, 255) { Value = newHash });
                    cmd.Parameters.Add(new SqlParameter("@Salt", SqlDbType.VarChar, 100) { Value = newSalt });
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool resetUserPasswordByAdmin(int userId, string newPassword, out string errorMessage)
        {
            errorMessage = string.Empty;

            if (string.IsNullOrWhiteSpace(newPassword) || newPassword.Length < 6)
            {
                errorMessage = "New password must be at least 6 characters long.";
                return false;
            }

            string newSalt = PasswordHasher.GenerateSalt();
            string newHash = PasswordHasher.HashPassword(newPassword, newSalt);

            using (SqlConnection con = getcon())
            {
                string sql = "UPDATE Users SET PasswordHash = @PasswordHash, Salt = @Salt, UpdatedAt = GETDATE() WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@PasswordHash", SqlDbType.VarChar, 255) { Value = newHash });
                    cmd.Parameters.Add(new SqlParameter("@Salt", SqlDbType.VarChar, 100) { Value = newSalt });
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public void getUserCountsByRole(out int totalCount, out int adminCount, out int factoryCount, out int supplierCount, out int technicianCount)
        {
            totalCount = 0;
            adminCount = 0;
            factoryCount = 0;
            supplierCount = 0;
            technicianCount = 0;

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        COUNT(*) AS Total,
                        ISNULL(SUM(CASE WHEN RoleId = 1 THEN 1 ELSE 0 END), 0) AS Admins,
                        ISNULL(SUM(CASE WHEN RoleId = 2 THEN 1 ELSE 0 END), 0) AS Factories,
                        ISNULL(SUM(CASE WHEN RoleId = 3 THEN 1 ELSE 0 END), 0) AS Suppliers,
                        ISNULL(SUM(CASE WHEN RoleId = 4 THEN 1 ELSE 0 END), 0) AS Technicians
                    FROM Users";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            totalCount = Convert.ToInt32(rdr["Total"]);
                            adminCount = Convert.ToInt32(rdr["Admins"]);
                            factoryCount = Convert.ToInt32(rdr["Factories"]);
                            supplierCount = Convert.ToInt32(rdr["Suppliers"]);
                            technicianCount = Convert.ToInt32(rdr["Technicians"]);
                        }
                    }
                }
            }
        }
    }
}

