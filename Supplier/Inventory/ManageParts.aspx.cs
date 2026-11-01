using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Supplier.Inventory
{
    public partial class ManageParts : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly InventoryLogic _inventoryLogic = new InventoryLogic();
        private readonly PartLogic _partLogic = new PartLogic();

        public ManageParts()
        {
            RequiredRole = RoleConstants.Supplier;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPartsDropdown();
                LoadInventory();
            }
        }

        private int GetSupplierId()
        {
            if (SessionHelper.UserId == null) return 0;
            return _userLogic.resolveSupplierId(SessionHelper.UserId.Value);
        }

        private void LoadPartsDropdown()
        {
            DataSet ds = _partLogic.selectAllParts();
            if (ds != null && ds.Tables.Count > 0)
            {
                ddlCatalogPart.Items.Clear();
                ddlCatalogPart.Items.Add(new ListItem("-- Select Part from Master Catalog --", ""));
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    string label = $"{row["PartNumber"]} - {row["PartName"]} ({row["CategoryName"]})";
                    ddlCatalogPart.Items.Add(new ListItem(label, row["PartId"].ToString()));
                }
            }
        }

        private void LoadInventory()
        {
            int supplierId = GetSupplierId();
            if (supplierId == 0) return;

            DataSet ds = _inventoryLogic.selectBySupplier(supplierId);
            DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;

            gvInventory.DataSource = dt;
            gvInventory.DataBind();

            lblInventoryCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
        }

        protected void btnToggleAddForm_Click(object sender, EventArgs e)
        {
            pnlAddStock.Visible = !pnlAddStock.Visible;
        }

        protected void btnCancelStock_Click(object sender, EventArgs e)
        {
            pnlAddStock.Visible = false;
        }

        protected void btnSaveStock_Click(object sender, EventArgs e)
        {
            int supplierId = GetSupplierId();
            if (supplierId == 0) return;

            if (string.IsNullOrEmpty(ddlCatalogPart.SelectedValue))
            {
                ShowAlert("Please select a spare part from the master catalog.", true);
                return;
            }

            int partId = Convert.ToInt32(ddlCatalogPart.SelectedValue);

            decimal unitPrice;
            if (!decimal.TryParse(txtUnitPrice.Text.Trim(), out unitPrice) || unitPrice <= 0)
            {
                ShowAlert("Please enter a valid positive unit price.", true);
                return;
            }

            int stockQty;
            if (!int.TryParse(txtStockQty.Text.Trim(), out stockQty) || stockQty < 0)
            {
                ShowAlert("Please enter a valid stock quantity.", true);
                return;
            }

            int leadTime;
            if (!int.TryParse(txtLeadTime.Text.Trim(), out leadTime) || leadTime < 0)
            {
                leadTime = 2;
            }

            string availability = ddlAvailability.SelectedValue;

            bool success = _inventoryLogic.insertInventory(supplierId, partId, unitPrice, stockQty, availability, leadTime);

            if (success)
            {
                pnlAddStock.Visible = false;
                txtUnitPrice.Text = string.Empty;
                txtStockQty.Text = string.Empty;
                txtLeadTime.Text = "2";
                ddlCatalogPart.SelectedIndex = 0;

                ShowAlert("Inventory stock item saved successfully!", false);
                LoadInventory();
            }
            else
            {
                ShowAlert("Failed to save inventory stock item. Please try again.", true);
            }
        }

        protected void gvInventory_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteStock")
            {
                int supplierId = GetSupplierId();
                if (supplierId == 0) return;

                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int inventoryId = Convert.ToInt32(gvInventory.DataKeys[rowIndex].Values["InventoryId"]);

                bool success = _inventoryLogic.deleteInventory(inventoryId, supplierId);

                if (success)
                {
                    ShowAlert("Inventory item removed successfully.", false);
                    LoadInventory();
                }
                else
                {
                    ShowAlert("Failed to remove inventory item.", true);
                }
            }
        }

        private void ShowAlert(string message, bool isError)
        {
            pnlAlert.Visible = true;
            if (isError)
            {
                pnlAlert.CssClass = "p-4 mb-6 rounded-[3px] bg-[#FEE2E2] border border-[#FCA5A5] text-xs text-[#991B1B] flex items-center justify-between";
            }
            else
            {
                pnlAlert.CssClass = "p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between";
            }
            lblAlertMessage.Text = message;
        }
    }
}

