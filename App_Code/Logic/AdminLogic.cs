using System;
using System.Data;
using System.Data.SqlClient;

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
    }
}
