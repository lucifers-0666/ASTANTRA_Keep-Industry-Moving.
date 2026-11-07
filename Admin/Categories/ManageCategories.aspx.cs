using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin.Categories
{
    public partial class ManageCategories : BasePage
    {
        private readonly PartLogic _partLogic = new PartLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public ManageCategories()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            try
            {
                // 1. Categories
                DataSet dsCat = _partLogic.selectCategories();
                DataTable dtCat = (dsCat != null && dsCat.Tables.Count > 0) ? dsCat.Tables[0] : null;
                gvCategories.DataSource = dtCat;
                gvCategories.DataBind();
                lblCatCount.Text = dtCat != null ? dtCat.Rows.Count.ToString() : "0";

                // 2. Machines
                DataSet dsMac = _partLogic.selectMachines();
                DataTable dtMac = (dsMac != null && dsMac.Tables.Count > 0) ? dsMac.Tables[0] : null;
                gvMachines.DataSource = dtMac;
                gvMachines.DataBind();
                lblMacCount.Text = dtMac != null ? dtMac.Rows.Count.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to load equipment taxonomy data"));
            }
        }

        #region Category Management
        protected void btnOpenAddCategoryModal_Click(object sender, EventArgs e)
        {
            hdnCategoryId.Value = "0";
            lblCatModalTitle.InnerText = "Register New Category";
            txtCategoryName.Text = string.Empty;
            txtCategoryDesc.Text = string.Empty;
            txtCategoryIcon.Text = "fa-solid fa-gear";
            pnlCategoryModal.Visible = true;
        }

        protected void btnCloseCatModal_Click(object sender, EventArgs e)
        {
            pnlCategoryModal.Visible = false;
        }

        protected void btnSaveCategory_Click(object sender, EventArgs e)
        {
            int catId = Convert.ToInt32(hdnCategoryId.Value);
            string name = txtCategoryName.Text.Trim();
            string desc = txtCategoryDesc.Text.Trim();
            string icon = txtCategoryIcon.Text.Trim();

            if (string.IsNullOrEmpty(name))
            {
                ShowAlert(false, "Validation Error: Category Name is required.");
                return;
            }

            try
            {
                if (catId == 0)
                {
                    int newId = _partLogic.insertCategory(name, desc, icon);
                    if (newId > 0)
                    {
                        _auditLogic.logAction(SessionHelper.UserId, "CREATE_CATEGORY", "Categories", newId, null, name, Request.UserHostAddress);
                        pnlCategoryModal.Visible = false;
                        ShowAlert(true, $"Category '{name}' created successfully.");
                        LoadData();
                    }
                    else
                    {
                        ShowAlert(false, "Failed to create category.");
                    }
                }
                else
                {
                    bool updated = _partLogic.updateCategory(catId, name, desc, icon, true);
                    if (updated)
                    {
                        _auditLogic.logAction(SessionHelper.UserId, "UPDATE_CATEGORY", "Categories", catId, null, name, Request.UserHostAddress);
                        pnlCategoryModal.Visible = false;
                        ShowAlert(true, $"Category #{catId} ('{name}') updated successfully.");
                        LoadData();
                    }
                    else
                    {
                        ShowAlert(false, $"Failed to update category #{catId}.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to modify spare part category"));
            }
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int catId = Convert.ToInt32(gvCategories.DataKeys[rowIndex].Values["CategoryId"]);
            string name = gvCategories.DataKeys[rowIndex].Values["CategoryName"]?.ToString();

            if (e.CommandName == "EditCategory")
            {
                hdnCategoryId.Value = catId.ToString();
                lblCatModalTitle.InnerText = "Edit Category Profile";
                txtCategoryName.Text = name;
                txtCategoryDesc.Text = gvCategories.DataKeys[rowIndex].Values["Description"] != DBNull.Value ? gvCategories.DataKeys[rowIndex].Values["Description"]?.ToString() : string.Empty;
                txtCategoryIcon.Text = gvCategories.DataKeys[rowIndex].Values["IconClass"] != DBNull.Value ? gvCategories.DataKeys[rowIndex].Values["IconClass"]?.ToString() : "fa-solid fa-cogs";
                pnlCategoryModal.Visible = true;
            }
            else if (e.CommandName == "DeleteCategory")
            {
                bool deleted = _partLogic.deleteCategory(catId);
                if (deleted)
                {
                    _auditLogic.logAction(SessionHelper.UserId, "DELETE_CATEGORY", "Categories", catId, name, null, Request.UserHostAddress);
                    ShowAlert(true, $"Category #{catId} ('{name}') deleted successfully.");
                    LoadData();
                }
                else
                {
                    ShowAlert(false, $"Cannot delete category #{catId} ('{name}') because spare parts are currently cataloged under it.");
                }
            }
        }
        #endregion

        #region Machine Management
        protected void btnOpenAddMachineModal_Click(object sender, EventArgs e)
        {
            hdnMachineId.Value = "0";
            lblMacModalTitle.InnerText = "Register Machine Model";
            txtMachineName.Text = string.Empty;
            txtMachineModel.Text = string.Empty;
            txtMachineMfg.Text = string.Empty;
            pnlMachineModal.Visible = true;
        }

        protected void btnCloseMacModal_Click(object sender, EventArgs e)
        {
            pnlMachineModal.Visible = false;
        }

        protected void btnSaveMachine_Click(object sender, EventArgs e)
        {
            int macId = Convert.ToInt32(hdnMachineId.Value);
            string name = txtMachineName.Text.Trim();
            string model = txtMachineModel.Text.Trim();
            string mfg = txtMachineMfg.Text.Trim();

            if (string.IsNullOrEmpty(name))
            {
                ShowAlert(false, "Validation Error: Machine Name is required.");
                return;
            }

            try
            {
                if (macId == 0)
                {
                    int newId = _partLogic.insertMachine(name, model, mfg);
                    if (newId > 0)
                    {
                        _auditLogic.logAction(SessionHelper.UserId, "CREATE_MACHINE", "Machines", newId, null, $"{name} ({model})", Request.UserHostAddress);
                        pnlMachineModal.Visible = false;
                        ShowAlert(true, $"Machine profile '{name}' registered successfully.");
                        LoadData();
                    }
                    else
                    {
                        ShowAlert(false, "Failed to register machine model.");
                    }
                }
                else
                {
                    bool updated = _partLogic.updateMachine(macId, name, model, mfg);
                    if (updated)
                    {
                        _auditLogic.logAction(SessionHelper.UserId, "UPDATE_MACHINE", "Machines", macId, null, $"{name} ({model})", Request.UserHostAddress);
                        pnlMachineModal.Visible = false;
                        ShowAlert(true, $"Machine model #{macId} ('{name}') updated successfully.");
                        LoadData();
                    }
                    else
                    {
                        ShowAlert(false, $"Failed to update machine model #{macId}.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to modify machinery model"));
            }
        }

        protected void gvMachines_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int macId = Convert.ToInt32(gvMachines.DataKeys[rowIndex].Values["MachineId"]);
            string name = gvMachines.DataKeys[rowIndex].Values["MachineName"]?.ToString();

            if (e.CommandName == "EditMachine")
            {
                hdnMachineId.Value = macId.ToString();
                lblMacModalTitle.InnerText = "Edit Machine Profile";
                txtMachineName.Text = name;
                txtMachineModel.Text = gvMachines.DataKeys[rowIndex].Values["ModelNumber"] != DBNull.Value ? gvMachines.DataKeys[rowIndex].Values["ModelNumber"]?.ToString() : string.Empty;
                txtMachineMfg.Text = gvMachines.DataKeys[rowIndex].Values["Manufacturer"] != DBNull.Value ? gvMachines.DataKeys[rowIndex].Values["Manufacturer"]?.ToString() : string.Empty;
                pnlMachineModal.Visible = true;
            }
            else if (e.CommandName == "DeleteMachine")
            {
                bool deleted = _partLogic.deleteMachine(macId);
                if (deleted)
                {
                    _auditLogic.logAction(SessionHelper.UserId, "DELETE_MACHINE", "Machines", macId, name, null, Request.UserHostAddress);
                    ShowAlert(true, $"Machine model #{macId} ('{name}') deleted successfully.");
                    LoadData();
                }
                else
                {
                    ShowAlert(false, $"Cannot delete machine #{macId} ('{name}') because spare parts are mapped to it.");
                }
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
