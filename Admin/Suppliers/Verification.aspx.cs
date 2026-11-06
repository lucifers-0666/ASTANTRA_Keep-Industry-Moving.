using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin.Suppliers
{
    public partial class Verification : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public Verification()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSuppliers();
            }
        }

        private void LoadSuppliers()
        {
            try
            {
                string status = ddlStatusFilter.SelectedValue;
                string search = txtSearch.Text.Trim();

                DataSet ds = _adminLogic.selectPendingSuppliers(string.IsNullOrEmpty(status) ? null : status);
                DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;

                // Client-side search filtering on DataTable if search keyword is present
                if (dt != null && !string.IsNullOrEmpty(search))
                {
                    DataView dv = dt.DefaultView;
                    dv.RowFilter = $"CompanyName LIKE '%{search}%' OR ContactName LIKE '%{search}%' OR Gstin LIKE '%{search}%' OR City LIKE '%{search}%'";
                    dt = dv.ToTable();
                }

                gvSuppliers.DataSource = dt;
                gvSuppliers.DataBind();

                lblSuppliersCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAlert(false, "Error loading suppliers: " + ex.Message);
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadSuppliers();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadSuppliers();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlStatusFilter.SelectedIndex = 0;
            LoadSuppliers();
        }

        protected void gvSuppliers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int supplierId = Convert.ToInt32(gvSuppliers.DataKeys[rowIndex].Values["SupplierId"]);
            int userId = Convert.ToInt32(gvSuppliers.DataKeys[rowIndex].Values["UserId"]);
            string companyName = gvSuppliers.DataKeys[rowIndex].Values["CompanyName"]?.ToString();

            if (e.CommandName == "InspectSupplier")
            {
                hdnInspectSupplierId.Value = supplierId.ToString();
                hdnInspectUserId.Value = userId.ToString();

                lblDossierCompanyName.InnerText = companyName;
                lblDossierStatus.InnerText = gvSuppliers.DataKeys[rowIndex].Values["VerificationStatus"]?.ToString();
                lblDossierGstin.InnerText = gvSuppliers.DataKeys[rowIndex].Values["Gstin"] != DBNull.Value ? gvSuppliers.DataKeys[rowIndex].Values["Gstin"]?.ToString() : "NOT ENTERED";
                lblDossierTradeReg.InnerText = gvSuppliers.DataKeys[rowIndex].Values["BusinessRegistrationNo"] != DBNull.Value ? gvSuppliers.DataKeys[rowIndex].Values["BusinessRegistrationNo"]?.ToString() : "Pending";
                lblDossierContact.InnerText = gvSuppliers.DataKeys[rowIndex].Values["ContactName"]?.ToString();
                lblDossierEmail.InnerText = gvSuppliers.DataKeys[rowIndex].Values["Email"]?.ToString();
                lblDossierPhone.InnerText = gvSuppliers.DataKeys[rowIndex].Values["PhoneNumber"] != DBNull.Value ? gvSuppliers.DataKeys[rowIndex].Values["PhoneNumber"]?.ToString() : "No phone provided";
                lblDossierLocation.InnerText = $"{gvSuppliers.DataKeys[rowIndex].Values["City"]}, {gvSuppliers.DataKeys[rowIndex].Values["State"]}";
                
                decimal rating = 4.5m;
                if (gvSuppliers.DataKeys[rowIndex].Values["Rating"] != DBNull.Value)
                {
                    decimal.TryParse(gvSuppliers.DataKeys[rowIndex].Values["Rating"].ToString(), out rating);
                }
                lblDossierRating.InnerText = $"{rating:F1} Quality Score";

                txtAuditRemarks.Text = string.Empty;
                pnlInspectModal.Visible = true;
            }
            else if (e.CommandName == "ApproveSupplier" || e.CommandName == "RejectSupplier")
            {
                bool isApprove = e.CommandName == "ApproveSupplier";
                ProcessVerification(supplierId, userId, companyName, isApprove, "Direct Quick Action");
            }
        }

        #region Dossier Modal Actions
        protected void btnCloseInspectModal_Click(object sender, EventArgs e)
        {
            pnlInspectModal.Visible = false;
        }

        protected void btnApproveDossier_Click(object sender, EventArgs e)
        {
            int supplierId = Convert.ToInt32(hdnInspectSupplierId.Value);
            int userId = Convert.ToInt32(hdnInspectUserId.Value);
            string companyName = lblDossierCompanyName.InnerText;
            string remarks = txtAuditRemarks.Text.Trim();

            ProcessVerification(supplierId, userId, companyName, true, string.IsNullOrEmpty(remarks) ? "Approved via Compliance Dossier" : remarks);
            pnlInspectModal.Visible = false;
        }

        protected void btnRejectDossier_Click(object sender, EventArgs e)
        {
            int supplierId = Convert.ToInt32(hdnInspectSupplierId.Value);
            int userId = Convert.ToInt32(hdnInspectUserId.Value);
            string companyName = lblDossierCompanyName.InnerText;
            string remarks = txtAuditRemarks.Text.Trim();

            ProcessVerification(supplierId, userId, companyName, false, string.IsNullOrEmpty(remarks) ? "Rejected via Compliance Dossier" : remarks);
            pnlInspectModal.Visible = false;
        }
        #endregion

        private void ProcessVerification(int supplierId, int userId, string companyName, bool isApproved, string remarks)
        {
            string newStatus = isApproved ? "Verified" : "Rejected";

            bool success = _adminLogic.verifySupplier(supplierId, userId, isApproved);
            if (success)
            {
                _auditLogic.logAction(
                    SessionHelper.UserId,
                    isApproved ? "APPROVE_SUPPLIER" : "REJECT_SUPPLIER",
                    "Suppliers",
                    supplierId,
                    null,
                    $"{companyName} -> {newStatus}. Remarks: {remarks}",
                    Request.UserHostAddress
                );

                ShowAlert(true, $"Supplier #{supplierId} ({companyName}) status updated to '{newStatus}' successfully.");
                LoadSuppliers();
            }
            else
            {
                ShowAlert(false, $"Failed to update verification status for supplier #{supplierId}.");
            }
        }

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
