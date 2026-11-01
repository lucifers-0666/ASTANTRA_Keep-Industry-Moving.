using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for Technician Maintenance Bookings, Dispatches, and Status Updates.
    /// </summary>
    public class ServiceLogic : BaseLogic
    {
        public DataSet selectAvailableTechnicians(string skill = null, string city = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT t.TechnicianId, t.UserId, t.SkillSummary, t.ExperienceYears, t.HourlyRate, 
                           t.City, t.State, t.IsAvailable, t.VerificationStatus,
                           u.FullName, u.Email, u.PhoneNumber
                    FROM Technicians t
                    INNER JOIN Users u ON t.UserId = u.UserId
                    WHERE u.IsActive = 1";

                var paramList = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(skill))
                {
                    sql += " AND t.SkillSummary LIKE @Skill";
                    paramList.Add(new SqlParameter("@Skill", SqlDbType.NVarChar, 255) { Value = "%" + skill + "%" });
                }

                if (!string.IsNullOrEmpty(city))
                {
                    sql += " AND t.City = @City";
                    paramList.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = city });
                }

                sql += " ORDER BY t.IsAvailable DESC, t.HourlyRate ASC";

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

        public int insertServiceRequest(int factoryId, int technicianId, string serviceType, string issueDescription, DateTime scheduledDate)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO ServiceRequests (FactoryId, TechnicianId, ServiceType, IssueDescription, ScheduledDate, ServiceStatus, CreatedAt)
                    VALUES (@FactoryId, @TechnicianId, @ServiceType, @IssueDescription, @ScheduledDate, 'Requested', GETDATE());
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    cmd.Parameters.Add(new SqlParameter("@TechnicianId", SqlDbType.Int) { Value = technicianId });
                    cmd.Parameters.Add(new SqlParameter("@ServiceType", SqlDbType.NVarChar, 100) { Value = serviceType });
                    cmd.Parameters.Add(new SqlParameter("@IssueDescription", SqlDbType.NVarChar, -1) { Value = issueDescription });
                    cmd.Parameters.Add(new SqlParameter("@ScheduledDate", SqlDbType.DateTime) { Value = scheduledDate });

                    object res = cmd.ExecuteScalar();
                    return Convert.ToInt32(res);
                }
            }
        }

        public DataSet selectRequestsByFactory(int factoryId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT s.ServiceRequestId, s.ServiceType, s.IssueDescription, s.ScheduledDate, 
                           s.ServiceStatus, s.CreatedAt,
                           u.FullName AS TechnicianName, t.HourlyRate, t.City AS TechnicianCity
                    FROM ServiceRequests s
                    INNER JOIN Technicians t ON s.TechnicianId = t.TechnicianId
                    INNER JOIN Users u ON t.UserId = u.UserId
                    WHERE s.FactoryId = @FactoryId
                    ORDER BY s.CreatedAt DESC";

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

        public DataSet selectAssignedJobs(int technicianId, string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT s.ServiceRequestId, s.ServiceType, s.IssueDescription, s.ScheduledDate, 
                           s.ServiceStatus, s.CreatedAt,
                           f.CompanyName AS FactoryName, f.City AS FactoryCity, f.Address AS FactoryAddress, 
                           f.ContactPerson, u.PhoneNumber AS FactoryPhone
                    FROM ServiceRequests s
                    INNER JOIN Factories f ON s.FactoryId = f.FactoryId
                    INNER JOIN Users u ON f.UserId = u.UserId
                    WHERE s.TechnicianId = @TechnicianId";

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    sql += " AND s.ServiceStatus = @Status";
                }

                sql += " ORDER BY s.ScheduledDate ASC, s.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@TechnicianId", SqlDbType.Int) { Value = technicianId });
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

        public DataSet selectJobDetails(int serviceRequestId, int technicianId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT s.ServiceRequestId, s.ServiceType, s.IssueDescription, s.ScheduledDate, 
                           s.ServiceStatus, s.Notes, s.CreatedAt,
                           f.CompanyName AS FactoryName, f.Address, f.City, f.State, f.Pincode,
                           f.ContactPerson, u.PhoneNumber, u.Email
                    FROM ServiceRequests s
                    INNER JOIN Factories f ON s.FactoryId = f.FactoryId
                    INNER JOIN Users u ON f.UserId = u.UserId
                    WHERE s.ServiceRequestId = @ServiceRequestId AND s.TechnicianId = @TechnicianId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@ServiceRequestId", SqlDbType.Int) { Value = serviceRequestId });
                    cmd.Parameters.Add(new SqlParameter("@TechnicianId", SqlDbType.Int) { Value = technicianId });

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public bool updateServiceStatus(int serviceRequestId, int technicianId, string newStatus, string notes = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE ServiceRequests 
                    SET ServiceStatus = @Status,
                        Notes = CASE WHEN @Notes IS NOT NULL AND @Notes <> '' THEN @Notes ELSE Notes END
                    WHERE ServiceRequestId = @ServiceRequestId AND TechnicianId = @TechnicianId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@ServiceRequestId", SqlDbType.Int) { Value = serviceRequestId });
                    cmd.Parameters.Add(new SqlParameter("@TechnicianId", SqlDbType.Int) { Value = technicianId });
                    cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 20) { Value = newStatus });
                    cmd.Parameters.Add(new SqlParameter("@Notes", SqlDbType.NVarChar, -1) { 
                        Value = string.IsNullOrEmpty(notes) ? (object)DBNull.Value : notes 
                    });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool updateTechnicianDutyStatus(int technicianId, bool isAvailable)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "UPDATE Technicians SET IsAvailable = @IsAvailable WHERE TechnicianId = @TechnicianId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@IsAvailable", SqlDbType.Bit) { Value = isAvailable });
                    cmd.Parameters.Add(new SqlParameter("@TechnicianId", SqlDbType.Int) { Value = technicianId });
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public void getTechnicianDashboardMetrics(int technicianId, out int assignedJobs, out int completedJobs, out decimal hourlyRate, out bool isAvailable)
        {
            assignedJobs = 0;
            completedJobs = 0;
            hourlyRate = 0.00m;
            isAvailable = false;

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        (SELECT COUNT(*) FROM ServiceRequests WHERE TechnicianId = @TechnicianId AND ServiceStatus IN ('Requested', 'Scheduled', 'In-Progress')) AS AssignedJobs,
                        (SELECT COUNT(*) FROM ServiceRequests WHERE TechnicianId = @TechnicianId AND ServiceStatus = 'Completed') AS CompletedJobs,
                        t.HourlyRate,
                        t.IsAvailable
                    FROM Technicians t
                    WHERE t.TechnicianId = @TechnicianId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@TechnicianId", SqlDbType.Int) { Value = technicianId });
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            assignedJobs = rdr["AssignedJobs"] != DBNull.Value ? Convert.ToInt32(rdr["AssignedJobs"]) : 0;
                            completedJobs = rdr["CompletedJobs"] != DBNull.Value ? Convert.ToInt32(rdr["CompletedJobs"]) : 0;
                            hourlyRate = rdr["HourlyRate"] != DBNull.Value ? Convert.ToDecimal(rdr["HourlyRate"]) : 0.00m;
                            isAvailable = rdr["IsAvailable"] != DBNull.Value ? Convert.ToBoolean(rdr["IsAvailable"]) : false;
                        }
                    }
                }
            }
        }
    }
}
