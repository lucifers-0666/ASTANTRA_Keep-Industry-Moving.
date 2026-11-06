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
        private readonly AuditLogic _auditLogic = new AuditLogic();

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
            try
            {
                string search = txtSearch.Text.Trim();
                string role = ddlRoleFilter.SelectedValue;
                string status = ddlStatusFilter.SelectedValue;

                DataSet ds = _userLogic.searchUsers(search, role, status);
                DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;

                gvUsers.DataSource = dt;
                gvUsers.DataBind();

                lblUsersCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAlert(false, "Error loading users: " + ex.Message);
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlRoleFilter.SelectedIndex = 0;
            ddlStatusFilter.SelectedIndex = 0;
            LoadUsers();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int userId = Convert.ToInt32(gvUsers.DataKeys[rowIndex].Values["UserId"]);
            string userFullName = gvUsers.DataKeys[rowIndex].Values["FullName"]?.ToString();

            if (e.CommandName == "ToggleActive")
            {
                bool currentActive = Convert.ToBoolean(gvUsers.DataKeys[rowIndex].Values["IsActive"]);
                bool newActive = !currentActive;

                // Superadmin self-deactivation guard
                if (SessionHelper.UserId.HasValue && userId == SessionHelper.UserId.Value && !newActive)
                {
                    ShowAlert(false, "Security Policy: You cannot deactivate your own active superadmin account.");
                    return;
                }

                bool success = _userLogic.updateUserStatus(userId, newActive);
                if (success)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "TOGGLE_STATUS",
                        "Users",
                        userId,
                        currentActive ? "Active" : "Inactive",
                        newActive ? "Active" : "Inactive",
                        Request.UserHostAddress
                    );

                    ShowAlert(true, $"User account #{userId} ({userFullName}) successfully {(newActive ? "activated" : "deactivated")}.");
                }
                else
                {
                    ShowAlert(false, $"Failed to toggle status for user account #{userId}.");
                }

                LoadUsers();
            }
            else if (e.CommandName == "EditUser")
            {
                // Populate edit modal
                hdnEditUserId.Value = userId.ToString();
                txtEditFullName.Text = userFullName;
                txtEditEmail.Text = gvUsers.DataKeys[rowIndex].Values["Email"]?.ToString();
                txtEditPhone.Text = gvUsers.DataKeys[rowIndex].Values["PhoneNumber"] != DBNull.Value ? gvUsers.DataKeys[rowIndex].Values["PhoneNumber"]?.ToString() : string.Empty;

                string roleIdStr = gvUsers.DataKeys[rowIndex].Values["RoleId"]?.ToString();
                if (ddlEditRole.Items.FindByValue(roleIdStr) != null)
                {
                    ddlEditRole.SelectedValue = roleIdStr;
                }

                chkEditIsActive.Checked = Convert.ToBoolean(gvUsers.DataKeys[rowIndex].Values["IsActive"]);
                chkEditIsVerified.Checked = Convert.ToBoolean(gvUsers.DataKeys[rowIndex].Values["IsVerified"]);

                pnlEditModal.Visible = true;
            }
            else if (e.CommandName == "DeleteUser")
            {
                // Superadmin self-deletion guard
                if (SessionHelper.UserId.HasValue && userId == SessionHelper.UserId.Value)
                {
                    ShowAlert(false, "Security Policy: You cannot delete your own active superadmin account.");
                    return;
                }

                bool deleted = _userLogic.deleteUser(userId);
                if (deleted)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "DELETE_USER",
                        "Users",
                        userId,
                        userFullName,
                        null,
                        Request.UserHostAddress
                    );

                    ShowAlert(true, $"User account #{userId} ({userFullName}) was permanently removed along with associated credentials.");
                }
                else
                {
                    ShowAlert(false, $"Unable to delete user #{userId}. Foreign key constraints or ongoing active transactions exist.");
                }

                LoadUsers();
            }
        }

        #region Add User Modal Events
        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            txtAddFullName.Text = string.Empty;
            txtAddEmail.Text = string.Empty;
            txtAddPhone.Text = string.Empty;
            txtAddPassword.Text = string.Empty;
            ddlAddRole.SelectedIndex = 1; // Default to Factory
            chkAddIsActive.Checked = true;
            chkAddIsVerified.Checked = true;
            pnlAddModal.Visible = true;
        }

        protected void btnCloseAddModal_Click(object sender, EventArgs e)
        {
            pnlAddModal.Visible = false;
        }

        protected void btnSubmitAddUser_Click(object sender, EventArgs e)
        {
            string fullName = txtAddFullName.Text.Trim();
            string email = txtAddEmail.Text.Trim();
            string phone = txtAddPhone.Text.Trim();
            string password = txtAddPassword.Text.Trim();
            int roleId = Convert.ToInt32(ddlAddRole.SelectedValue);
            bool isActive = chkAddIsActive.Checked;
            bool isVerified = chkAddIsVerified.Checked;

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowAlert(false, "Validation Error: Full Name, Email Address, and Initial Password are required.");
                return;
            }

            try
            {
                int newUserId = _userLogic.insertNewUser(fullName, email, phone, password, roleId, isActive, isVerified);
                if (newUserId > 0)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "CREATE_USER",
                        "Users",
                        newUserId,
                        null,
                        $"{fullName} ({email}, Role: {roleId})",
                        Request.UserHostAddress
                    );

                    pnlAddModal.Visible = false;
                    ShowAlert(true, $"User '{fullName}' (#{newUserId}) registered successfully into the platform.");
                    LoadUsers();
                }
                else
                {
                    ShowAlert(false, "Failed to register user. An account with this email address may already exist.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, "Registration Exception: " + ex.Message);
            }
        }
        #endregion

        #region Edit User Modal Events
        protected void btnCloseEditModal_Click(object sender, EventArgs e)
        {
            pnlEditModal.Visible = false;
        }

        protected void btnSubmitEditUser_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(hdnEditUserId.Value);
            string fullName = txtEditFullName.Text.Trim();
            string email = txtEditEmail.Text.Trim();
            string phone = txtEditPhone.Text.Trim();
            int roleId = Convert.ToInt32(ddlEditRole.SelectedValue);
            bool isActive = chkEditIsActive.Checked;
            bool isVerified = chkEditIsVerified.Checked;

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email))
            {
                ShowAlert(false, "Validation Error: Full Name and Email Address are required.");
                return;
            }

            try
            {
                bool updated = _userLogic.updateUser(userId, fullName, email, phone, roleId, isActive, isVerified);
                if (updated)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "UPDATE_USER",
                        "Users",
                        userId,
                        null,
                        $"{fullName} (Role: {roleId}, Active: {isActive})",
                        Request.UserHostAddress
                    );

                    pnlEditModal.Visible = false;
                    ShowAlert(true, $"User account #{userId} ({fullName}) updated successfully.");
                    LoadUsers();
                }
                else
                {
                    ShowAlert(false, $"Failed to update user account #{userId}.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, "Update Exception: " + ex.Message);
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
