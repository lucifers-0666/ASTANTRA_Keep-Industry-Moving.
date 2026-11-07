using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory.Machines
{
    public partial class MyMachinery : FactoryBasePage
    {
        private readonly FactoryMachineLogic _machineLogic = new FactoryMachineLogic();
        private readonly PartLogic _partLogic = new PartLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateMasterMachinesDropdown();
                LoadMetrics();
                LoadMachinesGrid();
            }
        }

        private void PopulateMasterMachinesDropdown()
        {
            DataSet ds = _partLogic.selectMachines();
            ddlMachineModel.Items.Clear();

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    string label = string.Format("{0} ({1}) - {2}", 
                        row["MachineName"], row["ModelNumber"], row["Manufacturer"]);
                    ddlMachineModel.Items.Add(new ListItem(label, row["MachineId"].ToString()));
                }
            }
            else
            {
                ddlMachineModel.Items.Add(new ListItem("-- No Master Machines Available --", ""));
            }
        }

        private void LoadMetrics()
        {
            int total, operational, maintenance, offline;
            _machineLogic.getFactoryMachineMetrics(CurrentFactoryId, out total, out operational, out maintenance, out offline);

            lblTotalCount.InnerText = total.ToString();
            lblOperationalCount.InnerText = operational.ToString();
            lblMaintenanceCount.InnerText = maintenance.ToString();
            lblOfflineCount.InnerText = offline.ToString();
        }

        private void LoadMachinesGrid()
        {
            string search = string.IsNullOrEmpty(txtSearch.Text.Trim()) ? null : txtSearch.Text.Trim();
            string status = ddlStatusFilter.SelectedValue;

            DataSet ds = _machineLogic.selectMachinesByFactory(CurrentFactoryId, search, status);

            int count = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0].Rows.Count : 0;
            lblGridCount.InnerText = count.ToString();

            gvMachinery.DataSource = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvMachinery.DataBind();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadMachinesGrid();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadMachinesGrid();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlStatusFilter.SelectedValue = "All";
            LoadMachinesGrid();
        }

        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            hdnFactoryMachineId.Value = "0";
            lblModalTitle.Text = "Register Equipment Asset";
            txtAssetTag.Text = string.Empty;
            txtSerialNumber.Text = string.Empty;
            txtDepartment.Text = string.Empty;
            txtInstalledDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            ddlStatus.SelectedValue = "Operational";
            txtNotes.Text = string.Empty;

            pnlMachineModal.Visible = true;
            pnlAlert.Visible = false;
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlMachineModal.Visible = false;
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }

        protected void gvMachinery_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditMachine")
            {
                int factoryMachineId = Convert.ToInt32(e.CommandArgument);
                DataRow row = _machineLogic.getMachineById(factoryMachineId, CurrentFactoryId);

                if (row != null)
                {
                    hdnFactoryMachineId.Value = factoryMachineId.ToString();
                    lblModalTitle.Text = "Update Equipment Asset (" + row["AssetTag"].ToString() + ")";

                    if (ddlMachineModel.Items.FindByValue(row["MachineId"].ToString()) != null)
                    {
                        ddlMachineModel.SelectedValue = row["MachineId"].ToString();
                    }

                    txtAssetTag.Text = row["AssetTag"].ToString();
                    txtSerialNumber.Text = row["SerialNumber"] != DBNull.Value ? row["SerialNumber"].ToString() : string.Empty;
                    txtDepartment.Text = row["Department"] != DBNull.Value ? row["Department"].ToString() : string.Empty;

                    if (row["InstalledDate"] != DBNull.Value)
                    {
                        txtInstalledDate.Text = Convert.ToDateTime(row["InstalledDate"]).ToString("yyyy-MM-dd");
                    }
                    else
                    {
                        txtInstalledDate.Text = string.Empty;
                    }

                    if (ddlStatus.Items.FindByValue(row["Status"].ToString()) != null)
                    {
                        ddlStatus.SelectedValue = row["Status"].ToString();
                    }

                    txtNotes.Text = row["Notes"] != DBNull.Value ? row["Notes"].ToString() : string.Empty;

                    pnlMachineModal.Visible = true;
                    pnlAlert.Visible = false;
                }
            }
            else if (e.CommandName == "DeleteMachine")
            {
                int factoryMachineId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    bool deleted = _machineLogic.deleteMachine(factoryMachineId, CurrentFactoryId);
                    if (deleted)
                    {
                        pnlAlert.Visible = true;
                        pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between";
                        lblAlertMessage.Text = "Machinery asset successfully removed from your plant register.";
                    }
                    else
                    {
                        pnlAlert.Visible = true;
                        pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-rose-50 border border-rose-300 text-xs text-rose-800 flex items-center justify-between";
                        lblAlertMessage.Text = "Unable to delete asset. Asset not found or permission denied.";
                    }
                }
                catch (Exception ex)
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-rose-50 border border-rose-300 text-xs text-rose-800 flex items-center justify-between";
                    lblAlertMessage.Text = "Cannot delete equipment asset: " + ex.Message;
                }

                LoadMetrics();
                LoadMachinesGrid();
            }
        }

        protected void btnSaveMachine_Click(object sender, EventArgs e)
        {
            string assetTag = txtAssetTag.Text.Trim();
            if (string.IsNullOrEmpty(assetTag))
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-amber-50 border border-amber-300 text-xs text-slate-800 flex items-center justify-between";
                lblAlertMessage.Text = "Please enter an Asset Tag (e.g. GHM-CNC-004).";
                return;
            }

            if (string.IsNullOrEmpty(ddlMachineModel.SelectedValue))
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-amber-50 border border-amber-300 text-xs text-slate-800 flex items-center justify-between";
                lblAlertMessage.Text = "Please select a master machine model specification.";
                return;
            }

            int machineId = Convert.ToInt32(ddlMachineModel.SelectedValue);
            string serialNumber = string.IsNullOrEmpty(txtSerialNumber.Text.Trim()) ? null : txtSerialNumber.Text.Trim();
            string department = string.IsNullOrEmpty(txtDepartment.Text.Trim()) ? null : txtDepartment.Text.Trim();
            DateTime? installedDate = null;
            if (DateTime.TryParse(txtInstalledDate.Text.Trim(), out DateTime dt))
            {
                installedDate = dt;
            }

            string status = ddlStatus.SelectedValue;
            string notes = string.IsNullOrEmpty(txtNotes.Text.Trim()) ? null : txtNotes.Text.Trim();

            int factoryMachineId = Convert.ToInt32(hdnFactoryMachineId.Value);

            try
            {
                if (factoryMachineId > 0)
                {
                    // Update existing
                    bool updated = _machineLogic.updateMachine(factoryMachineId, CurrentFactoryId, machineId, assetTag, serialNumber, department, installedDate, status, notes);
                    if (updated)
                    {
                        pnlMachineModal.Visible = false;
                        pnlAlert.Visible = true;
                        pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between";
                        lblAlertMessage.Text = string.Format("Equipment asset '{0}' updated successfully.", assetTag);
                    }
                    else
                    {
                        pnlAlert.Visible = true;
                        pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-rose-50 border border-rose-300 text-xs text-rose-800 flex items-center justify-between";
                        lblAlertMessage.Text = "Update failed: asset not found or unauthorized.";
                    }
                }
                else
                {
                    // Insert new
                    int newId = _machineLogic.insertMachine(CurrentFactoryId, machineId, assetTag, serialNumber, department, installedDate, status, notes);
                    pnlMachineModal.Visible = false;
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between";
                    lblAlertMessage.Text = string.Format("Equipment asset '{0}' registered successfully into plant fleet.", assetTag);
                }

                LoadMetrics();
                LoadMachinesGrid();
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-rose-50 border border-rose-300 text-xs text-rose-800 flex items-center justify-between";
                lblAlertMessage.Text = "Database error saving machinery asset: " + ex.Message;
            }
        }
    }
}