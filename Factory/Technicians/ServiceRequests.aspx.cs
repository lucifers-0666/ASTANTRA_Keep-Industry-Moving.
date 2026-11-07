using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory.Technicians
{
    public partial class ServiceRequests : FactoryBasePage
    {
        private readonly ServiceLogic _serviceLogic = new ServiceLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtScheduledDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
                LoadTechniciansDropdown();
                LoadServices();
            }
        }

        private void LoadTechniciansDropdown()
        {
            DataSet ds = _serviceLogic.selectAvailableTechnicians();
            ddlTechnicians.Items.Clear();

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    string label = string.Format("{0} ({1}) - {2} [₹{3:N0}/hr]", 
                        row["FullName"], row["City"], row["SkillSummary"], Convert.ToDecimal(row["HourlyRate"]));
                    ddlTechnicians.Items.Add(new ListItem(label, row["TechnicianId"].ToString()));
                }
            }
            else
            {
                ddlTechnicians.Items.Add(new ListItem("-- No Available Technicians Currently On-Duty --", ""));
            }
        }

        private void LoadServices()
        {
            string statusFilter = string.IsNullOrEmpty(ddlStatusFilter.SelectedValue) ? null : ddlStatusFilter.SelectedValue;
            string search = string.IsNullOrEmpty(txtSearch.Text.Trim()) ? null : txtSearch.Text.Trim();

            DataSet ds = _serviceLogic.selectRequestsByFactory(CurrentFactoryId, statusFilter, search);

            int count = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0].Rows.Count : 0;
            lblServiceCount.InnerText = count.ToString();

            gvServices.DataSource = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvServices.DataBind();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadServices();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadServices();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlStatusFilter.SelectedIndex = 0;
            LoadServices();
        }

        protected void btnOpenBookingForm_Click(object sender, EventArgs e)
        {
            pnlBooking.Visible = true;
            pnlAlert.Visible = false;
        }

        protected void btnCloseBooking_Click(object sender, EventArgs e)
        {
            pnlBooking.Visible = false;
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }

        protected void btnSubmitServiceRequest_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlTechnicians.SelectedValue))
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-amber-50 border border-amber-300 text-xs text-slate-800 flex items-center justify-between";
                lblAlertMessage.Text = "Please select an available technician.";
                return;
            }

            int technicianId = Convert.ToInt32(ddlTechnicians.SelectedValue);
            string serviceType = ddlServiceType.SelectedValue;
            string issueDesc = txtIssueDescription.Text.Trim();
            DateTime scheduledDate = DateTime.TryParse(txtScheduledDate.Text.Trim(), out DateTime d) ? d : DateTime.Now.AddDays(1);

            if (string.IsNullOrEmpty(issueDesc))
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-amber-50 border border-amber-300 text-xs text-slate-800 flex items-center justify-between";
                lblAlertMessage.Text = "Please provide a description of the issue or maintenance symptoms.";
                return;
            }

            try
            {
                int reqId = _serviceLogic.insertServiceRequest(CurrentFactoryId, technicianId, serviceType, issueDesc, scheduledDate);

                pnlBooking.Visible = false;
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between";
                lblAlertMessage.Text = string.Format("Service Request SRV-{0:D5} logged and notified to field specialist.", reqId);
                txtIssueDescription.Text = string.Empty;

                LoadServices();
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-4 mb-6 rounded-md bg-rose-50 border border-rose-300 text-xs text-rose-800 flex items-center justify-between";
                lblAlertMessage.Text = "Unable to dispatch request: " + ex.Message;
            }
        }
    }
}