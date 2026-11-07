using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for Purchase Orders and Consignment Tracking.
    /// </summary>
    public class OrderLogic : BaseLogic
    {
        public DataSet selectOrdersByFactory(int factoryId, string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT o.OrderId, o.OrderNumber, o.TotalAmount, o.OrderStatus, o.IsEmergency, 
                           o.TrackingNumber, o.OrderDate,
                           s.CompanyName AS SupplierCompany, s.City
                    FROM Orders o
                    INNER JOIN Suppliers s ON o.SupplierId = s.SupplierId
                    WHERE o.FactoryId = @FactoryId";

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    sql += " AND o.OrderStatus = @Status";
                }

                sql += " ORDER BY o.OrderDate DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                    if (!string.IsNullOrEmpty(statusFilter))
                    {
                        cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 30) { Value = statusFilter });
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

        public DataSet selectOrdersBySupplier(int supplierId, string statusFilter = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT o.OrderId, o.OrderNumber, o.TotalAmount, o.OrderStatus, o.IsEmergency, 
                           o.TrackingNumber, o.OrderDate,
                           f.CompanyName AS FactoryName, f.City AS FactoryCity, f.ContactPerson, f.Pincode
                    FROM Orders o
                    INNER JOIN Factories f ON o.FactoryId = f.FactoryId
                    WHERE o.SupplierId = @SupplierId";

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    sql += " AND o.OrderStatus = @Status";
                }

                sql += " ORDER BY o.OrderDate DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                    if (!string.IsNullOrEmpty(statusFilter))
                    {
                        cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 30) { Value = statusFilter });
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

        public bool updateOrderStatus(int orderId, int supplierId, string newStatus, string trackingNumber)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE Orders 
                    SET OrderStatus = @OrderStatus, 
                        TrackingNumber = CASE WHEN @TrackingNumber IS NOT NULL AND @TrackingNumber <> '' THEN @TrackingNumber ELSE TrackingNumber END
                    WHERE OrderId = @OrderId AND SupplierId = @SupplierId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@OrderId", SqlDbType.Int) { Value = orderId });
                    cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                    cmd.Parameters.Add(new SqlParameter("@OrderStatus", SqlDbType.VarChar, 30) { Value = newStatus });
                    cmd.Parameters.Add(new SqlParameter("@TrackingNumber", SqlDbType.VarChar, 100) { 
                        Value = string.IsNullOrEmpty(trackingNumber) ? (object)DBNull.Value : trackingNumber 
                    });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public DataSet selectAllOrders()
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT o.OrderId, o.OrderNumber, o.TotalAmount, o.OrderStatus, o.TrackingNumber, o.OrderDate,
                           f.CompanyName AS FactoryCompany,
                           s.CompanyName AS SupplierCompany
                    FROM Orders o
                    INNER JOIN Factories f ON o.FactoryId = f.FactoryId
                    INNER JOIN Suppliers s ON o.SupplierId = s.SupplierId
                    ORDER BY o.OrderDate DESC";

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

        public DataRow selectOrderDetailsByFactory(int orderId, int factoryId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT o.OrderId, o.OrderNumber, o.TotalAmount, o.OrderStatus, o.IsEmergency, 
                           o.ShippingAddress, o.TrackingNumber, o.OrderDate,
                           f.FactoryId, f.CompanyName AS FactoryName, f.Address AS FactoryAddress,
                           f.City AS FactoryCity, f.State AS FactoryState, f.Pincode AS FactoryPincode,
                           f.Gstin AS FactoryGstin, f.ContactPerson AS FactoryContact, f.ContactPhone AS FactoryPhone,
                           s.SupplierId, s.CompanyName AS SupplierName, s.Address AS SupplierAddress,
                           s.City AS SupplierCity, s.State AS SupplierState, s.Pincode AS SupplierPincode,
                           s.Gstin AS SupplierGstin, su.FullName AS SupplierContact,
                           su.Email AS SupplierEmail, su.PhoneNumber AS SupplierPhone
                    FROM Orders o
                    INNER JOIN Factories f ON o.FactoryId = f.FactoryId
                    INNER JOIN Suppliers s ON o.SupplierId = s.SupplierId
                    INNER JOIN Users su ON s.UserId = su.UserId
                    WHERE o.OrderId = @OrderId AND o.FactoryId = @FactoryId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@OrderId", SqlDbType.Int) { Value = orderId });
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

        public DataSet selectOrderItems(int orderId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT oi.OrderItemId, oi.OrderId, oi.PartId, oi.Quantity, oi.UnitPrice, oi.TotalPrice,
                           p.PartNumber, p.PartName, p.TechnicalSpecs, p.UnitOfMeasure,
                           c.CategoryName
                    FROM OrderItems oi
                    INNER JOIN SpareParts p ON oi.PartId = p.PartId
                    INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                    WHERE oi.OrderId = @OrderId
                    ORDER BY oi.OrderItemId ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@OrderId", SqlDbType.Int) { Value = orderId });
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

