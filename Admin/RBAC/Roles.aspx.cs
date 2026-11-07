using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin.RBAC
{
    public partial class Roles : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public Roles()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoles();
                LoadPermissionsForRole(1, "Administrator (Role #1)");
            }
        }

        private void LoadRoles()
        {
            try
            {
                DataSet ds = _adminLogic.selectAllRoles();
                if (ds != null && ds.Tables.Count > 0)
                {
                    gvRoles.DataSource = ds.Tables[0];
                    gvRoles.DataBind();
                    lblRolesCount.Text = ds.Tables[0].Rows.Count.ToString();
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, "Error loading security roles: " + ex.Message);
            }
        }

        private void LoadPermissionsForRole(int roleId, string roleName = null)
        {
            try
            {
                hdnSelectedRoleId.Value = roleId.ToString();
                if (!string.IsNullOrEmpty(roleName))
                {
                    lblSelectedRoleTitle.InnerText = $"{roleName} (Role #{roleId})";
                }

                DataSet ds = _adminLogic.selectPermissionsForRole(roleId);
                if (ds != null && ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];
                    gvPermissions.DataSource = dt;
                    gvPermissions.DataBind();

                    int grantedCount = 0;
                    foreach (DataRow r in dt.Rows)
                    {
                        if (Convert.ToInt32(r["IsGranted"]) == 1) grantedCount++;
                    }

                    lblGrantedPermCount.Text = grantedCount.ToString();
                    lblTotalPermCount.Text = dt.Rows.Count.ToString();
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, "Error loading granular permissions: " + ex.Message);
            }
        }

        protected void gvRoles_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "InspectRole")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                int roleId = Convert.ToInt32(gvRoles.DataKeys[index]["RoleId"]);
                string roleName = gvRoles.DataKeys[index]["RoleName"]?.ToString();
                LoadPermissionsForRole(roleId, roleName);
            }
        }

        protected void gvPermissions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "TogglePerm")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                int permId = Convert.ToInt32(gvPermissions.DataKeys[index]["PermissionId"]);
                string permKey = gvPermissions.DataKeys[index]["PermissionKey"]?.ToString();
                string permName = gvPermissions.DataKeys[index]["DisplayName"]?.ToString();
                bool isCurrentlyGranted = Convert.ToInt32(gvPermissions.DataKeys[index]["IsGranted"]) == 1;
                bool newGrant = !isCurrentlyGranted;

                int roleId = 1;
                int.TryParse(hdnSelectedRoleId.Value, out roleId);

                int adminUserId = SessionHelper.UserId ?? 1;

                bool success = _adminLogic.toggleRolePermission(roleId, permId, newGrant, adminUserId);
                if (success)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        newGrant ? "GRANT_ROLE_PERMISSION" : "REVOKE_ROLE_PERMISSION",
                        "RolePermissions",
                        permId,
                        isCurrentlyGranted ? "Granted" : "Revoked",
                        $"{newGrant} for Role #{roleId} ({permKey})",
                        Request.UserHostAddress
                    );

                    ShowAlert(true, $"Permission '{permName}' ({permKey}) {(newGrant ? "granted to" : "revoked from")} Role #{roleId} successfully.");
                    LoadPermissionsForRole(roleId);
                }
                else
                {
                    ShowAlert(false, $"Failed to update permission '{permName}'.");
                }
            }
        }

        private void ShowAlert(bool isSuccess, string message)
        {
            pnlAlert.Visible = true;
            if (isSuccess)
            {
                pnlAlert.CssClass = "p-3.5 mb-5 rounded bg-emerald-50 border border-emerald-200 text-xs text-emerald-900 flex items-center justify-between";
            }
            else
            {
                pnlAlert.CssClass = "p-3.5 mb-5 rounded bg-rose-50 border border-rose-200 text-xs text-rose-900 flex items-center justify-between";
            }
            lblAlertMessage.Text = message;
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }
    }
}
