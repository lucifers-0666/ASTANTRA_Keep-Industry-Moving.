using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory
{
    public partial class Dashboard : FactoryBasePage
    {
        private readonly PartLogic _partLogic = new PartLogic();
        private readonly QuotationLogic _quotationLogic = new QuotationLogic();
        private readonly OrderLogic _orderLogic = new OrderLogic();
        private readonly AdminLogic _adminLogic = new AdminLogic();
        private readonly FactoryMachineLogic _machineLogic = new FactoryMachineLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblUserCompany.InnerText = CurrentFactoryName;
                lblPlantLocation.InnerText = CurrentFactoryCity;

                string msg = Request.QueryString["msg"];
                if (string.Equals(msg, "emergency_submitted", StringComparison.OrdinalIgnoreCase))
                {
                    pnlAlertNotice.Visible = true;
                    lblAlertText.InnerText = "Priority machine breakdown ticket logged. Regional response engineers alerted.";
                }

                string action = Request.QueryString["action"];
                if (string.Equals(action, "rfq", StringComparison.OrdinalIgnoreCase))
                {
                    pnlRfqForm.Visible = true;
                }

                LoadPartsDropdown();
                LoadDashboard(CurrentFactoryId);
            }
        }

        private void LoadPartsDropdown()
        {
            DataSet ds = _partLogic.selectAllParts();
            ddlRfqPart.Items.Clear();
            ddlRfqPart.Items.Add(new ListItem("-- Select Equipment Spare Part --", ""));

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    string label = string.Format("{0} — {1}", row["PartNumber"], row["PartName"]);
                    ddlRfqPart.Items.Add(new ListItem(label, row["PartId"].ToString()));
                }
            }

            string partIdParam = Request.QueryString["partId"];
            if (!string.IsNullOrEmpty(partIdParam) && ddlRfqPart.Items.FindByValue(partIdParam) != null)
            {
                ddlRfqPart.SelectedValue = partIdParam;
            }
        }

        private void LoadDashboard(int factoryId)
        {
            LoadMetrics(factoryId);
            LoadRfqs(factoryId);
            LoadOrders(factoryId);
            LoadEmergencyRequests(factoryId);
            LoadChartsData(factoryId);
        }

        private void LoadMetrics(int factoryId)
        {
            int activeRfqs, quoteResponses, activeOrders, openEmergencies;
            _quotationLogic.getFactoryDashboardMetrics(factoryId, out activeRfqs, out quoteResponses, out activeOrders, out openEmergencies);

            int totalMac, opMac, maintMac, offMac;
            _machineLogic.getFactoryMachineMetrics(factoryId, out totalMac, out opMac, out maintMac, out offMac);

            lblMetricRfqs.InnerText = activeRfqs.ToString();
            lblMetricQuotes.InnerText = quoteResponses.ToString();
            lblMetricOrders.InnerText = activeOrders.ToString();
            lblMetricMachines.InnerText = totalMac.ToString();
            lblMetricEmergency.InnerText = openEmergencies.ToString();
        }

        private void LoadRfqs(int factoryId)
        {
            DataSet ds = _quotationLogic.selectRfqsByFactory(factoryId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                rptRfqs.DataSource = ds.Tables[0];
                rptRfqs.DataBind();
                rptRfqs.Visible = true;
                pnlNoRfqs.Visible = false;
            }
            else
            {
                rptRfqs.Visible = false;
                pnlNoRfqs.Visible = true;
            }
        }

        private void LoadOrders(int factoryId)
        {
            DataSet ds = _orderLogic.selectOrdersByFactory(factoryId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                rptOrders.DataSource = ds.Tables[0];
                rptOrders.DataBind();
                rptOrders.Visible = true;
                pnlNoOrders.Visible = false;
            }
            else
            {
                rptOrders.Visible = false;
                pnlNoOrders.Visible = true;
            }
        }

        private void LoadEmergencyRequests(int factoryId)
        {
            DataSet ds = _adminLogic.selectOpenEmergenciesByFactory(factoryId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                rptEmergency.DataSource = ds.Tables[0];
                rptEmergency.DataBind();
                rptEmergency.Visible = true;
                pnlNoEmergency.Visible = false;
            }
            else
            {
                rptEmergency.Visible = false;
                pnlNoEmergency.Visible = true;
            }
        }

        private void LoadChartsData(int factoryId)
        {
            var payload = new Dictionary<string, object>();

            // 1. Activity trend
            DataSet dsTrend = _quotationLogic.getFactoryActivityTrend(factoryId);
            var trendList = new List<Dictionary<string, object>>();
            if (dsTrend != null && dsTrend.Tables.Count > 0)
            {
                foreach (DataRow r in dsTrend.Tables[0].Rows)
                {
                    var item = new Dictionary<string, object>();
                    item["PeriodDate"] = r["PeriodDate"].ToString();
                    item["RfqCount"] = Convert.ToInt32(r["RfqCount"]);
                    item["OrderCount"] = Convert.ToInt32(r["OrderCount"]);
                    item["SpendTotal"] = Convert.ToDecimal(r["SpendTotal"]);
                    trendList.Add(item);
                }
            }
            payload["trend"] = trendList;

            // 2. Order status
            DataSet dsOrderSt = _quotationLogic.getFactoryOrderStatusCounts(factoryId);
            var orderStList = new List<Dictionary<string, object>>();
            if (dsOrderSt != null && dsOrderSt.Tables.Count > 0)
            {
                foreach (DataRow r in dsOrderSt.Tables[0].Rows)
                {
                    var item = new Dictionary<string, object>();
                    item["OrderStatus"] = r["OrderStatus"].ToString();
                    item["StatusCount"] = Convert.ToInt32(r["StatusCount"]);
                    orderStList.Add(item);
                }
            }
            payload["orderStatuses"] = orderStList;

            // 3. Machinery
            int totalMac, opMac, maintMac, offMac;
            _machineLogic.getFactoryMachineMetrics(factoryId, out totalMac, out opMac, out maintMac, out offMac);
            var macObj = new Dictionary<string, object>();
            macObj["total"] = totalMac;
            macObj["operational"] = opMac;
            macObj["maintenance"] = maintMac;
            macObj["offline"] = offMac;
            payload["machinery"] = macObj;

            // 4. Service status
            DataSet dsServiceSt = _quotationLogic.getFactoryServiceStatusCounts(factoryId);
            var serviceStList = new List<Dictionary<string, object>>();
            if (dsServiceSt != null && dsServiceSt.Tables.Count > 0)
            {
                foreach (DataRow r in dsServiceSt.Tables[0].Rows)
                {
                    var item = new Dictionary<string, object>();
                    item["ServiceStatus"] = r["ServiceStatus"].ToString();
                    item["StatusCount"] = Convert.ToInt32(r["StatusCount"]);
                    serviceStList.Add(item);
                }
            }
            payload["serviceStatuses"] = serviceStList;

            JavaScriptSerializer js = new JavaScriptSerializer();
            hdnFactoryCharts.Value = js.Serialize(payload);
        }

        protected void btnToggleRfqForm_Click(object sender, EventArgs e)
        {
            pnlRfqForm.Visible = !pnlRfqForm.Visible;
        }

        protected void btnCancelRfq_Click(object sender, EventArgs e)
        {
            pnlRfqForm.Visible = false;
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlertNotice.Visible = false;
        }

        protected void btnSubmitRfq_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlRfqPart.SelectedValue))
            {
                pnlAlertNotice.Visible = true;
                lblAlertText.InnerText = "Please select a valid spare part from the catalog to issue an RFQ.";
                return;
            }

            int partId;
            if (!int.TryParse(ddlRfqPart.SelectedValue, out partId))
            {
                return;
            }

            int quantity = 1;
            int.TryParse(txtRfqQty.Text.Trim(), out quantity);
            if (quantity <= 0) quantity = 1;

            decimal? targetPrice = null;
            decimal parsedPrice;
            if (decimal.TryParse(txtRfqTargetPrice.Text.Trim(), out parsedPrice) && parsedPrice > 0)
            {
                targetPrice = parsedPrice;
            }

            DateTime? requiredByDate = null;
            DateTime parsedDate;
            if (DateTime.TryParse(txtRfqRequiredDate.Text.Trim(), out parsedDate))
            {
                requiredByDate = parsedDate;
            }

            string remarks = txtRfqRemarks.Text.Trim();

            try
            {
                int rfqId = _quotationLogic.insertRfq(CurrentFactoryId, partId, quantity, targetPrice, requiredByDate, remarks);

                pnlRfqForm.Visible = false;
                pnlAlertNotice.Visible = true;
                lblAlertText.InnerText = string.Format("Request for Quotation RFQ-{0:D5} broadcasted to regional stocking suppliers.", rfqId);

                ddlRfqPart.SelectedIndex = 0;
                txtRfqQty.Text = "1";
                txtRfqTargetPrice.Text = string.Empty;
                txtRfqRequiredDate.Text = string.Empty;
                txtRfqRemarks.Text = string.Empty;

                LoadDashboard(CurrentFactoryId);
            }
            catch (Exception ex)
            {
                pnlAlertNotice.Visible = true;
                lblAlertText.InnerText = "Unable to issue RFQ. Please verify details and retry.";
                System.Diagnostics.Trace.TraceError("RFQ Submission Error: " + ex.Message);
            }
        }
    }
}
