using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Supplier.Orders
{
    public partial class ManageOrders : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly OrderLogic _orderLogic = new OrderLogic();

        public ManageOrders()
        {
            RequiredRole = RoleConstants.Supplier;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        private int GetSupplierId()
        {
            if (SessionHelper.UserId == null) return 0;
            return _userLogic.resolveSupplierId(SessionHelper.UserId.Value);
        }

        private void LoadOrders()
        {
            int supplierId = GetSupplierId();
            if (supplierId == 0) return;

            string statusFilter = ddlStatusFilter.SelectedValue;
            DataSet ds = _orderLogic.selectOrdersBySupplier(supplierId, statusFilter);
            DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;

            gvOrders.DataSource = dt;
            gvOrders.DataBind();

            lblOrdersCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadOrders();
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateOrder")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int orderId = Convert.ToInt32(gvOrders.DataKeys[rowIndex].Values["OrderId"]);
                string orderNumber = gvOrders.DataKeys[rowIndex].Values["OrderNumber"].ToString();
                string factoryName = gvOrders.DataKeys[rowIndex].Values["FactoryName"].ToString();
                string currentStatus = gvOrders.DataKeys[rowIndex].Values["OrderStatus"].ToString();
                string currentTracking = gvOrders.DataKeys[rowIndex].Values["TrackingNumber"] != DBNull.Value 
                    ? gvOrders.DataKeys[rowIndex].Values["TrackingNumber"].ToString() 
                    : string.Empty;

                hfSelectedOrderId.Value = orderId.ToString();
                lblOrderNumberDisp.Text = orderNumber;
                lblBuyerCompany.InnerText = factoryName;

                if (ddlUpdateStatus.Items.FindByValue(currentStatus) != null)
                {
                    ddlUpdateStatus.SelectedValue = currentStatus;
                }

                txtTrackingNumber.Text = currentTracking;
                pnlUpdateLogistics.Visible = true;
            }
        }

        protected void btnCancelLogistics_Click(object sender, EventArgs e)
        {
            pnlUpdateLogistics.Visible = false;
        }

        protected void btnSaveLogistics_Click(object sender, EventArgs e)
        {
            int supplierId = GetSupplierId();
            if (supplierId == 0) return;

            int orderId;
            if (!int.TryParse(hfSelectedOrderId.Value, out orderId))
            {
                ShowAlert("Invalid Order ID.", true);
                return;
            }

            string newStatus = ddlUpdateStatus.SelectedValue;
            string trackingNo = txtTrackingNumber.Text.Trim();

            bool success = _orderLogic.updateOrderStatus(orderId, supplierId, newStatus, trackingNo);

            if (success)
            {
                pnlUpdateLogistics.Visible = false;
                ShowAlert($"Logistics status for Order #{lblOrderNumberDisp.Text} updated to '{newStatus}' successfully!", false);
                LoadOrders();
            }
            else
            {
                ShowAlert("Failed to update order fulfillment status.", true);
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

