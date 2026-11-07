using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Admin.Security
{
    public partial class LoginSecurity : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();

        public LoginSecurity()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSecurityLogs();
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadSecurityLogs();
        }

        private void LoadSecurityLogs()
        {
            try
            {
                DataSet ds = _adminLogic.selectSecurityEvents(50);
                if (ds != null && ds.Tables.Count > 0)
                {
                    gvSecurityLogs.DataSource = ds.Tables[0];
                    gvSecurityLogs.DataBind();
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                lblAlertMessage.Text = "Failed to load authentication security stream: " + ex.Message;
            }
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }
    }
}

