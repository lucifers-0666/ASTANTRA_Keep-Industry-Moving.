using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin.Factories
{
    public partial class ManageFactories : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public ManageFactories()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFactories();
            }
        }

        private void LoadFactories()
        {
            try
            {
                string search = txtSearch.Text.Trim();
                string city = txtCityFilter.Text.Trim();

                DataSet ds = _adminLogic.selectAllFactories(search, string.IsNullOrEmpty(city) ? null : city);
                DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;

                gvFactories.DataSource = dt;
                gvFactories.DataBind();

                lblFactoriesCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to load industrial plants roster"));
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadFactories();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            txtCityFilter.Text = string.Empty;
            LoadFactories();
        }

        protected void gvFactories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int factoryId = Convert.ToInt32(gvFactories.DataKeys[rowIndex].Values["FactoryId"]);
            string companyName = gvFactories.DataKeys[rowIndex].Values["CompanyName"]?.ToString();

            if (e.CommandName == "EditFactory")
            {
                hdnEditFactoryId.Value = factoryId.ToString();
                txtEditCompanyName.Text = companyName;
                txtEditIndustryType.Text = gvFactories.DataKeys[rowIndex].Values["IndustryType"] != DBNull.Value ? gvFactories.DataKeys[rowIndex].Values["IndustryType"]?.ToString() : string.Empty;
                txtEditContactPerson.Text = gvFactories.DataKeys[rowIndex].Values["ContactPerson"] != DBNull.Value ? gvFactories.DataKeys[rowIndex].Values["ContactPerson"]?.ToString() : string.Empty;
                txtEditGstin.Text = gvFactories.DataKeys[rowIndex].Values["Gstin"] != DBNull.Value ? gvFactories.DataKeys[rowIndex].Values["Gstin"]?.ToString() : string.Empty;
                txtEditAddress.Text = gvFactories.DataKeys[rowIndex].Values["Address"] != DBNull.Value ? gvFactories.DataKeys[rowIndex].Values["Address"]?.ToString() : string.Empty;
                txtEditCity.Text = gvFactories.DataKeys[rowIndex].Values["City"] != DBNull.Value ? gvFactories.DataKeys[rowIndex].Values["City"]?.ToString() : string.Empty;
                txtEditState.Text = gvFactories.DataKeys[rowIndex].Values["State"] != DBNull.Value ? gvFactories.DataKeys[rowIndex].Values["State"]?.ToString() : string.Empty;
                txtEditPincode.Text = gvFactories.DataKeys[rowIndex].Values["Pincode"] != DBNull.Value ? gvFactories.DataKeys[rowIndex].Values["Pincode"]?.ToString() : string.Empty;

                pnlEditModal.Visible = true;
            }
            else if (e.CommandName == "DeleteFactory")
            {
                bool deleted = _adminLogic.deleteFactory(factoryId);
                if (deleted)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "DELETE_FACTORY",
                        "Factories",
                        factoryId,
                        companyName,
                        null,
                        Request.UserHostAddress
                    );

                    ShowAlert(true, $"Manufacturing facility #{factoryId} ({companyName}) and its user account were deleted.");
                }
                else
                {
                    ShowAlert(false, $"Failed to delete factory #{factoryId}. Associated procurement quotations or active purchase orders may exist.");
                }

                LoadFactories();
            }
        }

        #region Add Modal Events
        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            txtAddCompanyName.Text = string.Empty;
            txtAddIndustryType.Text = string.Empty;
            txtAddEmail.Text = string.Empty;
            txtAddPassword.Text = string.Empty;
            txtAddContactPerson.Text = string.Empty;
            txtAddPhone.Text = string.Empty;
            txtAddAddress.Text = string.Empty;
            txtAddCity.Text = string.Empty;
            txtAddState.Text = string.Empty;
            txtAddPincode.Text = string.Empty;
            txtAddGstin.Text = string.Empty;
            pnlAddModal.Visible = true;
        }

        protected void btnCloseAddModal_Click(object sender, EventArgs e)
        {
            pnlAddModal.Visible = false;
        }

        protected void btnSubmitAddFactory_Click(object sender, EventArgs e)
        {
            string company = txtAddCompanyName.Text.Trim();
            string industry = txtAddIndustryType.Text.Trim();
            string email = txtAddEmail.Text.Trim();
            string password = txtAddPassword.Text.Trim();
            string contact = txtAddContactPerson.Text.Trim();
            string phone = txtAddPhone.Text.Trim();
            string address = txtAddAddress.Text.Trim();
            string city = txtAddCity.Text.Trim();
            string state = txtAddState.Text.Trim();
            string pincode = txtAddPincode.Text.Trim();
            string gstin = txtAddGstin.Text.Trim();

            if (string.IsNullOrEmpty(company) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(contact) || string.IsNullOrEmpty(city))
            {
                ShowAlert(false, "Validation Error: Company Name, Login Email, Initial Password, Contact Person, and City are required.");
                return;
            }

            try
            {
                int newFactoryId = _adminLogic.insertNewFactory(company, industry, email, phone, password, contact, address, city, state, pincode, gstin);
                if (newFactoryId > 0)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "CREATE_FACTORY",
                        "Factories",
                        newFactoryId,
                        null,
                        $"{company} (Email: {email}, City: {city})",
                        Request.UserHostAddress
                    );

                    pnlAddModal.Visible = false;
                    ShowAlert(true, $"Industrial plant facility '{company}' (#{newFactoryId}) registered successfully.");
                    LoadFactories();
                }
                else
                {
                    ShowAlert(false, "Registration Failed: A user with this login email address may already exist.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to register industrial plant"));
            }
        }
        #endregion

        #region Edit Modal Events
        protected void btnCloseEditModal_Click(object sender, EventArgs e)
        {
            pnlEditModal.Visible = false;
        }

        protected void btnSubmitEditFactory_Click(object sender, EventArgs e)
        {
            int factoryId = Convert.ToInt32(hdnEditFactoryId.Value);
            string company = txtEditCompanyName.Text.Trim();
            string industry = txtEditIndustryType.Text.Trim();
            string contact = txtEditContactPerson.Text.Trim();
            string address = txtEditAddress.Text.Trim();
            string city = txtEditCity.Text.Trim();
            string state = txtEditState.Text.Trim();
            string pincode = txtEditPincode.Text.Trim();
            string gstin = txtEditGstin.Text.Trim();

            if (string.IsNullOrEmpty(company) || string.IsNullOrEmpty(contact) || string.IsNullOrEmpty(city))
            {
                ShowAlert(false, "Validation Error: Company Name, Contact Person, and City are required.");
                return;
            }

            try
            {
                bool updated = _adminLogic.updateFactory(factoryId, company, industry, address, city, state, pincode, gstin, contact);
                if (updated)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "UPDATE_FACTORY",
                        "Factories",
                        factoryId,
                        null,
                        $"{company} ({city}, {gstin})",
                        Request.UserHostAddress
                    );

                    pnlEditModal.Visible = false;
                    ShowAlert(true, $"Industrial plant facility #{factoryId} ({company}) updated successfully.");
                    LoadFactories();
                }
                else
                {
                    ShowAlert(false, $"Failed to update facility #{factoryId}.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to update factory profile"));
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

