using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for Factory Buyer Company Profile and Operations Settings.
    /// Strictly limits updates to the authenticated factory's own record.
    /// </summary>
    public class FactoryProfileLogic : BaseLogic
    {
        public DataRow getFactoryProfile(int factoryId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT f.FactoryId, f.UserId, f.CompanyName, f.IndustryType, 
                           f.Address, f.City, f.State, f.Pincode, f.Gstin, 
                           f.ContactPerson, f.ContactPhone, f.CreatedAt,
                           u.Email, u.FullName, u.PhoneNumber AS UserPhone, u.IsVerified
                    FROM Factories f
                    INNER JOIN Users u ON f.UserId = u.UserId
                    WHERE f.FactoryId = @FactoryId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt.Rows.Count > 0 ? dt.Rows[0] : null;
                    }
                }
            }
        }

        public bool updateFactoryProfile(int factoryId, string companyName, string industryType, string address, 
            string city, string state, string pincode, string gstin, string contactPerson, string contactPhone)
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
                        ContactPerson = @ContactPerson,
                        ContactPhone = @ContactPhone
                    WHERE FactoryId = @FactoryId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    cmd.Parameters.Add(new SqlParameter("@CompanyName", SqlDbType.NVarChar, 150) { Value = companyName });
                    cmd.Parameters.Add(new SqlParameter("@IndustryType", SqlDbType.NVarChar, 100) { Value = (object)industryType ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Address", SqlDbType.NVarChar, 255) { Value = (object)address ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@City", SqlDbType.NVarChar, 50) { Value = (object)city ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@State", SqlDbType.NVarChar, 50) { Value = (object)state ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Pincode", SqlDbType.VarChar, 10) { Value = (object)pincode ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Gstin", SqlDbType.VarChar, 20) { Value = (object)gstin ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@ContactPerson", SqlDbType.NVarChar, 100) { Value = (object)contactPerson ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@ContactPhone", SqlDbType.VarChar, 20) { Value = (object)contactPhone ?? DBNull.Value });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }
    }
}

