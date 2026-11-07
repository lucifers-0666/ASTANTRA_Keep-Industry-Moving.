using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Analytics Logic class for ASTANTRA Administrator Dashboard.
    /// Provides parameterized aggregations for executive KPIs, order pipelines, user demographics,
    /// RFQ conversion funnels, and real-time operational alerts without fabricated records.
    /// </summary>
    public class AdminAnalyticsLogic : BaseLogic
    {
        #region Executive Metrics & KPIs
        /// <summary>
        /// Computes real-time executive dashboard KPIs within an optional parameterized date window.
        /// KPI Definitions:
        /// - Gross Order Value: Sum of TotalAmount for all non-cancelled orders in the timeframe.
        /// - Realized Revenue: Sum of TotalAmount strictly for Delivered/Completed orders. Cancelled orders are excluded.
        /// - RFQ Conversion Rate: Percentage of RFQs that transitioned to Accepted quotes.
        /// </summary>
        public void getExecutiveMetrics(
            DateTime? startDate,
            DateTime? endDate,
            out int totalUsers,
            out int verifiedSuppliers,
            out int activeFactories,
            out int activeTechnicians,
            out int openEmergencies,
            out int totalOrders,
            out decimal grossOrderValue,
            out decimal realizedRevenue,
            out int pendingRfqs,
            out decimal rfqConversionRate,
            out int delayedOrdersCount)
        {
            totalUsers = 0;
            verifiedSuppliers = 0;
            activeFactories = 0;
            activeTechnicians = 0;
            openEmergencies = 0;
            totalOrders = 0;
            grossOrderValue = 0m;
            realizedRevenue = 0m;
            pendingRfqs = 0m > 0 ? 0 : 0;
            rfqConversionRate = 0m;
            delayedOrdersCount = 0;

            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        (SELECT COUNT(*) FROM Users WHERE IsActive = 1) AS TotalUsers,
                        (SELECT COUNT(*) FROM Suppliers WHERE VerificationStatus = 'Verified') AS VerifiedSuppliers,
                        (SELECT COUNT(*) FROM Factories) AS ActiveFactories,
                        (SELECT COUNT(*) FROM Technicians WHERE IsAvailable = 1) AS ActiveTechnicians,
                        (SELECT COUNT(*) FROM EmergencyRequests WHERE Status NOT IN ('Resolved', 'Closed')) AS OpenEmergencies,
                        (SELECT COUNT(*) FROM Orders WHERE (@StartDate IS NULL OR OrderDate >= @StartDate) AND (@EndDate IS NULL OR OrderDate <= @EndDate)) AS TotalOrders,
                        (SELECT ISNULL(SUM(TotalAmount), 0) FROM Orders WHERE OrderStatus <> 'Cancelled' AND (@StartDate IS NULL OR OrderDate >= @StartDate) AND (@EndDate IS NULL OR OrderDate <= @EndDate)) AS GrossOrderValue,
                        (SELECT ISNULL(SUM(TotalAmount), 0) FROM Orders WHERE OrderStatus = 'Delivered' AND (@StartDate IS NULL OR OrderDate >= @StartDate) AND (@EndDate IS NULL OR OrderDate <= @EndDate)) AS RealizedRevenue,
                        (SELECT COUNT(*) FROM QuotationRequests WHERE Status = 'Pending' AND (@StartDate IS NULL OR CreatedAt >= @StartDate) AND (@EndDate IS NULL OR CreatedAt <= @EndDate)) AS PendingRfqs,
                        (SELECT COUNT(*) FROM QuotationRequests WHERE (@StartDate IS NULL OR CreatedAt >= @StartDate) AND (@EndDate IS NULL OR CreatedAt <= @EndDate)) AS TotalRfqsInPeriod,
                        (SELECT COUNT(DISTINCT r.RfqId) FROM QuotationRequests r INNER JOIN QuotationResponses qr ON r.RfqId = qr.RfqId WHERE qr.Status = 'Accepted' AND (@StartDate IS NULL OR r.CreatedAt >= @StartDate) AND (@EndDate IS NULL OR r.CreatedAt <= @EndDate)) AS ConvertedRfqs,
                        (SELECT COUNT(*) FROM Orders WHERE OrderStatus IN ('Pending', 'Processing', 'Dispatched') AND DATEDIFF(day, OrderDate, GETDATE()) > 3) AS DelayedOrders";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@StartDate", SqlDbType.DateTime) { Value = (object)startDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@EndDate", SqlDbType.DateTime) { Value = (object)endDate ?? DBNull.Value });

                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            totalUsers = r["TotalUsers"] != DBNull.Value ? Convert.ToInt32(r["TotalUsers"]) : 0;
                            verifiedSuppliers = r["VerifiedSuppliers"] != DBNull.Value ? Convert.ToInt32(r["VerifiedSuppliers"]) : 0;
                            activeFactories = r["ActiveFactories"] != DBNull.Value ? Convert.ToInt32(r["ActiveFactories"]) : 0;
                            activeTechnicians = r["ActiveTechnicians"] != DBNull.Value ? Convert.ToInt32(r["ActiveTechnicians"]) : 0;
                            openEmergencies = r["OpenEmergencies"] != DBNull.Value ? Convert.ToInt32(r["OpenEmergencies"]) : 0;
                            totalOrders = r["TotalOrders"] != DBNull.Value ? Convert.ToInt32(r["TotalOrders"]) : 0;
                            grossOrderValue = r["GrossOrderValue"] != DBNull.Value ? Convert.ToDecimal(r["GrossOrderValue"]) : 0m;
                            realizedRevenue = r["RealizedRevenue"] != DBNull.Value ? Convert.ToDecimal(r["RealizedRevenue"]) : 0m;
                            pendingRfqs = r["PendingRfqs"] != DBNull.Value ? Convert.ToInt32(r["PendingRfqs"]) : 0;
                            delayedOrdersCount = r["DelayedOrders"] != DBNull.Value ? Convert.ToInt32(r["DelayedOrders"]) : 0;

                            int totalRfqs = r["TotalRfqsInPeriod"] != DBNull.Value ? Convert.ToInt32(r["TotalRfqsInPeriod"]) : 0;
                            int convertedRfqs = r["ConvertedRfqs"] != DBNull.Value ? Convert.ToInt32(r["ConvertedRfqs"]) : 0;
                            if (totalRfqs > 0)
                            {
                                rfqConversionRate = Math.Round(((decimal)convertedRfqs / totalRfqs) * 100m, 1);
                            }
                        }
                    }
                }
            }
        }
        #endregion

        #region Chart & Aggregate Data Methods
        /// <summary>
        /// 1. Order counts grouped by status.
        /// </summary>
        public DataTable getOrderCountsByStatus(DateTime? startDate, DateTime? endDate)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT OrderStatus, COUNT(*) AS TotalCount, ISNULL(SUM(TotalAmount), 0) AS TotalAmount
                    FROM Orders
                    WHERE (@StartDate IS NULL OR OrderDate >= @StartDate)
                      AND (@EndDate IS NULL OR OrderDate <= @EndDate)
                    GROUP BY OrderStatus
                    ORDER BY TotalCount DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@StartDate", SqlDbType.DateTime) { Value = (object)startDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@EndDate", SqlDbType.DateTime) { Value = (object)endDate ?? DBNull.Value });

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("OrderCountsByStatus");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// 2. Orders and transaction value grouped by date (Day).
        /// Distinguishes Gross Order Value (non-cancelled) from Completed Revenue (Delivered).
        /// </summary>
        public DataTable getOrderVolumeAndValueOverTime(DateTime? startDate, DateTime? endDate)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT CONVERT(varchar(10), OrderDate, 120) AS TimePeriod,
                           COUNT(*) AS TotalOrders,
                           ISNULL(SUM(CASE WHEN OrderStatus <> 'Cancelled' THEN TotalAmount ELSE 0 END), 0) AS GrossOrderValue,
                           ISNULL(SUM(CASE WHEN OrderStatus = 'Delivered' THEN TotalAmount ELSE 0 END), 0) AS CompletedRevenue
                    FROM Orders
                    WHERE (@StartDate IS NULL OR OrderDate >= @StartDate)
                      AND (@EndDate IS NULL OR OrderDate <= @EndDate)
                    GROUP BY CONVERT(varchar(10), OrderDate, 120)
                    ORDER BY TimePeriod ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@StartDate", SqlDbType.DateTime) { Value = (object)startDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@EndDate", SqlDbType.DateTime) { Value = (object)endDate ?? DBNull.Value });

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("OrderVolumeAndValueOverTime");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// 3. User registration counts grouped by date.
        /// </summary>
        public DataTable getUserRegistrationsOverTime(DateTime? startDate, DateTime? endDate)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT CONVERT(varchar(10), CreatedAt, 120) AS RegistrationDate,
                           COUNT(*) AS NewUsersCount
                    FROM Users
                    WHERE (@StartDate IS NULL OR CreatedAt >= @StartDate)
                      AND (@EndDate IS NULL OR CreatedAt <= @EndDate)
                    GROUP BY CONVERT(varchar(10), CreatedAt, 120)
                    ORDER BY RegistrationDate ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@StartDate", SqlDbType.DateTime) { Value = (object)startDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@EndDate", SqlDbType.DateTime) { Value = (object)endDate ?? DBNull.Value });

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("UserRegistrationsOverTime");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// 4. User distribution grouped by role.
        /// </summary>
        public DataTable getUserDistributionByRole()
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT r.RoleName, 
                           COUNT(u.UserId) AS UserCount,
                           ISNULL(SUM(CASE WHEN u.IsActive = 1 THEN 1 ELSE 0 END), 0) AS ActiveCount,
                           ISNULL(SUM(CASE WHEN u.IsVerified = 1 THEN 1 ELSE 0 END), 0) AS VerifiedCount
                    FROM Roles r
                    LEFT JOIN Users u ON r.RoleId = u.RoleId
                    GROUP BY r.RoleId, r.RoleName
                    ORDER BY UserCount DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("UserDistributionByRole");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// 5. RFQ pipeline conversion funnel: Created -> Bids Received -> Accepted -> Orders Dispatched.
        /// </summary>
        public DataTable getRfqConversionFunnel(DateTime? startDate, DateTime? endDate)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 
                        (SELECT COUNT(*) FROM QuotationRequests WHERE (@StartDate IS NULL OR CreatedAt >= @StartDate) AND (@EndDate IS NULL OR CreatedAt <= @EndDate)) AS TotalRfqsCreated,
                        (SELECT COUNT(DISTINCT r.RfqId) FROM QuotationRequests r INNER JOIN QuotationResponses qr ON r.RfqId = qr.RfqId WHERE (@StartDate IS NULL OR r.CreatedAt >= @StartDate) AND (@EndDate IS NULL OR r.CreatedAt <= @EndDate)) AS BidsReceived,
                        (SELECT COUNT(DISTINCT r.RfqId) FROM QuotationRequests r INNER JOIN QuotationResponses qr ON r.RfqId = qr.RfqId WHERE qr.Status = 'Accepted' AND (@StartDate IS NULL OR r.CreatedAt >= @StartDate) AND (@EndDate IS NULL OR r.CreatedAt <= @EndDate)) AS BidsAccepted,
                        (SELECT COUNT(*) FROM Orders WHERE (@StartDate IS NULL OR OrderDate >= @StartDate) AND (@EndDate IS NULL OR OrderDate <= @EndDate)) AS OrdersCreated";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@StartDate", SqlDbType.DateTime) { Value = (object)startDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@EndDate", SqlDbType.DateTime) { Value = (object)endDate ?? DBNull.Value });

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("RfqConversionFunnel");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// 6. Emergency requests grouped by priority and status.
        /// </summary>
        public DataTable getEmergenciesByPriorityAndStatus(DateTime? startDate, DateTime? endDate)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT PriorityLevel, Status, COUNT(*) AS IncidentCount
                    FROM EmergencyRequests
                    WHERE (@StartDate IS NULL OR CreatedAt >= @StartDate)
                      AND (@EndDate IS NULL OR CreatedAt <= @EndDate)
                    GROUP BY PriorityLevel, Status
                    ORDER BY 
                        CASE PriorityLevel 
                            WHEN 'Critical' THEN 1 
                            WHEN 'High' THEN 2 
                            WHEN 'Medium' THEN 3 
                            WHEN 'Low' THEN 4 
                            ELSE 5 
                        END, Status";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@StartDate", SqlDbType.DateTime) { Value = (object)startDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@EndDate", SqlDbType.DateTime) { Value = (object)endDate ?? DBNull.Value });

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("EmergenciesByPriorityAndStatus");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// 7. Supplier activity and inventory coverage.
        /// </summary>
        public DataTable getSupplierActivityAndInventoryCoverage()
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT s.SupplierId, s.CompanyName, s.VerificationStatus, s.Rating,
                           COUNT(si.InventoryId) AS StockedPartsCount,
                           ISNULL(SUM(si.StockQuantity), 0) AS TotalStockUnits,
                           ISNULL(AVG(si.UnitPrice), 0) AS AvgUnitPrice
                    FROM Suppliers s
                    LEFT JOIN SupplierInventory si ON s.SupplierId = si.SupplierId
                    GROUP BY s.SupplierId, s.CompanyName, s.VerificationStatus, s.Rating
                    ORDER BY StockedPartsCount DESC, s.Rating DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("SupplierActivityAndInventoryCoverage");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// 8. Spare parts grouped by category.
        /// </summary>
        public DataTable getSparePartsByCategory()
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT c.CategoryId, c.CategoryName, c.IconClass,
                           COUNT(p.PartId) AS TotalPartsCount,
                           COUNT(DISTINCT si.SupplierId) AS ActiveSuppliersCount
                    FROM Categories c
                    LEFT JOIN SpareParts p ON c.CategoryId = p.CategoryId
                    LEFT JOIN SupplierInventory si ON p.PartId = si.PartId
                    GROUP BY c.CategoryId, c.CategoryName, c.IconClass
                    ORDER BY TotalPartsCount DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("SparePartsByCategory");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// 9. Delayed and pending orders requiring administrator intervention.
        /// </summary>
        public DataTable getDelayedAndPendingOrders(DateTime? startDate, DateTime? endDate)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT o.OrderId, o.OrderNumber, o.TotalAmount, o.OrderStatus, o.IsEmergency, o.OrderDate,
                           f.CompanyName AS FactoryName,
                           s.CompanyName AS SupplierName,
                           DATEDIFF(day, o.OrderDate, GETDATE()) AS DaysPending
                    FROM Orders o
                    INNER JOIN Factories f ON o.FactoryId = f.FactoryId
                    INNER JOIN Suppliers s ON o.SupplierId = s.SupplierId
                    WHERE o.OrderStatus IN ('Pending', 'Processing', 'Dispatched')
                      AND (@StartDate IS NULL OR o.OrderDate >= @StartDate)
                      AND (@EndDate IS NULL OR o.OrderDate <= @EndDate)
                    ORDER BY DaysPending DESC, o.IsEmergency DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@StartDate", SqlDbType.DateTime) { Value = (object)startDate ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@EndDate", SqlDbType.DateTime) { Value = (object)endDate ?? DBNull.Value });

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("DelayedAndPendingOrders");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// 10. Operational alerts for administrator triage.
        /// </summary>
        public DataTable getCriticalOperationalAlerts()
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT 'CRITICAL_SOS' AS AlertType,
                           'Critical Machine Stoppage' AS AlertTitle,
                           e.MachineName + ' reported at ' + f.CompanyName + ' (' + e.LocationCity + ')' AS AlertDescription,
                           e.CreatedAt AS AlertTimestamp,
                           e.EmergencyRequestId AS TargetId,
                           '~/Admin/Orders/Oversight.aspx' AS NavigationUrl
                    FROM EmergencyRequests e
                    INNER JOIN Factories f ON e.FactoryId = f.FactoryId
                    WHERE e.Status NOT IN ('Resolved', 'Closed') AND e.PriorityLevel IN ('Critical', 'High')

                    UNION ALL

                    SELECT 'UNVERIFIED_SUPPLIER' AS AlertType,
                           'Pending Supplier Verification' AS AlertTitle,
                           s.CompanyName + ' submitted GSTIN: ' + ISNULL(s.Gstin, 'N/A') + ' awaiting audit' AS AlertDescription,
                           u.CreatedAt AS AlertTimestamp,
                           s.SupplierId AS TargetId,
                           '~/Admin/Suppliers/Verification.aspx' AS NavigationUrl
                    FROM Suppliers s
                    INNER JOIN Users u ON s.UserId = u.UserId
                    WHERE s.VerificationStatus = 'Pending'

                    ORDER BY AlertTimestamp DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable("CriticalOperationalAlerts");
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }
        #endregion
    }
}
