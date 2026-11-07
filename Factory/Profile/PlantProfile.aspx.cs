using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Factory.Profile
{
    public partial class PlantProfile : FactoryBasePage
    {
        private readonly FactoryProfileLogic _profileLogic = new FactoryProfileLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblTenantBadge.InnerText = string.Format("Tenant ID: FID-{0:D3}", CurrentFactoryId);
                LoadProfileData();
            }
        }

        private void LoadProfileData()
        {
            DataRow profile = _profileLogic.getFactoryProfile(CurrentFactoryId);
            if (profile != null)
            {
                txtCompanyName.Text = profile["CompanyName"].ToString();
                txtIndustryType.Text = profile["IndustryType"] != DBNull.Value ? profile["IndustryType"].ToString() : string.Empty;
                txtGstin.Text = profile["Gstin"] != DBNull.Value ? profile["Gstin"].ToString() : string.Empty;
                txtContactPerson.Text = profile["ContactPerson"] != DBNull.Value ? profile["ContactPerson"].ToString() : string.Empty;
                txtContactPhone.Text = profile["ContactPhone"] != DBNull.Value ? profile["ContactPhone"].ToString() : string.Empty;

                txtAddress.Text = profile["Address"] != DBNull.Value ? profile["Address"].ToString() : string.Empty;
                txtCity.Text = profile["City"] != DBNull.Value ? profile["City"].ToString() : string.Empty;
                txtState.Text = profile["State"] != DBNull.Value ? profile["State"].ToString() : string.Empty;
                txtPincode.Text = profile["Pincode"] != DBNull.Value ? profile["Pincode"].ToString() : string.Empty;

                lblUserEmail.InnerText = profile["Email"].ToString();
                if (profile["CreatedAt"] != DBNull.Value)
                {
                    lblRegistrationDate.InnerText = Convert.ToDateTime(profile["CreatedAt"]).ToString("dd MMM yyyy");
                }
            }
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            string companyName = txtCompanyName.Text.Trim();
            string contactPerson = txtContactPerson.Text.Trim();
            string contactPhone = txtContactPhone.Text.Trim();
            string address = txtAddress.Text.Trim();
            string city = txtCity.Text.Trim();
            string state = txtState.Text.Trim();
            string pincode = txtPincode.Text.Trim();
            string industryType = string.IsNullOrEmpty(txtIndustryType.Text.Trim()) ? null : txtIndustryType.Text.Trim();
            string gstin = string.IsNullOrEmpty(txtGstin.Text.Trim()) ? null : txtGstin.Text.Trim().ToUpper();

            if (string.IsNullOrEmpty(companyName) || string.IsNullOrEmpty(contactPerson) || 
                string.IsNullOrEmpty(contactPhone) || string.IsNullOrEmpty(address) || 
                string.IsNullOrEmpty(city) || string.IsNullOrEmpty(state) || string.IsNullOrEmpty(pincode))
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-amber-50 border border-amber-300 text-xs text-slate-800 flex items-center justify-between";
                lblAlertMessage.Text = "Please fill in all required company and plant address fields.";
                return;
            }

            try
            {
                bool success = _profileLogic.updateFactoryProfile(
                    CurrentFactoryId, companyName, industryType, address, city, state, pincode, gstin, contactPerson, contactPhone);

                if (success)
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between";
                    lblAlertMessage.Text = "Plant facility master profile and delivery coordinates updated successfully.";
                    LoadProfileData();
                }
                else
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-rose-50 border border-rose-300 text-xs text-rose-800 flex items-center justify-between";
                    lblAlertMessage.Text = "Profile update failed. Tenant record not found.";
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-rose-50 border border-rose-300 text-xs text-rose-800 flex items-center justify-between";
                lblAlertMessage.Text = "Database error updating profile: " + ex.Message;
            }
        }
    }
}