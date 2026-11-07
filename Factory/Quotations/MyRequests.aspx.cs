using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory.Quotations
{
    public partial class MyRequests : FactoryBasePage
    {
        private readonly QuotationLogic _quotationLogic = new QuotationLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRequests();
            }
        }

        private void LoadRequests()
        {
            string statusFilter = ddlStatusFilter.SelectedValue;

            DataSet ds = _quotationLogic.selectRfqsByFactory(CurrentFactoryId, statusFilter);
            gvRequests.DataSource = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvRequests.DataBind();

            lblRequestsCount.InnerText = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0].Rows.Count.ToString() : "0";
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadRequests();
        }

        protected void gvRequests_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "CompareBids")
            {
                string rfqId = e.CommandArgument.ToString();
                Response.Redirect("~/Factory/Quotations/Compare.aspx?rfqId=" + rfqId);
            }
        }
    }
}
