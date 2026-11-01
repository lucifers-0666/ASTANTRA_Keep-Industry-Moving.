using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Admin.Orders
{
    public partial class Oversight : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();
        private readonly OrderLogic _orderLogic = new OrderLogic();

        public Oversight()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOversightData();
            }
        }

        private void LoadOversightData()
        {
            // 1. Emergency breakdown alerts
            DataSet dsEmerg = _adminLogic.selectOpenEmergencies();
            DataTable dtEmerg = (dsEmerg != null && dsEmerg.Tables.Count > 0) ? dsEmerg.Tables[0] : null;
            gvEmergency.DataSource = dtEmerg;
            gvEmergency.DataBind();
            lblEmergencyCount.Text = dtEmerg != null ? dtEmerg.Rows.Count.ToString() : "0";

            // 2. Orders fulfillment
            DataSet dsOrders = _orderLogic.selectAllOrders();
            DataTable dtOrders = (dsOrders != null && dsOrders.Tables.Count > 0) ? dsOrders.Tables[0] : null;
            gvOrders.DataSource = dtOrders;
            gvOrders.DataBind();
            lblOrdersCount.Text = dtOrders != null ? dtOrders.Rows.Count.ToString() : "0";
        }
    }
}

