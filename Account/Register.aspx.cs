using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI;

namespace IndustrialSparePartPortal.Account
{
    public partial class Register : Page
    {
        private readonly UserLogic _userLogic = new UserLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string roleParam = Request.QueryString["role"];
                if (string.Equals(roleParam, "supplier", StringComparison.OrdinalIgnoreCase))
                {
                    rdoSupplier.Checked = true;
                    rdoFactory.Checked = false;
                    rdoTechnician.Checked = false;
                }
                else if (string.Equals(roleParam, "technician", StringComparison.OrdinalIgnoreCase))
                {
                    rdoTechnician.Checked = true;
                    rdoFactory.Checked = false;
                    rdoSupplier.Checked = false;
                }
                UpdatePanelVisibility();
            }
        }

        protected void Role_CheckedChanged(object sender, EventArgs e)
        {
            UpdatePanelVisibility();
        }

        private void UpdatePanelVisibility()
        {
            pnlFactoryFields.Visible = rdoFactory.Checked;
            pnlSupplierFields.Visible = rdoSupplier.Checked;
            pnlTechnicianFields.Visible = rdoTechnician.Checked;
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                ShowError("Please complete all required fields.");
                return;
            }

            // Check if email already registered
            DataSet existingUser = _userLogic.getUserByEmail(email);
            if (existingUser != null && existingUser.Tables.Count > 0 && existingUser.Tables[0].Rows.Count > 0)
            {
                ShowError("An account with this email address already exists.");
                return;
            }

            int roleId = 2; // Default Factory
            if (rdoSupplier.Checked) roleId = 3;
            else if (rdoTechnician.Checked) roleId = 4;

            string salt = PasswordHasher.GenerateSalt();
            string passwordHash = PasswordHasher.HashPassword(password, salt);

            int newUserId = _userLogic.insertUser(roleId, email, passwordHash, salt, fullName, phone, isActive: true, isVerified: false);
            if (newUserId <= 0)
            {
                ShowError("Failed to create user account. Please retry.");
                return;
            }

            bool profileSaved = false;
            if (roleId == 2) // Factory
            {
                profileSaved = _userLogic.insertFactoryProfile(
                    newUserId,
                    txtFactoryCompany.Text.Trim(),
                    txtIndustryType.Text.Trim(),
                    address: null,
                    city: txtFactoryCity.Text.Trim(),
                    state: txtFactoryState.Text.Trim(),
                    pincode: null,
                    gstin: txtFactoryGstin.Text.Trim(),
                    contactPerson: fullName
                );
            }
            else if (roleId == 3) // Supplier
            {
                profileSaved = _userLogic.insertSupplierProfile(
                    newUserId,
                    txtSupplierCompany.Text.Trim(),
                    txtRegNo.Text.Trim(),
                    txtSupplierGstin.Text.Trim(),
                    address: null,
                    city: txtSupplierCity.Text.Trim(),
                    state: txtSupplierState.Text.Trim(),
                    pincode: null
                );
            }
            else if (roleId == 4) // Technician
            {
                int experience = int.TryParse(txtExperience.Text.Trim(), out int exp) ? exp : 0;
                decimal hourlyRate = decimal.TryParse(txtHourlyRate.Text.Trim(), out decimal rate) ? rate : 0;

                profileSaved = _userLogic.insertTechnicianProfile(
                    newUserId,
                    txtSkills.Text.Trim(),
                    experience,
                    hourlyRate,
                    address: null,
                    city: txtTechCity.Text.Trim(),
                    state: null,
                    pincode: null
                );
            }

            if (profileSaved)
            {
                string loginErr;
                int uid;
                string roleName;
                string uname;
                bool isVer;

                if (_userLogic.authenticateUser(email, password, out loginErr, out uid, out roleName, out uname, out isVer))
                {
                    Response.Redirect(SessionHelper.GetDashboardUrlByRole(roleName));
                }
                else
                {
                    Response.Redirect("~/Account/Login.aspx?registered=true");
                }
            }
            else
            {
                ShowError("Account registered, but profile initialization encountered an issue.");
            }
        }

        private void ShowError(string message)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = "mb-6 p-4 rounded-lg bg-red-50 border border-red-200 text-red-700 text-xs flex items-center gap-2";
            litAlertMessage.Text = message;
        }
    }
}
