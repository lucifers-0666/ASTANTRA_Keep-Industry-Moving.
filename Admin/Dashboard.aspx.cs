using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin
{
    public partial class Dashboard : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly AdminLogic _adminLogic = new AdminLogic();
        private readonly AdminAnalyticsLogic _analyticsLogic = new AdminAnalyticsLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public Dashboard()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState["Timeframe"] = "all";
                LoadDashboard();
            }
        }

        #region Timeframe & Refresh Commands
        protected void btnTimeframe_Click(object sender, EventArgs e)
        {
            LinkButton btn = sender as LinkButton;
            if (btn != null)
            {
                string tf = btn.CommandArgument;
                ViewState["Timeframe"] = tf;
                LoadDashboard();
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadDashboard();
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }
        #endregion

        #region Dashboard Data Loading & Aggregations
        private void LoadDashboard()
        {
            try
            {
                string timeframe = ViewState["Timeframe"] as string ?? "all";
                UpdateTimeframeButtonsUI(timeframe);

                DateTime? startDate = null;
                DateTime? endDate = DateTime.Now;

                if (timeframe == "7")
                {
                    startDate = DateTime.Today.AddDays(-7);
                }
                else if (timeframe == "30")
                {
                    startDate = DateTime.Today.AddDays(-30);
                }
                else if (timeframe == "90")
                {
                    startDate = DateTime.Today.AddDays(-90);
                }
                else // "all"
                {
                    startDate = null;
                    endDate = null;
                }

                // 1. Executive Telemetry KPIs
                int totalUsers, verifiedSuppliers, activeFactories, activeTechnicians, openEmergencies, totalOrders, pendingRfqs, delayedOrders;
                decimal grossOrderValue, realizedRevenue, rfqConversionRate;

                _analyticsLogic.getExecutiveMetrics(
                    startDate,
                    endDate,
                    out totalUsers,
                    out verifiedSuppliers,
                    out activeFactories,
                    out activeTechnicians,
                    out openEmergencies,
                    out totalOrders,
                    out grossOrderValue,
                    out realizedRevenue,
                    out pendingRfqs,
                    out rfqConversionRate,
                    out delayedOrders
                );

                lblTotalUsers.InnerText = totalUsers.ToString();
                lblVerifiedSuppliers.InnerText = verifiedSuppliers.ToString();
                lblActiveFactories.InnerText = activeFactories.ToString();
                lblActiveTechnicians.InnerText = activeTechnicians.ToString();
                lblActiveEmergency.InnerText = openEmergencies.ToString();
                lblTotalOrders.InnerText = totalOrders.ToString();
                lblTotalGmv.InnerText = string.Format("₹{0:N0}", grossOrderValue);
                lblRealizedRevenue.InnerText = string.Format("₹{0:N0}", realizedRevenue);
                lblOpenRfqs.InnerText = pendingRfqs.ToString();
                lblRfqConversionRate.InnerText = string.Format("{0:F1}%", rfqConversionRate);
                lblDelayedOrders.InnerText = delayedOrders.ToString();
                lblLastRefreshed.InnerText = DateTime.Now.ToString("dd MMM yyyy, HH:mm:ss") + " IST";

                if (SessionHelper.UserId.HasValue)
                {
                    lblSessionUser.InnerText = SessionHelper.UserEmail ?? "Platform Superadmin";
                }

                // 2. Critical Operational Alerts (Pending Breakdown SOS, Unverified Suppliers)
                DataTable dtAlerts = _analyticsLogic.getCriticalOperationalAlerts();
                if (dtAlerts != null && dtAlerts.Rows.Count > 0)
                {
                    rptOperationalAlerts.DataSource = dtAlerts;
                    rptOperationalAlerts.DataBind();
                    rptOperationalAlerts.Visible = true;
                    pnlNoAlerts.Visible = false;
                }
                else
                {
                    rptOperationalAlerts.Visible = false;
                    pnlNoAlerts.Visible = true;
                }

                // 3. Active Emergency SOS Table (Platform-Wide Admin View)
                DataSet dsEmerg = _adminLogic.selectOpenEmergenciesForAdmin();
                if (dsEmerg != null && dsEmerg.Tables.Count > 0 && dsEmerg.Tables[0].Rows.Count > 0)
                {
                    gvEmergencies.DataSource = dsEmerg.Tables[0];
                    gvEmergencies.DataBind();
                    gvEmergencies.Visible = true;
                    pnlNoEmergencies.Visible = false;
                }
                else
                {
                    gvEmergencies.Visible = false;
                    pnlNoEmergencies.Visible = true;
                }

                // 4. Recent Registered Users (Database TOP 8 Query)
                DataSet dsUsers = _userLogic.selectRecentUsers(8);
                if (dsUsers != null && dsUsers.Tables.Count > 0 && dsUsers.Tables[0].Rows.Count > 0)
                {
                    gvUsers.DataSource = dsUsers.Tables[0];
                    gvUsers.DataBind();
                    gvUsers.Visible = true;
                    pnlNoUsers.Visible = false;
                }
                else
                {
                    gvUsers.Visible = false;
                    pnlNoUsers.Visible = true;
                }

                // 5. Recent Platform Audit Activity (Latest 6 Events)
                DataSet dsAudit = _auditLogic.selectAuditLogs(null, null, 6);
                if (dsAudit != null && dsAudit.Tables.Count > 0 && dsAudit.Tables[0].Rows.Count > 0)
                {
                    rptAuditActivity.DataSource = dsAudit.Tables[0];
                    rptAuditActivity.DataBind();
                    rptAuditActivity.Visible = true;
                    pnlNoAuditActivity.Visible = false;
                }
                else
                {
                    rptAuditActivity.Visible = false;
                    pnlNoAuditActivity.Visible = true;
                }

                // 6. Assemble and Serialize Chart.js Analytics Data
                SerializeAnalyticsChartData(startDate, endDate);
            }
            catch (Exception ex)
            {
                string safeMsg = AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to load executive telemetry data");
                lblAlertMessage.Text = safeMsg;
                pnlAlert.Visible = true;
            }
        }

        private void SerializeAnalyticsChartData(DateTime? startDate, DateTime? endDate)
        {
            // 1. Procurement Activity (TimePeriod, Orders, GrossValue, CompletedRevenue)
            DataTable dtActivity = _analyticsLogic.getOrderVolumeAndValueOverTime(startDate, endDate);
            List<Dictionary<string, object>> activityList = new List<Dictionary<string, object>>();
            if (dtActivity != null)
            {
                foreach (DataRow row in dtActivity.Rows)
                {
                    Dictionary<string, object> item = new Dictionary<string, object>();
                    item["TimePeriod"] = row["TimePeriod"].ToString();
                    item["TotalOrders"] = Convert.ToInt32(row["TotalOrders"]);
                    item["GrossOrderValue"] = Convert.ToDecimal(row["GrossOrderValue"]);
                    item["CompletedRevenue"] = Convert.ToDecimal(row["CompletedRevenue"]);
                    activityList.Add(item);
                }
            }

            // 2. Order Fulfillment Status (Status, Count)
            DataTable dtStatus = _analyticsLogic.getOrderCountsByStatus(startDate, endDate);
            List<Dictionary<string, object>> statusList = new List<Dictionary<string, object>>();
            if (dtStatus != null)
            {
                foreach (DataRow row in dtStatus.Rows)
                {
                    Dictionary<string, object> item = new Dictionary<string, object>();
                    item["OrderStatus"] = row["OrderStatus"].ToString();
                    item["TotalCount"] = Convert.ToInt32(row["TotalCount"]);
                    statusList.Add(item);
                }
            }

            // 3. User Role Distribution
            DataTable dtRoles = _analyticsLogic.getUserDistributionByRole();
            List<Dictionary<string, object>> rolesList = new List<Dictionary<string, object>>();
            if (dtRoles != null)
            {
                foreach (DataRow row in dtRoles.Rows)
                {
                    Dictionary<string, object> item = new Dictionary<string, object>();
                    item["RoleName"] = row["RoleName"].ToString();
                    item["UserCount"] = Convert.ToInt32(row["UserCount"]);
                    rolesList.Add(item);
                }
            }

            // 4. Emergency Priority & Status
            DataTable dtEmerg = _analyticsLogic.getEmergenciesByPriorityAndStatus(startDate, endDate);
            List<Dictionary<string, object>> emergList = new List<Dictionary<string, object>>();
            if (dtEmerg != null)
            {
                foreach (DataRow row in dtEmerg.Rows)
                {
                    Dictionary<string, object> item = new Dictionary<string, object>();
                    item["PriorityLevel"] = row["PriorityLevel"].ToString();
                    item["Status"] = row["Status"].ToString();
                    item["IncidentCount"] = Convert.ToInt32(row["IncidentCount"]);
                    emergList.Add(item);
                }
            }

            // 5. RFQ Pipeline Funnel
            DataTable dtFunnel = _analyticsLogic.getRfqConversionFunnel(startDate, endDate);
            Dictionary<string, object> funnelObj = new Dictionary<string, object>();
            if (dtFunnel != null && dtFunnel.Rows.Count > 0)
            {
                DataRow fRow = dtFunnel.Rows[0];
                funnelObj["TotalRfqsCreated"] = Convert.ToInt32(fRow["TotalRfqsCreated"]);
                funnelObj["BidsReceived"] = Convert.ToInt32(fRow["BidsReceived"]);
                funnelObj["BidsAccepted"] = Convert.ToInt32(fRow["BidsAccepted"]);
                funnelObj["OrdersCreated"] = Convert.ToInt32(fRow["OrdersCreated"]);
            }

            Dictionary<string, object> payload = new Dictionary<string, object>();
            payload["activity"] = activityList;
            payload["orderStatuses"] = statusList;
            payload["roles"] = rolesList;
            payload["emergencyPriorities"] = emergList;
            payload["rfqFunnel"] = funnelObj;

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            hdnChartData.Value = serializer.Serialize(payload);
        }

        private void UpdateTimeframeButtonsUI(string activeTf)
        {
            btnTimeframe7.CssClass = "timeframe-pill" + (activeTf == "7" ? " active" : "");
            btnTimeframe30.CssClass = "timeframe-pill" + (activeTf == "30" ? " active" : "");
            btnTimeframe90.CssClass = "timeframe-pill" + (activeTf == "90" ? " active" : "");
            btnTimeframeAll.CssClass = "timeframe-pill" + (activeTf == "all" ? " active" : "");
        }
        #endregion
    }
}
