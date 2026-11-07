using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Factory.Orders
{
    public partial class MyOrders : FactoryBasePage
    {
        private readonly OrderLogic _orderLogic = new OrderLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["accepted"] == "true")
                {
                    pnlAlert.Visible = true;
                    lblAlertMessage.Text = "Quotation accepted! Official purchase order placed with the supplier and dispatch tracking initialized.";
                }

                LoadOrders();
            }
        }

        private void LoadOrders()
        {
            string status = ddlStatusFilter.SelectedValue;
            DataSet ds = _orderLogic.selectOrdersByFactory(CurrentFactoryId, status);
            gvOrders.DataSource = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvOrders.DataBind();

            lblOrdersCount.InnerText = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0].Rows.Count.ToString() : "0";
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadOrders();
        }
    }
}
