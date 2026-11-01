using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory.SpareParts
{
    public partial class Search : BasePage
    {
        private readonly PartLogic _partLogic = new PartLogic();
        private readonly QuotationLogic _quotationLogic = new QuotationLogic();
        private readonly UserLogic _userLogic = new UserLogic();

        public Search()
        {
            RequiredRole = RoleConstants.Factory;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFilterDropdowns();
                LoadParts();
            }
        }

        private void LoadFilterDropdowns()
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
            string keyword = txtKeyword.Text.Trim();
            string categoryId = ddlCategory.SelectedValue;
            string machineId = ddlMachine.SelectedValue;

            DataSet ds = _partLogic.selectCatalog(keyword, categoryId, machineId);
            gvParts.DataSource = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvParts.DataBind();

            lblPartsCount.Text = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0].Rows.Count.ToString() : "0";
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadParts();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtKeyword.Text = string.Empty;
            ddlCategory.SelectedIndex = 0;
            ddlMachine.SelectedIndex = 0;
            pnlRfqModal.Visible = false;
            LoadParts();
        }

        protected void gvParts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RequestQuote")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                hfSelectedPartId.Value = parts[0];
                lblModalPartName.Text = parts.Length > 1 ? parts[1] : "Selected Part";
                pnlRfqModal.Visible = true;
                txtModalQuantity.Text = "1";
                txtModalTargetPrice.Text = string.Empty;
                txtModalRequiredDate.Text = DateTime.Now.AddDays(7).ToString("yyyy-MM-dd");
                txtModalRemarks.Text = string.Empty;
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlRfqModal.Visible = false;
        }

        protected void btnSubmitModalRfq_Click(object sender, EventArgs e)
        {
            int partId;
            if (!int.TryParse(hfSelectedPartId.Value, out partId))
            {
                return;
            }

            int qty;
            if (!int.TryParse(txtModalQuantity.Text.Trim(), out qty) || qty <= 0)
            {
                return;
            }

            int factoryId = _userLogic.resolveFactoryId(SessionHelper.UserId.Value);
            decimal? targetPrice = decimal.TryParse(txtModalTargetPrice.Text.Trim(), out decimal tp) ? (decimal?)tp : null;
            DateTime? reqDate = DateTime.TryParse(txtModalRequiredDate.Text.Trim(), out DateTime rd) ? (DateTime?)rd : null;
            string remarks = txtModalRemarks.Text.Trim();

            int rfqId = _quotationLogic.insertRfq(factoryId, partId, qty, targetPrice, reqDate, remarks);

            pnlRfqModal.Visible = false;
            pnlAlert.Visible = true;
            lblAlertMessage.Text = $"Quotation Request RFQ-{rfqId:D5} generated and dispatched to suppliers.";
        }
    }
}
