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
            DataSet dsCat = _partLogic.selectCategories();
            if (dsCat != null && dsCat.Tables.Count > 0)
            {
                foreach (DataRow row in dsCat.Tables[0].Rows)
                {
                    ddlCategory.Items.Add(new ListItem(row["CategoryName"].ToString(), row["CategoryId"].ToString()));
                }
            }

            DataSet dsMac = _partLogic.selectMachines();
            if (dsMac != null && dsMac.Tables.Count > 0)
            {
                foreach (DataRow row in dsMac.Tables[0].Rows)
                {
                    ddlMachine.Items.Add(new ListItem(row["MachineName"].ToString(), row["MachineId"].ToString()));
                }
            }
        }

        private void LoadParts()
        {
            DataSet ds = _partLogic.selectAllParts();
            DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;

            gvParts.DataSource = dt;
            gvParts.DataBind();

            lblPartsCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
        }

        protected void btnToggleAddForm_Click(object sender, EventArgs e)
        {
            pnlAddPart.Visible = !pnlAddPart.Visible;
        }

        protected void btnCancelAdd_Click(object sender, EventArgs e)
        {
            pnlAddPart.Visible = false;
        }

        protected void btnSavePart_Click(object sender, EventArgs e)
        {
            string partNum = txtPartNumber.Text.Trim();
            string partName = txtPartName.Text.Trim();
            int catId = Convert.ToInt32(ddlCategory.SelectedValue);
            int? macId = !string.IsNullOrEmpty(ddlMachine.SelectedValue) ? (int?)Convert.ToInt32(ddlMachine.SelectedValue) : null;
            string uom = ddlUom.SelectedValue;
            string specs = txtSpecs.Text.Trim();

            if (string.IsNullOrEmpty(partNum) || string.IsNullOrEmpty(partName))
            {
                return;
            }

            try
            {
                int partId = _partLogic.insertPart(catId, macId, partNum, partName, null, specs, uom);

                if (partId > 0)
                {
                    pnlAddPart.Visible = false;
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "p-4 mb-6 rounded-lg bg-emerald-50 border border-emerald-200 text-xs text-emerald-800 flex items-center justify-between";
                    lblAlertMessage.Text = $"Part '{partNum}' added to master catalog successfully.";

                    txtPartNumber.Text = string.Empty;
                    txtPartName.Text = string.Empty;
                    txtSpecs.Text = string.Empty;

                    LoadParts();
                }
                else
                {
                    pnlAlert.Visible = true;
                    pnlAlert.CssClass = "p-4 mb-6 rounded-lg bg-rose-50 border border-rose-200 text-xs text-rose-800 flex items-center justify-between";
                    lblAlertMessage.Text = "Failed to add part to master catalog.";
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-lg bg-rose-50 border border-rose-200 text-xs text-rose-800 flex items-center justify-between";
                lblAlertMessage.Text = "Error saving part: " + ex.Message;
            }
        }
    }
}

