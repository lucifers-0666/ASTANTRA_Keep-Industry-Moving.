using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Admin.Categories
{
    public partial class ManageCategories : BasePage
    {
        private readonly PartLogic _partLogic = new PartLogic();

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
            DataSet dsCat = _partLogic.selectCategories();
            DataTable dtCat = (dsCat != null && dsCat.Tables.Count > 0) ? dsCat.Tables[0] : null;
            gvCategories.DataSource = dtCat;
            gvCategories.DataBind();
            lblCatCount.Text = dtCat != null ? dtCat.Rows.Count.ToString() : "0";

            DataSet dsMac = _partLogic.selectMachines();
            DataTable dtMac = (dsMac != null && dsMac.Tables.Count > 0) ? dsMac.Tables[0] : null;
            gvMachines.DataSource = dtMac;
            gvMachines.DataBind();
            lblMacCount.Text = dtMac != null ? dtMac.Rows.Count.ToString() : "0";
        }

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            string name = txtCategoryName.Text.Trim();
            string desc = txtCategoryDesc.Text.Trim();
            string icon = txtCategoryIcon.Text.Trim();

            if (string.IsNullOrEmpty(name)) return;

            int newId = _partLogic.insertCategory(name, desc, icon);

            if (newId > 0)
            {
                txtCategoryName.Text = string.Empty;
                txtCategoryDesc.Text = string.Empty;
                txtCategoryIcon.Text = string.Empty;
                pnlAlert.Visible = true;
                lblAlertMessage.Text = $"Category '{name}' registered successfully.";
                LoadData();
            }
        }

        protected void btnAddMachine_Click(object sender, EventArgs e)
        {
            string name = txtMachineName.Text.Trim();
            string model = txtMachineModel.Text.Trim();
            string mfg = txtMachineMfg.Text.Trim();

            if (string.IsNullOrEmpty(name)) return;

            int newId = _partLogic.insertMachine(name, model, mfg);

            if (newId > 0)
            {
                txtMachineName.Text = string.Empty;
                txtMachineModel.Text = string.Empty;
                txtMachineMfg.Text = string.Empty;
                pnlAlert.Visible = true;
                lblAlertMessage.Text = $"Machine model '{name}' registered successfully.";
                LoadData();
            }
        }
    }
}

