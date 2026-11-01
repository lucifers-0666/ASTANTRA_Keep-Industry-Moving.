using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for Supplier Stock Inventory Management.
    /// </summary>
    public class InventoryLogic : BaseLogic
    {
        public DataSet selectBySupplier(int supplierId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT si.InventoryId, si.SupplierId, si.PartId, si.UnitPrice, si.StockQuantity, 
                           si.AvailabilityStatus, si.LeadTimeDays, si.LastUpdated,
                           p.PartNumber, p.PartName, p.UnitOfMeasure,
                           c.CategoryName
                    FROM SupplierInventory si
                    INNER JOIN SpareParts p ON si.PartId = p.PartId
                    INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                    WHERE si.SupplierId = @SupplierId
                    ORDER BY p.PartNumber ASC";

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

        public DataSet selectInventoryById(int inventoryId, int supplierId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT si.InventoryId, si.SupplierId, si.PartId, si.UnitPrice, si.StockQuantity, 
                           si.AvailabilityStatus, si.LeadTimeDays, si.LastUpdated,
                           p.PartNumber, p.PartName
                    FROM SupplierInventory si
                    INNER JOIN SpareParts p ON si.PartId = p.PartId
                    WHERE si.InventoryId = @InventoryId AND si.SupplierId = @SupplierId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@InventoryId", SqlDbType.Int) { Value = inventoryId });
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

        public bool insertInventory(int supplierId, int partId, decimal unitPrice, int stockQuantity, string availabilityStatus, int leadTimeDays)
        {
            using (SqlConnection con = getcon())
            {
                // Check if already exists; if so, update instead of crashing on unique constraint
                string sql = @"
                    IF EXISTS (SELECT 1 FROM SupplierInventory WHERE SupplierId = @SupplierId AND PartId = @PartId)
                    BEGIN
                        UPDATE SupplierInventory 
                        SET UnitPrice = @UnitPrice, StockQuantity = @StockQuantity, 
                            AvailabilityStatus = @AvailabilityStatus, LeadTimeDays = @LeadTimeDays, LastUpdated = GETDATE()
                        WHERE SupplierId = @SupplierId AND PartId = @PartId
                    END
                    ELSE
                    BEGIN
                        INSERT INTO SupplierInventory (SupplierId, PartId, UnitPrice, StockQuantity, AvailabilityStatus, LeadTimeDays, LastUpdated)
                        VALUES (@SupplierId, @PartId, @UnitPrice, @StockQuantity, @AvailabilityStatus, @LeadTimeDays, GETDATE())
                    END";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                    cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = partId });
                    cmd.Parameters.Add(new SqlParameter("@UnitPrice", SqlDbType.Decimal) { Value = unitPrice });
                    cmd.Parameters.Add(new SqlParameter("@StockQuantity", SqlDbType.Int) { Value = stockQuantity });
                    cmd.Parameters.Add(new SqlParameter("@AvailabilityStatus", SqlDbType.VarChar, 20) { Value = availabilityStatus ?? "InStock" });
                    cmd.Parameters.Add(new SqlParameter("@LeadTimeDays", SqlDbType.Int) { Value = leadTimeDays });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool updateInventory(int inventoryId, int supplierId, decimal unitPrice, int stockQuantity, string availabilityStatus, int leadTimeDays)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE SupplierInventory 
                    SET UnitPrice = @UnitPrice, StockQuantity = @StockQuantity, 
                        AvailabilityStatus = @AvailabilityStatus, LeadTimeDays = @LeadTimeDays, LastUpdated = GETDATE()
                    WHERE InventoryId = @InventoryId AND SupplierId = @SupplierId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@InventoryId", SqlDbType.Int) { Value = inventoryId });
                    cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                    cmd.Parameters.Add(new SqlParameter("@UnitPrice", SqlDbType.Decimal) { Value = unitPrice });
                    cmd.Parameters.Add(new SqlParameter("@StockQuantity", SqlDbType.Int) { Value = stockQuantity });
                    cmd.Parameters.Add(new SqlParameter("@AvailabilityStatus", SqlDbType.VarChar, 20) { Value = availabilityStatus });
                    cmd.Parameters.Add(new SqlParameter("@LeadTimeDays", SqlDbType.Int) { Value = leadTimeDays });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool deleteInventory(int inventoryId, int supplierId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "DELETE FROM SupplierInventory WHERE InventoryId = @InventoryId AND SupplierId = @SupplierId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@InventoryId", SqlDbType.Int) { Value = inventoryId });
                    cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public void getSupplierDashboardMetrics(int supplierId, out int inventoryCount, out int incomingRfqs, out int openEmergencies, out int ordersToFulfill)
        {
            inventoryCount = 0;
            incomingRfqs = 0;
            openEmergencies = 0;
            ordersToFulfill = 0;

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        (SELECT COUNT(*) FROM SupplierInventory WHERE SupplierId = @SupplierId) AS InventoryCount,
                        (SELECT COUNT(*) FROM QuotationRequests WHERE Status IN ('Pending', 'Quoted')) AS IncomingRfqs,
                        (SELECT COUNT(*) FROM EmergencyRequests WHERE Status = 'Open') AS OpenEmergencies,
                        (SELECT COUNT(*) FROM Orders WHERE SupplierId = @SupplierId AND OrderStatus IN ('Placed', 'Processing')) AS OrdersToFulfill";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            inventoryCount = rdr["InventoryCount"] != DBNull.Value ? Convert.ToInt32(rdr["InventoryCount"]) : 0;
                            incomingRfqs = rdr["IncomingRfqs"] != DBNull.Value ? Convert.ToInt32(rdr["IncomingRfqs"]) : 0;
                            openEmergencies = rdr["OpenEmergencies"] != DBNull.Value ? Convert.ToInt32(rdr["OpenEmergencies"]) : 0;
                            ordersToFulfill = rdr["OrdersToFulfill"] != DBNull.Value ? Convert.ToInt32(rdr["OrdersToFulfill"]) : 0;
                        }
                    }
                }
            }
        }
    }
}
