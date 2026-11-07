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
                LoadRoleMetrics();
                LoadUsers();
            }
        }

        private void LoadRoleMetrics()
        {
            try
            {
                int total, admins, factories, suppliers, techs;
                _userLogic.getUserCountsByRole(out total, out admins, out factories, out suppliers, out techs);

                lblCountAll.InnerText = total.ToString();
                lblCountFactories.InnerText = factories.ToString();
                lblCountSuppliers.InnerText = suppliers.ToString();
                lblCountTechnicians.InnerText = techs.ToString();
                lblCountAdmins.InnerText = admins.ToString();
            }
            catch
            {
                // Non-critical telemetry fallback
            }
        }

        protected void btnSegment_Click(object sender, EventArgs e)
        {
            LinkButton btn = sender as LinkButton;
            if (btn != null)
            {
                string targetRole = btn.CommandArgument;
                if (ddlRoleFilter.Items.FindByValue(targetRole) != null)
                {
                    ddlRoleFilter.SelectedValue = targetRole;
                }
                else
                {
                    ddlRoleFilter.SelectedIndex = 0;
                }

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
                LoadRoleMetrics();
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
                LoadRoleMetrics();
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

            txtAddFactoryCompany.Text = string.Empty;
            txtAddFactoryIndustry.Text = string.Empty;
            txtAddFactoryGstin.Text = string.Empty;
            txtAddFactoryAddress.Text = string.Empty;
            txtAddFactoryCity.Text = string.Empty;
            txtAddFactoryState.Text = string.Empty;
            txtAddFactoryPincode.Text = string.Empty;
            txtAddFactoryContact.Text = string.Empty;

            txtAddSupplierCompany.Text = string.Empty;
            txtAddSupplierRegNo.Text = string.Empty;
            txtAddSupplierGstin.Text = string.Empty;
            txtAddSupplierAddress.Text = string.Empty;
            txtAddSupplierCity.Text = string.Empty;
            txtAddSupplierState.Text = string.Empty;
            txtAddSupplierPincode.Text = string.Empty;

            txtAddTechSkills.Text = string.Empty;
            txtAddTechExp.Text = "3";
            txtAddTechRate.Text = "650";
            txtAddTechAddress.Text = string.Empty;
            txtAddTechCity.Text = string.Empty;
            txtAddTechState.Text = string.Empty;
            txtAddTechPincode.Text = string.Empty;
            chkAddTechAvailable.Checked = true;

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
                int techExp = 3;
                int.TryParse(txtAddTechExp.Text.Trim(), out techExp);
                decimal techRate = 650.00m;
                decimal.TryParse(txtAddTechRate.Text.Trim(), out techRate);

                int newUserId;
                string errMsg;
                bool success = _userLogic.registerUserWithProfileAtomic(
                    roleId,
                    fullName,
                    email,
                    phone,
                    password,
                    isActive,
                    isVerified,
                    // Factory fields
                    txtAddFactoryCompany.Text.Trim(),
                    txtAddFactoryIndustry.Text.Trim(),
                    txtAddFactoryGstin.Text.Trim(),
                    txtAddFactoryAddress.Text.Trim(),
                    txtAddFactoryCity.Text.Trim(),
                    txtAddFactoryState.Text.Trim(),
                    txtAddFactoryPincode.Text.Trim(),
                    txtAddFactoryContact.Text.Trim(),
                    // Supplier fields
                    txtAddSupplierCompany.Text.Trim(),
                    txtAddSupplierRegNo.Text.Trim(),
                    txtAddSupplierGstin.Text.Trim(),
                    txtAddSupplierAddress.Text.Trim(),
                    txtAddSupplierCity.Text.Trim(),
                    txtAddSupplierState.Text.Trim(),
                    txtAddSupplierPincode.Text.Trim(),
                    // Technician fields
                    txtAddTechSkills.Text.Trim(),
                    techExp,
                    techRate,
                    txtAddTechAddress.Text.Trim(),
                    txtAddTechCity.Text.Trim(),
                    txtAddTechState.Text.Trim(),
                    txtAddTechPincode.Text.Trim(),
                    chkAddTechAvailable.Checked,
                    out newUserId,
                    out errMsg
                );

                if (success)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "CREATE_USER",
                        "Users",
                        newUserId,
                        null,
                        $"{fullName} ({email}, Role: {roleId}) with profile provisions",
                        Request.UserHostAddress
                    );

                    pnlAddModal.Visible = false;
                    ShowAlert(true, $"User '{fullName}' (#{newUserId}) and profile provisioned atomically into the platform.");
                    LoadUsers();
                    LoadRoleMetrics();
                }
                else
                {
                    ShowAlert(false, !string.IsNullOrEmpty(errMsg) ? errMsg : "Failed to register user. An account with this email address may already exist.");
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

                    // Check for optional superadmin password reset
                    string newPassword = txtEditPassword.Text.Trim();
                    if (!string.IsNullOrEmpty(newPassword))
                    {
                        if (newPassword.Length < 6)
                        {
                            ShowAlert(false, "User details updated, but password reset failed: New password must be at least 6 characters.");
                            return;
                        }

                        string pwdErr;
                        bool pwdSuccess = _userLogic.resetUserPasswordByAdmin(userId, newPassword, out pwdErr);
                        if (pwdSuccess)
                        {
                            _auditLogic.logAction(
                                SessionHelper.UserId,
                                "ADMIN_RESET_PASSWORD",
                                "Users",
                                userId,
                                null,
                                $"Admin reset password for user: {email}",
                                Request.UserHostAddress
                            );
                        }
                        else
                        {
                            ShowAlert(false, "User details updated, but password reset failed: " + pwdErr);
                            return;
                        }
                    }

                    txtEditPassword.Text = string.Empty;
                    pnlEditModal.Visible = false;
                    ShowAlert(true, $"User account #{userId} ({fullName}) updated successfully.");
                    LoadUsers();
                    LoadRoleMetrics();
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
