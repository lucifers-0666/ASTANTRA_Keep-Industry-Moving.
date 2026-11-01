using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin.Users
{
    public partial class ManageUsers : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();

        public ManageUsers()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            string role = ddlRoleFilter.SelectedValue;
            DataSet ds = _userLogic.selectAllUsers(role);

            DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvUsers.DataSource = dt;
            gvUsers.DataBind();

            lblUsersCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
        }

        protected void ddlRoleFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleActive")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int userId = Convert.ToInt32(gvUsers.DataKeys[rowIndex].Values["UserId"]);
                bool currentActive = Convert.ToBoolean(gvUsers.DataKeys[rowIndex].Values["IsActive"]);
                bool newActive = !currentActive;

                // Prevent admin from deactivating themselves
                if (userId == SessionHelper.UserId.Value && !newActive)
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "p-4 mb-6 rounded-lg bg-rose-50 border border-rose-200 text-xs text-rose-800 flex items-center justify-between";
                    lblAlertMessage.Text = "Security Policy: You cannot deactivate your own active superadmin account.";
                    return;
                }

                bool success = _userLogic.updateUserStatus(userId, newActive);

                if (success)
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "p-4 mb-6 rounded-lg bg-emerald-50 border border-emerald-200 text-xs text-emerald-800 flex items-center justify-between";
                    lblAlertMessage.Text = $"User account #{userId} successfully {(newActive ? "activated" : "deactivated")}.";
                }
                else
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "p-4 mb-6 rounded-lg bg-rose-50 border border-rose-200 text-xs text-rose-800 flex items-center justify-between";
                    lblAlertMessage.Text = $"Failed to update status for user account #{userId}.";
                }

                LoadUsers();
            }
        }
    }
}

