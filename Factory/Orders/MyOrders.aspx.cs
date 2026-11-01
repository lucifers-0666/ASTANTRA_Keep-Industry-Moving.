using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Factory.Orders
{
    public partial class MyOrders : BasePage
    {
        private readonly OrderLogic _orderLogic = new OrderLogic();
        private readonly UserLogic _userLogic = new UserLogic();

        public MyOrders()
        {
            RequiredRole = RoleConstants.Factory;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["accepted"] == "true")
                {
                    pnlAlert.Visible = true;
                }

                LoadOrders();
            }
        }

        private void LoadOrders()
        {
            int factoryId = _userLogic.resolveFactoryId(SessionHelper.UserId.Value);
            string status = ddlStatusFilter.SelectedValue;

            DataSet ds = _orderLogic.selectOrdersByFactory(factoryId, status);
            gvOrders.DataSource = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvOrders.DataBind();

            lblOrdersCount.Text = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0].Rows.Count.ToString() : "0";
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadOrders();
        }
    }
}
