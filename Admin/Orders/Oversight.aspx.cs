using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin.Orders
{
    public partial class Oversight : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();
        private readonly OrderLogic _orderLogic = new OrderLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

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
            try
            {
                // 1. Emergency breakdown alerts
                DataSet dsEmerg = _adminLogic.selectAllEmergenciesDetailed();
                DataTable dtEmerg = (dsEmerg != null && dsEmerg.Tables.Count > 0) ? dsEmerg.Tables[0] : null;
                gvEmergency.DataSource = dtEmerg;
                gvEmergency.DataBind();
                lblEmergencyCount.Text = dtEmerg != null ? dtEmerg.Rows.Count.ToString() : "0";

                // 2. Commercial Quotations RFQ Monitor
                DataSet dsRfq = _adminLogic.selectAllQuotationsDetailed();
                DataTable dtRfq = (dsRfq != null && dsRfq.Tables.Count > 0) ? dsRfq.Tables[0] : null;
                gvQuotations.DataSource = dtRfq;
                gvQuotations.DataBind();
                lblRfqCount.Text = dtRfq != null ? dtRfq.Rows.Count.ToString() : "0";

                // 3. Purchase Orders fulfillment
                DataSet dsOrders = _orderLogic.selectAllOrders();
                DataTable dtOrders = (dsOrders != null && dsOrders.Tables.Count > 0) ? dsOrders.Tables[0] : null;
                gvOrders.DataSource = dtOrders;
                gvOrders.DataBind();
                lblOrdersCount.Text = dtOrders != null ? dtOrders.Rows.Count.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to load oversight telemetry"));
            }
        }

        #region SOS Triage Modal Events
        protected void gvEmergency_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "TriageSos")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int reqId = Convert.ToInt32(gvEmergency.DataKeys[rowIndex].Values["EmergencyRequestId"]);
                hdnSosRequestId.Value = reqId.ToString();

                lblSosPlant.InnerText = gvEmergency.DataKeys[rowIndex].Values["FactoryCompany"]?.ToString();
                lblSosMachine.InnerText = gvEmergency.DataKeys[rowIndex].Values["MachineName"]?.ToString();
                lblSosPriority.InnerText = gvEmergency.DataKeys[rowIndex].Values["PriorityLevel"]?.ToString();

                string status = gvEmergency.DataKeys[rowIndex].Values["Status"]?.ToString();
                if (ddlSosStatus.Items.FindByValue(status) != null)
                {
                    ddlSosStatus.SelectedValue = status;
                }

                pnlSosModal.Visible = true;
            }
        }

        protected void btnCloseSosModal_Click(object sender, EventArgs e)
        {
            pnlSosModal.Visible = false;
        }

        protected void btnSaveSosStatus_Click(object sender, EventArgs e)
        {
            int reqId = Convert.ToInt32(hdnSosRequestId.Value);
            string newStatus = ddlSosStatus.SelectedValue;

            try
            {
                bool updated = _adminLogic.updateEmergencyStatus(reqId, newStatus);
                if (updated)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "UPDATE_SOS_STATUS",
                        "EmergencyRequests",
                        reqId,
                        null,
                        $"Status -> {newStatus}",
                        Request.UserHostAddress
                    );

                    pnlSosModal.Visible = false;
                    ShowAlert(true, $"Emergency SOS breakdown ticket #{reqId} status updated to '{newStatus}'.");
                    LoadOversightData();
                }
                else
                {
                    ShowAlert(false, $"Failed to update SOS ticket #{reqId}.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to update emergency SOS ticket status"));
            }
        }
        #endregion

        #region Order Consignment Modal Events
        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditOrder")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int orderId = Convert.ToInt32(gvOrders.DataKeys[rowIndex].Values["OrderId"]);
                hdnOrderId.Value = orderId.ToString();

                lblModalOrderNo.InnerText = gvOrders.DataKeys[rowIndex].Values["OrderNumber"]?.ToString();
                lblModalBuyer.InnerText = gvOrders.DataKeys[rowIndex].Values["FactoryCompany"]?.ToString();
                lblModalSupplier.InnerText = gvOrders.DataKeys[rowIndex].Values["SupplierCompany"]?.ToString();

                string status = gvOrders.DataKeys[rowIndex].Values["OrderStatus"]?.ToString();
                if (ddlOrderStatus.Items.FindByValue(status) != null)
                {
                    ddlOrderStatus.SelectedValue = status;
                }

                txtTrackingNumber.Text = gvOrders.DataKeys[rowIndex].Values["TrackingNumber"] != DBNull.Value ? gvOrders.DataKeys[rowIndex].Values["TrackingNumber"]?.ToString() : string.Empty;

                pnlOrderModal.Visible = true;
            }
        }

        protected void btnCloseOrderModal_Click(object sender, EventArgs e)
        {
            pnlOrderModal.Visible = false;
        }

        protected void btnSaveOrderStatus_Click(object sender, EventArgs e)
        {
            int orderId = Convert.ToInt32(hdnOrderId.Value);
            string newStatus = ddlOrderStatus.SelectedValue;
            string tracking = txtTrackingNumber.Text.Trim();

            try
            {
                bool updated = _adminLogic.updateOrderStatusByAdmin(orderId, newStatus, tracking);
                if (updated)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "UPDATE_ORDER_STATUS",
                        "Orders",
                        orderId,
                        null,
                        $"Status: {newStatus}, Waybill: {tracking}",
                        Request.UserHostAddress
                    );

                    pnlOrderModal.Visible = false;
                    ShowAlert(true, $"Purchase Order #{orderId} updated to status '{newStatus}' successfully.");
                    LoadOversightData();
                }
                else
                {
                    ShowAlert(false, $"Failed to update order #{orderId}.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to update purchase order fulfillment status"));
            }
        }
        #endregion

        private void ShowAlert(bool isSuccess, string message)
        {
            pnlAlert.Visible = true;
            if (isSuccess)
            {
                pnlAlert.CssClass = "p-3.5 mb-5 rounded bg-emerald-50 border border-emerald-200 text-xs text-emerald-900 flex items-center justify-between";
                iconAlert.Attributes["class"] = "fa-solid fa-circle-check text-emerald-600";
            }
            else
            {
                pnlAlert.CssClass = "p-3.5 mb-5 rounded bg-rose-50 border border-rose-200 text-xs text-rose-900 flex items-center justify-between";
                iconAlert.Attributes["class"] = "fa-solid fa-triangle-exclamation text-rose-600";
            }
            lblAlertMessage.Text = message;
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }
    }
}
