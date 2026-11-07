using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin.Technicians
{
    public partial class ManageTechnicians : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public ManageTechnicians()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTechnicians();
            }
        }

        private void LoadTechnicians()
        {
            try
            {
                string search = txtSearch.Text.Trim();
                string status = ddlStatusFilter.SelectedValue;

                DataSet ds = _adminLogic.selectAllTechniciansDetailed(search, string.IsNullOrEmpty(status) ? null : status);
                DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;

                gvTechnicians.DataSource = dt;
                gvTechnicians.DataBind();

                lblTechsCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to load technician roster"));
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadTechnicians();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadTechnicians();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlStatusFilter.SelectedIndex = 0;
            LoadTechnicians();
        }

        protected void gvTechnicians_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int techId = Convert.ToInt32(gvTechnicians.DataKeys[rowIndex].Values["TechnicianId"]);
            string fullName = gvTechnicians.DataKeys[rowIndex].Values["FullName"]?.ToString();

            if (e.CommandName == "EditTech")
            {
                hdnEditTechId.Value = techId.ToString();
                txtEditSkills.Text = gvTechnicians.DataKeys[rowIndex].Values["SkillSummary"] != DBNull.Value ? gvTechnicians.DataKeys[rowIndex].Values["SkillSummary"]?.ToString() : string.Empty;
                txtEditExperience.Text = gvTechnicians.DataKeys[rowIndex].Values["ExperienceYears"] != DBNull.Value ? gvTechnicians.DataKeys[rowIndex].Values["ExperienceYears"]?.ToString() : "0";
                txtEditHourlyRate.Text = gvTechnicians.DataKeys[rowIndex].Values["HourlyRate"] != DBNull.Value ? Convert.ToDecimal(gvTechnicians.DataKeys[rowIndex].Values["HourlyRate"]).ToString("F0") : "500";
                txtEditAddress.Text = gvTechnicians.DataKeys[rowIndex].Values["Address"] != DBNull.Value ? gvTechnicians.DataKeys[rowIndex].Values["Address"]?.ToString() : string.Empty;
                txtEditCity.Text = gvTechnicians.DataKeys[rowIndex].Values["City"] != DBNull.Value ? gvTechnicians.DataKeys[rowIndex].Values["City"]?.ToString() : string.Empty;
                txtEditState.Text = gvTechnicians.DataKeys[rowIndex].Values["State"] != DBNull.Value ? gvTechnicians.DataKeys[rowIndex].Values["State"]?.ToString() : string.Empty;
                txtEditPincode.Text = gvTechnicians.DataKeys[rowIndex].Values["Pincode"] != DBNull.Value ? gvTechnicians.DataKeys[rowIndex].Values["Pincode"]?.ToString() : string.Empty;

                string ver = gvTechnicians.DataKeys[rowIndex].Values["VerificationStatus"]?.ToString();
                if (ddlEditVerification.Items.FindByValue(ver) != null)
                {
                    ddlEditVerification.SelectedValue = ver;
                }

                chkEditIsAvailable.Checked = Convert.ToBoolean(gvTechnicians.DataKeys[rowIndex].Values["IsAvailable"]);
                pnlEditModal.Visible = true;
            }
            else if (e.CommandName == "ToggleDuty")
            {
                bool currentAvail = Convert.ToBoolean(gvTechnicians.DataKeys[rowIndex].Values["IsAvailable"]);
                bool newAvail = !currentAvail;

                string skills = gvTechnicians.DataKeys[rowIndex].Values["SkillSummary"]?.ToString();
                int exp = Convert.ToInt32(gvTechnicians.DataKeys[rowIndex].Values["ExperienceYears"]);
                decimal rate = Convert.ToDecimal(gvTechnicians.DataKeys[rowIndex].Values["HourlyRate"]);
                string addr = gvTechnicians.DataKeys[rowIndex].Values["Address"]?.ToString();
                string city = gvTechnicians.DataKeys[rowIndex].Values["City"]?.ToString();
                string state = gvTechnicians.DataKeys[rowIndex].Values["State"]?.ToString();
                string pin = gvTechnicians.DataKeys[rowIndex].Values["Pincode"]?.ToString();
                string ver = gvTechnicians.DataKeys[rowIndex].Values["VerificationStatus"]?.ToString();

                bool updated = _adminLogic.updateTechnicianDetails(techId, skills, exp, rate, addr, city, state, pin, newAvail, ver);
                if (updated)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "TOGGLE_TECH_DUTY",
                        "Technicians",
                        techId,
                        currentAvail ? "Available" : "OffDuty",
                        newAvail ? "Available" : "OffDuty",
                        Request.UserHostAddress
                    );

                    ShowAlert(true, $"Technician #{techId} ({fullName}) duty status changed to '{(newAvail ? "Available On-Duty" : "Off-Duty")}'.");
                    LoadTechnicians();
                }
                else
                {
                    ShowAlert(false, $"Failed to update duty state for technician #{techId}.");
                }
            }
        }

        #region Add Modal Events
        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            txtAddFullName.Text = string.Empty;
            txtAddEmail.Text = string.Empty;
            txtAddPhone.Text = string.Empty;
            txtAddPassword.Text = string.Empty;
            txtAddSkills.Text = string.Empty;
            txtAddExperience.Text = "5";
            txtAddHourlyRate.Text = "750";
            txtAddAddress.Text = string.Empty;
            txtAddCity.Text = string.Empty;
            txtAddState.Text = "Gujarat";
            txtAddPincode.Text = string.Empty;
            pnlAddModal.Visible = true;
        }

        protected void btnCloseAddModal_Click(object sender, EventArgs e)
        {
            pnlAddModal.Visible = false;
        }

        protected void btnSubmitAddTech_Click(object sender, EventArgs e)
        {
            string fullName = txtAddFullName.Text.Trim();
            string email = txtAddEmail.Text.Trim();
            string phone = txtAddPhone.Text.Trim();
            string password = txtAddPassword.Text.Trim();
            string skills = txtAddSkills.Text.Trim();
            int exp = 0;
            int.TryParse(txtAddExperience.Text.Trim(), out exp);
            decimal rate = 500.00m;
            decimal.TryParse(txtAddHourlyRate.Text.Trim(), out rate);
            string address = txtAddAddress.Text.Trim();
            string city = txtAddCity.Text.Trim();
            string state = txtAddState.Text.Trim();
            string pincode = txtAddPincode.Text.Trim();

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(skills) || string.IsNullOrEmpty(city))
            {
                ShowAlert(false, "Validation Error: Full Name, Login Email, Initial Password, Technical Skills, and City are required.");
                return;
            }

            try
            {
                int newTechId = _adminLogic.insertNewTechnician(fullName, email, phone, password, skills, exp, rate, address, city, state, pincode);
                if (newTechId > 0)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "CREATE_TECHNICIAN",
                        "Technicians",
                        newTechId,
                        null,
                        $"{fullName} (Email: {email}, Skills: {skills})",
                        Request.UserHostAddress
                    );

                    pnlAddModal.Visible = false;
                    ShowAlert(true, $"Field technician '{fullName}' (#{newTechId}) registered successfully.");
                    LoadTechnicians();
                }
                else
                {
                    ShowAlert(false, "Registration Failed: A user with this login email address may already exist.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to register field service engineer"));
            }
        }
        #endregion

        #region Edit Modal Events
        protected void btnCloseEditModal_Click(object sender, EventArgs e)
        {
            pnlEditModal.Visible = false;
        }

        protected void btnSubmitEditTech_Click(object sender, EventArgs e)
        {
            int techId = Convert.ToInt32(hdnEditTechId.Value);
            string skills = txtEditSkills.Text.Trim();
            int exp = 0;
            int.TryParse(txtEditExperience.Text.Trim(), out exp);
            decimal rate = 500.00m;
            decimal.TryParse(txtEditHourlyRate.Text.Trim(), out rate);
            string address = txtEditAddress.Text.Trim();
            string city = txtEditCity.Text.Trim();
            string state = txtEditState.Text.Trim();
            string pincode = txtEditPincode.Text.Trim();
            string ver = ddlEditVerification.SelectedValue;
            bool isAvail = chkEditIsAvailable.Checked;

            if (string.IsNullOrEmpty(skills) || string.IsNullOrEmpty(city))
            {
                ShowAlert(false, "Validation Error: Technical Skills and City are required.");
                return;
            }

            try
            {
                bool updated = _adminLogic.updateTechnicianDetails(techId, skills, exp, rate, address, city, state, pincode, isAvail, ver);
                if (updated)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "UPDATE_TECHNICIAN",
                        "Technicians",
                        techId,
                        null,
                        $"Rate: ₹{rate}/hr, Avail: {isAvail}, Status: {ver}",
                        Request.UserHostAddress
                    );

                    pnlEditModal.Visible = false;
                    ShowAlert(true, $"Technician #{techId} profile and credentials updated successfully.");
                    LoadTechnicians();
                }
                else
                {
                    ShowAlert(false, $"Failed to update technician #{techId}.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to update technician credentials"));
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

