using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Admin
{
    public partial class Profile : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public Profile()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAdminProfile();
            }
        }

        private void LoadAdminProfile()
        {
            try
            {
                int adminId = SessionHelper.UserId ?? 1;
                DataSet ds = _userLogic.getUserById(adminId);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];

                    string fullName = row["FullName"] != DBNull.Value ? row["FullName"].ToString() : "Platform Administrator";
                    string email = row["Email"] != DBNull.Value ? row["Email"].ToString() : "admin@sparepartportal.com";
                    string phone = row["PhoneNumber"] != DBNull.Value ? row["PhoneNumber"].ToString() : "";
                    DateTime joined = row["CreatedAt"] != DBNull.Value ? Convert.ToDateTime(row["CreatedAt"]) : DateTime.Now;

                    dispAdminName.InnerText = fullName;
                    dispAdminEmail.InnerText = email;
                    dispAdminPhone.InnerText = !string.IsNullOrEmpty(phone) ? phone : "Not registered";
                    dispAdminJoined.InnerText = joined.ToString("dd MMM yyyy");
                    dispUserId.InnerText = "#" + adminId;

                    txtFullName.Text = fullName;
                    txtEmail.Text = email;
                    txtPhone.Text = phone;
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, "Failed to load administrator profile: " + ex.Message);
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            try
            {
                int adminId = SessionHelper.UserId ?? 1;
                string fullName = txtFullName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string phone = txtPhone.Text.Trim();

                if (string.IsNullOrWhiteSpace(fullName))
                {
                    ShowAlert(false, "Full Name is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(email))
                {
                    ShowAlert(false, "Email address is required.");
                    return;
                }

                bool updated = _userLogic.updateUserProfile(adminId, fullName, email, phone);
                if (updated)
                {
                    SessionHelper.FullName = fullName;

                    _auditLogic.logAction(
                        adminId,
                        "UPDATE_PROFILE",
                        "Users",
                        adminId,
                        null,
                        "Admin profile updated: " + fullName + " (" + email + ")",
                        Request.UserHostAddress
                    );

                    LoadAdminProfile();
                    ShowAlert(true, "Administrator profile credentials updated successfully.");
                }
                else
                {
                    ShowAlert(false, "Could not update profile record. Please check database connectivity.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, "Error updating profile: " + ex.Message);
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            try
            {
                int adminId = SessionHelper.UserId ?? 1;
                string currentPassword = txtCurrentPassword.Text.Trim();
                string newPassword = txtNewPassword.Text.Trim();
                string confirmPassword = txtConfirmPassword.Text.Trim();

                if (string.IsNullOrWhiteSpace(currentPassword))
                {
                    ShowAlert(false, "Current password is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(newPassword) || newPassword.Length < 6)
                {
                    ShowAlert(false, "New password must contain at least 6 characters.");
                    return;
                }

                if (newPassword != confirmPassword)
                {
                    ShowAlert(false, "New password and confirmation password do not match.");
                    return;
                }

                string errorMsg;
                bool success = _userLogic.changeUserPassword(adminId, currentPassword, newPassword, out errorMsg);

                if (success)
                {
                    _auditLogic.logAction(
                        adminId,
                        "CHANGE_PASSWORD",
                        "Users",
                        adminId,
                        null,
                        "Administrator password successfully rotated",
                        Request.UserHostAddress
                    );

                    txtCurrentPassword.Text = string.Empty;
                    txtNewPassword.Text = string.Empty;
                    txtConfirmPassword.Text = string.Empty;

                    ShowAlert(true, "Administrator security password changed successfully. Use the new password for upcoming sign-ins.");
                }
                else
                {
                    ShowAlert(false, !string.IsNullOrEmpty(errorMsg) ? errorMsg : "Failed to change password. Please verify your current password.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, "Error changing password: " + ex.Message);
            }
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }

        private void ShowAlert(bool isSuccess, string message)
        {
            pnlAlert.Visible = true;
            lblAlertMessage.Text = message;

            if (isSuccess)
            {
                pnlAlert.CssClass = "p-4 mb-6 rounded-md border text-xs flex items-center justify-between shadow-xs bg-emerald-50 text-emerald-900 border-emerald-300 admin-animate-enter";
                iconAlert.Attributes["class"] = "fa-solid fa-circle-check text-emerald-600 text-sm";
            }
            else
            {
                pnlAlert.CssClass = "p-4 mb-6 rounded-md border text-xs flex items-center justify-between shadow-xs bg-rose-50 text-rose-900 border-rose-300 admin-animate-enter";
                iconAlert.Attributes["class"] = "fa-solid fa-triangle-exclamation text-rose-600 text-sm";
            }
        }
    }
}
