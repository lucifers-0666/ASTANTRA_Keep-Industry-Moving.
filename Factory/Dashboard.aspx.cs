using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Database;
using IndustrialSparePartPortal.App_Code.Helpers;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory
{
    public partial class Dashboard : BasePage
    {
        public Dashboard()
        {
            RequiredRole = RoleConstants.Factory;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int? userId = SessionHelper.UserId;
                int factoryId = ResolveFactoryId(userId);

                // Handle incoming query string notifications
                string msg = Request.QueryString["msg"];
                if (string.Equals(msg, "emergency_submitted", StringComparison.OrdinalIgnoreCase))
                {
                    pnlAlertNotice.Visible = true;
                    lblAlertText.InnerText = "Priority machine breakdown logged. Emergency alert broadcasted across regional stocking suppliers.";
                }

                // Check if directed to issue an RFQ directly
                string action = Request.QueryString["action"];
                if (string.Equals(action, "rfq", StringComparison.OrdinalIgnoreCase))
                {
                    pnlRfqForm.Visible = true;
                }

                LoadPartsDropdown();
                LoadDashboard(factoryId);
            }
        }

        private int ResolveFactoryId(int? userId)
        {
            if (userId.HasValue)
            {
                string sql = "SELECT FactoryId, CompanyName, City, State FROM Factories WHERE UserId = @UserId";
                SqlParameter[] parameters = { new SqlParameter("@UserId", SqlDbType.Int) { Value = userId.Value } };
                DataRow row = DbFactory.ExecuteSingleRow(sql, parameters);

                if (row != null)
                {
                    lblUserCompany.InnerText = row["CompanyName"] != DBNull.Value ? row["CompanyName"].ToString() : "Industrial Buyer";
                    string city = row["City"] != DBNull.Value ? row["City"].ToString() : "Gujarat";
                    string state = row["State"] != DBNull.Value ? row["State"].ToString() : "MH/GJ";
                    lblPlantLocation.InnerText = $"{city}, {state} Operational Facility";
                    return Convert.ToInt32(row["FactoryId"]);
                }
            }

            lblUserCompany.InnerText = SessionHelper.FullName ?? "Industrial Plant Buyer";
            lblPlantLocation.InnerText = "Regional Manufacturing Plant";
            return 1; // Default demo fallback factory entity ID
        }

        private void LoadPartsDropdown()
        {
            string sql = "SELECT PartId, PartNumber + ' — ' + PartName AS DisplayName FROM SpareParts ORDER BY PartName ASC";
            DataTable dt = DbFactory.ExecuteQuery(sql);

            ddlRfqPart.Items.Clear();
            ddlRfqPart.Items.Add(new ListItem("-- Select Equipment Spare Part --", ""));

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    ddlRfqPart.Items.Add(new ListItem(row["DisplayName"].ToString(), row["PartId"].ToString()));
                }
            }

            // Check if part was preselected via URL
            string partIdParam = Request.QueryString["partId"];
            if (!string.IsNullOrEmpty(partIdParam) && ddlRfqPart.Items.FindByValue(partIdParam) != null)
            {
                ddlRfqPart.SelectedValue = partIdParam;
            }
        }

        private void LoadDashboard(int factoryId)
        {
            LoadMetrics(factoryId);
            LoadRfqs(factoryId);
            LoadOrders(factoryId);
            LoadEmergencyRequests(factoryId);
        }

        private void LoadMetrics(int factoryId)
        {
            // 1. Active RFQs
            string sqlRfqs = "SELECT COUNT(*) FROM QuotationRequests WHERE FactoryId = @FactoryId AND Status IN ('Pending', 'Quoted')";
            object rfqCount = DbFactory.ExecuteScalar(sqlRfqs, new[] { new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId } });
            lblMetricRfqs.InnerText = rfqCount != null ? rfqCount.ToString() : "0";

            // 2. Quotes Received pending review
            string sqlQuotes = @"
                SELECT COUNT(qr.ResponseId)
                FROM QuotationResponses qr
                INNER JOIN QuotationRequests q ON qr.RfqId = q.RfqId
                WHERE q.FactoryId = @FactoryId AND qr.Status = 'Submitted'";
            object quoteCount = DbFactory.ExecuteScalar(sqlQuotes, new[] { new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId } });
            lblMetricQuotes.InnerText = quoteCount != null ? quoteCount.ToString() : "0";

            // 3. Active Orders in transit
            string sqlOrders = "SELECT COUNT(*) FROM Orders WHERE FactoryId = @FactoryId AND OrderStatus IN ('Placed', 'Processing', 'Shipped')";
            object orderCount = DbFactory.ExecuteScalar(sqlOrders, new[] { new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId } });
            lblMetricOrders.InnerText = orderCount != null ? orderCount.ToString() : "0";

            // 4. Critical Emergency alerts
            string sqlEmergency = "SELECT COUNT(*) FROM EmergencyRequests WHERE FactoryId = @FactoryId AND Status IN ('Open', 'Dispatched')";
            object emergencyCount = DbFactory.ExecuteScalar(sqlEmergency, new[] { new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId } });
            lblMetricEmergency.InnerText = emergencyCount != null ? emergencyCount.ToString() : "0";
        }

        private void LoadRfqs(int factoryId)
        {
            string sql = @"
                SELECT q.RfqId, sp.PartNumber, sp.PartName, q.Quantity, q.TargetPrice, q.RequiredByDate, q.Status, q.CreatedAt,
                       (SELECT COUNT(*) FROM QuotationResponses qr WHERE qr.RfqId = q.RfqId) AS ResponseCount
                FROM QuotationRequests q
                INNER JOIN SpareParts sp ON q.PartId = sp.PartId
                WHERE q.FactoryId = @FactoryId
                ORDER BY q.CreatedAt DESC";

            DataTable dt = DbFactory.ExecuteQuery(sql, new[] { new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId } });

            if (dt != null && dt.Rows.Count > 0)
            {
                rptRfqs.DataSource = dt;
                rptRfqs.DataBind();
                rptRfqs.Visible = true;
                pnlNoRfqs.Visible = false;
            }
            else
            {
                rptRfqs.Visible = false;
                pnlNoRfqs.Visible = true;
            }
        }

        private void LoadOrders(int factoryId)
        {
            string sql = @"
                SELECT o.OrderId, o.OrderNumber, s.CompanyName AS SupplierName, o.TotalAmount, o.OrderStatus, o.IsEmergency, o.TrackingNumber, o.OrderDate
                FROM Orders o
                INNER JOIN Suppliers s ON o.SupplierId = s.SupplierId
                WHERE o.FactoryId = @FactoryId
                ORDER BY o.OrderDate DESC";

            DataTable dt = DbFactory.ExecuteQuery(sql, new[] { new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId } });

            if (dt != null && dt.Rows.Count > 0)
            {
                rptOrders.DataSource = dt;
                rptOrders.DataBind();
                rptOrders.Visible = true;
                pnlNoOrders.Visible = false;
            }
            else
            {
                rptOrders.Visible = false;
                pnlNoOrders.Visible = true;
            }
        }

        private void LoadEmergencyRequests(int factoryId)
        {
            string sql = @"
                SELECT e.EmergencyRequestId, e.MachineName, e.BreakdownDescription, e.PriorityLevel, e.LocationCity, e.Status, e.CreatedAt,
                       ISNULL(sp.PartNumber, 'OEM General Part') AS PartNumber
                FROM EmergencyRequests e
                LEFT JOIN SpareParts sp ON e.PartId = sp.PartId
                WHERE e.FactoryId = @FactoryId
                ORDER BY e.CreatedAt DESC";

            DataTable dt = DbFactory.ExecuteQuery(sql, new[] { new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId } });

            if (dt != null && dt.Rows.Count > 0)
            {
                rptEmergency.DataSource = dt;
                rptEmergency.DataBind();
                rptEmergency.Visible = true;
                pnlNoEmergency.Visible = false;
            }
            else
            {
                rptEmergency.Visible = false;
                pnlNoEmergency.Visible = true;
            }
        }

        protected void btnToggleRfqForm_Click(object sender, EventArgs e)
        {
            pnlRfqForm.Visible = !pnlRfqForm.Visible;
        }

        protected void btnCancelRfq_Click(object sender, EventArgs e)
        {
            pnlRfqForm.Visible = false;
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlertNotice.Visible = false;
        }

        protected void btnSubmitRfq_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlRfqPart.SelectedValue))
            {
                pnlAlertNotice.Visible = true;
                lblAlertText.InnerText = "Please select a valid spare part from the catalog to issue an RFQ.";
                return;
            }

            int partId;
            if (!int.TryParse(ddlRfqPart.SelectedValue, out partId))
            {
                return;
            }

            int quantity = 1;
            int.TryParse(txtRfqQty.Text.Trim(), out quantity);
            if (quantity <= 0) quantity = 1;

            decimal? targetPrice = null;
            decimal parsedPrice;
            if (decimal.TryParse(txtRfqTargetPrice.Text.Trim(), out parsedPrice) && parsedPrice > 0)
            {
                targetPrice = parsedPrice;
            }

            DateTime? requiredByDate = null;
            DateTime parsedDate;
            if (DateTime.TryParse(txtRfqRequiredDate.Text.Trim(), out parsedDate))
            {
                requiredByDate = parsedDate;
            }

            string remarks = txtRfqRemarks.Text.Trim();
            int factoryId = ResolveFactoryId(SessionHelper.UserId);

            string sql = @"
                INSERT INTO QuotationRequests (FactoryId, PartId, Quantity, TargetPrice, RequiredByDate, Status, Remarks, CreatedAt)
                VALUES (@FactoryId, @PartId, @Quantity, @TargetPrice, @RequiredByDate, 'Pending', @Remarks, GETDATE())";

            SqlParameter[] parameters = {
                new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId },
                new SqlParameter("@PartId", SqlDbType.Int) { Value = partId },
                new SqlParameter("@Quantity", SqlDbType.Int) { Value = quantity },
                new SqlParameter("@TargetPrice", SqlDbType.Decimal) { Value = (object)targetPrice ?? DBNull.Value },
                new SqlParameter("@RequiredByDate", SqlDbType.Date) { Value = (object)requiredByDate ?? DBNull.Value },
                new SqlParameter("@Remarks", SqlDbType.NVarChar) { Value = string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks }
            };

            try
            {
                DbFactory.ExecuteNonQuery(sql, parameters);
                pnlRfqForm.Visible = false;
                pnlAlertNotice.Visible = true;
                lblAlertText.InnerText = "Request for Quotation successfully broadcasted to regional stocking suppliers.";

                // Clear input fields
                ddlRfqPart.SelectedIndex = 0;
                txtRfqQty.Text = "1";
                txtRfqTargetPrice.Text = string.Empty;
                txtRfqRequiredDate.Text = string.Empty;
                txtRfqRemarks.Text = string.Empty;

                LoadDashboard(factoryId);
            }
            catch (Exception ex)
            {
                pnlAlertNotice.Visible = true;
                lblAlertText.InnerText = "Unable to issue RFQ. Please verify details and retry.";
                // Logging without exposing internal details to client
                System.Diagnostics.Trace.TraceError("RFQ Submission Error: " + ex.Message);
            }
        }
    }
}
