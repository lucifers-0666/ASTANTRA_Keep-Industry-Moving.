using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for Commercial RFQs, Quotation Bidding, and Bid Acceptance Transactions.
    /// </summary>
    public class QuotationLogic : BaseLogic
    {
        public int insertRfq(int factoryId, int partId, int quantity, decimal? targetPrice, DateTime? requiredByDate, string remarks)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO QuotationRequests (FactoryId, PartId, Quantity, TargetPrice, RequiredByDate, Status, Remarks, CreatedAt)
                    VALUES (@FactoryId, @PartId, @Quantity, @TargetPrice, @RequiredByDate, 'Pending', @Remarks, GETDATE());
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = partId });
                    cmd.Parameters.Add(new SqlParameter("@Quantity", SqlDbType.Int) { Value = quantity });
                    cmd.Parameters.Add(new SqlParameter("@TargetPrice", SqlDbType.Decimal) { Value = (object)targetPrice ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@RequiredByDate", SqlDbType.Date) { Value = (object)requiredByDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Remarks", SqlDbType.NVarChar, -1) { Value = string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks });

                    object res = cmd.ExecuteScalar();
                    return Convert.ToInt32(res);
                }
            }
        }

        public DataSet selectRfqsByFactory(int factoryId, string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT q.RfqId, q.Quantity, q.TargetPrice, q.RequiredByDate, q.Status, q.CreatedAt,
                           p.PartNumber, p.PartName,
                           (SELECT COUNT(*) FROM QuotationResponses r WHERE r.RfqId = q.RfqId) AS BidCount
                    FROM QuotationRequests q
                    INNER JOIN SpareParts p ON q.PartId = p.PartId
                    WHERE q.FactoryId = @FactoryId";

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    sql += " AND q.Status = @Status";
                }

                sql += " ORDER BY q.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
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

        public DataSet selectRfqById(int rfqId, int factoryId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT q.RfqId, q.Quantity, q.TargetPrice, q.Status, q.RequiredByDate, q.Remarks,
                           p.PartNumber, p.PartName
                    FROM QuotationRequests q
                    INNER JOIN SpareParts p ON q.PartId = p.PartId
                    WHERE q.RfqId = @RfqId AND q.FactoryId = @FactoryId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@RfqId", SqlDbType.Int) { Value = rfqId });
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

        public DataSet selectBidsByRfq(int rfqId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT r.ResponseId, r.RfqId, r.SupplierId, r.OfferedUnitPrice, r.OfferedLeadTimeDays,
                           r.ValidityDate, r.Status, r.Comments, r.CreatedAt,
                           s.CompanyName AS SupplierCompany, s.City, s.Rating
                    FROM QuotationResponses r
                    INNER JOIN Suppliers s ON r.SupplierId = s.SupplierId
                    WHERE r.RfqId = @RfqId
                    ORDER BY r.OfferedUnitPrice ASC, r.OfferedLeadTimeDays ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@RfqId", SqlDbType.Int) { Value = rfqId });
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet selectOpenRfqsForSupplier(int supplierId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT q.RfqId, q.PartId, q.Quantity, q.TargetPrice, q.RequiredByDate, q.Status, q.Remarks, q.CreatedAt,
                           p.PartNumber, p.PartName,
                           f.CompanyName AS FactoryName, f.City AS FactoryCity,
                           (SELECT COUNT(*) FROM QuotationResponses r WHERE r.RfqId = q.RfqId AND r.SupplierId = @SupplierId) AS HasQuoted
                    FROM QuotationRequests q
                    INNER JOIN SpareParts p ON q.PartId = p.PartId
                    INNER JOIN Factories f ON q.FactoryId = f.FactoryId
                    WHERE q.Status IN ('Pending', 'Quoted')
                    ORDER BY q.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public int insertBid(int rfqId, int supplierId, decimal unitPrice, int leadTimeDays, DateTime? validityDate, string comments)
        {
            using (SqlConnection con = getcon())
            {
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string insertSql = @"
                            INSERT INTO QuotationResponses (RfqId, SupplierId, OfferedUnitPrice, OfferedLeadTimeDays, ValidityDate, Status, Comments, CreatedAt)
                            VALUES (@RfqId, @SupplierId, @OfferedUnitPrice, @OfferedLeadTimeDays, @ValidityDate, 'Submitted', @Comments, GETDATE());
                            SELECT SCOPE_IDENTITY();";

                        int responseId;
                        using (SqlCommand cmd = new SqlCommand(insertSql, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@RfqId", SqlDbType.Int) { Value = rfqId });
                            cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                            cmd.Parameters.Add(new SqlParameter("@OfferedUnitPrice", SqlDbType.Decimal) { Value = unitPrice });
                            cmd.Parameters.Add(new SqlParameter("@OfferedLeadTimeDays", SqlDbType.Int) { Value = leadTimeDays });
                            cmd.Parameters.Add(new SqlParameter("@ValidityDate", SqlDbType.Date) { Value = (object)validityDate ?? DBNull.Value });
                            cmd.Parameters.Add(new SqlParameter("@Comments", SqlDbType.NVarChar, -1) { Value = string.IsNullOrEmpty(comments) ? (object)DBNull.Value : comments });

                            responseId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        // Update RFQ status to 'Quoted' so buyer sees quotes are available
                        string updateRfqSql = "UPDATE QuotationRequests SET Status = 'Quoted' WHERE RfqId = @RfqId AND Status = 'Pending'";
                        using (SqlCommand cmd = new SqlCommand(updateRfqSql, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@RfqId", SqlDbType.Int) { Value = rfqId });
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                        return responseId;
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        public void getFactoryDashboardMetrics(int factoryId, out int activeRfqs, out int quoteResponses, out int activeOrders, out int openEmergencies)
        {
            activeRfqs = 0;
            quoteResponses = 0;
            activeOrders = 0;
            openEmergencies = 0;

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        (SELECT COUNT(*) FROM QuotationRequests WHERE FactoryId = @FactoryId AND Status IN ('Pending', 'Quoted')) AS ActiveRfqs,
                        (SELECT COUNT(qr.ResponseId) FROM QuotationResponses qr INNER JOIN QuotationRequests q ON qr.RfqId = q.RfqId WHERE q.FactoryId = @FactoryId AND qr.Status = 'Submitted') AS QuotesCount,
                        (SELECT COUNT(*) FROM Orders WHERE FactoryId = @FactoryId AND OrderStatus IN ('Placed', 'Processing', 'Shipped')) AS ActiveOrders,
                        (SELECT COUNT(*) FROM EmergencyRequests WHERE FactoryId = @FactoryId AND Status IN ('Open', 'Dispatched')) AS OpenEmergencies";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            activeRfqs = rdr["ActiveRfqs"] != DBNull.Value ? Convert.ToInt32(rdr["ActiveRfqs"]) : 0;
                            quoteResponses = rdr["QuotesCount"] != DBNull.Value ? Convert.ToInt32(rdr["QuotesCount"]) : 0;
                            activeOrders = rdr["ActiveOrders"] != DBNull.Value ? Convert.ToInt32(rdr["ActiveOrders"]) : 0;
                            openEmergencies = rdr["OpenEmergencies"] != DBNull.Value ? Convert.ToInt32(rdr["OpenEmergencies"]) : 0;
                        }
                    }
                }
            }
        }

        public bool acceptBidTransaction(int rfqId, int responseId, int factoryId, int supplierId, decimal totalAmount)
        {
            using (SqlConnection con = getcon())
            {
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        // 1. Mark selected response accepted
                        string sqlAccept = "UPDATE QuotationResponses SET Status = 'Accepted' WHERE ResponseId = @ResponseId";
                        using (SqlCommand cmd = new SqlCommand(sqlAccept, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@ResponseId", SqlDbType.Int) { Value = responseId });
                            cmd.ExecuteNonQuery();
                        }

                        // 2. Mark remaining responses for this RFQ as rejected
                        string sqlRejectOthers = "UPDATE QuotationResponses SET Status = 'Rejected' WHERE RfqId = @RfqId AND ResponseId <> @ResponseId";
                        using (SqlCommand cmd = new SqlCommand(sqlRejectOthers, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@RfqId", SqlDbType.Int) { Value = rfqId });
                            cmd.Parameters.Add(new SqlParameter("@ResponseId", SqlDbType.Int) { Value = responseId });
                            cmd.ExecuteNonQuery();
                        }

                        // 3. Mark RFQ closed
                        string sqlCloseRfq = "UPDATE QuotationRequests SET Status = 'Closed' WHERE RfqId = @RfqId AND FactoryId = @FactoryId";
                        using (SqlCommand cmd = new SqlCommand(sqlCloseRfq, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@RfqId", SqlDbType.Int) { Value = rfqId });
                            cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                            cmd.ExecuteNonQuery();
                        }

                        // 4. Generate order in Orders table
                        string sqlOrder = @"
                            INSERT INTO Orders (OrderNumber, FactoryId, SupplierId, TotalAmount, OrderStatus, IsEmergency, OrderDate)
                            VALUES (@OrderNumber, @FactoryId, @SupplierId, @TotalAmount, 'Placed', 0, GETDATE())";
                        using (SqlCommand cmd = new SqlCommand(sqlOrder, con, tx))
                        {
                            string orderNo = "ORD-" + DateTime.Now.ToString("yyyyMMdd") + "-" + rfqId;
                            cmd.Parameters.Add(new SqlParameter("@OrderNumber", SqlDbType.VarChar, 50) { Value = orderNo });
                            cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                            cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                            cmd.Parameters.Add(new SqlParameter("@TotalAmount", SqlDbType.Decimal) { Value = totalAmount });
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
    }
}
