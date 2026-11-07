using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin.Settings
{
    public partial class PlatformSettings : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public PlatformSettings()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSettings();
            }
        }

        private void LoadSettings()
        {
            try
            {
                DataSet ds = _adminLogic.selectAllSystemSettings();
                if (ds != null && ds.Tables.Count > 0)
                {
                    gvSettings.DataSource = ds.Tables[0];
                    gvSettings.DataBind();
                    lblSettingsCount.Text = ds.Tables[0].Rows.Count.ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading settings: " + ex.Message);
            }
        }

        protected void gvSettings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditSetting")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                string key = gvSettings.DataKeys[index]["SettingKey"].ToString();
                string val = gvSettings.DataKeys[index]["SettingValue"].ToString();
                string desc = gvSettings.DataKeys[index]["Description"]?.ToString() ?? "";

                hdnEditSettingKey.Value = key;
                txtSettingKeyDisplay.Text = key;
                txtSettingValue.Text = val;
                lblSettingDesc.InnerText = desc;
                pnlEditModal.Visible = true;
            }
        }

        protected void btnSaveSetting_Click(object sender, EventArgs e)
        {
            try
            {
                if (!SessionHelper.UserId.HasValue)
                {
                    pnlAlert.Visible = true;
                    lblAlertMessage.Text = "Authentication required: Session expired.";
                    return;
                }
                int adminId = SessionHelper.UserId.Value;

                string key = hdnEditSettingKey.Value;
                string val = txtSettingValue.Text.Trim();

                string errorMsg;
                bool success = _adminLogic.updateSystemSetting(key, val, adminId, out errorMsg);
                if (success)
                {
                    _auditLogic.logAction(adminId, "UPDATE_SETTING", "SystemSettings", null, null, key + " -> " + val, Request.UserHostAddress);
                    pnlEditModal.Visible = false;
                    pnlAlert.Visible = true;
                    lblAlertMessage.Text = "System setting [" + key + "] updated to [" + val + "] successfully.";
                    LoadSettings();
                }
                else
                {
                    pnlAlert.Visible = true;
                    lblAlertMessage.Text = !string.IsNullOrEmpty(errorMsg) ? errorMsg : "Failed to update system setting.";
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                lblAlertMessage.Text = AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to update platform system setting");
            }
        }

        protected void btnCloseEditModal_Click(object sender, EventArgs e)
        {
            pnlEditModal.Visible = false;
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }
    }
}

