using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory.Quotations
{
    public partial class MyRequests : BasePage
    {
        private readonly QuotationLogic _quotationLogic = new QuotationLogic();
        private readonly UserLogic _userLogic = new UserLogic();

        public MyRequests()
        {
            RequiredRole = RoleConstants.Factory;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRequests();
            }
        }

        private void LoadRequests()
        {
            int factoryId = _userLogic.resolveFactoryId(SessionHelper.UserId.Value);
            string statusFilter = ddlStatusFilter.SelectedValue;

            DataSet ds = _quotationLogic.selectRfqsByFactory(factoryId, statusFilter);
            gvRequests.DataSource = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvRequests.DataBind();

            lblRequestsCount.Text = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0].Rows.Count.ToString() : "0";
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
