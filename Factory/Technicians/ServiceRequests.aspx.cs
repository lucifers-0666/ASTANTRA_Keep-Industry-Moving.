using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Factory.Technicians
{
    public partial class ServiceRequests : BasePage
    {
        private readonly ServiceLogic _serviceLogic = new ServiceLogic();
        private readonly UserLogic _userLogic = new UserLogic();

        public ServiceRequests()
        {
            RequiredRole = RoleConstants.Factory;
        }

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

            if (ds != null && ds.Tables.Count > 0)
            {
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    string label = $"{row["FullName"]} ({row["City"]}) - {row["SkillSummary"]} [₹{row["HourlyRate"]}/hr]";
                    ddlTechnicians.Items.Add(new ListItem(label, row["TechnicianId"].ToString()));
                }
            }
        }

        private void LoadServices()
        {
            int factoryId = _userLogic.resolveFactoryId(SessionHelper.UserId.Value);
            DataSet ds = _serviceLogic.selectRequestsByFactory(factoryId);

            gvServices.DataSource = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;
            gvServices.DataBind();

            lblServiceCount.Text = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0].Rows.Count.ToString() : "0";
        }

        protected void btnOpenBookingForm_Click(object sender, EventArgs e)
        {
            pnlBooking.Visible = true;
        }

        protected void btnCloseBooking_Click(object sender, EventArgs e)
        {
            pnlBooking.Visible = false;
        }

        protected void btnSubmitServiceRequest_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlTechnicians.SelectedValue))
            {
                return;
            }

            int factoryId = _userLogic.resolveFactoryId(SessionHelper.UserId.Value);
            int technicianId = Convert.ToInt32(ddlTechnicians.SelectedValue);
            string serviceType = ddlServiceType.SelectedValue;
            string issueDesc = txtIssueDescription.Text.Trim();
            DateTime scheduledDate = DateTime.TryParse(txtScheduledDate.Text.Trim(), out DateTime d) ? d : DateTime.Now.AddDays(1);

            if (string.IsNullOrEmpty(issueDesc))
            {
                return;
            }

            int reqId = _serviceLogic.insertServiceRequest(factoryId, technicianId, serviceType, issueDesc, scheduledDate);

            pnlBooking.Visible = false;
            pnlAlert.Visible = true;
            lblAlertMessage.Text = $"Service Request SRV-{reqId:D5} logged and notified to field specialist.";
            txtIssueDescription.Text = string.Empty;

            LoadServices();
        }
    }
}
