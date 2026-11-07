using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Admin.SpareParts
{
    public partial class ManageParts : BasePage
    {
        private readonly PartLogic _partLogic = new PartLogic();
        private readonly AuditLogic _auditLogic = new AuditLogic();

        public ManageParts()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropdowns();
                LoadParts();
            }
        }

        private void LoadDropdowns()
        {
            try
            {
                // Categories
                DataSet dsCat = _partLogic.selectCategories();
                if (dsCat != null && dsCat.Tables.Count > 0)
                {
                    ddlFilterCategory.Items.Clear();
                    ddlFilterCategory.Items.Add(new ListItem("All Categories", ""));
                    ddlModalCategory.Items.Clear();

                    foreach (DataRow row in dsCat.Tables[0].Rows)
                    {
                        string id = row["CategoryId"].ToString();
                        string name = row["CategoryName"].ToString();
                        ddlFilterCategory.Items.Add(new ListItem(name, id));
                        ddlModalCategory.Items.Add(new ListItem(name, id));
                    }
                }

                // Machines
                DataSet dsMac = _partLogic.selectMachines();
                if (dsMac != null && dsMac.Tables.Count > 0)
                {
                    ddlFilterMachine.Items.Clear();
                    ddlFilterMachine.Items.Add(new ListItem("All Machinery", ""));
                    ddlModalMachine.Items.Clear();
                    ddlModalMachine.Items.Add(new ListItem("Universal (Any Industrial Machinery)", ""));

                    foreach (DataRow row in dsMac.Tables[0].Rows)
                    {
                        string id = row["MachineId"].ToString();
                        string name = row["MachineName"].ToString();
                        ddlFilterMachine.Items.Add(new ListItem(name, id));
                        ddlModalMachine.Items.Add(new ListItem(name, id));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to load equipment taxonomy selectors"));
            }
        }

        private void LoadParts()
        {
            try
            {
                string search = txtSearch.Text.Trim();
                string category = ddlFilterCategory.SelectedValue;
                string machine = ddlFilterMachine.SelectedValue;

                DataSet ds = _partLogic.selectCatalog(
                    string.IsNullOrEmpty(search) ? null : search,
                    string.IsNullOrEmpty(category) ? null : category,
                    string.IsNullOrEmpty(machine) ? null : machine
                );

                DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
                gvParts.DataSource = dt;
                gvParts.DataBind();

                lblPartsCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to load master parts catalog"));
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadParts();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadParts();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlFilterCategory.SelectedIndex = 0;
            ddlFilterMachine.SelectedIndex = 0;
            LoadParts();
        }

        protected void gvParts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int partId = Convert.ToInt32(gvParts.DataKeys[rowIndex].Values["PartId"]);
            string partNumber = gvParts.DataKeys[rowIndex].Values["PartNumber"]?.ToString();
            string partName = gvParts.DataKeys[rowIndex].Values["PartName"]?.ToString();

            if (e.CommandName == "EditPart")
            {
                DataSet dsPart = _partLogic.selectPartById(partId);
                if (dsPart != null && dsPart.Tables.Count > 0 && dsPart.Tables[0].Rows.Count > 0)
                {
                    DataRow r = dsPart.Tables[0].Rows[0];
                    hdnPartId.Value = partId.ToString();
                    lblPartModalTitle.InnerText = "Edit Master Part Specification";
                    txtPartNumber.Text = r["PartNumber"].ToString();
                    txtPartName.Text = r["PartName"].ToString();

                    string catId = r["CategoryId"].ToString();
                    if (ddlModalCategory.Items.FindByValue(catId) != null)
                        ddlModalCategory.SelectedValue = catId;

                    string macId = r["MachineId"] != DBNull.Value ? r["MachineId"].ToString() : "";
                    if (ddlModalMachine.Items.FindByValue(macId) != null)
                        ddlModalMachine.SelectedValue = macId;

                    string uom = r["UnitOfMeasure"] != DBNull.Value ? r["UnitOfMeasure"].ToString() : "Piece";
                    if (ddlModalUom.Items.FindByValue(uom) != null)
                        ddlModalUom.SelectedValue = uom;

                    txtSpecs.Text = r["TechnicalSpecs"] != DBNull.Value ? r["TechnicalSpecs"].ToString() : "";
                    txtDescription.Text = r["Description"] != DBNull.Value ? r["Description"].ToString() : "";

                    pnlPartModal.Visible = true;
                }
            }
            else if (e.CommandName == "DeletePart")
            {
                bool deleted = _partLogic.deletePart(partId);
                if (deleted)
                {
                    _auditLogic.logAction(
                        SessionHelper.UserId,
                        "DELETE_PART",
                        "SpareParts",
                        partId,
                        $"{partNumber} - {partName}",
                        null,
                        Request.UserHostAddress
                    );

                    ShowAlert(true, $"Master part #{partId} ('{partNumber}') removed from catalog.");
                    LoadParts();
                }
                else
                {
                    ShowAlert(false, $"Failed to delete part #{partId}. Active quotations or supplier stock inventories reference it.");
                }
            }
        }

        #region Modal Actions
        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            hdnPartId.Value = "0";
            lblPartModalTitle.InnerText = "Register Master Part Record";
            txtPartNumber.Text = string.Empty;
            txtPartName.Text = string.Empty;
            txtSpecs.Text = string.Empty;
            txtDescription.Text = string.Empty;
            if (ddlModalCategory.Items.Count > 0) ddlModalCategory.SelectedIndex = 0;
            if (ddlModalMachine.Items.Count > 0) ddlModalMachine.SelectedIndex = 0;
            ddlModalUom.SelectedIndex = 0;
            pnlPartModal.Visible = true;
        }

        protected void btnClosePartModal_Click(object sender, EventArgs e)
        {
            pnlPartModal.Visible = false;
        }

        protected void btnSavePart_Click(object sender, EventArgs e)
        {
            int partId = Convert.ToInt32(hdnPartId.Value);
            string partNumber = txtPartNumber.Text.Trim();
            string partName = txtPartName.Text.Trim();
            int catId = Convert.ToInt32(ddlModalCategory.SelectedValue);
            int? macId = !string.IsNullOrEmpty(ddlModalMachine.SelectedValue) ? (int?)Convert.ToInt32(ddlModalMachine.SelectedValue) : null;
            string uom = ddlModalUom.SelectedValue;
            string specs = txtSpecs.Text.Trim();
            string desc = txtDescription.Text.Trim();

            if (string.IsNullOrEmpty(partNumber) || string.IsNullOrEmpty(partName))
            {
                ShowAlert(false, "Validation Error: OEM Part Number and Component Name are required.");
                return;
            }

            try
            {
                if (partId == 0)
                {
                    int newId = _partLogic.insertPart(catId, macId, partNumber, partName, desc, specs, uom);
                    if (newId > 0)
                    {
                        _auditLogic.logAction(
                            SessionHelper.UserId,
                            "CREATE_PART",
                            "SpareParts",
                            newId,
                            null,
                            $"{partNumber} - {partName} ({uom})",
                            Request.UserHostAddress
                        );

                        pnlPartModal.Visible = false;
                        ShowAlert(true, $"Master Part '{partNumber}' registered successfully into catalog.");
                        LoadParts();
                    }
                    else
                    {
                        ShowAlert(false, "Failed to register master part.");
                    }
                }
                else
                {
                    bool updated = _partLogic.updatePart(partId, catId, macId, partNumber, partName, desc, specs, uom);
                    if (updated)
                    {
                        _auditLogic.logAction(
                            SessionHelper.UserId,
                            "UPDATE_PART",
                            "SpareParts",
                            partId,
                            null,
                            $"{partNumber} - {partName}",
                            Request.UserHostAddress
                        );

                        pnlPartModal.Visible = false;
                        ShowAlert(true, $"Master Part #{partId} ('{partNumber}') updated successfully.");
                        LoadParts();
                    }
                    else
                    {
                        ShowAlert(false, $"Failed to update part #{partId}.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert(false, AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to execute spare part operation"));
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
