using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory
{
    public partial class Dashboard : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly PartLogic _partLogic = new PartLogic();
        private readonly QuotationLogic _quotationLogic = new QuotationLogic();
        private readonly OrderLogic _orderLogic = new OrderLogic();
        private readonly AdminLogic _adminLogic = new AdminLogic();

        public Dashboard()
        {
            RequiredRole = RoleConstants.Factory;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int factoryId = ResolveFactoryId(SessionHelper.UserId);

                string msg = Request.QueryString["msg"];
                if (string.Equals(msg, "emergency_submitted", StringComparison.OrdinalIgnoreCase))
                {
                    pnlAlertNotice.Visible = true;
                    lblAlertText.InnerText = "Priority machine breakdown logged. Emergency alert broadcasted across regional stocking suppliers.";
                }

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
                int fid = _userLogic.resolveFactoryId(userId.Value);
                if (fid > 0)
                {
                    lblUserCompany.InnerText = SessionHelper.FullName ?? "Industrial Buyer";
                    lblPlantLocation.InnerText = "Operational Facility";
                    return fid;
                }
            }

            // Reject unmapped or unauthorized direct identity requests
            Response.Redirect("~/Account/AccessDenied.aspx");
            return 0;
        }

        private void LoadPartsDropdown()
        {
            DataSet ds = _partLogic.selectAllParts();
            ddlRfqPart.Items.Clear();
            ddlRfqPart.Items.Add(new ListItem("-- Select Equipment Spare Part --", ""));

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    string label = $"{row["PartNumber"]} — {row["PartName"]}";
                    ddlRfqPart.Items.Add(new ListItem(label, row["PartId"].ToString()));
                }
            }

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
            int activeRfqs, quoteResponses, activeOrders, openEmergencies;
            _quotationLogic.getFactoryDashboardMetrics(factoryId, out activeRfqs, out quoteResponses, out activeOrders, out openEmergencies);

            lblMetricRfqs.InnerText = activeRfqs.ToString();
            lblMetricQuotes.InnerText = quoteResponses.ToString();
            lblMetricOrders.InnerText = activeOrders.ToString();
            lblMetricEmergency.InnerText = openEmergencies.ToString();
        }

        private void LoadRfqs(int factoryId)
        {
            DataSet ds = _quotationLogic.selectRfqsByFactory(factoryId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                rptRfqs.DataSource = ds.Tables[0];
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
            DataSet ds = _orderLogic.selectOrdersByFactory(factoryId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                rptOrders.DataSource = ds.Tables[0];
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
            if (factoryId <= 0)
            {
                rptEmergency.Visible = false;
                pnlNoEmergency.Visible = true;
                return;
            }

            DataSet ds = _adminLogic.selectOpenEmergenciesByFactory(factoryId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                rptEmergency.DataSource = ds.Tables[0];
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

            try
            {
                int rfqId = _quotationLogic.insertRfq(factoryId, partId, quantity, targetPrice, requiredByDate, remarks);

                pnlRfqForm.Visible = false;
                pnlAlertNotice.Visible = true;
                lblAlertText.InnerText = $"Request for Quotation RFQ-{rfqId:D5} broadcasted to regional stocking suppliers.";

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
                System.Diagnostics.Trace.TraceError("RFQ Submission Error: " + ex.Message);
            }
        }
    }
}
