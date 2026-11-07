using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Factory.Orders
{
    public partial class OrderDetails : FactoryBasePage
    {
        private readonly OrderLogic _orderLogic = new OrderLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOrderDetails();
            }
        }

        private void LoadOrderDetails()
        {
            string rawOrderId = Request.QueryString["orderId"];
            if (string.IsNullOrEmpty(rawOrderId) || !int.TryParse(rawOrderId, out int orderId))
            {
                pnlNotFound.Visible = true;
                pnlOrderInvoice.Visible = false;
                return;
            }

            // Query strictly isolated to current authenticated factory
            DataRow order = _orderLogic.selectOrderDetailsByFactory(orderId, CurrentFactoryId);
            if (order == null)
            {
                pnlNotFound.Visible = true;
                pnlOrderInvoice.Visible = false;
                return;
            }

            pnlNotFound.Visible = false;
            pnlOrderInvoice.Visible = true;

            // Success alert if just created
            if (Request.QueryString["created"] == "true")
            {
                pnlAlert.Visible = true;
                lblAlertMessage.Text = string.Format("Purchase Order {0} generated successfully from accepted commercial quote.", order["OrderNumber"]);
            }

            // Header info
            lblOrderNumber.InnerText = order["OrderNumber"].ToString();
            DateTime orderDate = Convert.ToDateTime(order["OrderDate"]);
            lblOrderDate.InnerText = orderDate.ToString("dd MMM yyyy, hh:mm tt");

            string status = order["OrderStatus"].ToString();
            lblOrderStatusBadge.InnerText = status;
            lblOrderStatusBadge.Attributes["class"] = "badge-status " + GetStatusBadgeCss(status);

            // Buyer Plant Details
            lblFactoryName.InnerText = order["FactoryName"].ToString();
            string factoryAddress = string.Format("{0}, {1}, {2} - {3}", 
                order["FactoryAddress"], order["FactoryCity"], order["FactoryState"], order["FactoryPincode"]);
            lblFactoryAddress.InnerText = factoryAddress;
            lblFactoryGstin.InnerText = order["FactoryGstin"] != DBNull.Value && !string.IsNullOrEmpty(order["FactoryGstin"].ToString()) 
                ? order["FactoryGstin"].ToString() : "Unregistered";
            lblFactoryContact.InnerText = order["FactoryContact"] != DBNull.Value ? order["FactoryContact"].ToString() : "Plant Operations";
            lblFactoryPhone.InnerText = order["FactoryPhone"] != DBNull.Value && !string.IsNullOrEmpty(order["FactoryPhone"].ToString())
                ? order["FactoryPhone"].ToString() : "N/A";

            // Supplier Details
            lblSupplierName.InnerText = order["SupplierName"].ToString();
            string supplierAddress = string.Format("{0}, {1}, {2} - {3}", 
                order["SupplierAddress"], order["SupplierCity"], order["SupplierState"], order["SupplierPincode"]);
            lblSupplierAddress.InnerText = supplierAddress;
            lblSupplierGstin.InnerText = order["SupplierGstin"] != DBNull.Value && !string.IsNullOrEmpty(order["SupplierGstin"].ToString())
                ? order["SupplierGstin"].ToString() : "Unregistered";
            lblSupplierContact.InnerText = order["SupplierContact"] != DBNull.Value ? order["SupplierContact"].ToString() : "Commercial Sales Desk";
            lblSupplierEmail.InnerText = order["SupplierEmail"] != DBNull.Value ? order["SupplierEmail"].ToString() : "orders@vendor.com";

            // Shipping & Waybill
            lblShippingAddress.InnerText = order["ShippingAddress"] != DBNull.Value && !string.IsNullOrEmpty(order["ShippingAddress"].ToString())
                ? order["ShippingAddress"].ToString() : factoryAddress;

            string trackingNo = order["TrackingNumber"] != DBNull.Value ? order["TrackingNumber"].ToString() : null;
            if (!string.IsNullOrEmpty(trackingNo))
            {
                lblTrackingNumber.InnerText = trackingNo;
            }
            else
            {
                lblTrackingNumber.InnerText = "Awaiting Vendor Dispatch Waybill";
            }

            // Line Items
            DataSet itemsDs = _orderLogic.selectOrderItems(orderId);
            decimal totalAmount = Convert.ToDecimal(order["TotalAmount"]);

            if (itemsDs != null && itemsDs.Tables.Count > 0 && itemsDs.Tables[0].Rows.Count > 0)
            {
                gvOrderItems.DataSource = itemsDs.Tables[0];
                gvOrderItems.DataBind();

                decimal subTotal = 0;
                foreach (DataRow item in itemsDs.Tables[0].Rows)
                {
                    subTotal += Convert.ToDecimal(item["TotalPrice"]);
                }

                // If items sum up to total, calculate taxable base & 18% GST breakdown
                decimal taxRate = 0.18m;
                decimal netTaxable = Math.Round(totalAmount / (1m + taxRate), 2);
                decimal taxAmount = totalAmount - netTaxable;

                lblSubTotal.InnerText = string.Format("₹{0:N2}", netTaxable);
                lblTaxAmount.InnerText = string.Format("₹{0:N2}", taxAmount);
                lblGrandTotal.InnerText = string.Format("₹{0:N2}", totalAmount);
            }
            else
            {
                gvOrderItems.DataSource = null;
                gvOrderItems.DataBind();

                decimal netTaxable = Math.Round(totalAmount / 1.18m, 2);
                decimal taxAmount = totalAmount - netTaxable;

                lblSubTotal.InnerText = string.Format("₹{0:N2}", netTaxable);
                lblTaxAmount.InnerText = string.Format("₹{0:N2}", taxAmount);
                lblGrandTotal.InnerText = string.Format("₹{0:N2}", totalAmount);
            }
        }

        private string GetStatusBadgeCss(string status)
        {
            switch (status)
            {
                case "Delivered":
                    return "badge-delivered";
                case "Shipped":
                case "Confirmed":
                    return "badge-processing";
                case "Cancelled":
                    return "badge-cancelled";
                case "Pending":
                default:
                    return "badge-pending";
            }
        }
    }
}
