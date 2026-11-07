using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Admin.Audit
{
    public partial class AuditLogs : BasePage
    {
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public AuditLogs()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAuditLogs();
            }
        }

        private void LoadAuditLogs()
        {
            try
            {
                string actionFilter = ddlActionFilter.SelectedValue;
                string entityFilter = ddlEntityFilter.SelectedValue;
                int topCount = 100;
                int.TryParse(ddlTopCount.SelectedValue, out topCount);

                DataSet ds = _auditLogic.selectAuditLogs(
                    string.IsNullOrEmpty(actionFilter) ? null : actionFilter,
                    string.IsNullOrEmpty(entityFilter) ? null : entityFilter,
                    topCount
                );

                DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
                gvAuditLogs.DataSource = dt;
                gvAuditLogs.DataBind();

                lblLogsCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                lblAlertMessage.Text = "Failed to load audit trail: " + ex.Message;
            }
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadAuditLogs();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadAuditLogs();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlActionFilter.SelectedIndex = 0;
            ddlEntityFilter.SelectedIndex = 0;
            ddlTopCount.SelectedValue = "100";
            LoadAuditLogs();
        }
    }
}

