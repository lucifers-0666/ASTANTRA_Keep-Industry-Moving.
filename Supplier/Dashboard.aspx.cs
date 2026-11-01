using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;

namespace IndustrialSparePartPortal.Supplier
{
    public partial class Dashboard : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly InventoryLogic _inventoryLogic = new InventoryLogic();

        public Dashboard()
        {
            RequiredRole = RoleConstants.Supplier;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblSupplierCompany.InnerText = SessionHelper.FullName ?? "Spare-Part Supplier";
                LoadSupplierMetrics();
            }
        }

        private void LoadSupplierMetrics()
        {
            if (SessionHelper.UserId == null) return;

            int supplierId = _userLogic.resolveSupplierId(SessionHelper.UserId.Value);

            int inventoryCount, incomingRfqs, openEmergencies, ordersToFulfill;
            _inventoryLogic.getSupplierDashboardMetrics(supplierId, out inventoryCount, out incomingRfqs, out openEmergencies, out ordersToFulfill);

            lblInventoryCount.Text = inventoryCount.ToString();
            lblIncomingRfqs.Text = incomingRfqs.ToString();
            lblBreakdownAlerts.Text = openEmergencies.ToString();
            lblOrdersToFulfill.Text = ordersToFulfill.ToString();
        }
    }
}
