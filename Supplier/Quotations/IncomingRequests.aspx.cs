using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Supplier.Quotations
{
    public partial class IncomingRequests : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly QuotationLogic _quotationLogic = new QuotationLogic();

        public IncomingRequests()
        {
            RequiredRole = RoleConstants.Supplier;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRfqs();
            }
        }

        private int GetSupplierId()
        {
            if (SessionHelper.UserId == null) return 0;
            return _userLogic.resolveSupplierId(SessionHelper.UserId.Value);
        }

        private void LoadRfqs()
        {
            int supplierId = GetSupplierId();
            if (supplierId == 0) return;

            DataSet ds = _quotationLogic.selectOpenRfqsForSupplier(supplierId);
            DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;

            gvRfqs.DataSource = dt;
            gvRfqs.DataBind();

            lblRfqCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
        }

        protected void gvRfqs_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "PrepareBid")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int rfqId = Convert.ToInt32(gvRfqs.DataKeys[rowIndex].Values["RfqId"]);
                string partNumber = gvRfqs.DataKeys[rowIndex].Values["PartNumber"].ToString();
                string partName = gvRfqs.DataKeys[rowIndex].Values["PartName"].ToString();

                hfSelectedRfqId.Value = rfqId.ToString();
                lblBidRfqId.Text = rfqId.ToString();
                lblBidPartInfo.InnerText = $"{partNumber} - {partName}";

                txtOfferedPrice.Text = string.Empty;
                txtBidLeadTime.Text = "3";
                txtValidityDate.Text = DateTime.Today.AddDays(14).ToString("yyyy-MM-dd");
                txtBidComments.Text = string.Empty;

                pnlSubmitBid.Visible = true;
            }
        }

        protected void btnCancelBid_Click(object sender, EventArgs e)
        {
            pnlSubmitBid.Visible = false;
        }

        protected void btnSubmitBidAction_Click(object sender, EventArgs e)
        {
            int supplierId = GetSupplierId();
            if (supplierId == 0) return;

            int rfqId;
            if (!int.TryParse(hfSelectedRfqId.Value, out rfqId))
            {
                ShowAlert("Invalid RFQ reference.", true);
                return;
            }

            decimal unitPrice;
            if (!decimal.TryParse(txtOfferedPrice.Text.Trim(), out unitPrice) || unitPrice <= 0)
            {
                ShowAlert("Please enter a valid positive unit price.", true);
                return;
            }

            int leadTimeDays;
            if (!int.TryParse(txtBidLeadTime.Text.Trim(), out leadTimeDays) || leadTimeDays < 0)
            {
                leadTimeDays = 3;
            }

            DateTime? validity = null;
            DateTime parsedVal;
            if (DateTime.TryParse(txtValidityDate.Text.Trim(), out parsedVal))
            {
                validity = parsedVal;
            }

            string comments = txtBidComments.Text.Trim();

            try
            {
                int responseId = _quotationLogic.insertBid(rfqId, supplierId, unitPrice, leadTimeDays, validity, comments);

                if (responseId > 0)
                {
                    pnlSubmitBid.Visible = false;
                    ShowAlert($"Quotation Bid #{responseId} for RFQ #{rfqId} has been successfully submitted to the factory buyer!", false);
                    LoadRfqs();
                }
                else
                {
                    ShowAlert("Failed to transmit quotation bid. Please try again.", true);
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error submitting bid: " + ex.Message, true);
            }
        }

        private void ShowAlert(string message, bool isError)
        {
            pnlAlert.Visible = true;
            if (isError)
            {
                pnlAlert.CssClass = "p-4 mb-6 rounded-[3px] bg-[#FEE2E2] border border-[#FCA5A5] text-xs text-[#991B1B] flex items-center justify-between";
            }
            else
            {
                pnlAlert.CssClass = "p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between";
            }
            lblAlertMessage.Text = message;
        }
    }
}

