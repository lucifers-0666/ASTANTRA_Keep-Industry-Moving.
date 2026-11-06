using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for Platform Governance and Administrative Audit Logging.
    /// Follows the college professor's ADO.NET method using getcon().
    /// </summary>
    public class AuditLogic : BaseLogic
    {
        public bool logAction(int? userId, string actionType, string targetEntity, int? entityId, string oldValue = null, string newValue = null, string ipAddress = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO AuditLogs (UserId, ActionType, TargetEntity, EntityId, OldValue, NewValue, IpAddress, CreatedAt)
                    VALUES (@UserId, @ActionType, @TargetEntity, @EntityId, @OldValue, @NewValue, @IpAddress, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = (object)userId ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@ActionType", SqlDbType.VarChar, 50) { Value = actionType });
                    cmd.Parameters.Add(new SqlParameter("@TargetEntity", SqlDbType.VarChar, 50) { Value = targetEntity });
                    cmd.Parameters.Add(new SqlParameter("@EntityId", SqlDbType.Int) { Value = (object)entityId ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@OldValue", SqlDbType.NVarChar, -1) { Value = (object)oldValue ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@NewValue", SqlDbType.NVarChar, -1) { Value = (object)newValue ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@IpAddress", SqlDbType.VarChar, 50) { Value = (object)ipAddress ?? DBNull.Value });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public DataSet selectAuditLogs(string actionFilter = null, string entityFilter = null, int topCount = 100)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "SELECT TOP (" + topCount + @") 
                    a.LogId, a.UserId, a.ActionType, a.TargetEntity, a.EntityId, 
                    a.OldValue, a.NewValue, a.IpAddress, a.CreatedAt,
                    ISNULL(u.FullName, 'System Service') AS ActorName,
                    ISNULL(u.Email, 'system@platform.local') AS ActorEmail,
                    r.RoleName AS ActorRole
                FROM AuditLogs a
                LEFT JOIN Users u ON a.UserId = u.UserId
                LEFT JOIN Roles r ON u.RoleId = r.RoleId
                WHERE (1 = 1)";

                var paramList = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(actionFilter))
                {
                    sql += " AND a.ActionType = @ActionType";
                    paramList.Add(new SqlParameter("@ActionType", SqlDbType.VarChar, 50) { Value = actionFilter });
                }

                if (!string.IsNullOrEmpty(entityFilter))
                {
                    sql += " AND a.TargetEntity = @TargetEntity";
                    paramList.Add(new SqlParameter("@TargetEntity", SqlDbType.VarChar, 50) { Value = entityFilter });
                }

                sql += " ORDER BY a.CreatedAt DESC";

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
    }
}
