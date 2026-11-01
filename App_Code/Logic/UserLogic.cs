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
                           u.FullName, u.PhoneNumber, u.IsActive, u.IsVerified, u.CreatedAt
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
                           u.FullName, u.PhoneNumber, u.IsActive, u.IsVerified, u.CreatedAt
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
            if (!isActive)
            {
                errorMessage = "Your account has been deactivated. Please contact platform administration.";
                return false;
            }

            string storedHash = row["PasswordHash"].ToString();
            string storedSalt = row["Salt"].ToString();

            if (!PasswordHasher.VerifyPassword(password, storedHash, storedSalt))
            {
                errorMessage = "Invalid email or password.";
                return false;
            }

            userId = Convert.ToInt32(row["UserId"]);
            roleName = row["RoleName"].ToString();
            fullName = row["FullName"].ToString();
            isVerified = Convert.ToBoolean(row["IsVerified"]);

            // Set session variables directly using SessionHelper
            SessionHelper.UserId = userId;
            SessionHelper.UserRole = roleName;
            SessionHelper.UserEmail = email;
            SessionHelper.FullName = fullName;
            SessionHelper.IsVerified = isVerified;

            return true;
        }
    }
}

