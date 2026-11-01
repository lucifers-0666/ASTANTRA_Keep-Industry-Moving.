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
            string status = ddlStatusFilter.SelectedValue;
            DataSet ds = _adminLogic.selectPendingSuppliers(status);

            DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvSuppliers.DataSource = dt;
            gvSuppliers.DataBind();

            lblSuppliersCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadSuppliers();
        }

        protected void gvSuppliers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ApproveSupplier" || e.CommandName == "RejectSupplier")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int supplierId = Convert.ToInt32(gvSuppliers.DataKeys[rowIndex].Values["SupplierId"]);
                int userId = Convert.ToInt32(gvSuppliers.DataKeys[rowIndex].Values["UserId"]);
                bool isApprove = e.CommandName == "ApproveSupplier";
                string newStatus = isApprove ? "Verified" : "Rejected";

                bool success = _adminLogic.verifySupplier(supplierId, userId, isApprove);

                if (success)
                {
                    pnlAlert.Visible = true;
                    lblAlertMessage.Text = $"Supplier #{supplierId} status updated to '{newStatus}'.";
                }
                else
                {
                    pnlAlert.Visible = true;
                    lblAlertMessage.Text = "Failed to update supplier verification status.";
                }

                LoadSuppliers();
            }
        }
    }
}

