using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for Factory-Owned Machinery Asset Management.
    /// Strictly scopes all reads, writes, and deletions by authenticated FactoryId.
    /// </summary>
    public class FactoryMachineLogic : BaseLogic
    {
        public DataSet selectMachinesByFactory(int factoryId, string search = null, string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT fm.FactoryMachineId, fm.FactoryId, fm.MachineId, fm.AssetTag, 
                           fm.SerialNumber, fm.Department, fm.InstalledDate, fm.Status, fm.Notes, fm.CreatedAt,
                           m.MachineName, m.ModelNumber, m.Manufacturer,
                           (SELECT COUNT(*) FROM EmergencyRequests er WHERE er.FactoryMachineId = fm.FactoryMachineId) AS BreakdownCount
                    FROM FactoryMachines fm
                    INNER JOIN Machines m ON fm.MachineId = m.MachineId
                    WHERE fm.FactoryId = @FactoryId";

                var paramList = new System.Collections.Generic.List<SqlParameter>();
                paramList.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (fm.AssetTag LIKE @Search OR fm.SerialNumber LIKE @Search OR fm.Department LIKE @Search OR m.MachineName LIKE @Search OR m.ModelNumber LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 100) { Value = "%" + search + "%" });
                }

                if (!string.IsNullOrEmpty(statusFilter) && statusFilter != "All")
                {
                    sql += " AND fm.Status = @Status";
                    paramList.Add(new SqlParameter("@Status", SqlDbType.VarChar, 20) { Value = statusFilter });
                }

                sql += " ORDER BY fm.Department ASC, fm.AssetTag ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddRange(paramList.ToArray());
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataRow getMachineById(int factoryMachineId, int factoryId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT fm.FactoryMachineId, fm.FactoryId, fm.MachineId, fm.AssetTag, 
                           fm.SerialNumber, fm.Department, fm.InstalledDate, fm.Status, fm.Notes, fm.CreatedAt,
                           m.MachineName, m.ModelNumber, m.Manufacturer
                    FROM FactoryMachines fm
                    INNER JOIN Machines m ON fm.MachineId = m.MachineId
                    WHERE fm.FactoryMachineId = @FactoryMachineId AND fm.FactoryId = @FactoryId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryMachineId", SqlDbType.Int) { Value = factoryMachineId });
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return (dt.Rows.Count > 0) ? dt.Rows[0] : null;
                    }
                }
            }
        }

        public int insertMachine(int factoryId, int machineId, string assetTag, string serialNumber, string department, DateTime? installedDate, string status, string notes)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO FactoryMachines (FactoryId, MachineId, AssetTag, SerialNumber, Department, InstalledDate, Status, Notes, CreatedAt, UpdatedAt)
                    VALUES (@FactoryId, @MachineId, @AssetTag, @SerialNumber, @Department, @InstalledDate, @Status, @Notes, GETDATE(), GETDATE());
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    cmd.Parameters.Add(new SqlParameter("@MachineId", SqlDbType.Int) { Value = machineId });
                    cmd.Parameters.Add(new SqlParameter("@AssetTag", SqlDbType.NVarChar, 50) { Value = assetTag });
                    cmd.Parameters.Add(new SqlParameter("@SerialNumber", SqlDbType.NVarChar, 100) { Value = (object)serialNumber ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = (object)department ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@InstalledDate", SqlDbType.Date) { Value = (object)installedDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 20) { Value = string.IsNullOrEmpty(status) ? "Operational" : status });
                    cmd.Parameters.Add(new SqlParameter("@Notes", SqlDbType.NVarChar, -1) { Value = (object)notes ?? DBNull.Value });

                    object res = cmd.ExecuteScalar();
                    return Convert.ToInt32(res);
                }
            }
        }

        public bool updateMachine(int factoryMachineId, int factoryId, int machineId, string assetTag, string serialNumber, string department, DateTime? installedDate, string status, string notes)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE FactoryMachines 
                    SET MachineId = @MachineId,
                        AssetTag = @AssetTag,
                        SerialNumber = @SerialNumber,
                        Department = @Department,
                        InstalledDate = @InstalledDate,
                        Status = @Status,
                        Notes = @Notes,
                        UpdatedAt = GETDATE()
                    WHERE FactoryMachineId = @FactoryMachineId AND FactoryId = @FactoryId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryMachineId", SqlDbType.Int) { Value = factoryMachineId });
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    cmd.Parameters.Add(new SqlParameter("@MachineId", SqlDbType.Int) { Value = machineId });
                    cmd.Parameters.Add(new SqlParameter("@AssetTag", SqlDbType.NVarChar, 50) { Value = assetTag });
                    cmd.Parameters.Add(new SqlParameter("@SerialNumber", SqlDbType.NVarChar, 100) { Value = (object)serialNumber ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = (object)department ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@InstalledDate", SqlDbType.Date) { Value = (object)installedDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 20) { Value = string.IsNullOrEmpty(status) ? "Operational" : status });
                    cmd.Parameters.Add(new SqlParameter("@Notes", SqlDbType.NVarChar, -1) { Value = (object)notes ?? DBNull.Value });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool deleteMachine(int factoryMachineId, int factoryId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "DELETE FROM FactoryMachines WHERE FactoryMachineId = @FactoryMachineId AND FactoryId = @FactoryId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryMachineId", SqlDbType.Int) { Value = factoryMachineId });
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public void getFactoryMachineMetrics(int factoryId, out int totalCount, out int operationalCount, out int maintenanceCount, out int offlineCount)
        {
            totalCount = 0;
            operationalCount = 0;
            maintenanceCount = 0;
            offlineCount = 0;

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        COUNT(*) AS TotalCount,
                        ISNULL(SUM(CASE WHEN Status = 'Operational' THEN 1 ELSE 0 END), 0) AS OperationalCount,
                        ISNULL(SUM(CASE WHEN Status = 'Under Maintenance' THEN 1 ELSE 0 END), 0) AS MaintenanceCount,
                        ISNULL(SUM(CASE WHEN Status IN ('Offline', 'Decommissioned') THEN 1 ELSE 0 END), 0) AS OfflineCount
                    FROM FactoryMachines
                    WHERE FactoryId = @FactoryId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            totalCount = Convert.ToInt32(rdr["TotalCount"]);
                            operationalCount = Convert.ToInt32(rdr["OperationalCount"]);
                            maintenanceCount = Convert.ToInt32(rdr["MaintenanceCount"]);
                            offlineCount = Convert.ToInt32(rdr["OfflineCount"]);
                        }
                    }
                }
            }
        }
    }
}
