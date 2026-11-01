using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory.Quotations
{
    public partial class Compare : BasePage
    {
        private readonly QuotationLogic _quotationLogic = new QuotationLogic();
        private readonly UserLogic _userLogic = new UserLogic();
        private int _rfqId;

        public Compare()
        {
            RequiredRole = RoleConstants.Factory;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["rfqId"], out _rfqId))
            {
                Response.Redirect("~/Factory/Quotations/MyRequests.aspx");
                return;
            }

            lblRfqIdHeader.Text = _rfqId.ToString("D5");

            if (!IsPostBack)
            {
                LoadRfqSummary();
                LoadSupplierBids();
            }
        }

        private void LoadRfqSummary()
        {
            int factoryId = _userLogic.resolveFactoryId(SessionHelper.UserId.Value);
            DataSet ds = _quotationLogic.selectRfqById(_rfqId, factoryId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                DataRow row = ds.Tables[0].Rows[0];
                lblPartNumber.InnerText = row["PartNumber"].ToString();
                lblPartName.InnerText = row["PartName"].ToString();
                lblQuantity.InnerText = row["Quantity"].ToString();
                lblTargetPrice.InnerText = row["TargetPrice"] != DBNull.Value 
                    ? "₹" + Convert.ToDecimal(row["TargetPrice"]).ToString("N2") 
                    : "Open";
            }
            else
            {
                Response.Redirect("~/Factory/Quotations/MyRequests.aspx");
            }
        }

        private void LoadSupplierBids()
        {
            DataSet ds = _quotationLogic.selectBidsByRfq(_rfqId);
            gvBids.DataSource = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvBids.DataBind();

            lblBidCount.Text = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0].Rows.Count.ToString() : "0";
        }

        protected void gvBids_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AcceptBid")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int responseId = Convert.ToInt32(gvBids.DataKeys[rowIndex].Values["ResponseId"]);
                int supplierId = Convert.ToInt32(gvBids.DataKeys[rowIndex].Values["SupplierId"]);
                decimal unitPrice = Convert.ToDecimal(gvBids.DataKeys[rowIndex].Values["OfferedUnitPrice"]);
                int quantity = int.TryParse(lblQuantity.InnerText, out int q) ? q : 1;
                decimal totalAmount = unitPrice * quantity;
                int factoryId = _userLogic.resolveFactoryId(SessionHelper.UserId.Value);

                if (_quotationLogic.acceptBidTransaction(_rfqId, responseId, factoryId, supplierId, totalAmount))
                {
                    Response.Redirect("~/Factory/Orders/MyOrders.aspx?accepted=true");
                }
                else
                {
                    pnlAlert.Visible = true;
                    lblAlertMessage.Text = "Failed to process quotation acceptance. Please retry.";
                }
            }
        }
    }
}
